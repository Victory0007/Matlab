function g = sigmoidGradient(z)
    g = zeros(size(z));
    s = sigmoid(z);
    g = s .* (1-s);
end