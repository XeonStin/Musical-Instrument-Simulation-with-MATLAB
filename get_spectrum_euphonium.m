% 读取乐曲文件
[y, Fs] = audioread('euphonium.mp3');
Fs

% 作出时域波形
n = 1: length(y);
subplot(3, 1, 1);
plot(n, y);

% 取较稳定一段进行频域分析
y1 = y(101017+11079+1: 131552);
sound(y1, Fs);
L = length(y1);
n = 1: L;

subplot(3, 1, 2);
plot(n, y1);

% 分析频谱
Y = fft(y1, L);
f = n*Fs/L;

% 作频域图像
subplot(3, 1, 3);
stem(n, abs(Y));
axis([0 2000*L/Fs -inf inf]);

harmoScale = [];
% 根据频域图像确定谐波最高点位置，进一步读取谐波组成
for i = [104, 207, 310, 413, 516, 621, 724, 825]
    display(['i = ', num2str(i), ', f = ', num2str(f(i)), ', Y = ', num2str(Y(i))])
    harmoScale = [harmoScale, Y(i)];
end

tmp = abs(harmoScale(1));
harmoScale = harmoScale / tmp
