function [] = segmenthuman( filename )

%% Giriþ Resmini Alma

I = imread('D:\Projelerim\Görüntü Ýþleme\Resimler\101087.jpg');
figure(1),imshow(I),impixelinfo,title('Giriþ Görüntüsü');

%% RGB ve HSV DeÐerlerini Alma
R=I(:,:,1); 
G=I(:,:,2); 
B=I(:,:,3); 

I_hsv = rgb2hsv(I) ;    % HSV renk uzayýna çevirme
H=I_hsv(:,:,1); 
S=I_hsv(:,:,2); 
%V=I_hsv(:,:,3); 

%% Hue ve Saturasyon Kanalýna Göre Filtreleme
C=double((H)<0.15);     % Hue kanalýna göre
P=double((S)>0.15);     % Saturasyon kanalýna göre

figure(2);imshow(C),impixelinfo,title('Hue Filtreleme');
figure(3);imshow(P),impixelinfo,title('Saturasyon Filtreleme');

%% Morfolojik Ýþlem Uygulama
C = bwareaopen(C,200);      %Çýkýntýlý bölümler ve küçük parçalar yok edildi
P = bwareaopen(P,200);
C = ~C;
P = ~P;
C = bwareaopen(C,200);
P = bwareaopen(P,200);
C = ~C;
P = ~P;

P = medfilt2(P);            %Yumuþatma yapýlarak kenar çizgisindeki çýkýntýlar giderildi
P = medfilt2(P);

C = bwmorph(C,'erode',1);   %Önce aþýndýrma yap ki ayaðýnýn altýndaki kýsým gitsin

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

%% Ýki Kanalý BÝrleþtirme ve Gereksiz Verileri Elemine Etme
C(~P(:, :, ones(1, size(C, 3)))) = 0;C = bwareaopen(C,5000);
figure(6),imshow(C);

%% Orjinal Resmin Üzerinde Gösterme
out=edge(C,'canny');
out=bwareaopen(out,40);

outline = bwperim(out);
Segout = I;
Segout(outline) = 255;
figure(4),imshow(Segout),impixelinfo,title('Çýkýþ Görüntüsü');

%% Çýkýþ Resminin Oluþturulmasý
r=(R).*uint8(C); 
g=(G).*uint8(C); 

b=(B).*uint8(C); 

Is(:,:,1)=r;
Is(:,:,2)=g;
Is(:,:,3)=b;

figure(5),imshow(Is),impixelinfo,title('Çýkýþ Görüntüsü');
end