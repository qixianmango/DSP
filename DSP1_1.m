clc;
clear;

% 定义信号
x1 = [1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0];
x2 = [0, 1, 2, 1, 0, 0, 0, 1, 2, 1, 0, 0];

p = length(x1);  % x1长度
q = length(x2);  % x2长度
n = p + q - 1;   % 卷积结果的长度

% 初始化 y2，保存 x2 的反转信号
y2 = zeros(1, q);
for a = 1:q
    y2(a) = x2(q - a + 1);  % 反转 x2
end

% 绘制 x1 和 x2
subplot(2, 2, 1);
stem(0:p-1, x1, 'filled');
title('x1(m)');
axis([0, p, 0, 2]);
grid on;

subplot(2, 2, 2);
stem(0:q-1, x2, 'filled');
title('x2(m)');
axis([0, q, 0, 3]);
grid on;

% 逐步显示 x2(n-m) 的变化
subplot(2, 2, 3);
for a = 1:n
    k = -q + a : 1 : -1 + a;
    stem(k - 10, y2, 'filled');
    title('x2(n-m)');
    axis([-16, 16, 0, 4]);
    pause(0.2);
end

% 进行卷积运算，并逐步绘制卷积结果
y = conv(x1, x2);  % 计算卷积
subplot(2, 2, 4);
for m = 1:n
    h = y(1:m);  % 获取前 m 项
    t = 0:m-1;
    stem(t, h, 'filled');
    title('线性卷积 y(n)');
    axis([0, n, 0, max(y)+1]);
    grid on;
    pause(0.1);
end
