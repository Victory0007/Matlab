function [encodedData, huffmanTree] = huffmanEncoding(data)

    % Step 1: Calculate symbol frequencies
    %Gets every unique element and arranges it in ascending order. use the
    %"stable" keyword to  keep the original order
    symbols = unique(data);
    % Gets the counts of every unqiue entry in the array. Takes arguments
    % "data" and "the bin edges". the last bin edge is considered exclusive
    % hence max(symbols)+1 is added to include it.
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
    queue = [queue, node];
    queue = minHeapify(queue, numel(queue));
end

function queue = minHeapify(queue, index)
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
