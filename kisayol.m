function [] = segmenthuman( filename )

%% Giri� Resmini Alma

I = imread('D:\Projelerim\G�r�nt� ��leme\Resimler\101087.jpg');
figure(1),imshow(I),impixelinfo,title('Giri� G�r�nt�s�');

%% RGB ve HSV De�erlerini Alma
R=I(:,:,1); 
G=I(:,:,2); 
B=I(:,:,3); 

I_hsv = rgb2hsv(I) ;    % HSV renk uzay�na �evirme
H=I_hsv(:,:,1); 
S=I_hsv(:,:,2); 
%V=I_hsv(:,:,3); 

%% Hue ve Saturasyon Kanal�na G�re Filtreleme
C=double((H)<0.15);     % Hue kanal�na g�re
P=double((S)>0.15);     % Saturasyon kanal�na g�re

figure(2);imshow(C),impixelinfo,title('Hue Filtreleme');
figure(3);imshow(P),impixelinfo,title('Saturasyon Filtreleme');

%% Morfolojik ��lem Uygulama
C = bwareaopen(C,200);      %��k�nt�l� b�l�mler ve k���k par�alar yok edildi
P = bwareaopen(P,200);
C = ~C;
P = ~P;
C = bwareaopen(C,200);
P = bwareaopen(P,200);
C = ~C;
P = ~P;

P = medfilt2(P);            %Yumu�atma yap�larak kenar �izgisindeki ��k�nt�lar giderildi
P = medfilt2(P);

C = bwmorph(C,'erode',1);   %�nce a��nd�rma yap ki aya��n�n alt�ndaki k�s�m gitsin

SE=strel('disk',20);
C=imclose(C,SE);

SE=strel('disk',7);
C=imopen(C,SE);

SE=strel('disk',2);
C=imdilate(C,SE);
C=imdilate(C,SE);

C = ~C;                     %Tepe yok edildi
C = bwareaopen(C,2000);
C = ~C;

%% �ki Kanal� B�rle�tirme ve Gereksiz Verileri Elemine Etme
C(~P(:, :, ones(1, size(C, 3)))) = 0;C = bwareaopen(C,5000);
figure(6),imshow(C);

%% Orjinal Resmin �zerinde G�sterme
out=edge(C,'canny');
out=bwareaopen(out,40);

outline = bwperim(out);
Segout = I;
Segout(outline) = 255;
figure(4),imshow(Segout),impixelinfo,title('��k�� G�r�nt�s�');

%% ��k�� Resminin Olu�turulmas�
r=(R).*uint8(C); 
g=(G).*uint8(C); 

b=(B).*uint8(C); 

Is(:,:,1)=r;
Is(:,:,2)=g;
Is(:,:,3)=b;

figure(5),imshow(Is),impixelinfo,title('��k�� G�r�nt�s�');
end