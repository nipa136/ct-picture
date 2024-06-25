clear
n_obs = 170; % Amount of observations
gri = 16; % Side length for square grid
tic

A = zeros(n_obs, gri * gri); % Empty system matrix
% Array of observations in vector form (has to be a n_obs x 1 matrix)
b = [0.199832; 0.271462; 0.394208; 0.273114; 0.357574; 0.494193; ...
     0.18006; 0.187619; 0; 0.694406; 0.366607; 0.424513; 0.0609391; ...
     0.0254791; 0.388627; 0.0689929; 0.619219; 0.352193; 0.605298; ...
     0.41685; 0.381233; 0.451805; 0.48598; 0.436119; 0; 0.977899; ...
     0.48598; 0.481898; 0.242192; 0.218438; 0.578023; 0.205996; ...
     0.190658; 0.20137; 0.13443; 0.858259; 0.555849; 0.457752; ...
     0.355777; 0.231036; 0.549292; 0.212197; 0.409246; 0.390484; ...
     0.151847; 0.168084; 0.131557; 0.0703415; 0.13443; 0.457752; ...
     0.712195; 0.434175; 0.494193; 0.255095; 0.184588; 0.609917; ...
     0.148923; 0.394208; 0.445894; 0.166597; 0.124409; 0.151847; ...
     0.664627; 0.372067; 0.714763; 0.41685; 0.420675; 0.281412; ...
     0.318768; 0.366607; 0.153312; 0.449831; 0.348621; 0.91944; ...
     0.496257; 0.614557; 0.424513; 0.293148; 0.56466; 0.341516; ...
     0.377556; 0.654895; 0.399821; 0.362984; 0.580268; 0.390484; ...
     0.350405; 0.455766; 0.311872; 0.506642; 0.964609; 0.596123; ...
     0.396075; 0.48598; 0.432235; 0.451805; 0.350405; 0.418761; ...
     0.370244; 0.311872; 0.551473; 1.07992; 0.598409; 0.519247; ...
     0.48598; 0.525609; 0.473784; 0.689381; 0.68189; 0.434175; ...
     0.348621; 0.323972; 0.445894; 0.506642; 1.01538; 0.34684; ...
     0.238992; 0.571319; 0.571319; 0.496257; 0.422592; 0.325713; ...
     0.430299; 0.76214; 0.496257; 0.479863; 0.288101; 0.494193; ...
     0.477833; 0.578023; 0.525609; 0.350405; 0.357574; 0.441973; ...
     0.411142; 0.638087; 0.141651; 0.209092; 0.226293; 0.390484; ...
     0.432235; 0.451805; 0.418761; 0.394208; 0.626253; 0.504556; ...
     0.461736; 0.269813; 0.392344; 0.432235; 0.455766; 0.540615; ...
     0.352193; 0.434175; 0.492133; 0.366607; 0.48598; 0.465736; ...
     0.532013; 0.498325; 0.477833; 0.483937; 0.34684; 0.584772; ...
     0.555849; 0.355777; 0.598409; 0.508731; 0.426438; 0.63097];

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