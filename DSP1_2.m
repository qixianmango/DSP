clear all;
clc;

% 定义信号
x1 = [1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0];
x2 = [0, 1, 2, 1, 0, 0, 0, 1, 2, 1, 0, 0];

p = length(x1);  % x1长度
q = length(x2);  % x2长度
n = p + q - 1;   % 卷积结果的长度

% 反转 x2
a = 0:q-1;
y2 = x2(q - a);

% 获取用户输入
N1 = input('请输入L1=');
N2 = input('请输入L2=');
N3 = input('请输入L3=');

% 计算线性卷积并逐步显示
y = conv(x1, x2);  % 线性卷积结果
subplot(3, 2, 1);
for i = 1:n
    t = 0:i-1;
    stem(t, y(1:i), 'filled');
    title('线性卷积 y(n)');
    axis([0, n, 0, max(y) + 1]);
    pause(0.1);
end

% 显示第一种圆周卷积（L < N + M - 1）
x1_1 = [x1, zeros(1, N1 - p)];
x2_1 = [x2, zeros(1, N1 - q)];
y1_1 = conv(x1_1, x2_1);  % 圆周卷积计算
z11 = [zeros(1, N1), y1_1(1:(N1 - 1))];
z21 = [y1_1((N1 + 1):(2 * N1 - 1)), zeros(1, N1)];
z1 = z11(1:(2 * N1 - 1)) + z21(1:(2 * N1 - 1)) + y1_1(1:(2 * N1 - 1));
y1 = z1(1:N1);

subplot(3, 2, 2);
for i = 1:N1
    t = 0:i-1;
    stem(t, y1(1:i), 'filled');
    title('圆周卷积序列 L < N + M - 1');
    axis([0, N1, 0, max(y1) + 1]);
    pause(0.1);
end

% 显示第二种圆周卷积（L = N + M - 1）
x1_2 = [x1, zeros(1, N2 - p)];
x2_2 = [x2, zeros(1, N2 - q)];
y1_2 = conv(x1_2, x2_2);  % 圆周卷积计算
z11_2 = [zeros(1, N2), y1_2(1:(N2 - 1))];
z21_2 = [y1_2((N2 + 1):(2 * N2 - 1)), zeros(1, N2)];
z2 = z11_2(1:(2 * N2 - 1)) + z21_2(1:(2 * N2 - 1)) + y1_2(1:(2 * N2 - 1));
y2 = z2(1:N2);

subplot(3, 2, 3);
for i = 1:N2
    t = 0:i-1;
    stem(t, y2(1:i), 'filled');
    title('圆周卷积序列 L = N + M - 1');
    axis([0, N2, 0, max(y2) + 1]);
    pause(0.1);
end

% 可选：第三种圆周卷积，可以根据需要设置
x1_3 = [x1, zeros(1, N3 - p)];
x2_3 = [x2, zeros(1, N3 - q)];
y1_3 = conv(x1_3, x2_3);  % 圆周卷积计算
z11_3 = [zeros(1, N3), y1_3(1:(N3 - 1))];
z21_3 = [y1_3((N3 + 1):(2 * N3 - 1)), zeros(1, N3)];
z3 = z11_3(1:(2 * N3 - 1)) + z21_3(1:(2 * N3 - 1)) + y1_3(1:(2 * N3 - 1));
y3 = z3(1:N3);

subplot(3, 2, 4);
for i = 1:N3
    t = 0:i-1;
    stem(t, y3(1:i), 'filled');
    title('圆周卷积序列 L = N + M - 1');
    axis([0, N3, 0, max(y3) + 1]);
    pause(0.1);
end

% 完成所有绘图
disp('卷积计算和图形展示已完成');
