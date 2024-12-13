clc;
clear;

% 给定设计指标
fp = 1000;  % 通带截止频率 (Hz)
fs = 1200;  % 阻带截止频率 (Hz)
Fs = 10000; % 采样频率 (Hz)
rs = 100;   % 阻带最小衰减 (dB)
rp = 1;     % 通带最大衰减 (dB)

% 计算归一化频率
wp = 2 * pi * fp / Fs;  % 通带截止频率（归一化）
ws = 2 * pi * fs / Fs;  % 阻带截止频率（归一化）

% 过渡带宽度
B = ws - wp;

% 根据过渡带宽度计算滤波器阶数 N
M = ceil((rs - 8) / (2.285 * B));  % FIR 滤波器阶数
wc = (wp + ws) / 2 / pi;  % 截止频率

% 创建一个有干扰频率的时域序列
x = [-4, -2, 0, -4, -6, -4, -2, -4, -6, -6, -4, -4, -6, -6, -2, 6, 12, 8, 0, -16, -38, -60, -84, -90, -66, -32, -4, -2, -4, 8, 12, 12, 10, 6, 6, 6, 4, 0, 0, 0, 0, 0, -2, -4, 0, 0, 0, -2, -2, 0, 0, -2, -2, -2, -2, 0]; 

% 画出干扰序列的时域图
subplot(3, 2, 1);
plot(x);
title('干扰序列时域图');
xlabel('时间');
ylabel('幅度');

% 对干扰序列进行 FFT 变换
y = fft(x, 1024);

% 画出干扰序列的频域图
subplot(3, 2, 2);
plot(abs(y));
title('干扰序列频域图');
xlabel('频率 (Hz)');
ylabel('幅度');

% 使用 Hamming 窗生成滤波器系数
hn1 = fir1(M, wc, hamming(M + 1));  % 求 Hamming 窗滤波器系数

% 绘制 Hamming 窗滤波器系数
N = length(hn1) - 1;
n = 0:N;
subplot(3, 2, 3);
stem(n, hn1, '.');
title('Hamming 窗');
xlabel('样本');
ylabel('幅度');

% 计算并绘制滤波器的频率响应
[Hw, w] = freqz(hn1);
subplot(3, 2, 4);
plot(w * Fs / (2 * pi), 20 * log10(abs(Hw)), 'LineWidth', 1.5);
grid on;
title('Hamming 窗频域响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');

% 通过滤波器处理干扰序列
hn2 = ifft(fft(hn1, 1024) .* fft(x, 1024), 1024);

% 绘制通过滤波器后的时域图
subplot(3, 2, 5);
plot(hn2);
title('通过滤波器后的时域图');
xlabel('时间');
ylabel('幅度');
grid on;

% 对滤波后的信号进行 FFT 变换
hn3 = fft(hn2);

% 绘制通过滤波器后的频域图
subplot(3, 2, 6);
plot(abs(hn3));
title('通过滤波器后的频域图');
xlabel('频率 (Hz)');
ylabel('幅度');
grid on;

% 计算 FIR 滤波器的频响 dB 值
db = 20 * log10((abs(hn3) + eps) / max(abs(hn3)));

% 计算通带波动（Passband Ripple）和阻带衰减（Stopband Attenuation）
delta_w = 2 * pi / 1000;  % 将 2*pi 等分 1000 份

% 计算通带波动（Passband Ripple）
Rp1 = -min(db(1:ceil(wp / delta_w) + 1));  % 通带波动（dB）

% 计算阻带衰减（Stopband Attenuation）
As1 = -max(db(ceil(ws / delta_w) + 1:501));  % 阻带衰减（dB）

% 显示结果
disp(['通带波动 (Passband Ripple): ', num2str(Rp1), ' dB']);
disp(['阻带衰减 (Stopband Attenuation): ', num2str(As1), ' dB']);
