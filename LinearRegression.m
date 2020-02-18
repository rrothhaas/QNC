%% 1 plot data
age=[3 4 5 6 8 9 10 11 12 14 15 16 17]; 
wingLength=[1.4 1.5 2.2 2.4 3.1 3.2 3.2 3.9 4.1 4.7 4.5 5.2 5]; 
plot(age, wingLength, '.', 'MarkerSize', 10);

%% 2 regression line
n=length(age); 
sumAge=sum(age); 
sumWingLength=sum(wingLength); 
meanAge=mean(age); 
meanWingLength=mean(wingLength); 
sumAge2=sum(age.^2);  
sumAge2=sumAge2-sumAge^2/n; 
sumWingLength2=sum(wingLength.^2);
sumXY=sum(age.*wingLength); 
sumXY=sumXY-sumAge*sumWingLength/n;

b=sumXY/sumAge2; 
a=meanWingLength-b*meanAge;

xline=[3 17];
ypred=b*xline+a;
plot(xline,ypred,age,wingLength,'.','Markersize',10);
xlabel('Age (years)');
ylabel('Wing Length (cm)');

%% 3 t-test
df=n-2;
total=sumWingLength2-sumWingLength^2/n;
regression=sumXY^2/sumAge2;
residuals=total-regression;
syx=sqrt((residuals/df));
SEb=sqrt(syx^2/sumAge2); % standard error of the regression slope
Tval=(b-0)/SEb; % t-test, null hypothesis is b=0
prob = 1-tcdf(Tval,df);
disp(prob)% 2.6335e-10

%% 4 confidence intervals
t=-1*tinv(.05/2,df); 
lowerCI=b-t*SEb; % lower confidence interval
upperCI=b+t*SEb; % upper confidence interval
lowerIntercept=meanWingLength-lowerCI*meanAge; %intercept for lower confidence interval
upperIntercept=meanWingLength-upperCI*meanAge; %intercept for upper confidence interval
plot(xline,lowerCI*xline+lowerIntercept,xline,upperCI*xline+upperIntercept)
legend({'lower confidence interval','upper confidence interval'},'Location','northwest');

%% 5 r2 (coefficient of determination)
r2=regression/total;
disp(r2) % 0.9733