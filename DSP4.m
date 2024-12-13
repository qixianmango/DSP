clc;
clear;
close all;

% 1. 读取原始图像
RGB = imread('photo.jpg');  % 将图像读入工作区
I = rgb2gray(RGB);  % 将图像灰度化

% 2. 添加椒盐噪声
f = imnoise(I, 'salt & pepper', 0.02);  % 添加椒盐噪声

% 3. 线性滤波
h = ones(3) / 9.0;  % 定义3x3均值滤波器
g1 = filter2(h, f) / 255;  % 使用filter2函数进行线性滤波，并归一化

% 4. 中值滤波
f1 = double(f);  % 将噪声图像转换为double类型
img2 = uint8(medfilt2(f1, [3 3]));  % 使用中值滤波器去噪

% 5. 理想低通滤波
J = double(imnoise(I, 'salt & pepper', 0.02));  % 重新添加椒盐噪声
f_fft = fft2(J);  % 对图像进行傅里叶变换
f_fft_shift = fftshift(f_fft);  % 将频谱中心化
[M, N] = size(f_fft);  % 获取图像的尺寸
n1 = floor(M / 2); n2 = floor(N / 2);  % 计算频谱中心位置
d0 = 65;  % 理想低通滤波器的截止频率

% 频率响应：理想低通滤波器
for i = 1:M
    for j = 1:N
        d = sqrt((i - n1)^2 + (j - n2)^2);  % 计算频率坐标
        if d <= d0
            h = 1;  % 在截止频率内设置为1
        else
            h = 0;  % 超出截止频率的部分设置为0
        end
        f_fft_shift(i, j) = h * f_fft_shift(i, j);  % 应用低通滤波器
    end
end
f_fft_shift = ifftshift(f_fft_shift);  % 逆中心化频谱
g3 = uint8(real(ifft2(f_fft_shift)));  % 进行逆傅里叶变换，恢复图像

% 6. 显示结果
figure('Name', '林一鸣2022211076', 'NumberTitle', 'off');

% 原始图像
subplot(1, 4, 1);
imshow(I);
title('原始图像');

% 添加椒盐噪声后的图像
subplot(1, 4, 2);
imshow(f);
title('添加椒盐噪声图像');

% 线性滤波结果
subplot(1, 4, 3);
imshow(g1);
title('线性滤波结果');

% 理想低通滤波结果
subplot(1, 4, 4);
imshow(g3);
title('理想低通滤波结果');
