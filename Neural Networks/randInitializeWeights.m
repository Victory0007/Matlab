function[W] = randInitializeWeights(l_prev, l_next)
%l_prev - number of neurons in previous layer
%l_next number of neurons in the next layer or current layer
%Added 1 more column to account for the bias of each node
%This generates a matrix where the rows represent a neuron the next layer
%and the columns are the weight attached to the neuron from the nodes of
%the previous layer.
W = zeros(l_next, 1 + l_prev);


epsilon_init = 0.12;
%rand samples from a uniform distribution and not a normal distribution
%This is known as Xavier Initialization
%A completely different implementation than what was thought in cs231n
%From cs231n I should be dividing by the sqrt(l_prev)
%The -epsilon_init is to shift the minimum value of the distribution to
%epsilion_init. epsilon_init can be seen as the range. That is (upper_bound
%- lower_bound). This determines the range of values
W = rand(l_next, 1 + l_prev) * 2 * epsilon_init - epsilon_init; %Use pemdas to evaluate this
end