clear, clc, close all; figure; hold on;

space = [-500*ones(1,10); 500*ones(1,10)]; % interval <-500,500> for every variable (10 vars)                                                                                                                   
graph = zeros(1, 500);                                                                                                           
amp = 5*ones(1, 10);

popSize = 40;
bestSize = 10;

for i = 1:5
    pop = genrpop(popSize, space);

    for j = 1:500
        fit = schwefel(pop);
        graph(j) = min(fit); % draw min from population

        best = selbest(pop, fit, bestSize); % get best offsprings
        offspings = selsort(pop, fit, (popSize-bestSize)); % get random offsprings

        offsprings = mutx(offspings, 0.1, space); % global mutation
        offsprings = muta(offsprings,0.1, amp, space); % additive mutation
        offsprings = crossov(offsprings,1,1); % offsprings(parent) crossing

        pop = [best; offsprings]; % new population
    end

    line = plot(graph);
    color = get(line, 'Color');
    text(480, (-2000)-i*(150), "" + i + "", 'Color', color);

    disp("Best sample " + i + ":");
    disp(selbest(pop, fit, 1));
    disp("Fitness: " + min(fit));
    disp('___________________________');
end
hold off
