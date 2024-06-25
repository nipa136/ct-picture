function A = siddon_alg(xi, xf, gri)   
    startpos = xi; % Initial position of ray (both coordinates)
    endpos = xf; % Final position of ray (both coordinates)
    e = 1e-3; % Error margin
    d = 8 / gri; % Pixel size (length of side)
    % Slope of ray
    k = ((endpos(2) - startpos(2)) / (endpos(1) - startpos(1))); 
    X = []; % Array of lengths of paths inside pixels
    C = []; % Vector including indexed pixels 
    prev = 0; % Accrued lengths of paths inside pixels
    x = d - rem(startpos(1), d); % Indicating amount that x needs to be
                                 % moved when changing pixels
    y = d - rem(startpos(2), d); % Indicating amount that y needs to be 
                                 % moved when changing pixels
        % Loop until the ray's path has ended
        while x <= endpos(1) - startpos(1) + e || y <= endpos(2)...
                - startpos(2) + e
            % Calculating travel lengths in x and y directions
            hx = sqrt(x ^ 2 + (x * k) ^ 2);
            hy = sqrt(y ^ 2 + (y / k) ^ 2);
            % Remainder needed indexing pixels
            re = rem(1 / d * gri * (x + startpos(1) - d) + e, gri);
            % Differentiating between left-right and right-left rays
            if startpos(2) > endpos(2)
                h = -1 / d * y + 1;
            else
                h = 1 / d * y;
            end
            % Indexing the pixel
            C = [C, round(1 / d * gri * (x + startpos(1) - d) - re ...
                + floor(h + 1 / d * startpos(2) + e))];
            % Determining if the ray hits a hprizontal or vertical "wall"
                % If the ray hits a vertical wall first
                if hy > hx 
                    % Adding length to vector
                    X = [X, hx - prev]; 
                    prev = hx;
                    x = x + d;
                % If the ray hits a horizontal wall first
                elseif hx > hy
                    % Adding length to vector
                    X = [X, hy - prev];
                    prev = hy;
                    y = y + d;
                % If the ray hits both walls at the same time
                else
                    % Adding length to vector
                    X = [X, hx - prev];
                    prev = hx;
                    y = y + d;
                    x = x + d;
                end
        end
    % Reformatting lentgh and pixel vectors into a single matrix
    Q=[C; X];
    A = []; % Empty matrix for the final system matrix
    % Forming a vector the kength of the amount of pixels in grid
    for j = 1:(gri * gri)
        o = 0;
            % Checking each pixel to see if the pixel is included in C
            % If the pixel is included in C, then the traveled path length
            % is added to the current entry of the vector
            for k = 1:length(C)
                if C(k) == j
                    A = [A, Q(2,k)];
                    o = 1;
                end
            end
            % If the pixel isn't included in C, its traveled path length 
            % is zero
            if o == 0
                A = [A, 0];
            end
    end
end    