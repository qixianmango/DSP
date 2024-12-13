clear;
close all;

% 设计目标参数
fp = 100;  % 通带截止频率 (Hz)
fs = 200;  % 阻带截止频率 (Hz)
Rp = 2;    % 通带最大衰减 (dB)
Rs = 60;   % 阻带最小衰减 (dB)
Fs = 1000; % 采样频率 (Hz)

% 转换为角频率
Wp = 2*pi*fp;
Ws = 2*pi*fs;

% 计算巴特沃斯滤波器的阶数和归一化截止频率
[N, Wn] = buttord(Wp, Ws, Rp, Rs, 's');

% 设计巴特沃斯模拟滤波器
[b, a] = butter(N, Wn, 's');

% 计算并绘制模拟滤波器的幅度频率特性
w = linspace(1, 400, 100) * 2*pi;  % 频率范围
H = freqs(b, a, w);
figure(1);
plot(w/2/pi, 20*log10(abs(H)), 'LineWidth', 1.5);
title('巴特沃斯模拟滤波器幅频特性');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
grid on;

% 使用脉冲响应不变法设计数字滤波器
[bz, az] = impinvar(b, a, Fs);

% 绘制数字滤波器的零极点分布图
figure(2);
zplane(bz, az);
title('脉冲响应不变法零极点分布图');
grid on;

% 绘制数字滤波器的幅度和相位频率特性
figure(3);
subplot(2, 1, 1);
freqz(bz, az, 256, Fs);
grid on;
title('巴特沃斯数字滤波器幅频特性');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');

subplot(2, 1, 2);
title('巴特沃斯数字滤波器相频特性');
grid on;

% 生成带有干扰频率的时域信号
n = 0:99;  % 时间样本
x = cos(2*pi*50*n/Fs) + cos(2*pi*500*n/Fs);

% 滤波前输入信号的时域波形
figure(4);
subplot(1, 2, 1);
plot(n, x, 'LineWidth', 1.5);
title('滤波前输入信号');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

% 通过数字滤波器进行滤波
y = filter(bz, az, x);

% 滤波后输出信号的时域波形
subplot(1, 2, 2);
plot(n/Fs, y, 'LineWidth', 1.5);
title('滤波后输出信号');
xlabel('时间 (s)');
ylabel('幅度');
grid on;

