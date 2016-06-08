function [colornew,colorbar,colorbar_lam] = new_colormap(et,color); 

%verdi  532

s = size(color)
j = 1;
gamma = .9;
A = 10;
B = 530-A*800;
M = max(max(abs(et)));
colornew = [];
while j<=s(2);
    k = 1;
    while k<=s(1);
        col = rgb2hsv(spectrumRGB(color(k,j)*A+B));
        col(3) = col(3)*((abs(et(k,j))/M).^gamma);
        col = hsv2rgb(col);
        colornew(k,j,:) = col;
        k = k+1;
    end
    j = j+1;
end


lam = [790:810];
%imagesc(lam,[],spectrumRGB(lam*A+B));
colorbar = spectrumRGB(lam*A+B);
colorbar_lam  = [790:810];
assignin('base','colorbar_lam', colorbar_lam)
assignin('base','colorbar', colorbar)
end