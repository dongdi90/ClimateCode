%lassoCrossValidation.m
%Runs a leave-k-out cross validation
%NOTE: DOES NOT WORK IF X/k isn't a round number
%to run [B, F, y_pred, mse] = lassoCrossValidation(X,Y, 8, 0.1)
%where X is NxM matrix and Y is 1xN vector

function [B, F, y_pred fold_mse] =  lassoCrossValidation(x,y,k, lambda, intercept)

if nargin < 5
    intercept = false;
end

assert(mod(length(x),k)==0,'X/k must be 0 i.e. 8 elements and leave 2 out.');
assert(isscalar(lambda), 'lambda must be a scalar');
count = 1;
for i=1:k:size(x,1)
    test = x(i:i+k-1,:); %set the first k observations as test
    train = x; 
    train(i:i+k-1,:)=[]; %hide the first k observations from the training set
    test_y = y(i:i+k-1);
    train_y = y; 
    train_y(i:i+k-1)=[];
    [B{count},F{count}] = lasso(train,train_y,'lambda',lambda);
    if F{count}.DF < 1
        disp('Lambda valude too high!')
        
    end
    assert(F{count}.DF>=1,'Lambda value is too high. All predictors are dropped.')
    y_pred{count} =test * B{count};
    
    if intercept == true
        y_pred{count} = y_pred{count} + F{count}.Intercept;
    end
    
    fold_mse(count) = sum((test_y - y_pred{count}).^2);
    count = count+1;
end
y_pred = cell2mat(y_pred');
end

