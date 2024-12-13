clear;
close all;

N = 27; M = 32; n = 0:N;

% 产生N长三角波序列x(n)
xa = 0:floor(N/2); 
xb = ceil(N/2)-1:-1:0; 
xn = [xa, xb];

Xk = fft(xn, 1024); % 1024点FFT[x(n)], 用于近似序列x(n)的TF
X32k = fft(xn, 32); % 32点FFT[x(n)]
x32n = ifft(X32k); % 32点IFFT[X32(k)]得到x32(n)

X16k = X32k(1:2:M); % 隔点抽取X32k得到X16(K)
x16n = ifft(X16k, M/2); % 16点IFFT[X16(k)]得到x16(n)

figure;

% 绘制三角波序列x(n)
subplot(3, 2, 2);
stem(n, xn, '.', 'LineWidth', 1.2);
box on;
title('(b) 三角波序列x(n)');
xlabel('n'); ylabel('x(n)');
axis([0, 32, 0, 20]);
grid on;

% 绘制FT[x(n)]
k = 0:1023; wk = 2*k/1024;
subplot(3, 2, 1);
plot(wk, abs(Xk), 'LineWidth', 1.2);
title('(a) FT[x(n)]');
xlabel('\omega / \pi'); ylabel('|X(e^{j\omega})|');
axis([0, 1, 0, 200]);
grid on;

% 绘制16点频域采样
k = 0:M/2-1;
subplot(3, 2, 3);
stem(k, abs(X16k), '.', 'LineWidth', 1.2);
box on;
title('(c) 16点频域采样');
xlabel('k'); ylabel('|X_{16}(k)|');
axis([0, 16, 0, 200]);
grid on;

% 绘制16点IDFT[X16(k)]
n1 = 0:M/2-1;
subplot(3, 2, 4);
stem(n1, x16n, '.', 'LineWidth', 1.2);
box on;
title('(d) 16点IDFT[X_{16}(k)]');
xlabel('n'); ylabel('x_{16}(n)');
axis([0, 16, 0, 20]);
grid on;

% 动态显示32点频域采样
for n = 1:32
    t = 1:n;
    h = abs(X32k(1:n));
    subplot(3, 2, 5);
    stem(t-1, h, '.', 'LineWidth', 1.2);
    title('(e) 动态32点频域采样');
    xlabel('k'); ylabel('|X_{32}(k)|');
    axis([0, 32, 0, 200]);
    grid on;
    pause(0.1);
end

% 动态显示32点IDFT[X32(k)]
for test1 = 0:2
    for b = 1:32
        n1 = 0:M-1;
        t = 1+test1*32:b+test1*32;
        h = real(x32n(mod(t-1, 32)+1));
        subplot(3, 2, 6);
        stem(t-1, h, '.', 'LineWidth', 1.2);
        hold on;
        title('(f) 动态32点IDFT[X_{32}(k)]');
        xlabel('n'); ylabel('x_{32}(n)');
        axis([0, 96, 0, 20]);
        grid on;
        pause(0.1);
    end
    hold off;
end