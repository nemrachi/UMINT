clear, clc, close all; figure; hold on;

x = -6:0.1:6;
x0 = 5;
xStep = 0.1;

plot(x,fun(x));

while true
    xPrev = x0-xStep;
    xNext = x0+xStep;
    
    yPrev = fun(xPrev);
    yNext = fun(xNext);
    y0 = fun(x0);

    plot(x0,y0,'g|', 'LineWidth', 1)

    if yPrev < y0 
        x0 = xPrev;
    elseif yNext < y0
        x0 = xNext;
    else 
      break
    end
end

plot(x0,y0,'r.', 'MarkerSize', 15)

fprintf('Min: [%f, %f]\n', x0, y0); 

function[y] = fun(x)
    y= 0.2*x.^4+0.2*x.^3-4*x.^2+10;
end
