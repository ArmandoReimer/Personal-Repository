close all force;
latticesize = 7;
latticesize = latticesize + 1;
lattices = {};

for k = 1:100000
    lattice = zeros(latticesize, latticesize);
    i=1;
    j=1;
    lattice(i, j)=1;
    while ~lattice(latticesize, latticesize)
        d = randi(2)-1;
        if d && j~=latticesize
            lattice(i, j+1) = 1;
            j = j+1;
        elseif i~=latticesize
            lattice(i+1, j) = 1;
            i = i+1;
        end
    end
    l = length(lattices);
    flag = 0;
    for m = 1:l
        if isequal(lattice, lattices{m})
            flag = 1;
        end
    end
    if ~flag
        lattices{l+1} = lattice;
    end    
end
display(length(lattices));