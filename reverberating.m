clear all;

a = 0.5;
R = 5000;
Bz = [a, zeros(1, R-1), 1];
Az = [1, zeros(1, R-1), a];

[h, w] = freqz(Bz, Az);

subplot(2, 1, 1);
plot(w, abs(h));

subplot(2, 1, 2);
plot(w, angle(h));