function [Moduli, Phase] = PVAnalysis(x, winSize, hopSize)
% Perform analysis portion of phase vocoder 
% Reference: Bernardini et al. 
% TODO: Loop and containers need to be adapted for different length inputs  

% Variables to do with samples and windowing
numSamp = length(x);
numWin = ceil((numSamp - winSize) / (hopSize) - 1);   
% Matrices to store output data (Every row is a new window)
Moduli = zeros(numWin, winSize);
Phase = zeros(numWin, winSize);
fprintf("Window Size: %d\nHop Size: %d\n# Windows: %d", winSize, hopSize, numWin)

% Obtain window coefficients 
hanWin = hanning(winSize)';

start = 1;
for i = 1:numWin 
    % Grab samples 
    currWin = x(start:start + winSize - 1);
    % Apply window 
    wcurrWin = currWin .* hanWin; 
    % Calculate spectrum 
    X = fft(wcurrWin);  
    % Shift (Need to clarify why this is done) (Phase unwrapping)
    XCentered = fftshift(X);
    % Store spectrum for output
    R = abs(XCentered); 
    I = angle(XCentered);
    % Update output matrices 
    Moduli(i, :) = R; 
    Phase(i, :) = I;
    % Update start pointer
    start = start + hopSize;
end 

end