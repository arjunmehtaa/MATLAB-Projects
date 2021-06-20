clc;                                % clears the command window
clear;                              % clears the workspace

a=load("test_1.txt");               % load test_1.txt

% Allow user to choose the mode

prompt='Choose the mode:\n1. Derivative\n2. Integration\nChoose either 1 or 2 : ';
mode=input(prompt);

n=size(a);                      % n is the size of matrix a
rows=n(1);                      % rows is the number of rows in matrix a

% DERIVATIVE MODE

if(mode==1)
    
    % Allow user to input the point at which derivative is to be found
    
    prompt='Enter point p where you want to perform derivative : ';
    p=input(prompt);
    counter=0;
    
    % Following code contains loops and code to perform the algorithm
    
    for i=1:rows
        
        if(a(i,1)==p)
            if((a(i+1,1)-a(i,1))==(a(i,1)-a(i-1,1)))
                counter=1;
                fupper=a(i+1,2);
                flower=a(i-1,2);
                xupper=a(i+1,1);
                xlower=a(i-1,1);
            end
        end
    end
    
    % The point is from the data set and the spacing between the points is
    % even
    
    if(counter==1)
        
        % Output the derivative
        
        derivative=(fupper-flower)/(xupper-xlower);
        fprintf("The derivative of the function at point p = "+p+" is "+derivative+"\n");
        
    end
    
    % The point is not from the data set and/or the spacing between the
    % points is not even
    
    if(counter==0)
        
        fprintf("The point is not from the data set and/or the spacing between the points is not even.\nPerforming polynomial regression.\n");
        h=a(2,1)-a(1,1);
        
        for i=1:rows-1
            
            if((a(i+1,1)-a(i,1))<h)
                h=(a(i+1,1)-a(i,1));
            end
            
        end
        
        
        % POLYNOMIAL METHOD
        
        
        % Allow user to choose the degree of polynomial in the Polynomial
        % method
        
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
        
        % Calculate desired values from equation found from polynomial
        % regression and perform the algorithm
        
        mupper=p+h;
        mlower=p-h;
        
        if(degree==3)
            fupper=((mupper^3)*avalues(4,1)+(mupper^2)*avalues(3,1)+(mupper)*avalues(2,1)+avalues(1,1));
            flower=((mlower^3)*avalues(4,1)+(mlower^2)*avalues(3,1)+(mlower)*avalues(2,1)+avalues(1,1));
            fp=(fupper-flower)/(2*h);
        end
        
        if(degree==2)
            fupper=((mupper^2)*avalues(3,1)+(mupper)*avalues(2,1)+avalues(1,1));
            flower=((mlower^2)*avalues(3,1)+(mlower)*avalues(2,1)+avalues(1,1));
            fp=(fupper-flower)/(2*h);
        end
        
        if(degree==1)
            fupper=((mupper)*avalues(2,1)+avalues(1,1));
            flower=((mlower)*avalues(2,1)+avalues(1,1));
            fp=(fupper-flower)/(2*h);
        end
        
        % Output the derivative
        
        fprintf("The derivative of the function at point p = "+p+" is "+fp+"\n");
        
    end
    
end

% INTEGRATION

if(mode==2)
    
    % Allow user to enter lower limit, upper limit and number of segments
    
    prompt="Enter lower integration limit : ";
    p1=input(prompt);
    prompt="Enter upper integration limit : ";
    p2=input(prompt);
    prompt="Enter number of segments : ";
    segs=input(prompt);
    
    % Initialize required variables
    
    height=(p2-p1)/segs;
    newdata=zeros(segs+1,1);
    i=1;
    present=0;
    limitpresent=0;
    
    % Following code contains loops and code to perform the algorithm
    
    while(newdata(i,1)~=p2&&i<segs+1)
        
        newdata(i,1)=p1+(i-1)*height;
        i=i+1;
        
    end
    newdata(i)=p2;
    n2=size(newdata);                      % n is the size of matrix a
    newrows=n2(1);                         % rows is the number of rows in matrix a
    
    for i=1:newrows
        
        for j=1:rows
            
            if(newdata(i,1)==a(j,1))
                present=present+1;
                newdata(i,2)=a(j,2);
                if(newdata(i,1)==p1)
                    limitpresent=limitpresent+1;
                    fa=newdata(i,2);
                end
                if(newdata(i,1)==p2)
                    limitpresent=limitpresent+1;
                    fb=newdata(i,2);
                end
            end
            
        end
        
    end
    
    ba2n=(p2-p1)/(2*segs);
    summation=0;
    
    % The values of the new data set belong to the original data set
    
    if(present==newrows)
        
        for i=1:segs-1
            
            for j=1:newrows
                if(newdata(j,1)==(p1+i*height))
                    faih=newdata(j,2);
                end
            end
            
            summation=summation+faih;
            
        end
        
        integral=ba2n*(fa+(2*summation)+fb);
        
        % Output the integral
        
        fprintf("The integral of the function is "+integral+"\n");
        
    end
    
    % The limits (p1 and p2) are within the range of the original data set,
    % but atleast one of the values of the new data set do not belong to the original data
    
    if(present~=newrows&&limitpresent==2)
        
        fprintf("Limits are present in original data set but not all other values.\nPerforming polynomial regression.\n");
        
        % POLYNOMIAL METHOD
        
        
        % Allow user to choose the degree of polynomial in the Polynomial
        % method
        
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
        
        % Calculate desired values from equation found from polynomial
        % regression and perform the algorithm
        
        for i=1:segs-1
            if(degree==3)
                summation=summation+(((p1+i*height)^3)*avalues(4,1)+((p1+i*height)^2)*avalues(3,1)+((p1+i*height))*avalues(2,1)+avalues(1,1));
            end
            if(degree==2)
                summation=summation+(((p1+i*height)^2)*avalues(3,1)+((p1+i*height))*avalues(2,1)+avalues(1,1));
            end
            if(degree==1)
                summation=summation+(((p1+i*height))*avalues(2,1)+avalues(1,1));
            end
        end
        
        % Output the integral
        
        integral=ba2n*(fa+(2*summation)+fb);
        fprintf("The integral of the function is "+integral+"\n");
        
    end
    
    %  At least one of the limits (p1 and p2) is out of the range of the
    %  original data set
    
    if(present~=newrows&&limitpresent~=2)
        
        fprintf("Error : Atleast one of the limits not present in original data\n");
        
    end
    
end
