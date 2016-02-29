function processedData = inputProcessingModule(signals)
% inputProcessingModule: filters the input to extract meaningfull
% information and to correctly format the data.
%   Input: the data coming from sensor as structure composed by: sig (the
%   signal itself) and filterName (the filter to be applied as string)
%   Output: the processed and formatted data


for ii = 1:length(signals)
    switch signals(ii).filterName
        case 'NoFiltering'
            result = signals(ii).sig(:);
        case 'LogPolarBW'
            result = getLogPolarBW(signals(ii).sig);
            result = result(:);
        case 'CartesianSaturation'
            result = getCartesianSaturation(signals(ii).sig);
            result = result(:);
        case 'LogPolarSaturation'
            result = getLogPolarSaturation(signals(ii).sig);
            result = result(:);
         otherwise
            disp('Warning: you have specified an unexpected filter!');
            disp('         No filter will be used!');
            result = signals(ii).sig(:);
    end
    signals(ii).sig = result;
end
processedData = signals;
end