function Med = fastMedian(IN,Dimm)
% Perform a fast nanmedian using succesive iterations with min and max
% It will be efficient only if the dim has a limited length (<50). This
% function is perfect for computing a Normal from meteorological record
% IN = N-dim matrix
% Dimm = dim of median

Stest = size(IN,Dimm) ;

if Stest > 60
  Med = nanmedian(IN,Dimm);
  return
end

d = 1:ndims(IN) ;
OtherDimm = setdiff(d,Dimm);
Dimm = {OtherDimm,Dimm};

[IN Sin]= Myreshape(IN,Dimm) ;
Med = nan(prod(Sin(OtherDimm)),1);
StillData = -1 ;

while ~isempty(StillData)
  
  if StillData~=-1 % not the first iteration
    % find min/max of each row
    [d indmin]=min(IN ,[],2);
    [d indmax]=max(IN ,[],2);
    
    % change min/max of each row to nan
    linearInd = sub2ind(size(IN),1:size(IN,1),indmin');
    IN(linearInd) = NaN;
    linearInd = sub2ind(size(IN),1:size(IN,1),indmax');
    IN(linearInd) = NaN;
  end
  % perform the mean of each rows
  MeanDum = nanmean(IN,2) ;
  
  % rows that have not been processed and have <=2 data => use the mean as
  % the median
  test = (sum(~isnan(IN),2)<=2 & isnan(Med));
  Med(test) = MeanDum(test);
  
  % check if a new iteration is needed
  StillData = find(sum(~isnan(IN),2)>2) ;
  
end
% put it back to the original dim
if length(Dimm{1})==1
  Med = permute(reshape(Med,[Sin(Dimm{1}) 1] ) , cell2mat(Dimm));
else
  Med = permute(reshape(Med,Sin(Dimm{1}) ) , cell2mat(Dimm));
end

function [Out s] = Myreshape(In,Dimm)
% re-dim In in n dimensions as length(Dimm). this function is useful when
% you want to apply mean/median/min/... to more than one dimension
% In is a n-dim matrix
% Dimm is m-dim cell that include the n dim of In (eg, {[1,2],3})
% Out is a m-dim matrix

s = size(In);

if max(cat(2,Dimm{:}))>length(s)
  s(length(s)+1:max(cat(2,Dimm{:})))=1;
end

outsize = [];
for i=1:length(Dimm)
  outsize = [outsize prod(s(Dimm{i}))];
end
if length(outsize)==1;outsize=[outsize 1];end
Out = reshape(permute(In,cell2mat(Dimm)),outsize);