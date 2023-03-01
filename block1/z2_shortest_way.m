clear, clc, close all;

B = [0,0; 77,68; 12,75; 32,17; 51,64; 20,19; 72,87; 80,37; 35,82;
    2,15; 18,90; 33,50; 85,52; 97,27; 37,67; 20,82; 49,0; 62,14; 7,60;
    100,100]; % coords of way's points

genSize = 500;
popSize = 50;
bestSize = 25;
factor = 0.05;

graph = zeros(1, genSize);
points1n20 = [ones(popSize,1), ones(popSize,1)*20];
points2to19 = zeros(2, 18);
for row = 1:2
    for col = 1:18
        points2to19(row, col) = col+1;
    end
end

for generation = 1:5
    bestChromosome = 0;
    pop = genrpop(popSize, points2to19);
    for gen = 1:genSize
        popFull = [points1n20(:,1), pop, points1n20(:,2)]; % full "chromosome" from 1 to 20
        fit = pathLength(popFull, popSize, B);
        graph(gen) = min(fit);

        bestOffs = selbest(pop, fit, bestSize);
        offsprings = selsus(pop, fit, popSize-bestSize); % roulette (stochastic selection)
        offsprings = swapgen(offsprings, factor); % order mutation
        offsprings = swappart(offsprings, factor); % change order inbetween
        offsprings = invord(offsprings, 1); % order inversion
        offsprings = crosord(offsprings, 0); % permutation crossover
        
        bestChromosome = selbest(pop, fit, 1);
    
        pop = [bestOffs; offsprings];
    end
    figure(1)
    plot(graph)
    hold on
end
hold off

mapXY = interp1(B, [1, bestChromosome, 20]);
figure(2)
hold on
plot(mapXY(:,1),mapXY(:,2),'r');
plot(mapXY(:,1),mapXY(:,2),'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
for i = 1:20
    text(B(i, 1)+2, B(i, 2)+1, "" + i + "");
end

disp('Best route length is: ');
disp(graph(gen));

function [out] = pathLength(xy, size, coords)
    out = zeros(1, size);
    for i=1:size    
        for j=1:height(coords)-1
            x = coords(xy(i, j+1), 1) - coords(xy(i, j), 1);
            y = coords(xy(i, j+1), 2) - coords(xy(i, j), 2);
            out(i) = out(i) + sqrt(x^2 + y^2);
        end   
    end
end