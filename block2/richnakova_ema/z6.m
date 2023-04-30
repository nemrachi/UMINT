clc, clear, close all;

% nacitanie vstupnych dat pre Neuronovu Siet (NS)
% namerane priznaky z CTG vysetrenia (kardiotokograficky zaznam)
load("CTGdata.mat");
% pole pre 3 typy ochorenia (1-normalny, 2-podozrivy, 3-patologicky)
targets = zeros(3,size(typ_ochorenia,1)); % ake data chceme dosiahnut
% utriedenie dat pre typy ochorenia 
for i=1:size(typ_ochorenia,1)
    if typ_ochorenia(i)==1
        targets(typ_ochorenia(i),i)=1;
    elseif typ_ochorenia(i)==2
        targets(typ_ochorenia(i),i)=1;
    else
        targets(3,i)=1;
    end
end

% vstupné hodnoty
inputs = NDATA'; % transpozicia pola dat
cTest = 50; % hodnota confusion pre test data

for i = 1:10
    net = patternnet(20); % NS pre rozpoznavanie patternov

    % rozdelenie dat
    net.divideFcn = 'dividerand';       % nahodne rozdelenie dat
    net.divideParam.trainRatio = 0.6;   % 60% dat na trenovanie
    net.divideParam.valRatio = 0;       % 0% na validaciu (nepovinne) 
    net.divideParam.testRatio = 0.4;    % 40% dat na testovanie

    net.trainParam.goal = 0.01;         % ukoncovacia podmienka na chybu SSE
    net.trainParam.show = 5;            % frekvencia zobrazovania priebehu chyby trénovania (v epochach)
    net.trainParam.epochs = 300;        % max. pocet trenovacich cyklov
    net.trainParam.min_grad = 1e-4;     % ukoncovacia podmienka na min. gradient 
    
    % trenovanie NS
    [net,tr] = train(net,inputs,targets);
    
    % simulacia vystupu NS
    outputs = net(inputs);
    % ziskanie dat pre confusion tabulku
    outputsTrain = net(inputs(:,tr.trainInd));
    outputsTest = net(inputs(:,tr.testInd));
    targetsTrain = targets(:,tr.trainInd);
    targetsTest = targets(:,tr.testInd);
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);
    
    % confusion tabulky
    [cTrain,cmTrain] = confusion(targetsTrain,outputsTrain);
    [cTest,cmTest] = confusion(targetsTest,outputsTest);
    [cAll,cm] = confusion(targets,outputs);

    fprintf('\n\n%d. Úspešnosť klasifikácie (train,test,all): %.4f  %.4f %.4f\n', i,100*(1-cTrain),100*(1-cTest), 100*(1-cAll));
    fprintf('Train -> Senzitivita: %.4f | Špecificita: %.4f\n',cmTrain(2,2)/(cmTrain(2,2)+cmTrain(2,1)), cmTrain(1,1)/(cmTrain(1,1)+cmTrain(1,2)));
    fprintf('Test -> Senzitivita: %.4f | Špecificita: %.4f\n',cmTest(2,2)/(cmTest(2,2)+cmTest(2,1)), cmTest(1,1)/(cmTest(1,1)+cmTest(1,2)));
    fprintf('All -> Senzitivita: %.4f | Špecificita: %.4f\n',cm(2,2)/(cm(2,2)+cm(2,1)), cm(1,1)/(cm(1,1)+cm(1,2)));

    success(i,1) = 100*(1-cTrain);
    success(i,2) = 100*(1-cTest);
    success(i,3) = 100*(1-cAll);

end

fprintf('\n');
successMin = min(success);
successMax = max(success);
successMean = mean(success);
fprintf('Úspešnosť train (min,max,average): %.4f %.4f %.4f \n',successMin(1), successMax(1), successMean(1));
fprintf('Úspešnosť test (min,max,average): %.4f %.4f %.4f \n',successMin(2), successMax(2), successMean(2));
fprintf('Úspešnosť all (min,max,average): \t%.4f %.4f %.4f \n',successMin(3), successMax(3), successMean(3));
