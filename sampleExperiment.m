function [output1,output2] = sampleExperiment(data,param1,param2,param3)
% 
% sampleExperiment: sample function for experiment with input parameters
%
% [syntax]
%   [output1,output2] = sampleExperiment(param1,param2,param3)
%
% [inputs]
%      data: input data
%    param1: parameter 1 (scalar)
%    param2: parameter 2 (scalar)
%    param3: parameter 3 (string, "max" or "min")
%
% [outputs]
%   output1: result of algorithm
%   output2: result of algorithm
%

random = param2 * randn(size(data)) + param1;
randData = data + random;

if strcmp(param3, "max")
    output1 = max(randData(:));
elseif strcmp(param3, "min")
    output1 = min(randData(:));
else
    error("The input param3 is not supported.\n");
end
output2 = median(randData(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%