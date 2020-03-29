function projectHis(FileMode,ExperimentType, Channel2)

%Do we have a second channel for Histone?
if strcmp(Channel2,'His-RFP')
    HisChannel=1;
else
    HisChannel=0;
end

NewName=[Prefix,'-His_',iIndex(i,3),'.tif'];

%Get the maximum projection and cap the highest brightness pixles
MaxHistoneImage=max(ImageHistone,3);
MaxHistoneImage(MaxHistoneImage>MaxHistone)=MaxHistone;

imwrite(MaxHistoneImage,[OutputFolder,filesep,NewName]);