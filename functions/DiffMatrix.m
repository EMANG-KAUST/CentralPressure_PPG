function D = DiffMatrix(M)
%DIFFMATRIX this function computes the second order differentiation matrix
%for SCSA using the fourier spectral method

D = zeros(M, M);
delta = 2*pi/M;
dt = 1;


for i=1:M
    for j=1:M
        if mod(M, 2) == 0
            if i == j
                D(i, j) = - pi^2/(3*delta^2) - 1/6;
            else 
                D(i, j) = -(-1)^(i-j)*.5*csc((i-j)*delta/2)^2;
            end
        else
            if i == j
                D(i, j) = - pi^2/(3*delta^2) - 1/12;
            else 
                D(i, j) = -(-1)^(i-j)*.5*csc((i-j)*delta/2)*cot((i-j)*delta/2);
            end
        end
    end
end

D = ((delta/dt)^2).*D;
end

