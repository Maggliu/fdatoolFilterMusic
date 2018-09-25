function Hd = bandpassFIR(Fs,Fstop1,Fpass1,Fpass2,Fstop2)
%BANDPASSFIR Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 04-Jan-2018 22:02:19

% Elliptic Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
%Fs = 40000;  % Sampling Frequency

%Fstop1 = 500;     % First Stopband Frequency
%Fpass1 = 600;     % First Passband Frequency
%Fpass2 = 1000;    % Second Passband Frequency
%Fstop2 = 1200;    % Second Stopband Frequency
Astop1 = 60;      % First Stopband Attenuation (dB)
Apass  = 1;       % Passband Ripple (dB)
Astop2 = 80;      % Second Stopband Attenuation (dB)
match  = 'both';  % Band to match exactly

% Construct an FDESIGN object and call its ELLIP method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'ellip', 'MatchExactly', match);

% [EOF]
