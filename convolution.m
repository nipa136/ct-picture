function pic2 = convolution(pic)
    % Extracting the grid size from the dimensions of the picture
    grid = size(pic);
    
    % Forming 1 pixel wide buffer space of zeros outside the picture in 
    % order to make iterating easier
    pic = [zeros(size(pic,1),1), pic];
    pic = [zeros(1,size(pic,2)); pic];
    pic(grid+2,grid+2)=0;
    
    % Defining the output matrix of size grid
    pic2 = zeros(grid);
    
    % Iterating through the pixels excluding buffers
    for i = 2:grid + 1
        for j = 2:grid + 1
            % Calculating the output pixel by summing the values of the 9
            % pixels surrounding it, including the pixel itself
            pic2(j-1,i-1) = sum(pic(j-1,i-1:i+1)) + ...
                sum(pic(j,i-1:i+1)) + ...
                sum(pic(j+1,i-1:i+1));
        end
    end
end