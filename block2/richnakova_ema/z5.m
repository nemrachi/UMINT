clc, clear, close all;

% nacitanie vstupnych dat pre Neuronovu Siet
load('datafun.mat'); % hodnoty pre NS (indx_train, indx_test) a pre funkciu (x, y)

% trenovacia metoda - Levenberg-Marquardt 
net = fitnet(24); % pocet skrytych vrstiev

% rozdelenie dat
net.divideFcn='divideind';         % kazda n-ta vzorka (indexove)
net.divideParam.trainInd = indx_train; % index pre indexove rozdelenie trenovacich dat
net.divideParam.testInd = indx_test; % index pre indexove rozdelenie testovacich dat
% nastavenie parametrov trénovania
net.trainParam.goal = 1e-4;        % ukoncovacia podmienka na chybu SSE
net.trainParam.show = 5;          % frekvencia zobrazovania priebehu chyby trénovania
net.trainParam.epochs = 300;       % max. pocet trenovacich cyklov
net.trainParam.min_grad = 1e-4;    % ukoncovacia podmienka na min. gradient 
% minimalna odchylka pod 1e-4 pri testovacich datach

% trenovanie NS
[net,tr] = train(net,x,y);

% simulácia výstupu NS
outnetsim = sim(net,x);

% vykreslenie priebehov
figure
plot(x,y,'b', x, outnetsim, '-or')
xlabel('x');
ylabel('y');