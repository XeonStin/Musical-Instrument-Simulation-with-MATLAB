% ��ȡ�����ļ�
[y, Fs] = audioread('euphonium.mp3');
Fs

% ����ʱ����
n = 1: length(y);
subplot(3, 1, 1);
plot(n, y);

% ȡ���ȶ�һ�ν���Ƶ�����
y1 = y(101017+11079+1: 131552);
sound(y1, Fs);
L = length(y1);
n = 1: L;

subplot(3, 1, 2);
plot(n, y1);

% ����Ƶ��
Y = fft(y1, L);
f = n*Fs/L;

% ��Ƶ��ͼ��
subplot(3, 1, 3);
stem(n, abs(Y));
axis([0 2000*L/Fs -inf inf]);

harmoScale = [];
% ����Ƶ��ͼ��ȷ��г����ߵ�λ�ã���һ����ȡг�����
for i = [104, 207, 310, 413, 516, 621, 724, 825]
    display(['i = ', num2str(i), ', f = ', num2str(f(i)), ', Y = ', num2str(Y(i))])
    harmoScale = [harmoScale, Y(i)];
end

tmp = abs(harmoScale(1));
harmoScale = harmoScale / tmp
