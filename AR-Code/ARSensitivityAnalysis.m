%Daniel Kang, Jordan Rogers
%AM115 project 1 - Arms Race Sensitivity Analysis 


x_m = 15;%Country A carrying capacity
y_m = 15;
a = 2;%Country A reaction
b = .5;
m = .2;%Country A fatigue 
n = 1;
r = 2;%Country A greivance constant 
s = -.5;
x0 = 2;%initial country A arms
y0 = 3;
dxdt = 0;%initialize x for greivance as variable model
dydt = 0;

B = 2;%Country A greivance coefficient 
G = .1;

timespan = 0:.05:10;
dt = .001;
steps = size(timespan,2);

%%%%Sensitivity initialization%%%%
%%%Carrying capacity%%%
x_msens = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
y_msens = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
xsens = ones(steps,15)*x0;
ysens = ones(steps,15)*y0;

%%%Grievance Level%%%
rg = [-3 -2 -1 0 1 2 3 4 5 6 7];
sg = [-3 -2 -1 0 1 2 3 4 5 6 7];
xsensg = ones(steps,11)*x0;
ysensg = ones(steps,11)*y0;

for i = 2:steps
    %calculate new derivatives
    %for greivance as variable model
    for j = 1:15 
        dxdt_new = (1 - (xsens(i-1)/x_msens(j)))*(a*ysens(i-1) - m*xsens(i-1) + B*dydt + r);
        dydt_new = (1 - (ysens(i-1)/y_msens(j)))*(b*xsens(i-1) - n*ysens(i-1) + G*dxdt + s);
    
        %assign new derivatives
        dxdt = dxdt_new;
        dydt = dydt_new;
    
        %update values
        xsens(i,j) = xsens(i-1,j) + dxdt*dt;
        ysens(i,j) = ysens(i-1,j) + dydt*dt;
        
        if xsens(i,j) < 0
            xsens(i,j) = 0;
        end
        if ysens(i,j) < 0
            ysens(i,j) = 0; 
        end
    end 
      
end

for i = 2:steps
    %calculate new derivatives
    %for greivance as variable model
    for j = 1:11 
        dxdt_newg = (1 - (xsensg(i-1)/x_m))*(a*ysensg(i-1) - m*xsensg(i-1) + B*dydt + rg(j));
        dydt_newg = (1 - (ysensg(i-1)/y_m))*(b*xsensg(i-1) - n*ysensg(i-1) + G*dxdt + sg(j));
    
        %assign new derivatives
        dxdtg = dxdt_newg;
        dydtg = dydt_newg;
    
        %update values
        xsensg(i,j) = xsensg(i-1,j) + dxdtg*dt;
        ysensg(i,j) = ysensg(i-1,j) + dydtg*dt;
        
        if xsensg(i,j) < 0
            xsensg(i,j) = 0;
        end
        if ysensg(i,j) < 0
            ysensg(i,j) = 0; 
        end
    end 
      
end

%Carrying capacity cannot be less than initial stockpile condition, so
%cropping matrix 
xsensc = xsens(:,3:15);
ysensc = ysens(:,3:15);

figure(1)
title('Arms evolution over carrying capacity') 
plot(xsensc) %varying carrying capacity for aggressive country
plot(ysensc) %varying carrying capacity for diplomatic country 
legend()

    
figure(2)
title('Arms evolution over changing internal and external pressure (r,s)')
plot(xsensg) %changing external/internal pressure for aggressive country 
plot(ysensg) %changing external/internal pressure for diplomatic country
legend('Nation A - arms stockpile', 'Nation B - arms stockpile')

