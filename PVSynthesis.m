function [reconstOutp] = PVSynthesis(Mag, Phase, anHop, synthHop)
% PVocoder Synthesis 

% Precompute constants 
pi2 = 2 * pi; 
[numFrames, numBins] = size(Mag); 
binFreqs = pi2 .* (0 : numBins - 1) ./ numBins;
phShiftFactor = anHop * binFreqs; 
% Containers
nPhase = zeros(numFrames, numBins); 
synPhase = zeros(numFrames, numBins);
instFreq = zeros(numFrames, numBins); 
synthOut = zeros(numFrames, numBins);
reconstrWins = zeros(numFrames, numBins);  
reconstOutp = zeros(1, synthHop * numFrames + numBins); % WARNING HARDCODE 


% Loop over frames and calculate instantaneous frequency 
for i = 2 : numFrames 
    % Phase Difference 
    nPhase(i, :) = Phase(i, :) - Phase(i - 1, :);
    % Subtract off phase shift factor (Heterodyned phase) 
    nPhase(i, :) = nPhase(i, :) - phShiftFactor;
    % Take principal determination of phase (I think wraptopi works here)
    nPhase(i, :) = wrapToPi(nPhase(i, :));
    % Instantaneous Frequency 
    instFreq(i, :) = binFreqs + nPhase(i, :) / anHop;
end  

% Phase propagation for time-scaling with resynthesis  
start = 1;  
lst = start + numBins - 1;
mid = lst - synthHop; 
for j = 2 : numFrames  
    % Augment bin phases by factor of synthHop
    synPhase(j, :) = synPhase(j - 1, :) + synthHop * instFreq(j, :);  
    % Recombine Mag and Phase for input to IFFT
    synthOut(j, :) = Mag(j, :).*exp(1i * synPhase(j, :)); 
    reconstrWins(j, :) = ifft(fftshift(synthOut(j, :)), 'symmetric');
    % Overlap add/append data to reconstructed output
    reconstOutp(1, start:mid) = reconstOutp(1, start:mid) + ...
                                reconstrWins(j, 1 : numBins - synthHop); 
    reconstOutp(1, mid+1: lst) = reconstrWins(j, numBins - synthHop+1:end); 
    % Update pointers
    start = (j - 1) * synthHop; 
    lst = start + numBins - 1;
    mid = lst - synthHop;
end 
% Resynthesis loop

end