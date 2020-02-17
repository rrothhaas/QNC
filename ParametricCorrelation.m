%% 1
wingLength = [10.4 10.8 11.1 10.2 10.3 10.2 10.7 10.5 10.8 11.2 10.6 11.4];
tailLength = [7.4 7.6 7.9 7.2 7.4 7.1 7.4 7.2 7.8 7.7 7.8 8.3];

plot(wingLength, tailLength, '.', 'MarkerSize', 10);
xlabel('Wing Length (cm)');
ylabel('Tail Length (cm)');
% Yes, there appears to be a positive linear correlation.

%% 2
n = length(wingLength); 
sampleMeanX = sum(wingLength)/n;
sampleMeanY = sum(tailLength)/n;
sumSE_x = sum((wingLength - sampleMeanX).^2);
sumSE_y = sum((tailLength - sampleMeanY).^2);
sumCovariance = sum((wingLength - sampleMeanX).*(tailLength - sampleMeanY));
r_xy = sumCovariance/(sqrt(sumSE_x)*sqrt(sumSE_y));
r_yx = sumCovariance/(sqrt(sumSE_y)*sqrt(sumSE_x));

correlation = corrcoef(wingLength, tailLength); 
disp(r_xy); % calcuated: 0.8704
disp(r_yx); % calcuated: 0.8704
disp(correlation); % using corrcoef: 0.8704
% Yes, the correlation is 0.8704 using either method

%% 3
standardError = sqrt((1-r_xy^2)/(n-2));
z = 0.5.*log((1+r_xy)/(1-r_xy));
sz = sqrt(1/(n-3));
zs = z+[1 -1].*norminv(0.025).*sz;
confidenceInterval = (exp(2.*zs)-1)./(exp(2.*zs)+1);
disp(standardError); %0.1557
disp(confidenceInterval); % 0.5923 to 0.9632

%% 4
t = r_xy/standardError;
p = 1-tcdf(t,n-2); 
disp(p); % 1.1555e-04 
% Yes, the value of r_xy should be considered significant 

%% 5
z_m = 0.5*log((1+r_xy)/(1-r_xy));
z_h = 0.5*log((1+0.75)/(1-0.75));
Z = (z_m-z_h)/sqrt(1/(n-3));
probability = 1-tcdf(Z/2,inf);
disp(probability); % 0.2938
% p > 0.05, fail to reject difference between z_m and z_h

%% 6 (from answer key)
v=n-2;
z_m=0.5*log((1+r_xy)/(1-r_xy));

tCritical=tinv(1-0.05/2,n-2);
rCritical=sqrt(tCritical^2/(tCritical^2+(n-2)));
z_r=0.5*log((1+rCritical)/(1-rCritical));

Z_b=(z_m-z_r)*sqrt(n-3);
power=normcdf(Z_b);
disp(num2str(power)); % r=0: 0.97904

often = 0.01; 
rho=0.5;
alpha=0.05; 
Z_b=tinv(1-often,inf);
Z_a=tinv(1-alpha/2,inf);
zeta=0.5*log((1+rho)/(1-rho));
sampleSize=round(((Z_b+Z_a)/zeta)^2+3);
disp(num2str(sampleSize)) % need n >= 64