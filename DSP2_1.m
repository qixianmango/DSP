clear;
close all;

% 输入采样频率和信号带宽
Fc = input('输入信号的最大频率 (Fc): ');
Fs = input('输入采样频率 (Fs): ');

% 定义时间步长和时间范围
Dt = 0.001;
t = -0.05:Dt:0.05;

% 定义时域信号 xa(t)
xa = 50 * sinc(25 * t).^2;

% 绘制时域信号
figure;
subplot(3, 2, 1);
plot(t * 1000, xa, 'k', 'LineWidth', 1.5);
axis([-50, 50, 0, 60]);
xlabel('时间 (ms)');
ylabel('x_a(t)');
title('时域信号');
grid on;

% 计算信号的最大角频率和傅里叶变换采样点数
Wmax = 2 * pi * Fc;
K = 25;
k = 0:1:K;
W = k * Wmax / K;

% 连续时间傅里叶变换 (CTFT)
Xa = xa * exp(-1j * t' * W) * Dt;
Xa = real(Xa);

% 构造对称频率和幅度
W = [-fliplr(W), W(2:end)];
Xa = [fliplr(Xa), Xa(2:end)];

% 采样时间间隔和离散时间序列
ts = 1 / Fs;
t1 = -0.05:ts:0.05;
n1 = length(t1);
h = ones(1, n1);

% 绘制采样序列
subplot(3, 2, 3);
stem(t1 * 1000, h, '^', 'LineWidth', 1.2);
xlabel('时间 (ms)');
ylabel('幅值');
title('采样序列 h(t)');
grid on;

% 绘制连续时间傅里叶变换
subplot(3, 2, 5);
plot(W / (2 * pi * Fc), Xa * 100, 'k', 'LineWidth', 1.5);
xlabel('频率 (归一化)');
ylabel('X_a(j\omega) \times 100');
title('连续时间傅里叶变换');
grid on;

% 采样信号的离散傅里叶变换 (DFT)
n = -5:1:5;
x = 50 * sinc(25 * n * ts).^2;
w = pi * k / K;
X = x * exp(-1j * n' * w);
X = real(X);

w = [-fliplr(w), w(2:end)];
X = [fliplr(X), X(2:end)];

% 动态绘制采样后的时序列
for b = 1:1:length(x)
    subplot(3, 2, 4);
    stem(n(1:b) * ts * 1000, x(1:b), 'k', 'LineWidth', 1.2);
    xlabel('时间 (ms)');
    ylabel('幅值');
    title('采样后的时序列');
    grid on;
    pause(0.5);
end

% 绘制频域采样信号
wc = 0.1; % 归一化带宽
ws = (Fs / Fc) * wc; % 归一化采样频率
N = fix(0.5 / ws);

for i = 0:N
    % 绘制频谱
    subplot(3, 2, 6);
    stem([-ws * i, ws * i], [1, 1], '^', 'LineWidth', 1.2);
    hold on;
    axis([-0.5, 0.5, 0, 1]);
    xlabel('频率 (归一化)');
    ylabel('幅值');
    title('采样信号的频谱 H(j\omega)');
    grid on;

    % 绘制时域频谱响应
    subplot(3, 2, 2);
    t1 = [-ws * i - wc, -ws * i, -ws * i + wc];
    t2 = [ws * i - wc, ws * i, ws * i + wc];
    x = [0, 1, 0];
    plot(t1, x, 'k', t2, x, 'k', 'LineWidth', 1.5);
    hold on;
    axis([-0.5, 0.5, 0, 1]);
    xlabel('频率 (归一化)');
    ylabel('幅值');
    title('时域信号频谱 Y(j\omega)');
    grid on;
    pause(0.5);
end
