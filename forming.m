% 整体包络波形
noteioFilterx = [0  0.01  0.02  0.1  0.2   0.3  0.5   0.66   0.8   0.90  0.95  0.991  1]';
noteioFiltery = [0      0  0.39  0.6  0.73  0.8  0.82  0.92  0.98     1  0.2       0  0]';

tx = 0: 0.01: 1; % 插值
ty = interp1(noteioFilterx, noteioFiltery, tx, 'pchip');
%subplot(3, 1, 1);
plot(tx, ty)

% 乐曲开头淡入
noteiFilterx = [0  0.3  0.6  1]';
noteiFiltery = [0  0.3 0.85  1]';

txi = 0: 0.01: 1; % 插值
tyi = interp1(noteiFilterx, noteiFiltery, txi, 'pchip');
%subplot(3, 1, 2);
plot(txi, tyi)

% 乐曲结尾淡出
noteoFilterx = [0   0.4  0.7  1]';
noteoFiltery = [1  0.85  0.3  0]';
txo = 0: 0.01: 1; % 插值
tyo = interp1(noteoFilterx, noteoFiltery, txo, 'pchip');
%subplot(3, 1, 3);
plot(txo, tyo)