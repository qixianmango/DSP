% 读取原始图像并转换为灰度图像
RGB = imread('photo.jpg'); % 读取图像
I = rgb2gray(RGB); % 转换为灰度图像
I = I(:,:,1); % 提取灰度图像的单通道

% 添加椒盐噪声
P1 = imnoise(I, 'salt & pepper', 0.02);

% FFT变换到频域
f = fft2(P1);
g = fftshift(f); % 频域中心化
[M, N] = size(f); % 获取图像大小
n1 = floor(M/2);
n2 = floor(N/2);

% 设置低通、高通和带通滤波器的参数
d1_low = 40;  % 低通滤波器截止频率
d1_high = 10; % 高通滤波器截止频率
d1_band = 5;  % 带通滤波器低截止频率
d2_band = 50; % 带通滤波器高截止频率

% ---------------------------- 低通滤波器 ----------------------------
g_low = g; % 创建低通滤波器图像副本
for i = 1:M
    for j = 1:N
        d = sqrt((i-n1)^2 + (j-n2)^2);
        if d <= d1_low
            h = 1;
        else
            h = 0;
        end
        g_low(i,j) = h * g_low(i,j);
    end
end

g_low = ifftshift(g_low); % 反中心化
g_low = uint8(real(ifft2(g_low))); % 反变换到时域并取实部

% ---------------------------- 高通滤波器 ----------------------------
g_high = g; % 创建高通滤波器图像副本
for i = 1:M
    for j = 1:N
        d = sqrt((i-n1)^2 + (j-n2)^2);
        if d >= d1_high
            h = 1;
        else
            h = 0;
        end
        g_high(i,j) = h * g_high(i,j);
    end
end

g_high = ifftshift(g_high); % 反中心化
g_high = uint8(real(ifft2(g_high))); % 反变换到时域并取实部

% ---------------------------- 带通滤波器 ----------------------------
g_band = g; % 创建带通滤波器图像副本
for i = 1:M
    for j = 1:N
        d = sqrt((i-n1)^2 + (j-n2)^2);
        if d >= d1_band && d <= d2_band
            h = 1;
        else
            h = 0;
        end
        g_band(i,j) = h * g_band(i,j);
    end
end

g_band = ifftshift(g_band); % 反中心化
g_band = uint8(real(ifft2(g_band))); % 反变换到时域并取实部

% ---------------------------- 显示结果 ----------------------------
figure('Name', '林一鸣2022211076', 'NumberTitle', 'off');

% 第一行，显示原始图像与添加椒盐噪声后的图像
subplot(2,3,1), imshow(I); title('原始图像');
subplot(2,3,2), imshow(P1); title('添加椒盐噪声图像');

% 第二行，显示低通、高通和带通处理结果
subplot(2,3,4), imshow(g_low); title('低通处理结果');
subplot(2,3,5), imshow(g_high); title('高通处理结果');
subplot(2,3,6), imshow(g_band); title('带通处理结果');
