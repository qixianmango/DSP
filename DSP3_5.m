clc;
clear;

% 给定设计目标
wp = 0.5 * pi;   % 通带截止频率 (弧度/秒)
ws = 0.6 * pi;   % 阻带截止频率 (弧度/秒)
N = 20;           % 滤波器阶数

tr_width = ws - wp;   % 过渡带宽度
alpha = (N - 1) / 2;  % N 为偶数

% 计算频率采样点
l = 0:1:N-1; 
wl = (2*pi / N) * l;

% 理想滤波器的频率响应
Hrs = [ones(1,6), zeros(1,9), ones(1,5)];  % 偶对称
Hdr = [1 1 0 0];  % 期望的频率响应
wdl = [0 0.5 0.6 1];  % 理想滤波器的频率区间
k1 = 0:(N/2 - 1);
k2 = (N/2 + 1):N-1;

% 计算理想频率响应的相位
angH = [-alpha * (2 * pi) / N * k1, 0, alpha * (2 * pi) / N * (N - k2)];

% 生成频率采样法的滤波器系数
H = Hrs .* exp(1i * angH);

% 计算单位脉冲响应 h(n)
h = real(ifft(H, N));

% 计算频率响应
[H_freq, w] = freqz(h, 1, 1000, 'whole');

% 求 FIR 滤波器频响的 dB 值
db = 20 * log10((abs(H_freq) + eps) / max(abs(H_freq)));

% 绘图部分

% 绘制理想滤波器的频率响应
figure(2); clf;
subplot(221);
plot(wl(1:11) / pi, Hrs(1:11), 'o', wdl, Hdr, 'linewidth', 2);
title('理想滤波器频域波形');
xlabel('频率 (单位: π)');
ylabel('H_r(k)');
axis([0 1 -0.1 1.2]);
set(gca, 'XTick', [0 0.5 0.6 1]);
grid;

% 绘制滤波器的单位脉冲响应 h(n)
subplot(222);
stem(0:N-1, h, 'm');
title('单位脉冲响应 h(n)');
xlabel('n');
ylabel('h(n)');
axis([-1, N, -0.15, 0.55]);
grid;

% 绘制滤波器的频率响应幅度
subplot(223);
plot(w / pi, abs(H_freq), 'LineWidth', 2);
title('滤波器频率响应幅度');
xlabel('频率 (单位: π)');
ylabel('幅度');
grid;

% 绘制滤波器的频率响应的 dB 值
subplot(224);
plot(w / pi, db, 'LineWidth', 2);
title('滤波器频率响应 (dB)');
xlabel('频率 (单位: π)');
ylabel('幅度 (dB)');
axis([0 1 -100 5]);
grid;

% 打印最大通带衰减和阻带衰减
delta_w = 2 * pi / 1000;  % 将 2π 等分为 1000 份
Rp1 = -min(db(1:round(wp / delta_w) + 1));  % 通带衰减
As1 = -max(db(round(ws / delta_w) + 1:end));  % 阻带衰减

disp(['通带最大衰减 (Rp): ', num2str(Rp1), ' dB']);
disp(['阻带最小衰减 (As): ', num2str(As1), ' dB']);
