clc;
clear;

% 数字滤波器设计目标
wp = 0.4 * pi;   % 通带截止频率 (rad/s)
ws = 0.6 * pi;   % 阻带截止频率 (rad/s)
rp = 0.5;        % 通带最大衰减 (dB)
rs = 50;         % 阻带最小衰减 (dB)
fs = 1000;       % 采样频率 (Hz)

% 将数字滤波器指标转换为模拟滤波器的指标（K = 1）
Omgp = tan(wp / 2);  % 通带截止频率转换为模拟频率
Omgs = tan(ws / 2);  % 阻带截止频率转换为模拟频率

% 模拟滤波器的计算
[N, wo] = cheb1ord(Omgp, Omgs, rp, rs, 's');  % 计算模拟滤波器的阶数 N 和截止频率 wo
[b, a] = cheby1(N, rp, wo, 's');              % 设计 Chebyshev I 型模拟滤波器

% 计算模拟滤波器的频率响应
[Ha, Omg] = freqs(b, a);                     % 求模拟系统频率响应
dbHa = 20 * log10(abs(Ha) / max(abs(Ha)) + eps);  % 转换为 dB 幅度响应

% 使用双线性变换法设计数字滤波器
[bd, ad] = bilinear(b, a, fs);               % 通过双线性变换法得到数字滤波器系数
[H, w] = freqz(bd, ad);                      % 计算数字系统频率响应
dbH = 20 * log10(abs(H) / max(abs(H)));      % 转换为 dB 幅度响应

% 绘制各个图形
figure;

% a) 模拟滤波器幅度响应（dB）
subplot(3, 2, 1);
plot(Omg * Omgp / (2 * pi), dbHa, 'LineWidth', 1.5);
grid on;
title('a) 模拟滤波器幅度响应 (dB)');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');

% b) 数字滤波器幅度响应
subplot(3, 2, 2);
plot(w / pi, abs(H), 'LineWidth', 1.5);
title('b) 数字滤波器幅度响应');
xlabel('频率 (归一化)');
ylabel('幅度');
axis([0, 1, 0, 1]);

% c) 数字滤波器幅度响应 (dB)
subplot(3, 2, 3);
plot(w / pi, dbH, 'LineWidth', 1.5);
grid on;
title('c) 数字滤波器幅度响应 (dB)');
xlabel('频率 (归一化)');
ylabel('幅度 (dB)');
axis([0, 1, -300, 100]);

% d) 数字滤波器幅度响应 (dB)，更详细的区域
subplot(3, 2, 4);
plot(w / pi, dbH, 'LineWidth', 1.5);
grid on;
title('d) 数字滤波器幅度响应 (dB)');
xlabel('频率 (归一化)');
ylabel('幅度 (dB)');
axis([0, 0.7, -60, 5]);

% e) 相位响应
subplot(3, 2, 5);
plot(w / pi, angle(H) / pi, 'LineWidth', 1.5);
title('e) 数字滤波器相位响应');
xlabel('频率 (归一化)');
ylabel('相位 (\pi rad)');
axis([0, 1, -1, 1]);

% f) 时域序列（有干扰频率）
n = 0:500;  % 生成时域序列的样本点
x = cos(2 * pi * 0.1 * n) + cos(2 * pi * 0.5 * n) + 0.5 * randn(1, 501);  % 信号包含干扰频率

% 绘制时域序列
subplot(3, 2, 6);
plot(n, x, 'LineWidth', 1.5);
title('f) 时域序列（有干扰频率）');
xlabel('时间 (样本)');
ylabel('幅值');
grid on;

% 通过数字滤波器滤波
y = filter(bd, ad, x);  % 使用数字滤波器滤波时域信号

% 显示滤波后的结果
figure;
subplot(2, 1, 1);
plot(n, x, 'LineWidth', 1.5);
title('时域序列（有干扰频率）');
xlabel('时间 (样本)');
ylabel('幅值');
grid on;

subplot(2, 1, 2);
plot(n, y, 'LineWidth', 1.5);
title('滤波后输出（无干扰）');
xlabel('时间 (样本)');
ylabel('幅值');
grid on;
