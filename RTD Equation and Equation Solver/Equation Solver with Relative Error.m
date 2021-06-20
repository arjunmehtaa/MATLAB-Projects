clc;                                % clears the command window
clear;                              % clears the workspace

initial=[1;1;1];                    % matrix to store the values of x, y, z from the previous step
iteration=0;                        % keep track of the number of iterations to reach required step

relativeerror=[1;1;1];              % initialize the relative error matrix for x, y, z

% The following lines of code allows user to input initial values of x,y,z

promptx='Enter the initial value of x : ';
prompty='Enter the initial value of y : ';
promptz='Enter the initial value of z : ';
q(1,1)=input(promptx);
q(2,1)=input(prompty);
q(3,1)=input(promptz);

% The following code implements while loop till relative error is greater
% than or equal to 0.1, initializes the arrays for f(x) and f'(x) and then
% implements gauss elimination (from Simulation Assignment 1) to solve
% the given equation

while(abs(max(relativeerror))>=0.1)
    iteration=iteration+1;
    
    syms x y z;

    f1=(x^3)-(10*x)+y-z+3;
    f2=(y^3)+(10*y)-(2*x)-(2*z)-5;
    f3=x+y-(10*z)+(2*sin(z))+5;
    b=[f1;f2;f3];
    a=jacobian(b,[x,y,z]);
    a=subs(a,[x,y,z],[q(1),q(2),q(3)]);
    b=subs(b,[x,y,z],[q(1),q(2),q(3)]);
     
    n=size(a);                      % n is the size of matrix a
    rows=n(1);                      % rows is the number of rows in matrix a
    
    
    % GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
    % Note : Result is given by matrix y

    for i=1:rows-1
       
        maxval=0;                   % default max value is 0
        index=0;                    % index will be the row which has maxval value
   
    % Partial Pivoting
   
        for m=i:rows                % find the index of the max value in the column
        
            if(abs(a(m,i))>maxval)
            
                maxval=abs(a(m,i));
                index=m;
            
            end
        
        end
    
        if(a(i,i)~=a(index,i))      % swap the row with the max value with row i
        
            temp=a(i,:);
            a(i,:)=a(index,:);
            a(index,:)=temp;
        
            temp2=b(i);
            b(i)=b(index);
            b(index)=temp2;
        
        end
    
    % Forward Elimination
    
        for j=i+1:rows                          % forward elimination algorithm implemented
                                                % using for loops
            multiplier=(a(j,i)/a(i,i));
            a(j,:) = a(j,:) - multiplier*a(i,:);
            b(j) = b(j) - multiplier*b(i);
        
        end
    
    end



    % Back Susbstitution

    y=zeros(rows,1);
    y(rows)=b(rows)/a(rows,rows);

    for i=rows-1:-1:1                   % back substitution algorithm implemented
                                        % using for loops
        sum=0;
        for j=i+1:rows
        
            sum = sum+(a(i,j)*y(j));
        
        end
    
        y(i)=(b(i)-sum)/a(i,i);

    end

    for i=1:rows                        % calculate relative error
   
        initial(i,1)=q(i);
        q(i)=q(i)-y(i);
        relativeerror(i,1) = (abs(q(i)-initial(i))/abs(q(i)))*100;
    
    end
    
    clear a;
    clear b;
    
end

% OUTPUTS 

fprintf("The total  number of iterations is %i\n",iteration);
fprintf("The final value of x is %f\n",q(1));
fprintf("The final value of y is %f\n",q(2));
fprintf("The final value of z is %f\n",q(3));
fprintf("The relative error in x is %f\n",relativeerror(1));
fprintf("The relative error in y is %f\n",relativeerror(2));
fprintf("The relative error in z is %f\n",relativeerror(3));



