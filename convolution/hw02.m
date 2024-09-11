clear;
ori_pic = imread('柴犬飛飛.jpg');    
pic = im2double(ori_pic);   %計算矩陣，補0後當作接下來計算的基礎
ori_pic = im2double(ori_pic);   %原圖，用來計算psnr
a = zeros(6,6,3);   %左上6*6的0矩陣
a(7:646,7:646,:) = pic; %將pic加在右下方
pic = a;    %擴展後的矩陣存回pic
a = zeros(6,6,3);
pic(647:652,647:652,:) = a; %在右下方加上0矩陣，直接擴展

%-------以下計算a_1-------
a_1 = zeros(640,640,3); %先宣告0矩陣，晚點填值
G = fspecial( 'gaussian', [3 3], 1);
b = pic(6:8,6:8,3);
b = b(:)';
G = G(:)';  %為了方便計算，轉成1維矩陣
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+5:i+7,j+5:j+7,k); %挑出mask覆蓋的範圍
            a = a(:)';  %轉成1*9
            a = a.*G;   %兩個1維矩陣相乘
            a_1(i,j,k) = sum(a);
        end
    end
end
peaksnr = psnr(a_1, ori_pic);   %計算psnr，資料形態要相同
fprintf('a_1的psnr值為：%0.4f\n',peaksnr);
imwrite(a_1,'a_1.jpg'); %輸出，yay!

%-------以下計算a_2-------
a_2 = zeros(640,640,3);
G = fspecial( 'gaussian', [7 7], 1);
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+3:i+9,j+3:j+9,k); %挑出mask覆蓋的範圍
            a = a(:)';
            a = a.*G;
            a_2(i,j,k) = sum(a);
        end
    end
end
peaksnr = psnr(a_2, ori_pic);
fprintf('a_2的psnr值為：%0.4f\n',peaksnr);
imwrite(a_2,'a_2.jpg'); %輸出，yay!

%-------以下計算a_3-------
a_3 = zeros(640,640,3);
G = fspecial( 'gaussian', [13 13], 1);
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i:i+12,j:j+12,k); %挑出mask覆蓋的範圍
            a = a(:)';
            a = a.*G;
            a_3(i,j,k) = sum(a);
        end
    end
end
peaksnr = psnr(a_3, ori_pic);
fprintf('a_3的psnr值為：%0.4f\n',peaksnr);
imwrite(a_3,'a_3.jpg'); %輸出，yay!

%-------以下計算b_1-------
%b_1與a_1結果相同，都是hsize = 3x3,sigma = 1的Gaussian filter
b_1 = a_1;
peaksnr = psnr(b_1, ori_pic);   %計算psnr
fprintf('b_1的psnr值為：%0.4f\n',peaksnr);
imwrite(b_1,'b_1.jpg'); %輸出，yay!

%-------以下計算b_2-------
b_2 = zeros(640,640,3);
G = fspecial( 'gaussian', [3 3], 30);   %更改sigma值
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+5:i+7,j+5:j+7,k);
            a = a(:)';
            a = a.*G;
            b_2(i,j,k) = sum(a);
        end
    end
end
peaksnr = psnr(b_2, ori_pic);
fprintf('b_2的psnr值為：%0.4f\n',peaksnr);
imwrite(b_2,'b_2.jpg'); %輸出，yay!

%-------以下計算b_3-------
b_3 = zeros(640,640,3);
G = fspecial( 'gaussian', [3 3], 100);   %更改sigma值
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+5:i+7,j+5:j+7,k);
            a = a(:)';
            a = a.*G;
            b_3(i,j,k) = sum(a);
        end
    end
end
peaksnr = psnr(b_3, ori_pic);
fprintf('b_3的psnr值為：%0.4f\n',peaksnr);
imwrite(b_3,'b_3.jpg'); %輸出，yay!

%-------以下計算d_edge-------
d_edge = zeros(640,640,3);
G = [-1 -1 -1;-1 8 -1;-1 -1 -1];    %作業PDF的矩陣
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+5:i+7,j+5:j+7,k); %3*3的mask範圍
            a = a(:)';
            a = a.*G;
            d_edge(i,j,k) = sum(a);
        end
    end
end
imwrite(d_edge,'d_edge.jpg'); %輸出，yay!

%-------以下計算d_unsharp.jpg-------
d_unsharp = zeros(640,640,3);
G = [0 -1 0 ; -1 5 -1; 0 -1 0]; %Unit3的ppt
G = G(:)';
for i = 1:640
    for j = 1:640
        for k = 1:3
            a = pic(i+5:i+7,j+5:j+7,k); %3*3的mask範圍
            a = a(:)';
            a = a.*G;
            d_unsharp(i,j,k) = sum(a);
        end
    end
end
imwrite(d_unsharp,'d_unsharp.jpg'); %輸出，yay!

figure('name','a_1');   %顯示
imshow(a_1);
figure('name','a_2');
imshow(a_2);
figure('name','a_3');
imshow(a_3);
figure('name','b_1');
imshow(b_1);
figure('name','b_2');
imshow(b_2);
figure('name','b_3');
imshow(b_3);
figure('name','d_edge');
imshow(d_edge);
figure('name','d_unsharp');
imshow(d_unsharp);