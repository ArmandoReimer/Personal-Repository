function neuralNetClassifier(image)

    image = double(image);
    
    inputs = [];
    outputs = [];
    hiddens1 = [];
    weights = [];
    
    weights(1) = 1;
    
    inputs(1) = image;
    hiddens1(1) = inputs(1)*weights(1);
    outputs(1) = 1 ./ (1 + exp(-hiddens1(1)));
    imshow(outputs(1), []);
    
end