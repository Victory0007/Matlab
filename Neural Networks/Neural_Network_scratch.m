%% 
% Loading the dataset
close all; clear;
load("data.mat");

%dataset is divide into X and y. X is 5000 examples by 400 features
% y is 5000 labels
%What I am not sure is how X and y is loaded when we just call
%load("data.mat")

m = size(X, 1); %This return 5000 
%Generate 5000 numbers randomly
rand_indices = randperm(m);
%Select only 100 of those values and 
sel = X(rand_indices(1:100), :); %First 100 random indices and all the columns

%Write a function to display the data you created (check out that github
%account)

%Defining the network architecture
%The input layer will have 400 neurons corresponding to the number of
%feature of the image. This is a 20 * 20 grey scale image
input_layer_size = size(X, 2);
num_labels = 10; %There are 10 unique classes hence 10 output neurons
%Matlab is one-indexed so to have 10 classes(0-9) we need 10 neurons and
%hence 0 has to be mapped to 10

layer_sizes = [input_layer_size, 40, num_labels];%There are 40 neurons in the hidden layer

%Creating a new variable y_new. I still dont know what this variable is
%doing
y_new = (1:10) == y; %This returns a 5000 * 10 matrix filled with 1 or 0(True or false) depending on if the
%elements of y match 1 to 10. This is like label encoding. Create the y_new that is a matrix with size of m*num_labels
%examples passed through the 10 different classifiers. The output
size(y)
%% 

%Weight Initialization
%A general array is storing layer_sizes -1 weight matrixes. We have
%layer_sizes-1 weight matrixes because the output layer doesnt have a
%weight matrix(There is no other layer to connect to from the output layer)
for i = 1:size(layer_sizes,2)-1
    %Each individual weight matrix must consist of (number of nodes of
    %current layer) by ( number of nodes of prev layer). The way this
    %function is collecting this function is not intuitive in any way
    initial_weights{i} = randInitializeWeights(layer_sizes(i), layer_sizes(i+1));
end

%Regularization term and learning rate
lambda = 1;
alpha = 1e-1;

%The number of epochs- Number of times it would go through the training
%example
max_iter = 1000;

%Creating arrays for the loss, precision metric and count of every
%minibatch(each minibatch has 25 examples)
loss = [];
count = [];
precisionT = [];
weights = initial_weights;

%Creating a new figure window for my plot. This is useful to choose the
%figure window you are plotting in
figure;
%YGrid = "on" enables the grid line of the y axis. same for xgrid too
ax1 = subplot(2,1,1); ax1.YGrid="on"; ax1.XGrid = "on";
ax2 = subplot(2,1,2); ax2.YGrid="on"; ax2.XGrid = "on";

%tic is used to start a timer in matlab. toc stops the timer and returns
%ths elapsed time
tic;

for i = 1:max_iter
    % J is the current loss after the ith trainig example
    [J, weights] = train(weights, layer_sizes, X, y_new, lambda,  alpha);
    % Its plotting after every 25th iteration to make the plot easy to
    % understand
    if (mod(i, 25) == 0)
        loss = [loss;J];
        count = [count;i];
        plot(ax1, count, loss, "LineWidth",2); ax1.YGrid = 'on'; ax1.XGrid="on"; %Why turning on the gridlines twice?
        title(ax1, "loss evolution/plot");
        xlabel(ax1,"iterations");
        ylabel(ax1, "Loss function"); 
        pred = predict(weights, X, layer_sizes);
        %This is a weird way to calculate the precision metric tho. I feel
        %its more of the accuracy metric
        precision = mean(double(pred==y)) * 100;
        precisionT = [precisionT; precision];
        plot(ax2, count, precisionT, "LineWidth", 2); ax2.YGrid = 'on'; ax2.XGrid="on";
        title(ax2, "Accuracy evolution/plot");
        xlabel(ax2, "iterations");
        ylabel("accuracy values");
        %Try and write this using the fprintf function as soon as you know
        %what the output looks like
        %disp(['Iteration #: ' num2str(i) ' / ' num2str(maxIter) ' | Loss J: ' num2str(J) ' | Accuracy: ' num2str(precision)]);
        fprintf('Iteration #: %d / %d | Loss J: %f | Accuracy: %f\n', i, max_iter, J, precision);
        %drawnow is a MATLAB function that forces the immediate rendering and updating of the figures and user interface (UI).
        drawnow();
    end
end
%Stores time it took for the for loop to run. finish time
finT = toc;
disp(['Time spent on training the net: ' num2str(finT) ' seconds' ]);
%My attempt using the fprintf function. Try running it tho
%fprintf("Time spent on training the net: %d seconds", finT)

%%
% Testing the model on one example in the training set. There is no
%validation set or test set. We cant truly know how well the model is doing
i = randi(length(y));
pred = predict(weights, X(i,:), layer_sizes);
disp(pred)
%Display the selected image
imshow(reshape(X(i,:), 20, 20));
%Displaying predicted result
fprintf("True class %d | predicted class %d\n", y(i), pred);




