function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%code for feedforward and cost function without regularization

X = [ones(m,1) X];

z2 = X * Theta1';

a2 = 1./(1+exp(-z2));

a2 = [ones(m,1) a2];

z3 = a2 * Theta2';

a3 = 1./(1+exp(-z3));

for i = 1:m,

a = a3(i,:);

b=1:num_labels;

b = (b==y(i));

J = J + (b * (log(a))' + (1-b) * (log(1-a))');;

end

J = -1/m * J;

%code using  feedforward propagation and cost function with 
%regularization
%adding a regularized expression to the above code

t1 = Theta1(: , 2:size(Theta1,2));
t2 = Theta2(: , 2:size(Theta2,2));
p1 = lambda/(2*m) * (sum(sum(t1.^2)) + sum(sum(t2.^2)));

J = J + p1;

%backpropagation algorithm

for t = 1:m
a1 = X(t,:);%(1x401)
z2 = a1 * Theta1';%(1x401) * (401x25)
a2 = sigmoid(z2);%(1x25)
a2 = [ones(1,1) a2];%(1x26)
z3 = a2 * Theta2';%(1x26) * (26x10)
a3 = sigmoid(z3);%(1x10)
b = 1:num_labels;
b = (b==y(t));%(1x10)
s3 = a3 - b;%(1x10)
z2=[ones(1,1) z2];%(1x26)
s2 = (s3 * Theta2).*sigmoidGradient(z2);%((1x10)*(10x26))
s2 = s2(:,2:size(s2,2));%(1x25)
Theta2_grad = Theta2_grad + s3' * a2;
Theta1_grad = Theta1_grad + s2' * a1;
end

Theta2_grad = (1/m) * Theta2_grad;
Theta1_grad = (1/m) * Theta1_grad;

%Adding the regularized expression to the previously implemented backpropagation algotrithm

theta1 = Theta1(:,2:size(Theta1,2));%(25x400)
theta2 = Theta2(:,2:size(Theta2,2));%(10x25)

Theta2_grad(:,2:end) = Theta2_grad(:,2:size(Theta2_grad,2)) + (lambda/(m)).* theta2;
Theta1_grad(:,2:end) = Theta1_grad(:,2:size(Theta1_grad,2)) + (lambda/(m)).* theta1;
























% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
