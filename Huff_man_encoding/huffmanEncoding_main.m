function [encodedData, huffmanTree] = huffmanEncoding(data)

    % Step 1: Calculate symbol frequencies
    symbols = unique(data, 'stable');
    freq = histcounts(data, [symbols, max(symbols)+1]);
    
    % Step 2: Create priority queue (min-heap)
    queue = createMinHeap();
    
    % Step 3: Create leaf nodes and insert into priority queue
    for i = 1:numel(symbols)
        node = createNode(freq(i), symbols(i), [], []);
        queue = insertNode(queue, node);
    end
    
    % Step 4: Build Huffman tree
    while numel(queue) > 1
        node1 = extractMin(queue);
        node2 = extractMin(queue);
        mergedNode = createNode(node1.freq + node2.freq, [], node1, node2);
        queue = insertNode(queue, mergedNode);
    end
    
    % Step 5: Root of Huffman tree
    huffmanTree = extractMin(queue);
    
    % Step 6: Generate binary codes
    codes = generateCode(huffmanTree);
    
    % Step 7: Create lookup table
    lookupTable = createLookupTable(codes);
    
    % Step 8: Encode the input data
    encodedData = encodeData(data, lookupTable);
    
end

function queue = createMinHeap()
    queue = [];
end

function node = createNode(freq, symbol, leftChild, rightChild)
    node.freq = freq;
    node.symbol = symbol;
    node.left = leftChild;
    node.right = rightChild;
end

function queue = insertNode(queue, node)
%This a node object. So it doesn't just concatenate it.
    queue = [queue, node];
    %numel(queue) indicates the index of the element to be considered.
    %where the new element was entered.
    queue = minHeapify(queue, numel(queue));
end

function queue = minHeapify(queue, index)
%floor rounds towards negative infinity
%This gets the parent of the new element just added
%The function is recursive because the number added to the min heap could
%be smaller than its parent and the parent of its parent and so on. so we
%have to keep checking until this condition is met.
%The minheap property need the index of the element to be checked
    parent = floor(index / 2);
    if parent >= 1
        if queue(index).freq < queue(parent).freq
            temp = queue(index);
            queue(index) = queue(parent);
            queue(parent) = temp;
            queue = minHeapify(queue, parent);
        end
    end
end

function node = extractMin(queue)
%The first element is always the first element. collect it and heapify to
%maintain heap property
    node = queue(1);
    queue(1) = queue(end);
    queue(end) = [];
    queue = minHeapify(queue, 1);
end

function codes = generateCodes(node, currentCode, codes)
    if isempty(node.left) && isempty(node.right)
        codes{node.symbol} = currentCode;
    else
        codes = generateCodes(node.left, [currentCode, 0], codes);
        codes = generateCodes(node.right, [currentCode, 1], codes);
    end
end

function codes = generateCode(huffmanTree)
% I am guessing 256 characters adequately represents the unique characters
% we need
    codes = generateCodes(huffmanTree, [], cell(1, 256));
end

function lookupTable = createLookupTable(codes)
    lookupTable = cell(256, 2);
    for i = 1:256
        if ~isempty(codes{i})
            lookupTable{i, 1} = i;
            lookupTable{i, 2} = codes{i};
        end
    end
    lookupTable(all(cellfun(@isempty, lookupTable), 2), :) = [];
end

function encodedData = encodeData(data, lookupTable)
    encodedData = '';
    for i = 1:numel(data)
        symbol = data(i);
        code = lookupTable{symbol, 2};
        encodedData = [encodedData, code];
    end
end

% Sample usage:
%data = [1, 1, 2, 3, 3, 3, 4, 4, 4, 4];  % Example input data
%[encodedData, huffmanTree] = huffmanEncoding(data);
%disp(encodedData);
%disp(huffmanTree);
