clc, clear, close all;

% nacitanie vstupnych dat pre Neuronovu Siet
load('databody.mat');

% vykreslenie bodov z databody.mat
h = figure;
axis([0 1 0 1 0 1]); % 3D limit
title('Data body');
xlabel('x'); ylabel('y'); zlabel('z');
hold on
plot3(data1(:,1),data1(:,2),data1(:,3),'r*');
plot3(data2(:,1),data2(:,2),data2(:,3),'gs');
plot3(data3(:,1),data3(:,2),data3(:,3),'b+');
plot3(data4(:,1),data4(:,2),data4(:,3),'co');
plot3(data5(:,1),data5(:,2),data5(:,3),'mx');

% vstupne data po stlpcoch
X = [data1; data2; data3; data4; data5];
X = X'; % array transposition

% vystupne data pre NS
P = [ones(1,50) zeros(1,50) zeros(1,50) zeros(1,50) zeros(1,50);
     zeros(1,50) ones(1,50) zeros(1,50) zeros(1,50) zeros(1,50);
     zeros(1,50) zeros(1,50) ones(1,50) zeros(1,50) zeros(1,50);
     zeros(1,50) zeros(1,50) zeros(1,50) ones(1,50) zeros(1,50);
     zeros(1,50) zeros(1,50) zeros(1,50) zeros(1,50) ones(1,50);
];

% vytvorenie struktury NS na klasifikaciu
net = patternnet([5]); % pocet skrytych vrstiev

% rozdelenie dat
net.divideFcn='dividerand';         % nahodne rozdelenie dat
net.divideParam.trainRatio = 0.8;     % 80% dat na trenovanie
net.divideParam.valRatio = 0;         % na validaciu (nepovinne)  
net.divideParam.testRatio = 0.2;      % na testovanie

net.trainParam.goal = 0.0001;	    % ukoncovacia podmienka na chybu SSE
net.trainParam.epochs = 500;  	    % max. pocet trenovacich cyklov
net.trainParam.min_grad = 1e-6;      % ukoncovacia podmienka na min. gradient

% trenovanie siete
net = train(net,X,P);

% simulacia vystupu NS
y = net(X);
% vypocet chyby siete
perf = perform(net,P,y);
% priradenie vstupov do tried
classes = vec2ind(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5 zadefinovanych testovacich bodov
X2 = [0.3 0.4 0.7 0.8 0.5; 0.6 0.7 0.2 0.3 0.5; 0.2 0.4 0.3 0.8 0.7];

% simulacia vystupu NS
y2 = net(X2);
% priradenie vstupov do tried
classes2 = vec2ind(y2);

% vykreslenie testovacich dat
% disp(y2);
plot3(X2(1,:),X2(2,:),X2(3,:), 'k*');
hold off