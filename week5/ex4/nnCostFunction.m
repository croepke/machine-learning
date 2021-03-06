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
K = size(Theta2, 1);
         
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
X = [ones(m,1) X];
Y_hot = eye(num_labels);
%h = sigmoid([ones(m,1) sigmoid(X*Theta1')]*Theta2');

% Calculate h
a2=sigmoid(X*Theta1');
a2=[ones(m,1) a2];
h=sigmoid(a2*Theta2');

for i = 1:m
  % Calculate inner sum
  k_sum = 0;
  y_i = Y_hot(y(i),:);
  h_i = h(i,:);
  for k = 1:K
    k_sum+=-y_i(k)*log(h_i(k))-(1-y_i(k))*log(1-(h_i(k)));
  endfor
  J+=k_sum;
endfor
J=(1/m)*J;
% Add regularization
T1_squared = Theta1(:,2:end).*Theta1(:,2:end);
T2_squared = Theta2(:,2:end).*Theta2(:,2:end);
r = (lambda/(2*m))*(sum(T1_squared(:))+sum(T2_squared(:)));
J=J+r;
  
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
for t = 1:m
  # a1 
  a1 = X(t,:); # 1 x 400
  # a2
  z2 = a1*Theta1'; # 1 x 25
  a2 = sigmoid(z2); # 1 x 25
  a2 = [1 a2]; # 1 x 26
  # a3 
  z3 = a2*Theta2'; # 1 x 10
  a3 = sigmoid(z3); # 1 x 10
  # delta_3
  y_t = Y_hot(y(t),:); # 1 x 10
  d3 = a3 - y_t; # 1 x 10
  # delta 2
  d2 = d3*Theta2.*sigmoidGradient([1 z2]); # 1x26
  # Theta2_grad: 10x26, d3: 1x10, a2: 1x26
  Theta2_grad = Theta2_grad+d3'*a2;
  Theta1_grad = Theta1_grad+d2(2:end)'*a1;
end
  
Theta1_grad = (1/m) *Theta1_grad;
Theta2_grad = (1/m) *Theta2_grad;

%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
