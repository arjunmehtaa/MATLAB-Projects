clc;                                % clears the command window
clear;                              % clears the workspace

initial=100;                        % initial value as given in example 9

% The following two lines allow the user to enter the resistance value of
% their choice 

prompt='Enter the resistance value (in Ohms) = ';
x=input(prompt);

a=3.9083*10^-3;                     % given value of a
b=-5.775*10^-7;                     % given value of b
c=-4.183*10^-12;                    % given value of c
f=[-b -a -1+(x/initial)];           % RTD function

% BISECTION METHOD

if(x>100)                           % check value of x to choose right value of r1 and r2
    
    t1=0;
    t2=1000;
    
elseif(x<100)
    
    t1=-1000;
    t2=0;
    
end

bisectionerror=100;                 % error for bijection method
t3=0;                               % initial value (given)
bisectioniteration=0;               % number of iterations required

% The following code implements a while loop till relative error for
% bijection method is greater than 0.05

while(bisectionerror>0.05)          % methods and formulas for bijection method
    
    bisectioniteration=bisectioniteration+1;
    
    if((polyval(f,t1)<0&&polyval(f,t2)>0)||(polyval(f,t1)>0&&polyval(f,t2)<0))
        
        old=t3;
        t3=(t1+t2)/2;
        
        if(polyval(f,t3)<0)
            
            t2=t3;
            
        elseif(polyval(f,t3)>0)
                
            t1=t3;
    
        end
        
        bisectionerror=(abs(t3-old)/abs(t3))*100;
        
    elseif(polyval(f,t1)==0)
        
        t3=t1;
        break;
        
    elseif(polyval(f,t2)==0)
        
        t3=t2;
        break;
        
    end
    
end

% NEWTON RAPHSON METHOD

fdiff=[-2*b -a];                    % differentiated RTD function
newtonerror=100;                    % error for NR method
newtoniteration=0;                  % number of iterations required
t4=300;                             % initial value (given)

% The following code implements a while loop till relative error for
% newton method is greater than 0.05

while(newtonerror>0.05)             % methods and formulas for NR method
    
    newtoniteration=newtoniteration+1;
    oldval=t4;
    t4=oldval-(polyval(f,oldval)/polyval(fdiff,oldval));
    newtonerror=(abs(t4-oldval)/abs(t4))*100;
end

% OUTPUTS
fprintf('The temperature obtained by bisection is %f degrees Celsius\n',t3); 
fprintf('The temperature obtained by NR is %f degrees Celsius\n',t4);
fprintf('The number of required iterations for bisection is %i\n',bisectioniteration);
fprintf('The number of required iterations for NR is %i\n',newtoniteration);
fprintf('The absolute relative approximate error in percentage for bisection is %f\n',bisectionerror);
fprintf('The absolute relative approximate error in percentage for NR is %f\n',newtonerror);


