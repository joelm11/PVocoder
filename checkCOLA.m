function [] = checkCOLA(window, winSize)
% Simple check for COLA property
% Takes input window and plots with overlap add over several periods
outp = zeros(1, winSize * 10);
for i = 0:20 
    a = i * winSize/2 + 1;      % Current window start pos
    b = (i + 1) * winSize/2;    % Current window mid pos 
    c = b+winSize/2;            % Curr window end pos
    outp(1, a : b) = outp(1, a : b) + window(1 : winSize/2); % Overlap add
    outp(1, (b+1) : c) = window(winSize/2+1:end);            % Append
end 
outp = outp / max(outp);
plot(outp) 
title('Window OLA Over 10 Periods')
axis([0 5700 0 1.1])
end