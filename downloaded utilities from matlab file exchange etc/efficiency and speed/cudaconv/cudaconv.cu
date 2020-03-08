/*
* Copyright 1993-2007 NVIDIA Corporation.  All rights reserved.
	*
	* NOTICE TO USER:   
*
	* This source code is subject to NVIDIA ownership rights under U.S. and 
	* international Copyright laws.  Users and possessors of this source code 
	* are hereby granted a nonexclusive, royalty-free license to use this code 
	* in individual and commercial software.
	*
	* NVIDIA MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE 
	* CODE FOR ANY PURPOSE.  IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR 
	* IMPLIED WARRANTY OF ANY KIND.  NVIDIA DISCLAIMS ALL WARRANTIES WITH 
	* REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF 
	* MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.
	* IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, 
	* OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS 
	* OF USE, DATA OR PROFITS,  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE 
	* OR OTHER TORTIOUS ACTION,  ARISING OUT OF OR IN CONNECTION WITH THE USE 
	* OR PERFORMANCE OF THIS SOURCE CODE.  
	*
	* U.S. Government End Users.   This source code is a "commercial item" as 
	* that term is defined at  48 C.F.R. 2.101 (OCT 1995), consisting  of 
	* "commercial computer  software"  and "commercial computer software 
	* documentation" as such terms are  used in 48 C.F.R. 12.212 (SEPT 1995) 
	* and is provided to the U.S. Government only as a commercial end item.  
	* Consistent with 48 C.F.R.12.212 and 48 C.F.R. 227.7202-1 through 
	* 227.7202-4 (JUNE 1995), all U.S. Government End Users acquire the 
	* source code with only those rights set forth herein. 
	*
	* Any use of this source code in individual and commercial software must 
	* include, in the user documentation and internal comments to the code,
	* the above Disclaimer and U.S. Government End Users Notice.
*/


#include "cufft.h"
#include "cutil.h"
#include "mex.h"
#include "cuda.h"
#include <stdio.h>
#include <stdlib.h>

typedef float2 Complex;

static bool debug = false;

////////////////////////////////////////////////////////////////////////////////
// Helper functions
////////////////////////////////////////////////////////////////////////////////
//Round a / b to nearest higher integer value
int iDivUp(int a, int b){
	return (a % b != 0) ? (a / b + 1) : (a / b);
}

//Align a to nearest higher multiple of b
int iAlignUp(int a, int b){
	return (a % b != 0) ?  (a - a % b + b) : a;
}

////////////////////////////////////////////////////////////////////////////////
// Padding kernels
////////////////////////////////////////////////////////////////////////////////
#include "convolutionFFT2D_kernel.cu"

////////////////////////////////////////////////////////////////////////////////
// Data configuration
////////////////////////////////////////////////////////////////////////////////
int calculateFFTsize(int dataSize){
	//Highest non-zero bit position of dataSize
	int hiBit;
	//Neares lower and higher powers of two numbers for dataSize
	unsigned int lowPOT, hiPOT;

	//Align data size to a multiple of half-warp
	//in order to have each line starting at properly aligned addresses
	//for coalesced global memory writes in padKernel() and padData()
	dataSize = iAlignUp(dataSize, 16);

	//Find highest non-zero bit
	for(hiBit = 31; hiBit >= 0; hiBit--)
		if(dataSize & (1U << hiBit)) break;

	//No need to align, if already power of two
	lowPOT = 1U << hiBit;
	if(lowPOT == dataSize) return dataSize;

	//Align to a nearest higher power of two, if the size is small enough,
	//else align only to a nearest higher multiple of 512,
	//in order to save computation and memory bandwidth
	hiPOT = 1U << (hiBit + 1);
	//if(hiPOT <= 1024)
		return hiPOT;
	//else 
	//	return iAlignUp(dataSize, 512);
}

////////////////////////////////////////////////////////////////////////////////
// FFT convolution program
////////////////////////////////////////////////////////////////////////////////
void fftFunction(double *output, double *in_Data, double *in_Kernel, int DATA_H, int DATA_W, int KERNEL_H, int KERNEL_W ) {
	float *h_Kernel, *h_Data, *h_Result;

	cudaArray *a_Kernel, *a_Data;
	cudaChannelFormatDesc float2tex = cudaCreateChannelDesc<float>();
	float *d_PaddedKernel, *d_PaddedData;
	Complex *fft_PaddedKernel, *fft_PaddedData;

	cufftHandle FFTplan_R2C;
	cufftHandle FFTplan_C2R;

	int i, j;
	int KERNEL_X, KERNEL_Y, PADDING_W, PADDING_H, FFT_W, FFT_H, FFT_SIZE, KERNEL_SIZE, DATA_SIZE, CFFT_SIZE;

	// we expect 2 inputs: prhs[0] -- data, prhs[1] -- kernel
	// Kernel center position
	KERNEL_X = KERNEL_W/2;
	KERNEL_Y = KERNEL_H/2;
	//fprintf(stderr,"Kernel center: x=%d, y=%d\n",KERNEL_X,KERNEL_Y);

	// Width and height of padding for "clamp to border" addressing mode
	PADDING_W = KERNEL_W - 1;
	PADDING_H = KERNEL_H - 1;

	// Derive FFT size from data and kernel dimensions
	//fprintf(stderr,"Calculating FFT size\n");
	FFT_W = calculateFFTsize(DATA_W + PADDING_W);
	FFT_H = calculateFFTsize(DATA_H + PADDING_H);
	if (debug) fprintf(stderr,"FFT size: h=%d, w=%d\n",FFT_H,FFT_W);

	//fprintf(stderr,"Calculating byte sizes..\n");
	FFT_SIZE = FFT_W * FFT_H * sizeof(float);
	CFFT_SIZE = FFT_W * FFT_H * sizeof(Complex);
	KERNEL_SIZE = KERNEL_W * KERNEL_H * sizeof(float);
	DATA_SIZE = DATA_W * DATA_H * sizeof(float);

	// Allocate memory for input
	h_Kernel = (float *)mxMalloc(KERNEL_SIZE);
	h_Data = (float *)mxMalloc(DATA_SIZE);

	//fprintf(stderr,"Casting kernel and data as float\n");
	// Load the Kernel and data into variables with complex datatype
	for(i = 0; i < KERNEL_W; i++) {
		for(j = 0; j < KERNEL_H; j++) {
			h_Kernel[i+j*KERNEL_W] = (float) in_Kernel[j+i*KERNEL_H];
			//h_Kernel[i+j*KERNEL_W].y = 0;
		}
	}

	for(i = 0; i < DATA_W; i++) {
		for(j = 0; j < DATA_H; j++) {
			h_Data[i+j*DATA_W] = (float) in_Data[j+i*DATA_H];
			//h_Data[i+j*DATA_W].y = 0;
		}
	}

	//fprintf(stderr,"Allocating GPU space, creating fft plan\n");
	h_Result = (float *)mxMalloc(FFT_SIZE);

	cudaMallocArray(&a_Kernel, &float2tex, KERNEL_W, KERNEL_H) ;
	cudaMallocArray(&a_Data,   &float2tex,   DATA_W,   DATA_H) ;
	cudaMalloc((void **)&d_PaddedKernel, 	FFT_SIZE) ;
	cudaMalloc((void **)&d_PaddedData,   	FFT_SIZE) ;
	cudaMalloc((void **)&fft_PaddedKernel, 	CFFT_SIZE);
	cudaMalloc((void **)&fft_PaddedData, 	CFFT_SIZE);

	cufftPlan2d(&FFTplan_C2R, FFT_H, FFT_W, CUFFT_C2R) ;
	cufftPlan2d(&FFTplan_R2C, FFT_H, FFT_W, CUFFT_R2C) ;

	cudaMemset(d_PaddedKernel, 0, FFT_SIZE) ;
	cudaMemset(d_PaddedData,   0, FFT_SIZE) ;

	//fprintf(stderr,"Copying to GPU\n");
	// copying input data and convolution kernel from host to CUDA arrays
	cudaMemcpyToArray(a_Kernel, 0, 0, h_Kernel, KERNEL_SIZE, cudaMemcpyHostToDevice) ;
	cudaMemcpyToArray(a_Data,   0, 0, h_Data,   DATA_SIZE,   cudaMemcpyHostToDevice) ;
	//binding CUDA arrays to texture references
	cudaBindTextureToArray(texKernel, a_Kernel) ;
	cudaBindTextureToArray(texData,   a_Data)   ;

	//Block width should be a multiple of maximum coalesced write size 
	//for coalesced memory writes in padKernel() and padData()
	dim3 threadBlock(16, 12);
	dim3 kernelBlockGrid(iDivUp(KERNEL_W, threadBlock.x), iDivUp(KERNEL_H, threadBlock.y));
	dim3 dataBlockGrid(iDivUp(FFT_W, threadBlock.x), iDivUp(FFT_H, threadBlock.y));

	//fprintf(stderr,"Padding convolution kernel\n");
	// padding convolution kernel
	padKernel<<<kernelBlockGrid, threadBlock>>>(
		d_PaddedKernel,
		FFT_W,
		FFT_H,
		KERNEL_W,
		KERNEL_H,
		KERNEL_X,
		KERNEL_Y
		);

	//fprintf(stderr,"Padding input data array\n");
	// padding input data array
	padData<<<dataBlockGrid, threadBlock>>>(
		d_PaddedData,
		FFT_W,
		FFT_H,
		DATA_W,
		DATA_H,
		KERNEL_W,
		KERNEL_H,
		KERNEL_X,
		KERNEL_Y
		);

	//fprintf(stderr,"Computing FFT\n");
	cufftExecR2C(FFTplan_R2C, (cufftReal *)d_PaddedKernel, (cufftComplex *)fft_PaddedKernel);
	cufftExecR2C(FFTplan_R2C, (cufftReal *)d_PaddedData, (cufftComplex *)fft_PaddedData);

	modulateAndNormalize<<<16, 128>>>(
		fft_PaddedData,
		fft_PaddedKernel,
		FFT_W * FFT_H
		);
	cufftExecC2R(FFTplan_C2R, (cufftComplex *)fft_PaddedData, (cufftReal *)d_PaddedData);

	//fprintf(stderr,"Fetching result from GPU\n");
	cudaMemcpy(h_Result, d_PaddedData, FFT_SIZE, cudaMemcpyDeviceToHost) ;

	//fprintf(stderr,"Copying to MATLAB output\n");
	// Copy the data into a MATLAB output variable
	for (i = 0; i < DATA_W; i++) {
		for (j = 0; j < DATA_H; j++) {
			output[DATA_H*i + j] = (double) h_Result[i+j*FFT_W];
		}
	}

	//fprintf(stderr,"Freeing memory\n");
	cudaUnbindTexture(texData);
	cudaUnbindTexture(texKernel);
	cufftDestroy(FFTplan_C2R);
	cufftDestroy(FFTplan_R2C);
	cudaFree(d_PaddedData);
	cudaFree(d_PaddedKernel);
	cudaFree(fft_PaddedData);
	cudaFree(fft_PaddedKernel);
	cudaFreeArray(a_Data);
	cudaFreeArray(a_Kernel);
	mxFree(h_Result);
	mxFree(h_Data);
	mxFree(h_Kernel);

}

////////////////////////////////////////////////////////////////////////////////
// Main program
////////////////////////////////////////////////////////////////////////////////
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {	
	// Check inputs
	if (nrhs !=2) mexErrMsgTxt("Must have two input arguments: data, kernel");
	if (nlhs !=1) mexErrMsgTxt("Must have one output argument");
	if ( mxIsComplex(prhs[0]) || !mxIsClass(prhs[0],"double")) {
		mexErrMsgTxt("Input must be real, double type");
	}
	if ( mxIsComplex(prhs[1]) || !mxIsClass(prhs[1],"double")) {
		mexErrMsgTxt("Input must be real, double type");
	}
	/*
	// First we check to see if the data is ~too small, and if so, throw it back to MATLAB
	if ( (mxGetNumberOfElements(prhs[0]) < 32768) && (mxGetNumberOfElements(prhs[1]) < 64) ) {
		if(debug) fprintf(stderr,"Too few elements, using CPU convolution...");
		prhs[3] = mxCreateString("same");
		
		mexCallMATLAB(1, plhs, 3, (mxArray **)prhs, "conv2");
	}
	*/
	
	// Otherwise, we want to do this the right way!
	else {
		int KERNEL_W, KERNEL_H, DATA_W, DATA_H, FFT_W, FFT_H, PADDING_H, PADDING_W;

		// Data dimensions
		DATA_H = mxGetM(prhs[0]);
		DATA_W = mxGetN(prhs[0]);
		if(debug) fprintf(stderr,"Data size: h=%d, w=%d\n",DATA_H,DATA_W);

		// Kernel dimensions
		KERNEL_H = mxGetM(prhs[1]);
		KERNEL_W = mxGetN(prhs[1]);
		if(debug) fprintf(stderr,"Kernel size: h=%d, w=%d\n",KERNEL_H,KERNEL_W);

		// Width and height of padding for "clamp to border" addressing mode
		PADDING_W = KERNEL_W - 1;
		PADDING_H = KERNEL_H - 1;

		// Derive FFT size from data and kernel dimensions
		//fprintf(stderr,"Calculating FFT size\n");
		FFT_W = calculateFFTsize(DATA_W + PADDING_W);
		FFT_H = calculateFFTsize(DATA_H + PADDING_H);
		if(debug) fprintf(stderr,"FFT size: h=%d, w=%d\n",FFT_H,FFT_W);
		
		plhs[0] = mxCreateDoubleMatrix(DATA_H, DATA_W, mxREAL);
		double *output = mxGetPr(plhs[0]);
		
		double *input_kernel = mxGetPr(prhs[1]);
		double *input_data   = mxGetPr(prhs[0]);
		
		// If there's just too much data to do in a single run, we need to break it up, eh?
		// how much "too big" is it?
		int MAX_FFT_W = 1048576/FFT_H;
		if ( FFT_W > MAX_FFT_W ) { // we need to break up the data
			if(debug) fprintf(stderr,"Max FFT width: %d, actual FFT width: %d\n",MAX_FFT_W,FFT_W);
			
			int STRIP_W = MAX_FFT_W-KERNEL_W+1;
			int STRIP_SIZE = STRIP_W * DATA_H * sizeof(double);
			int OVERLAP_SIZE = DATA_H * KERNEL_W/2 * sizeof(double);
			
			double *strip_output = (double *)mxMalloc(STRIP_SIZE);
			double *strip_input  = (double *)mxMalloc(STRIP_SIZE);
			
			int REMAIN_W = DATA_W; // counter showing how much of the data remains to be processed
			
			// Do the first strip
			if(debug) fprintf(stderr,"Writing first strip from 0 to %d\n",STRIP_W);
			cudaMemcpy(strip_input, input_data, STRIP_SIZE, cudaMemcpyHostToHost);
			fftFunction(strip_output, strip_input, input_kernel, DATA_H, STRIP_W, KERNEL_H, KERNEL_W);
			cudaMemcpy(output, strip_output, STRIP_SIZE, cudaMemcpyHostToHost);
			
			REMAIN_W -= STRIP_W - KERNEL_W/2; // need some overlap on the right..
			
			while ( REMAIN_W > STRIP_W ) {
				if(debug) fprintf(stderr,"Writing strip from %d to %d\n",DATA_W-REMAIN_W,DATA_W-REMAIN_W+STRIP_W);
				// read the strip
				cudaMemcpy(strip_input, input_data + DATA_H*(DATA_W-REMAIN_W-KERNEL_W/2), STRIP_SIZE,cudaMemcpyHostToHost);
				// convolve the strip
				fftFunction(strip_output, strip_input, input_kernel, DATA_H, STRIP_W, KERNEL_H, KERNEL_W);
				// copy the result into the output
				cudaMemcpy(output + DATA_H*(DATA_W-REMAIN_W), strip_output+DATA_H*KERNEL_W/2, STRIP_SIZE-OVERLAP_SIZE,cudaMemcpyHostToHost);
				
				// set the remaining number of columns
				REMAIN_W -= STRIP_W - KERNEL_W;
			}
			
			// Now we have to do the remaining edge strip
			int LAST_STRIP_SIZE = REMAIN_W * DATA_H * sizeof(double);
			double *last_strip_output = (double *)mxMalloc(LAST_STRIP_SIZE+OVERLAP_SIZE);
			double *last_strip_input  = (double *)mxMalloc(LAST_STRIP_SIZE+OVERLAP_SIZE);
			
			if(debug) fprintf(stderr,"Writing last strip from %d to end\n",DATA_W-REMAIN_W);
			cudaMemcpy(last_strip_input, input_data+DATA_H*(DATA_W-REMAIN_W-KERNEL_W/2),LAST_STRIP_SIZE+OVERLAP_SIZE,cudaMemcpyHostToHost);
			fftFunction(last_strip_output, last_strip_input, input_kernel, DATA_H, REMAIN_W+KERNEL_W/2, KERNEL_H, KERNEL_W);
			if(debug) fprintf(stderr,"Writing last strip from %d to end\n",DATA_W-REMAIN_W);
			cudaMemcpy(output + DATA_H*(DATA_W-REMAIN_W), last_strip_output+DATA_H*KERNEL_W/2, LAST_STRIP_SIZE,cudaMemcpyHostToHost);
			
			mxFree(strip_output);
			mxFree(strip_input);
			mxFree(last_strip_output);
			mxFree(last_strip_input);
		}
		else {
			fftFunction(output, input_data, input_kernel, DATA_H, DATA_W, KERNEL_H, KERNEL_W);
		}
	}	
}