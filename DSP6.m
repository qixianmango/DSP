% 读取图片并添加椒盐噪声
RGB = imread('photo.jpg');  % 将图像读取到工作区
I = rgb2gray(RGB);  % 将图像转换为灰度图
P1 = imnoise(I, 'salt & pepper', 0.02);  % 添加椒盐噪声

% 线性滤波
h1 = ones(3) / 9.0;
g1 = filter2(h1, P1) / 255;  % 使用滤波器进行处理
h2 = fspecial('average', 3);
g2 = filter2(h2, P1) / 255;  % 平均滤波器

% 理想低通滤波器
f = fft2(P1);
g3 = fftshift(f);
[M, N] = size(f);
n1 = floor(M / 2);
n2 = floor(N / 2);
d1 = 70;
for i = 1:M
    for j = 1:N
        d = sqrt((i - n1)^2 + (j - n2)^2);
        if d <= d1
            h = 1;
        else
            h = 0;
        end
        g3(i, j) = h * g3(i, j);
    end
end
g3 = ifftshift(g3);
g3 = uint8(real(ifft2(g3)));

% 巴特沃斯低通滤波器
g4 = fftshift(f);
n = 3;
d0 = 70;
for i = 1:M
    for j = 1:N
        d = sqrt((i - n1)^2 + (j - n2)^2);
        h = 1 / (1 + (d / d0)^(2 * n));
        g4(i, j) = h * g4(i, j);
    end
end
g4 = ifftshift(g4);
g4 = uint8(real(ifft2(g4)));

% 显示结果
figure('Name', '林一鸣2022211076', 'NumberTitle', 'off');
subplot(2, 3, 1), imshow(I); title('原始图像');
subplot(2, 3, 2), imshow(P1); title('添加椒盐噪声图像');
subplot(2, 3, 3), imshow(g1); title('线性滤波');
subplot(2, 3, 4), imshow(g2); title('平均滤波');
subplot(2, 3, 5), imshow(g3); title('理想低通滤波');
subplot(2, 3, 6), imshow(g4); title('巴特沃斯滤波');
