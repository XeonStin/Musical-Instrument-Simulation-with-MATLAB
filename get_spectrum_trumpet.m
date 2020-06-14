% ��ȡ�����ļ�
[y, Fs] = audioread('trumpetA4.mp3');
Fs

% ����ʱ����
n = 1: length(y);
subplot(3, 1, 1);
plot(n, y);

% ȡ���ȶ�һ�ν���Ƶ�����
y1 = y(20000: 110000);
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
axis([0 20000 -inf inf]);

harmoScale = [];
% ����Ƶ��ͼ��ȷ��г����ߵ�λ�ã���һ����ȡг�����
for i = [901, 1801, 2701, 3612, 4512, 5412, 6312, 7180, 8133, 9033, 9933, 10833, 11712]
    display(['i = ', num2str(i), ', f = ', num2str(f(i)), ', Y = ', num2str(Y(i))])
    harmoScale = [harmoScale, Y(i)];
end

tmp = abs(harmoScale(1));
harmoScale = harmoScale / tmp
