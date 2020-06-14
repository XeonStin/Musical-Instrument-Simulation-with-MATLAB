clear all;

% 上低音号（Euphonium）的谐波组成
harmoScale = [ 0.4278 + 0.9039i   0.8979 + 0.8038i   1.1748 + 0.1950i   0.3093 + 0.6547i   0.3684 + 0.2864i   0.2762 + 0.0290i   0.1530 - 0.0444i   0.0150 - 0.0939i   0.0173 - 0.0451i   0.0070 - 0.0279i    0.0010 - 0.0169i   0.0015 - 0.0120i  -0.0032 + 0.0080i];     % euphonium
harmoNum =  length(harmoScale);

% 曲谱，定义s为连音
s = -99;
score = [
    7 s s s s s s s 5 6 7 8 s 9 s s 10 11 ...           % 1
    7 s s s s s s s ...
    7 s 10 s 12 s 12 s s s s 11 9.5 11 13 s s s s s ...
    12 s 11 s 10 9 10 s s s s s s s ...                 % 4
    10 s 9 s s 7 8 s s s s s 9 10 ...
    11 s s s 9 s 8 s 7 s s s s s 5 s ...
    8.5 s s s 8 s s s 7 s 6 5 6 s s s s s s s ...
    4 5 6 6 s s s s s 2 s 4 s s s s s s s ...           % 8
    3 s s s s s s s ...
    5 s s s s 0 3 7 s s s s 3 10 ...
    9 s 8 7 s 6 7 s s s s 5 6 ...
    7 s s s 6 5 4 s s s s 5 3 ...
    1 s s s 3 s s s 3 s s s 4 s s s ...
    5 s s s s 0 3 7 s s s s 3 10 ...
    9 s 8 7 s 6 5 s s s 4 s s s ...
    3 s s s s s ...
    10 10 9  s 10 s 11 s 12 s s s ...
    12 12 11 s 12 s 13 s 12 s s s ...
    10 11 12 s s s s s 7 s s s s s 10 s s s s s ...
    7 8 9 10 11 12 14 s s s s 13 12 11 s s s s ...
    12 10 8 s s s s s s s ...
    12 s s s 9 s s s 10 s s s s s s s s s s s s s s s
];      % hibike euphonium

% 音高与频率对应表 C3 - B4 包括半音
noteFreq = [
    123.47 130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 174.61, 185.00, 196.00, 207.65, 220.00, 233.08, 246.94, 246.94
];

% 根据调式调整音高
mode = [
    1, 1, 1, 1, 2^(-1/12), 2^(-1/12), 1, 1, 1, 1, 2^(-1/12), 2^(-1/12), 2^(-1/12), 2^(-1/12)
];

% 采样率
Fs = 44100;

% 淡入淡出模式，中间点作插值处理
noteioFilterx = [0  0.01  0.02  0.1  0.2   0.3  0.5   0.66   0.8   0.90  0.95  0.991  1]';
noteioFiltery = [0      0  0.39  0.6  0.73  0.8  0.82  0.92  0.98     1  0.2       0  0]';
noteiFilterx  = [0  0.3   0.6  1]';
noteiFiltery  = [0  0.3  0.85  1]';
noteoFilterx  = [0   0.4  0.7  1]';
noteoFiltery  = [1  0.85  0.3  0]';

% 设置音量大小、乐曲速度
amp = 0.2;
noteLength = floor(Fs/4);
L = length(score)*noteLength;
music = zeros(1, L);
n = 1: L;
len = 1;
curStart = 0;

% 生成乐曲
for i = 1: length(score)
    % 处理连音
    if (i+1<=length(score)) && (score(i+1) == s)
        len = len + 1;
        continue
    end
    
    % 设置淡入淡出模式
    tx = linspace(0, 1, len*noteLength);
    ty = interp1(noteioFilterx, noteioFiltery, tx, 'pchip');
    if curStart == 0
        txi = linspace(0, 1, len*noteLength);
        tyi = interp1(noteiFilterx, noteiFiltery, txi, 'pchip');
    end
    if i == length(score)
        txo = linspace(0, 1, len*noteLength);
        tyo = interp1(noteoFilterx, noteoFiltery, txo, 'pchip');
    end
    
    % 确定当前音符频率
    octave = 1;
    note = score(curStart+1);
    while note > 7
        octave = octave * 2;
        note = note - 7;
    end
    while note < 1
        octave = octave / 2;
        note = note + 7;
    end
    note = note * 2;
    freq = octave * noteFreq(note) * mode(note);

    ampTmp = 0;
    for j = 1: len*noteLength
        % 加入各次谐波
        for k = 1: harmoNum
            music(curStart*noteLength+j) = music(curStart*noteLength+j) + amp * real(exp(1j*2*pi*freq*k*j/Fs) * harmoScale(k));
        end
        % 模拟每个音的送气收气产生的幅值淡入淡出，并且根据音高调整幅值
        music(curStart*noteLength+j) = music(curStart*noteLength+j) * ty(j) * ((score(curStart+1)+1)/28+0.5);
        
        % 在乐曲起始和结束处添加淡入淡出效果
        if curStart == 0
            music(curStart*noteLength+j) = music(curStart*noteLength+j) * tyi(j);
        end
        if i == length(score)
            music(curStart*noteLength+j) = music(curStart*noteLength+j) * tyo(j);
        end
    end
    
    curStart = curStart + len;
    len = 1;
end

subplot(2, 1, 1);
plot(n, music)
axis([-inf inf -1 1]);

% 全通滤波器产生混响效果
a = 0.5;
R = 5000;
Bz = [a, zeros(1, R-1), 1];
Az = [1, zeros(1, R-1), a];
music2 = 0.5*filter(Bz, Az, music) + music;

% 模拟气息产生的振幅抖动
for i = 1: L
    music2(i) = music2(i) .* (1+0.072*sin(2*pi*4*i/Fs));
end

% 播放和存储乐曲
sound(music2, Fs);
subplot(2, 1, 2);
plot(n/Fs, music2)
axis([-inf inf -1 1]);
audiowrite('hibike-euphonium-trumpet.flac', music2, Fs, 'BitsPerSample', 24);