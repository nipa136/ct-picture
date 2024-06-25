clear
n_obs = 170; % Amount of observations
gri = 16; % Side length for square grid
tic

A = zeros(n_obs, gri * gri); % Empty system matrix
% Array of observations in vector form (has to be a n_obs x 1 matrix)
b = [];

xs = []; % Start position of ray (both coordinates)
xe = []; % End position of ray (both coordinates)

% Forming vertical, horizontal and slightly diagonal rays
for z = 1:4
    for height = 0:(8 - 1)
       
        % Vertical rays
        if z == 1
            xs = [xs, [height; 0]];
            
            % Added term to height for when height is zero
            xe = [xe, [height + 0.00000000001; 8]];
        
        % Horizontal rays
        elseif z == 2
            xs = [xs, [0; height]];
            xe = [xe, [8; height]];
        
        % Slightly diagonal and vertical rays
        elseif z == 3
            xs = [xs, [height; 0]];
            xe = [xe, [height + 1; 8]];
        
        % Slightly diagonal and horizontal rays
        else
            xs = [xs, [0; height]];
            xe = [xe, [8; height + 1]];
        end
    end
end

startx = []; % Starting points of x and ending points of y for 45 
             % degree rightup diagonals
endx = [1:8-1]; % Starting points of y and ending points of x for 45 
                % degree rightup diagonals

% Forming beginning of startx and ending of endx
for h = 1:8
    startx = [startx, 0];
    endx = [endx, 8];
end

% Finishing startx
startx = [startx, 1:8-1];

% Forming starting coordinates and ending coordinates
starts = [startx; endx];
ends = [endx; startx];

% Adding the coordinates to xs and xe
for g = 1:length(starts)
    xs = [xs, starts(:, g)];
    xe = [xe, ends(:, g)];
end

% Forming starting and ending coordinates for 45 degree rightdown 
% diagonals
starts2 = [fliplr(startx); startx];
ends2 = [fliplr(endx); endx];

% Adding the coordinates to xs and xe
for g = 1:length(starts)
    xs = [xs, starts2(:, g)];
    xe = [xe, ends2(:, g)];
end

% Forming coordinates for the rest of the diagonals
for ending = 6:-1:1
    for i = 1:2
        for height = 0:ending
            
            % Vertical diagonal rays
            if i == 1
                startpos = [0; height];
                endpos = [8; height + (-ending + 8)];
            
            % Horizontal diagonal rays
            else
                startpos = [height; 0];
                endpos = [height + (-ending + 8); 8];
            end
            for s = 1:2
                
                % Reverse rays
                if s == 2
                    startpos(2) = 8 - startpos(2);
                    endpos(2) = 8 - endpos(2);
                end
                
                % Adding coordinates to xs and xe
                xs = [xs, startpos];
                xe = [xe, endpos];
            end
        end
    end
end

% Forming the system matrix
for ii = 1:n_obs
    
    % Initial and final coordinates taken from matrix that contains all
    % coordinates
    xi = xs(:, ii);
    xf = xe(:, ii);  

    % Forming each row of system matrix using the Siddon algorithm
    A(ii, :) = siddon_alg(xi, xf, gri);
end

% Tikhonov regularization
% Manually choosing alpha for Tikhonov regularization
alpha_opt = 1e-8;
x = tikhonov(A, b, alpha_opt);

% Reshaping to grid form
pic = reshape(x, gri, gri);

% Using a convolution function to reduce noise
pic = convolution(pic);

% Forming picture
pic(gri + 1, gri + 1) = 0;
h = pcolor(pic);
colormap('bone')

% Another way of forming the picture
% f1 = figure(1)
% tiledlayout
% imshow(imresize(pic, 20))
    
% Reformatting the picture
axis square
toc
