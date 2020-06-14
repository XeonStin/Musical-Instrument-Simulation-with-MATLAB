% 读取乐曲文件
[y, Fs] = audioread('trumpetA4.mp3');
Fs

% 作出时域波形
n = 1: length(y);
subplot(3, 1, 1);
plot(n, y);

% 取较稳定一段进行频域分析
y1 = y(20000: 110000);
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
axis([0 20000 -inf inf]);

harmoScale = [];
% 根据频域图像确定谐波最高点位置，进一步读取谐波组成
for i = [901, 1801, 2701, 3612, 4512, 5412, 6312, 7180, 8133, 9033, 9933, 10833, 11712]
    display(['i = ', num2str(i), ', f = ', num2str(f(i)), ', Y = ', num2str(Y(i))])
    harmoScale = [harmoScale, Y(i)];
end

tmp = abs(harmoScale(1));
harmoScale = harmoScale / tmp
