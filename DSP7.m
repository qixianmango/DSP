image = imread('photo.jpg');
rgb=im2double(image);
r=rgb(:,:,1);
g=rgb(:,:,2);
b=rgb(:,:,3);
num=0.5*((r-g)+(r-b));
den=sqrt( (r-g).^2 + (r-b).*(g-b) );
theta=acos(num./(den+eps));
H0=theta.*(g>=b);
H1=(2*pi-theta).*(g<b);
H=H0+H1;
num=3.*min(min(r,g),b);
S=1-num./(r+g+b+eps);
I=(r+g+b)/3;
H=(H-min(min(H)))./(max(max(H))-min(min(H)));
S=(S-min(min(S)))./(max(max(S))-min(min(S)));
iHsi=cat(3,H,S,I);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
hsi_H=iHsi(:,:,1);
hsi_S=iHsi(:,:,2);
hsi_I=iHsi(:,:,3);
subplot(131);imshow(hsi_H);title('H（色调）');
subplot(132);imshow(hsi_S);title('S（饱和度）');
subplot(133);imshow(hsi_I);title('I（亮度）');
HSV = rgb2hsv(image);
hsv_H = HSV(:,:,1);
hsv_S = HSV(:,:,2);
hsv_V = HSV(:,:,3);
R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(4,3,1);imshow(hsv_H);title('H分量');
subplot(4,3,2);imshow(hsv_S);title('S分量');
subplot(4,3,3);imshow(hsv_V);title('V分量');
subplot(4,3,4);imhist(hsv_H);title('H分量直方图');
subplot(4,3,5);imhist(hsv_S);title('S分量直方图');
subplot(4,3,6);imhist(hsv_V);title('V分量直方图');
subplot(4,3,7);imshow(R);title('R分量');
subplot(4,3,8);imshow(G);title('G分量');
subplot(4,3,9);imshow(B);title('B分量');
subplot(4,3,10);imhist(R);title('R分量直方图');
subplot(4,3,11);imhist(G);title('G分量直方图');
subplot(4,3,12);imhist(B);title('B分量直方图');
R=log(abs(fftshift(fft2(im2double(R))))+1);
G=log(abs(fftshift(fft2(im2double(G))))+1);
B=log(abs(fftshift(fft2(im2double(B))))+1);
hsv_H=log(abs(fftshift(fft2(im2double(hsv_H))))+1);
hsv_S=log(abs(fftshift(fft2(im2double(hsv_S))))+1);
hsv_V=log(abs(fftshift(fft2(im2double(hsv_V))))+1);
hsi_H=log(abs(fftshift(fft2(im2double(hsi_H))))+1);
hsi_S=log(abs(fftshift(fft2(im2double(hsi_S))))+1);
hsi_I=log(abs(fftshift(fft2(im2double(hsi_I))))+1);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(3,3,1),imshow(R,[]),title('R');
subplot(3,3,2),imshow(G,[]),title('G');
subplot(3,3,3),imshow(B,[]),title('B');
subplot(3,3,4),imshow(hsv_H,[]),title('hsv_H');
subplot(3,3,5),imshow(hsv_S,[]),title('hsv_S');
subplot(3,3,6),imshow(hsv_V,[]),title('hsv_V');
subplot(3,3,7),imshow(hsi_H,[]),title('hsi_H');
subplot(3,3,8),imshow(hsi_S,[]),title('hsi_S');
subplot(3,3,9),imshow(hsi_I,[]),title('hsi_I');
P1=imnoise(image,'salt & pepper',0.02);
P2=imnoise(image,'salt & pepper',0.03);
P3=imnoise(image,'salt & pepper',0.04);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(2,2,1),imshow(image),title('原图');
subplot(2,2,2),imshow(P1),title('噪声系数0.02');
subplot(2,2,3),imshow(P2),title('噪声系数0.03');
subplot(2,2,4),imshow(P3),title('噪声系数0.04');
n1=log(abs(fftshift(fft2(im2double(rgb2gray(P1)))))+1);
n2=log(abs(fftshift(fft2(im2double(rgb2gray(P2)))))+1);
n3=log(abs(fftshift(fft2(im2double(rgb2gray(P3)))))+1);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(1,3,1),imshow(n1,[]),title('p1');
subplot(1,3,2),imshow(n2,[]),title('p2');
subplot(1,3,3),imshow(n3,[]),title('p3');
h1=ones(3)/9.0;
g1_1=filter2(h1,P1(:,:,1))/255;
g1_2=filter2(h1,P1(:,:,2))/255;
g1_3=filter2(h1,P1(:,:,3))/255;
g1=cat(3,g1_1,g1_2,g1_3);
h2=ones(4)/16.0;
g2_1=filter2(h2,P2(:,:,1))/255;
g2_2=filter2(h2,P2(:,:,2))/255;
g2_3=filter2(h2,P2(:,:,3))/255;
g2=cat(3,g2_1,g2_2,g2_3);
h3=ones(5)/25.0;
g3_1=filter2(h3,P3(:,:,1))/255;
g3_2=filter2(h3,P3(:,:,2))/255;
g3_3=filter2(h3,P3(:,:,3))/255;
g3=cat(3,g3_1,g3_2,g3_3);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(3,3,1),imshow(image);title('原始图像')
subplot(3,3,2),imshow(P1);title('噪声系数0.02')
subplot(3,3,3),imshow(g1);title('线性滤波')
subplot(3,3,4),imshow(image);title('原始图像')
subplot(3,3,5),imshow(P2);title('噪声系数0.03')
subplot(3,3,6),imshow(g2);title('线性滤波')
subplot(3,3,7),imshow(image);title('原始图像')
subplot(3,3,8),imshow(P3);title('噪声系数0.04')
subplot(3,3,9),imshow(g3);title('线性滤波')
 
h1=fspecial('average',3);
g1_1=filter2(h1,P1(:,:,1))/255;
g1_2=filter2(h1,P1(:,:,2))/255;
g1_3=filter2(h1,P1(:,:,3))/255;
g1=cat(3,g1_1,g1_2,g1_3);
h2=fspecial('average',6);
g2_1=filter2(h2,P2(:,:,1))/255;
g2_2=filter2(h2,P2(:,:,2))/255;
g2_3=filter2(h2,P2(:,:,3))/255;
g2=cat(3,g2_1,g2_2,g2_3);
h3=fspecial('average',9);
g3_1=filter2(h3,P3(:,:,1))/255;
g3_2=filter2(h3,P3(:,:,2))/255;
g3_3=filter2(h3,P3(:,:,3))/255;
g3=cat(3,g3_1,g3_2,g3_3);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(3,3,1),imshow(image);title('原始图像')
subplot(3,3,2),imshow(P1);title('噪声系数0.02')
subplot(3,3,3),imshow(g1);title('中值滤波')
subplot(3,3,4),imshow(image);title('原始图像')
subplot(3,3,5),imshow(P2);title('噪声系数0.03')
subplot(3,3,6),imshow(g2);title('中值滤波')
subplot(3,3,7),imshow(image);title('原始图像')
subplot(3,3,8),imshow(P3);title('噪声系数0.04')
subplot(3,3,9),imshow(g3);title('中值滤波')
 
J1=double(P1(:,:,1));
f1=fft2(J1);
g1=fftshift(f1);
J2=double(P1(:,:,2));
f2=fft2(J2);
g2=fftshift(f2);
J3=double(P1(:,:,3));
f3=fft2(J3);
g3=fftshift(f3);
[M,N]=size(f1);
n1=floor(M/2);
n2=floor(N/2);
d1=100;
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
if d<=d1
h=1;
else
h=0;
end
g1(i,j)=h*g1(i,j);
end
end
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
if d<=d1
h=1;
else
h=0;
end
g2(i,j)=h*g2(i,j);
end
end
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
if d<=d1
h=1;
else
h=0;
end
g3(i,j)=h*g3(i,j);
end
end
g1=ifftshift(g1);
g1=uint8(real(ifft2(g1)));
g2=ifftshift(g2);
g2=uint8(real(ifft2(g2)));
g3=ifftshift(g3);
g3=uint8(real(ifft2(g3)));
g=cat(3,g1,g2,g3);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(1,3,1),imshow(image);title('原始图像')
subplot(1,3,2),imshow(P1);title('添加椒盐噪声图像')
subplot(1,3,3),imshow(g);title('理想低通滤波')
 
J1=double(P1(:,:,1));
f1=fft2(J1);
g1=fftshift(f1);
J2=double(P1(:,:,2));
f2=fft2(J2);
g2=fftshift(f2);
J3=double(P1(:,:,3));
f3=fft2(J3);
g3=fftshift(f3);
[M,N]=size(f1);
n1=floor(M/2);
n2=floor(N/2);
n=3;
d0=100;
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
h=1/(1+(d/d0)^(2*n));
g1(i,j)=h*g1(i,j);
end
end
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
h=1/(1+(d/d0)^(2*n));
g2(i,j)=h*g2(i,j);
end
end
for i=1:M
for j=1:N
d=sqrt((i-n1)^2+(j-n2)^2);
h=1/(1+(d/d0)^(2*n));
g3(i,j)=h*g3(i,j);
end
end
g1=ifftshift(g1);
g1=uint8(real(ifft2(g1)));
g2=ifftshift(g2);
g2=uint8(real(ifft2(g2)));
g3=ifftshift(g3);
g3=uint8(real(ifft2(g3)));
g=cat(3,g1,g2,g3);
figure('NumberTitle', 'off', 'Name', '林一鸣2022211076');
subplot(1,3,1),imshow(image);title('原始图像')
subplot(1,3,2),imshow(P1);title('添加椒盐噪声图像')
subplot(1,3,3),imshow(g);title('巴特沃斯滤波')