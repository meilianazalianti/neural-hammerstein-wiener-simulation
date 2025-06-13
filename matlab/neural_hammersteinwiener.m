clear;
clc;
load 'datanh';

Data   = input;
target = output;
hidlay = 30;
a=40/100
b=30/100

data = zscore(Data);
%% wiener

% nonlinear
dataidenmiso1 = iddata(target,data);
opt = n4sidOptions('Focus','simulation','InitialState','zero');
Gmiso1 = n4sid(dataidenmiso1,'best','DisturbanceModel','none',opt);

ssSimulation = sim(Gmiso1, data)

% linear
nettemp = newff(ssSimulation',target',hidlay)
nettemp.divideParam.trainRatio = a;  %rasio data u/ dilatih
nettemp.divideParam.valRatio = b;    %rasio data u/ divalidasi
nettemp.divideParam.testRatio = b;   %rasio data u/ diuji

nettemp = train(nettemp,ssSimulation',target'); 
Wiener = sim(nettemp,ssSimulation');

%% hammerstein

%linear
nettemp2 = newff(data',target',hidlay);
nettemp2.divideParam.trainRatio = a;  %rasio data u/ dilatih
nettemp2.divideParam.valRatio = b;    %rasio data u/ divalidasi
nettemp2.divideParam.testRatio = b;   %rasio data u/ diuji
nettemp2 = train(nettemp2,data',target');

FFNN = sim(nettemp2,data');

FFNN =  FFNN';

u = FFNN;
y = target;

%nonlinear
dataidenmiso2 = iddata (y, u);
opt2 = n4sidOptions('Focus','simulation','InitialState','zero');
Gmiso2 = n4sid(dataidenmiso2,'best','DisturbanceModel','none',opt2);

Hammerstein = sim(Gmiso2,u);

%%%
%% hammerstein wiener

%linear
nettemp3 = newff(Hammerstein',target',hidlay);
nettemp3.divideParam.trainRatio =a;  %rasio data u/ dilatih
nettemp3.divideParam.valRatio = b;    %rasio data u/ divalidasi
nettemp3.divideParam.testRatio = b;   %rasio data u/ diuji
nettemp3 = train(nettemp3,Hammerstein',target');
Hammerstein_Wiener = sim(nettemp3,Hammerstein');

%% MSE, RMSE, MAE and MAPE

abserrorNHW = abs(target-Hammerstein_Wiener');
errorNHW = abserrorNHW/target;
mseNHW = mse(errorNHW);
rmseNHW = sqrt(mseNHW);
maeNHW = mean(sum(errorNHW));
mapeNHW = maeNHW*100;

abserrorss = abs(target-ssSimulation);
errorss = abserrorss/target;
msess = mse(errorss);
rmsess = sqrt(msess);
maess = mean(sum(errorss));
mapess = maess*100;

abserrorNH = abs(target-Hammerstein);
errorNH = abserrorNH/target;
mseNH = mse(errorNH);
rmseNH = sqrt(mseNH);
maeNH = mean(sum(errorNH));
mapeNH = maeNH*100;

abserrorN = abs(target-FFNN);
errorN = abserrorN/target;
mseN = mse(errorN);
rmseN = sqrt(mseN);
maeN = mean(sum(errorN));
mapeN = maeN*100;

% figure;
% plot(t,Hammerstein,t,target)
% legend(['Hammerstein=', num2str(mseNH)],'location','southwest')
% ylabel ('Hammerstein & Mg-Experiment');
% xlabel ('Data');
% grid on;


% 
abserrorNW = abs(target-Wiener');
errorNW = abserrorNW/target;
mseNW = mse(errorNW);
rmseNW = sqrt(mseNW);
maeNW = mean(sum(errorNW));
mapeNW = maeNW*100;
% 
result = [mseNHW rmseNHW maeNHW mapeNHW mseNH rmseNH maeNH mapeNH mseNW rmseNW maeNW mapeNW];

figure;
plot(t,Wiener,t,target)
errorNW = abs((target-Wiener'))/target;
ylabel ('Mg-Neural Wienner & Mg-Experiment ');
xlabel ('Data');
legend(['MSE Wiener=', num2str(mseNW)],'location','southwest')
grid on;
 
figure;
plot(t,Hammerstein',t,target)
legend(['MSE Hammerstein=', num2str(mseNH)],'location','southwest')
ylabel ('Mg-Neural Hammerstein & Mg-Experiment');
xlabel ('Data');
grid on;

figure;
plot(t,Hammerstein_Wiener',t,target)
legend(['MSE HammersteinWiener =', num2str(mseNHW)],[' MAPE HammersteinWiener =', num2str(mapeNHW)],'location','southwest')
ylabel ('Hammerstein-wiener & Mg-Experiment');
xlabel ('Data');
grid on;

% figure;
% plot(t,ssSimulation,t,target)
% legend(['MSE State Space =', num2str(msess)],'location','southwest')
% ylabel ('State Space & Mg-Experiment');
% xlabel ('Data');
% grid on;
% 
% figure;
% plot(t,FFNN,t,target)
% legend(['MSE FFNN =', num2str(mseN)],'location','southwest')
% ylabel ('FFNN & Mg-Experiment');
% xlabel ('Data');
% grid on;
% 
figure;
plot(t,target,t,Hammerstein,t,Wiener,t,Hammerstein_Wiener',t,target)
xlim([1 20]);
ylabel ('Mg');
xlabel ('Data');
legend(['Data experiment'],['MSE Hammerstein =', num2str(mseNH)],['MSE Wiener =', num2str(mseNW)],['MSE Hammersteinwiener =', num2str(mseNHW)],'location','southwest')
grid on;
Hammerstein = Hammerstein';

% simulink_FFNN = gensim(nettemp2);
% simulink_wiener = gensim(nettemp);
% simulink_Hammerstein_wiener = gensim(nettemp3)
