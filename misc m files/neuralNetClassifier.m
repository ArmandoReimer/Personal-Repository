function neuralNetClassifier(image)

    %plan. this will (to start) be a traditional 3 layer neural network
    %without frills. it will take small subsets of images(10x10 or 20x20
   % and maybe with a 3rd dimension) and decide if
    %they have spots. then it will put everything together to get a
    %probability map for the original image. maybe 3 hidden nodes and
    %2 output nodes.
    
    image = double(image);
    len = size(image, 1);
    wid = size(image, 2);
    area = len*wid;
    
    in = reshape(image, [area 1])';
    out = zeros(area,1)
    h1 = zeros(area,1)
    h1weights = zeros(area, 1)';
    oweights = zeros(hweights, 1)';
    
    %set hidden layer
    h1(1) = in(1).*h1weights(1);
    h1(1) = 1 ./ (1 + exp(-h1(1)));
    
    %set output layer
    out(1) = hiddens(1).*oweights(1);
    out(1) = 1 ./ (1 + exp(-out(1)));
    
    %wrap it up
    decisions(1) = out(1) > .5
    certainty(1) = out(1)
    imshow(decisions(1), []);
    
    
end