clear all;

harmoScale = [ 0.4278 + 0.9039i   0.8979 + 0.8038i   1.1748 + 0.1950i   0.3093 + 0.6547i   0.3684 + 0.2864i   0.2762 + 0.0290i   0.1530 - 0.0444i   0.0150 - 0.0939i   0.0173 - 0.0451i   0.0070 - 0.0279i    0.0010 - 0.0169i   0.0015 - 0.0120i  -0.0032 + 0.0080i];
harmoNum =  length(harmoScale);

% ²ÉÑùÂÊ
Fs = 44100;

n = 1:2*Fs;
amp = 0.2;
baseFreq = 441.4851;
genSound = zeros(1, length(n));
for k = 1: harmoNum
    genSound = genSound + amp * real(harmoScale(k) * exp(1j*2*pi*baseFreq*k*n/Fs));
end

sound(genSound, Fs);

plot(n, genSound)
axis([-inf inf -2 +2]);

L = length(n);
Ts = 1 / Fs;

Y = fft(genSound, L);
f = n*Fs/L;

subplot(2, 1, 1);
plot(n, genSound);

subplot(2, 1, 2);
stem(f, abs(Y));
axis([0 6000 -inf inf]);
