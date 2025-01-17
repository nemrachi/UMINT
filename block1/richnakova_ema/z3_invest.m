clear, clc, close all; figure; hold on;

genSize = 1000;
popSize = 300;
bestSize = 30;
factor = 0.2;

fit = zeros(1, popSize);
bestFit = zeros(1, genSize);

space = [0*ones(1, 5); 10000000*ones(1, 5)]; % matrix 2x5 -> lower and upper bound of genomes
amp = 100000*ones(1, 5);
kp = 10000; % fine constant
profit = [0.04 0.07 0.11 0.06 0.05];
penaltyTypes = dictionary([1 2 3], ["death" "step" "proportional"]);

for pt = 1:numEntries(penaltyTypes)
    pop = genrpop(popSize, space);
    for gen = 1:genSize
        for i = 1:popSize
            fit(i) = evalFitness(pop(i,:), profit, kp, pt);
        end
        best = selsort(pop, fit, bestSize);
        offsprings = seltourn(pop, fit, popSize - bestSize); % tournament

        offsprings = crossov(offsprings, 1, 0); % offsprings(parent) crossing
        offsprings = mutx(offsprings, factor,space); % global mutation
        offsprings = muta(offsprings, factor, amp ,space); % additive mutation
        
        pop = [best; offsprings];
        bestFit(gen) = -min(fit);
    end

    hold on
    line = plot(1:genSize, bestFit);
    xlabel("Profit");
    ylabel("Fitness");
    color = get(line, 'Color');
    text(genSize-(genSize/3), 660000-pt*10000, penaltyTypes(pt) + ' penalty', 'Color', color);
    ylim([600000 730000]);

    % get fitness of last population
    for i = 1:popSize
        fit(i) = evalFitness(pop(i,:),profit,kp,pt);
    end
    minFitness = min(fit);
    
    % get first index of min (best) value -> get best chromosome
    % bestIndex = find(fit == minFit);
    % bestIndex = bestIndex(1,1);
    bestChromosome = selbest(pop, fit, 1);
    fprintf('\n___' + penaltyTypes(pt) + '_penalty____________________________________\n')
    disp([bold('Zisk: '), num2str(-minFitness)]);
    disp([bold('Najlepsi chromozom: '), num2str(bestChromosome)]);    
    disp([bold('Podmienka - neprekrocit investiciu cez 10M: '), num2str(sum(bestChromosome)),' < 10000000']);
    disp([bold('Podmienka - neprekrocit celkovu sumu investicii cez 2.5M: '), num2str(bestChromosome(1,1)+bestChromosome(1,2)),' < 2500000']);
    disp('Investicie do statnych dlhopisov nemaju byt mensie nez uspory v banke');
    disp([bold('V statnych dlhopisoch: '), num2str(bestChromosome(1,4))]);
    disp([bold('V banke: '), num2str(bestChromosome(1,5))]);
    disp('Suma investicii do dlhopisov nema presiahnut polovicu vsetkych investovanych prostriedkov');
    disp([bold('V dlhopisoch:'), num2str(bestChromosome(1,3) + bestChromosome(1,4))]);
    disp([bold('Celkovo investovane: '), num2str(sum(bestChromosome))]);
end

function boldStr = bold(str)
    boldStr = strjoin({'<strong>', str, '</strong>'}, "");
end

function fitness = evalFitness(investment, profit, kp, penaltyType)
    fitness = 0;
    for i = 1:length(profit) % get actual profit
        fitness = investment(1, i) * profit(i) + fitness;
    end

    switch penaltyType
        case 1 % death penalty
            if sum(investment) > 10000000 ||...
               (investment(1,1) + investment(1,2)) > 2500000 ||...
               (-1*investment(1,4) + investment(1,5)) > 0 ||...
               (-0.5*investment(1,1) - 0.5*investment(1,2) + 0.5*investment(1,3) + 0.5*investment(1,4) - 0.5*investment(1,5)) > 0
                fitness = -1000000000;
            end
        case 2 % step penalty
            if sum(investment) > 10000000
                fitness = fitness - 100000000;
            end
            if (investment(1,1) + investment(1,2)) > 2500000
                fitness = fitness - 100000000;
            end
            if (-1*investment(1,4) + investment(1,5)) > 0
               fitness = fitness - 100000000;
            end
            if (-0.5*investment(1,1) - 0.5*investment(1,2) + 0.5*investment(1,3) + 0.5*investment(1,4) - 0.5*investment(1,5)) > 0
                fitness = fitness - 100000000;
            end
        case 3 % proportional penalty
            if sum(investment) > 10000000
                fitness = fitness - (sum(investment) - 10000000)*kp;
            end
            if (investment(1,1) + investment(1,2)) > 2500000
                fitness = fitness - (investment(1,1)+investment(1,2) - 2500000)*kp;
            end
            if (-1*investment(1,4) + investment(1,5)) > 0
               fitness = fitness - (-1*investment(1,4) + investment(1,5))*kp;
            end
            if (-0.5*investment(1,1) - 0.5*investment(1,2) + 0.5*investment(1,3) + 0.5*investment(1,4) - 0.5*investment(1,5)) > 0
                fitness = fitness - (-0.5*investment(1,1) - 0.5*investment(1,2) + 0.5*investment(1,3) + 0.5*investment(1,4) - 0.5*investment(1,5))*kp;
            end
    end
    % invert fitness value, because selbest selects minimum
    fitness = -fitness;
end
