clc;                            % clears the command window
clear;                          % clears the workspace
a=load('a.txt');                % load matrix a from a.txt
b=load('b.txt');                % load matrix b from b.txt
fprintf("a =\n");       
disp(a);                        % display matrix a on command window
fprintf("b =\n");
disp(b);                        % display matrix b on command window


% SIMPLE MATRIX INVERSION
% Finding the inverse of the matrix a and multiplying it with matrix b
% gives us the values of x1,x2,...,xn
% Note : Result is given by matrix x

x=inv(a)*b;
round(x,5,'significant')
fprintf("x =\n");
disp(x);                        % display matrix x on command window


% GAUSSIAN ELIMINATION WITH PARTIAL PIVOTING
% Note : Result is given by matrix y
 
a=a*1.05;
fprintf("a =\n");       
disp(a);                        % display matrix a on command window
fprintf("b =\n");
disp(b);                        % display matrix b on command window
n=size(a);                      % n is the size of matrix a
rows=n(1);                      % rows is the number of rows in matrix a
    
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

fprintf("modified a =\n");
disp(a);
fprintf("modified b =\n");
disp(b);

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

round(y,5,'significant')            % rounds off y to 5 significant digits
fprintf("y =\n");                       
disp(y);                            % displays y on command window

% GAUSS - SEIDEL ITERATION
% Note : Result is given by matrix z

a=load('a.txt');                        % load matrix a from a.txt again
b=load('b.txt');                        % load matrix b from b.txt again

initial=zeros(rows,1);                  % initial guess is [0;0;0;0]
z=zeros(rows,1);                        % initialize matrix z 
relativeerror=ones(rows,1);

iteration=0;                            % number of iterations taken to reach 
                                        % required value of relative error
                                    
errorcounter=1;                         % to provide the required number of iterations
                                        % for the given relative error values
                                        % only once

while(max(abs(relativeerror))>=0.01)    % run till relative error is not less than 0.01                         

    iteration=iteration+1;
    
for i=1:rows                            % implementing Gauss-Seidel method using for loops
    
    sum=0;
    
    for j=1:rows
        
        if(j~=i) 
            
            sum = sum + (a(i,j)*z(j));
            
        end
        
    end
     
    z(i)=(b(i)-sum)/a(i,i);
    round(z,5,'significant');           % round values of matrix z to 5 significant digits
    
end

for i=1:rows                            % calculate relative error
   
   relativeerror(i) = ((z(i)-initial(i))/z(i))*100;
    
end

for i=1:rows                            % initial matrix now becomes z
   
   initial(i) = z(i);
    
end

% displaying relative error, obtained values(matrix z) and number of required iterations

% for relative error smaller than 1 percent

if(max(abs(relativeerror))<1&&max(abs(relativeerror))>=0.5&&errorcounter==1)    
    
    errorcounter=errorcounter+1;
    fprintf("Relative error less than 1 percent.\nRelative error = \n");
    disp(relativeerror);
    fprintf("Iterations required = ");
    disp(iteration);
    fprintf("z =\n");
    disp(z);
    
% for relative error smaller than 0.5 percent
    
elseif(max(abs(relativeerror))<0.5&&max(abs(relativeerror))>=0.1&&errorcounter==2)
    
    errorcounter=errorcounter+1;
    fprintf("Relative error less than 0.5 percent.\nRelative error = \n");
    disp(relativeerror);
    fprintf("Iterations required = ");
    disp(iteration);
    fprintf("z =\n");
    disp(z);
    
% for relative error smaller than 0.1 percent
    
elseif(max(abs(relativeerror))<0.1&&max(abs(relativeerror))>=0.01&&errorcounter==3)
    
    errorcounter=errorcounter+1;
    fprintf("Relative error less than 0.1 percent.\nRelative error = \n");
    disp(relativeerror);
    fprintf("Iterations required = ");
    disp(iteration);
    fprintf("z =\n");
    disp(z);
    
end
    

end

% for relative error smaller than 0.01 percent

fprintf("Relative error less than 0.01 percent.\nRelative error = \n");
disp(relativeerror);
fprintf("Iterations required = ");
disp(iteration);
fprintf("z =\n");
disp(z);


