clear;
close all;

% 设置滤波器参数
wp = 1; % 通带截止频率
ws = 2; % 阻带截止频率
rp = 2; % 通带最大衰减 (dB)
as = 30; % 阻带最小衰减 (dB)

f = 0:1/100:0.5; % 频率范围
wk = 2*pi*f; % 角频率

% 低通滤波器设计
[n, wc] = buttord(wp, ws, rp, as, 's'); % 计算滤波器阶数 n 和截止频率 wc
[b, a] = butter(n, wc, 's'); % 设计低通滤波器
hk_lp = freqs(b, a, wk); % 计算频响

figure;
subplot(4, 1, 1);
plot(f, abs(hk_lp), 'b', 'LineWidth', 2);
hold on;
fill([wp, wp, ws, ws], [0, max(abs(hk_lp)), max(abs(hk_lp)), 0], 'g', 'FaceAlpha', 0.3); % 通带
fill([ws, ws, max(f), max(f)], [0, max(abs(hk_lp)), max(abs(hk_lp)), 0], 'r', 'FaceAlpha', 0.3); % 阻带
title('低通滤波器');
xlabel('频率 (Hz)');
ylabel('幅度');
legend('幅度响应', '通带', '阻带');
grid on;

% 低通转高通
[bh, ah] = lp2hp(b, a, 2); % 低通到高通转换
hk_hp = freqs(bh, ah, wk); % 计算频响

subplot(4, 1, 2);
plot(f, abs(hk_hp), 'b', 'LineWidth', 2);
hold on;
fill([0, 0, min(ws, max(f)), min(ws, max(f))], [0, max(abs(hk_hp)), max(abs(hk_hp)), 0], 'g', 'FaceAlpha', 0.3); % 通带
fill([min(ws, max(f)), min(ws, max(f)), max(f), max(f)], [0, max(abs(hk_hp)), max(abs(hk_hp)), 0], 'r', 'FaceAlpha', 0.3); % 阻带
title('高通滤波器');
xlabel('频率 (Hz)');
ylabel('幅度');
legend('幅度响应', '通带', '阻带');
grid on;

% 低通转带阻
[bz, az] = lp2bs(b, a, 1.6, 0.5); % 低通到带阻转换
hz_bs = freqs(bz, az, wk); % 计算频响

subplot(4, 1, 3);
plot(f, abs(hz_bs), 'b', 'LineWidth', 2);
hold on;
fill([0, 0, 1.6-0.5, 1.6-0.5], [0, max(abs(hz_bs)), max(abs(hz_bs)), 0], 'g', 'FaceAlpha', 0.3); % 通带
fill([1.6-0.5, 1.6-0.5, 1.6+0.5, 1.6+0.5], [0, max(abs(hz_bs)), max(abs(hz_bs)), 0], 'r', 'FaceAlpha', 0.3); % 阻带
fill([1.6+0.5, 1.6+0.5, max(f), max(f)], [0, max(abs(hz_bs)), max(abs(hz_bs)), 0], 'g', 'FaceAlpha', 0.3); % 通带
title('带阻滤波器');
xlabel('频率 (Hz)');
ylabel('幅度');
legend('幅度响应', '通带', '阻带');
grid on;

% 低通转带通
[bz_bp, az_bp] = lp2bp(b, a, 1.6, 0.5); % 低通到带通转换
hz_bp = freqs(bz_bp, az_bp, wk); % 计算频响

subplot(4, 1, 4);
plot(f, abs(hz_bp), 'b', 'LineWidth', 2);
hold on;
fill([0, 0, 1.6-0.5, 1.6-0.5], [0, max(abs(hz_bp)), max(abs(hz_bp)), 0], 'r', 'FaceAlpha', 0.3); % 阻带
fill([1.6-0.5, 1.6-0.5, 1.6+0.5, 1.6+0.5], [0, max(abs(hz_bp)), max(abs(hz_bp)), 0], 'g', 'FaceAlpha', 0.3); % 通带
fill([1.6+0.5, 1.6+0.5, max(f), max(f)], [0, max(abs(hz_bp)), max(abs(hz_bp)), 0], 'r', 'FaceAlpha', 0.3); % 阻带
title('带通滤波器');
xlabel('频率 (Hz)');
ylabel('幅度');
legend('幅度响应', '通带', '阻带');
grid on;

% 简要说明采用脉冲响应不变法对 AHPF 和 ASBF 数字化保护滤波器的作用
disp('脉冲响应不变法的作用：');
disp('1. 脉冲响应不变法将模拟滤波器转换为数字滤波器时，保持了模拟滤波器的脉冲响应。');
disp('2. 对于AHPF（高通）和ASBF（带阻）滤波器，这种方法可以保留原始模拟滤波器的特性。');
disp('3. 然而，该方法可能会产生频谱混叠现象，特别是在高频段。');
disp('4. 因此，在实际应用中需要谨慎选择采样频率以避免混叠。');