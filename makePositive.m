% positive value manifold
%
% http://www.ams.stonybrook.edu/~jias/AAAI17_camera_ready.pdf
% http://proceedings.mlr.press/v37/huanga15.pdf
%
% deltaS(A,B) = log det((A+B)/2) - 1/2 log det(AB)
%   log det((A+B)/2)/sqrt(det(AB)) = log ((A+B)/2/sqrt(AB))
%   GIVEN A and delta how to step it?
%       exp(d) =  (A+B)/2/sqrt(AB)
%
% From manopt:
% exponential
%   Y = symm(X*real(expm(X\(t*eta))));
% logarithm:
%   H = symm(X*real(logm(X\Y)));
% eta = egrad2rgrad(X, eta)
%       eta = X*symm(eta)*X;
% tangent2ambient = @(X, eta) eta;
% proj = @(X, eta) symm(eta);
function m = makePositive(n)ì