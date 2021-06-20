clc;                                % clears the command window
clear;                              % clears the workspace

% Get user input for which test file to use and which method

testprompt='Choose test file (Enter 1 or 2) : ';
testnumber=input(testprompt);
prompt = 'Select the function to fit your data\n1. Polynomial\n2. Exponential\n3. Saturation\nSelect one of the functions : ';
option=input(prompt);

% Load test file based on user input, get number of inputs

if(testnumber==1)
    a=load('test1.txt');
elseif(testnumber==2)
    a=load('test2.txt');
end
    
n=size(a);                      % n is the size of matrix a
rows=n(1);                      % rows is the number of rows in matrix a

% POLYNOMIAL METHOD

if(option==1)
    
    % Allow user to choose the degree of polynomial in the Polynomial
    % method
    
    mode='Polynomial';
    prompt2 = 'Select the degree of polynomial : ';
    degree=input(prompt2);
    
    % Initiate required matrices and variables
    
    avalues=zeros(degree+1,1);
    xyvalues=zeros(degree+1,1);
    matrix=zeros(degree+1,degree+1);
    x=zeros(rows,1);
    y=zeros(rows,1);
    yfinal=zeros(rows,1);
    x2=zeros(rows,1);
    x3=zeros(rows,1);
    x4=zeros(rows,1);
    x5=zeros(rows,1);
    x6=zeros(rows,1);
    yx=zeros(rows,1);
    yx2=zeros(rows,1);
    yx3=zeros(rows,1);
    
    % Initiate sums to be zero
    
    sumx=0;
    sumx2=0;
    sumx3=0;
    sumx4=0;
    sumx5=0;
    sumx6=0;
    sumy=0;
    sumyx=0;
    sumyx2=0;
    sumyx3=0;
    Sr=0;
    St=0;
    
    % Set values of each element of required matrices as well as the sums
    % using for loop
    
    for i=1:rows
   
        x(i)=a(i,1);
        y(i)=a(i,2);
        x2(i)=x(i)^2;
        x3(i)=x(i)^3;
        x4(i)=x(i)^4;
        x5(i)=x(i)^5;
        x6(i)=x(i)^6;
        yx(i)=y(i)*x(i);
        yx2(i)=y(i)*x2(i);
        yx3(i)=y(i)*x3(i);
        sumx=sumx+x(i);
        sumx2=sumx2+x2(i);
        sumx3=sumx3+x3(i);
        sumx4=sumx4+x4(i);
        sumx5=sumx5+x5(i);
        sumx6=sumx6+x6(i);
        sumy=sumy+y(i);
        sumyx=sumyx+yx(i);
        sumyx2=sumyx2+yx2(i);
        sumyx3=sumyx3+yx3(i);
    
    end
    
    % Fill up the main matrix with the required sums as required in the
    % method
    
    for i=1:degree+1
            
    for j=1:degree+1
                
        if(i+j==2)
            matrix(i,j)=rows;
                
        elseif(i+j==3)
            matrix(i,j)=sumx;
                    
        elseif(i+j==4)
            matrix(i,j)=sumx2;
                    
        elseif(i+j==5)
            matrix(i,j)=sumx3;
                    
        elseif(i+j==6)
            matrix(i,j)=sumx4;
                    
        elseif(i+j==7)
            matrix(i,j)=sumx5;
                    
        elseif(i+j==8)
            matrix(i,j)=sumx6;
                    
        end
                
    end
            
    end
    
    % Set values of each element in the right hand side matrix
        
    for i=1:degree+1
        
        if(i==1)
            xyvalues(1,1)=sumy;
        elseif(i==2)
            xyvalues(2,1)=sumyx;
        elseif(i==3)
            xyvalues(3,1)=sumyx2;
        elseif(i==4)
            xyvalues(4,1)=sumyx3;
        end
    
    end
    
    % Solve for a0, a1, a2 etc. using Simple Matrix Inversion
    
    avalues=inv(matrix)*xyvalues;
    
    % Find the final values of y to be used for plotting
    
    for i=1:rows
        
        if(degree==1)
            yfinal(i)=avalues(1)+avalues(2)*x(i);
        elseif(degree==2)
            yfinal(i)=avalues(1)+avalues(2)*x(i)+avalues(3)*x2(i);
        elseif(degree==3)
            yfinal(i)=avalues(1)+avalues(2)*x(i)+avalues(3)*x2(i)+avalues(4)*x3(i);
        end
        
    end
    
    ym=sumy/rows;           % Calculate mean value of y
    
    % Find St and Sr (to be used for calculating R2) 
    
    for i=1:rows
        
        St=St+(y(i)-ym)*(y(i)-ym);
        Sr=Sr+(y(i)-yfinal(i))*(y(i)-yfinal(i));
        
    end
    
    R2=(St-Sr)/St;          % Find R2 using given formula
    
    % Plotting of data on graph
    
    figure;
    plot(x,yfinal,'r');
    hold on
    plot(x,y,'b*');
    hold off
    axis([0 real(max(x)+x(1)) 0 real(max(yfinal)+yfinal(1))]);
    xlabel('x');
    ylabel('y');
    gravstr=mode;
    gravstr=[gravstr sprintf(', y = ')];
    
    for i=0:degree
        
        if(i==degree)
            gravstr=[gravstr sprintf('%0.4f x^{%i}',[avalues(i+1)],[i])];
            gravstr=[gravstr sprintf(', R^{2} = %0.4f',[R2])];
        else
            gravstr=[gravstr sprintf('%0.4f x^{%i} + ',[avalues(i+1)],[i])];
        end
        
    end
        
    legend(gravstr);
    set(gca,'FontSize',20);
    
 
end

% EXPONENTIAL METHOD

if(option==2)

    mode='Exponential';

    % Initiate required matrices and variables
    
    x=zeros(rows,1);
    y=zeros(rows,1);
    lny=zeros(rows,1);
    xsquared=zeros(rows,1);
    xlny=zeros(rows,1);
    yfinal=zeros(rows,1);
    
    % Initiate sums to be zero

    sumx=0;
    sumy=0;
    sumlny=0;
    sumxlny=0;
    sumxsquared=0;
    Sr=0;
    St=0;

    % Set values of each element of required matrices as well as the sums
    % using for loop
    nn=rows;
    for i=1:rows
   
        x(i)=a(i,1);
        y(i)=a(i,2);
        xsquared(i)=x(i)*x(i);
        if(y(i)<=0)
            fprintf("Warning : ln of zero or negative value encountered.\n");
            nn=nn-1;
            sumy=sumy+y(i);
        else
        lny(i)=log(y(i));
        xlny(i)=x(i)*lny(i);
        sumx=sumx+x(i);
        sumy=sumy+y(i);
        sumlny=sumlny+lny(i);
        sumxsquared=sumxsquared+xsquared(i);
        sumxlny=sumxlny+xlny(i);
        end
    
    end
    
    % Find a1 and a0 using formula

    a1=((nn*sumxlny)-(sumx*sumlny))/((nn*sumxsquared)-(sumx*sumx));
    a0=(sumlny/nn)-(a1*(sumx/nn));
    
    % Find A and B using the vales of a0 and a1 found above

    A=exp(a0);
    B=a1;

    % Find the final values of y to be used for plotting
    
    for i=1:rows
    
        yfinal(i)=A*(exp(B*x(i)));
     
    end
    
    ym=sumy/rows;           % Calculate mean value of y
    
    % Find St and Sr (to be used for calculating R2) 
    
    for i=1:rows
        
        St=St+(y(i)-ym)*(y(i)-ym);
        Sr=Sr+(y(i)-yfinal(i))*(y(i)-yfinal(i));
        
    end
    
    R2=(St-Sr)/St;          % Find R2 using given formula
    
% Plotting of data on graph
    
    figure;
    plot(x,yfinal,'r');
    hold on
    plot(x,y,'b*');
    hold off
    axis([0 real(max(x)+x(1)) 0 real(max(yfinal)+yfinal(1))]);
    xlabel('x');
    ylabel('y');
    gravstr=mode;
    gravstr=[gravstr sprintf(', y = ')];
    
    gravstr=[gravstr sprintf('%0.4fe^{%0.4fx}',[A],[B])];
    gravstr=[gravstr sprintf(', R^{2} = %0.4f',[R2])];
        
    legend(gravstr);
    set(gca,'FontSize',20);


end

% SATURATION METHOD

if(option==3)
    
    mode='Saturation';
    
    % Initiate required matrices and variables
    
    x=zeros(rows,1);
    y=zeros(rows,1);
    X=zeros(rows,1);
    Y=zeros(rows,1);
    X2=zeros(rows,1);
    XY=zeros(rows,1);
    yfinal=zeros(rows,1);
    
    % Initiate sums to be zero
    
    sumX=0;
    sumY=0;
    sumXY=0;
    sumX2=0;
    sumy=0;
    Sr=0;
    St=0;
    nn=rows;
    
    % Set values of each element of required matrices as well as the sums
    % using for loop
  
    for i=1:rows
   
        x(i)=a(i,1);
        y(i)=a(i,2);
        
        if x(i)==0 || y(i)==0
            fprintf("Warning : Invalid x/y value encountered. Division by zero might cause errors.\n");
            nn=nn-1;
            sumy=sumy+y(i);
         
        else
        X(i)=1/x(i);
        Y(i)=1/y(i);
        X2(i)=X(i)*X(i);
        XY(i)=X(i)*Y(i); 
        sumX=sumX+X(i);
        sumY=sumY+Y(i);
        sumXY=sumXY+XY(i);
        sumX2=sumX2+X2(i);
        sumy=sumy+y(i);
        end
        
    end
    
    % Find a1 and a0 using formula
    
    a1=((nn*sumXY)-(sumX*sumY))/((nn*sumX2)-(sumX*sumX));
    a0=(sumY/nn)-(a1*(sumX/nn));
    
    % Find A and B using the vales of a0 and a1 found above
    
    A=1/a0;
    B=a1*A;
    
    % Find the final values of y to be used for plotting 
    
    for i=1:rows
    
        yfinal(i)=(A*x(i))/(B+x(i));
     
    end
    
    ym=sumy/rows;                   % Calculate mean value of y
    
    % Find St and Sr (to be used for calculating R2) 
    
    for i=1:rows
        
        St=St+(y(i)-ym)*(y(i)-ym);
        Sr=Sr+(y(i)-yfinal(i))*(y(i)-yfinal(i));
        
    end
    
    R2=(St-Sr)/St;                  % Find R2 using given formula
    
    % Plotting of data on graph
    
    figure;
    plot(x,yfinal,'r');
    hold on
    plot(x,y,'b*');
    hold off
    axis([0 real(max(x)+x(1)) 0 real(max(yfinal)+yfinal(1))]);
    xlabel('x');
    ylabel('y');
    gravstr=mode;
    gravstr=[gravstr sprintf(', y = ')];
    
    gravstr=[gravstr sprintf('(%0.4f x)/(%0.4f + x)',[A],[B])];
    gravstr=[gravstr sprintf(', R^{2} = %0.4f',[R2])];
        
    legend(gravstr);
    set(gca,'FontSize',20);
    
    
end
