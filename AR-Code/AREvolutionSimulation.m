%AM115 project 1 - Arms race
% Jordan Rogers, Daniel Kang
%Code simulates the evolution of two countries arms stockpiles
%Three different country choices: Aggressor, Defensive, and Diplomatic

% %Country A Aggressor 
% a = 2;
% m = .2;
% B = 2;
% r = 2;
% x0 = 2;
% x_m = 10;

%Country A Defensive 
a = 1.5;
m = 2;
B = 1;
r = 2;
x0 = 5;
x_m = 8;

% %Country A Diplomatic
% a = .5;
% m = 1;
% B = .1;
% r = -.5;
% x0 = 3;
% x_m = 4;

% %Country B Aggressor 
% b = 2;
% n = .2;
% G = 2;
% s = 2;
% y0 = 2;
% y_m = 10;

% %Country B Defensive 
% b = 1.5;
% n = 2;
% G = 1;
% s = 2;
% y0 = 5;
% y_m = 8;

%Country B Diplomatic
b = .5;
n = 1;
G = .1;
s = -.5;
y0 = 3;
y_m = 4;


dxdt = 0;%initialize x' for greivance as variable model
dxdtcg = dxdt;%initialize x' for greivance as constant model
dydt = 0;
dydtcg = dydt;

timespan = 0:.05:20;
dt = .05;
steps = size(timespan,2);

xs = ones(steps,1)*x0;%array to track country A arms: Grievance as Variable
xscg = ones(steps,1)*x0;%array to track country A arms: Grievance as Constant
xsvc = ones(steps,1)*x0;%array to track country A: Varying Carrying Capacity
ys = ones(steps,1)*y0;
yscg = ones(steps,1)*y0;
ysvc = ones(steps,1)*y0;

for i = 2:steps
    %calculate new derivatives
    %for greivance as variable model
    dxdt_new = (1 - xs(i-1)/x_m)*(a*ys(i-1) - m*xs(i-1) + B*dydt + r);
    dydt_new = (1 - ys(i-1)/y_m)*(b*xs(i-1) - n*ys(i-1) + G*dxdt + s);
    
    %for greivance as constant model
    dxdtcg_new = (1 - xscg(i-1)/x_m)*(a*yscg(i-1) - m*xscg(i-1) + r);
    dydtcg_new = (1 - yscg(i-1)/y_m)*(b*xscg(i-1) - n*yscg(i-1) + s);
    
    %assign new derivatives
    dxdt = dxdt_new;
    dydt = dydt_new;
    
    dxdtcg = dxdtcg_new;
    dydtcg = dydtcg_new;

    %update values
    xs(i) = xs(i-1) + dxdt*dt;
    ys(i) = ys(i-1) + dydt*dt;
    xscg(i) = xscg(i-1) + dxdtcg*dt;
    yscg(i) = yscg(i-1) + dydtcg*dt;
    
    %Ensure arsenals dont go below 0
    if xs(i) < 0
        xs(i) = 0;
    end
    if ys(i) < 0
       ys(i) = 0; 
    end
    if xscg(i) < 0
        xscg(i) = 0;
    end
    if yscg(i) < 0
       yscg(i) = 0; 
    end    
    
end

figure(1)
plot(timespan, xs, 'r*', timespan, ys, 'r.', timespan, xscg, 'k*', timespan, yscg, 'k.')
title('Arms evolution over time: Defensive vs Defensive')
xlabel('Time')
ylabel('Stockpile size')
legend('Nation A - GAV', 'Nation B - GAV', 'Nation A - GAC', 'Nation B - GAC')
