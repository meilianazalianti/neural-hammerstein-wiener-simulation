clc ; close all;

load 'datanh';
inputdata = input;
outputdata = output;
hidden_neuron = 10;

nettemp = newff(inputdata',outputdata',hidden_neuron);
nettemp.divideParam.trainRatio = 50/100; %rasio data u/ dilatih
nettemp.divideParam.valRatio = 25/100; %rasio data u/divalidasi
nettemp.divideParam.testRatio = 25/100; %rasio data u/ diuji
nettemp = trainlm(nettemp,inputdata',outputdata');

neural = sim(nettemp,inputdata');

figure;
plot(t, neural, t, outputdata);
errorN = abs((outputdata - neural') ./ outputdata);
mseN = mse(errorN);
rmseN = sqrt(mseN);
maeN = mean(sum(errorN));
mapeN = maeN * 100;
legend({['Neural (MSE = ', num2str(mseN), ', MAPE = ', num2str(mapeN), '%)'], ...
        'Data Experiment'}, 'location', 'southwest');

dataiden = iddata(outputdata,neural');
opt = n4sidOptions('Focus','simulation','InitialState','zero');
Gmisol = n4sid(dataiden,'best','DisturbanceModel','none',opt);

NH = sim(Gmisol,neural');

figure;
plot(t,NH,t,outputdata)
errorNH = abs((outputdata-NH)/outputdata);
mseNH = mse(errorNH);
rmseNH = sqrt(mseNH);
maeNH = mean(sum(errorNH));
mapeNH = maeNH*100;
legend(['Neural Hammers',[' MSE =', num2str(mseNH)],[' MAPE =',
num2str(mapeNH)]],['Data Experiment'],'location','southwest')

nettemp2 = newff(NH',outputdata',hidden_neuron);
nettemp2.divideParam.trainRatio = a; %rasio data u/ dilatih
nettemp2.divideParam.valRatio = b; %rasio data u/ divalidasi
nettemp2.divideParam.testRatio = b; %rasio data u/ diuji
nettemp2 = train(nettemp2,NH',outputdata');

NHW = sim(nettemp2,NH');

figure
plot(t,NHW,t,outputdata)
errorNHW = abs((outputdata-NHW')/outputdata);
mseNHW = mse(errorNHW);
rmseNHW = sqrt(mseNHW);
maeNHW = mean(sum(errorNHW));
mapeNHW = maeNHW*100;
legend(['Neural HW',[' MSE =', num2str(mseNHW)],[' MAPE =',
num2str(mapeNHW)]],['Data Experiment'],'location','southwest')

simulink_HammersteinWiener = gensim(nettemp);