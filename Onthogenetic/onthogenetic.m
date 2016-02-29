function [ onthoSignal ] = Onthogenetic( catOutput, weightsArr )
%ONTHOGENETIC [onthoSignal] -> ritorna il segnale ontogenetico avendo in ingresso l'output
%del categorization e il vettore dei pesi
%   Detailed explanation goes here
result = zeros(size(catOutput));
for i=1:length(catOutput)
    result(i,1)=catOutput(i)*weightsArr(i);
end

onthoSignal = max(result);

end

