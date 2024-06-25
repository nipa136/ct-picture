function x = tikhonov(A, b, alpha)
    % Calculating grid size by taking the square root of the number of
    % pixels
    gri = sqrt(size(A, 2));
    
    % Updating the system matrix to include an identity matrix of the same
    % size, scaled by the parameter alpha, to regularize the solution
    A = [A; alpha * eye(gri .^ 2)];
    
    % Updating the measurements to match the size of the system matrix
    b = [b; zeros(gri .^ 2, 1)];
    
    % Calculating the pixel values by using the native inverse problem
    % solver
    x = sparse(A) \ b;
end