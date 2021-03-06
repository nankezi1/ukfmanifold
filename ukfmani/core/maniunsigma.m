% recomposes the sigma points
%
% Input:
%  model 
%  sigma: Chiz = [N,G]
%  sigmainfo: the weights
%  the delta of input sigma: vChi (see manisigma)
%
% Emanuele Ruffaldi 2017 @ SSSA
function [mz,Czz,Cxz] = maniunsigma(model,Chiz,sigmainfo,vChi,steps)

if nargin < 5
    steps = 20;
end
% estimates the mean in a weighted way
N=size(Chiz,1);

v = zeros(size(Chiz,1),model.alg); % preallocated
mz = Chiz(1,:); % COLUMN vector

% for lie group we make a little optimization using inv
if isfield(model,'log') && isfield(model,'fastinv')
    % estimate mean but weighted of WM
    for k=1:steps
        imz = model.inv(mz);
        for i=1:N
            v(i,:) = model.log(model.prod(Chiz(i,:),imz));
        end
        % update mz by weighted v
        mz = model.prod(model.exp(v'*sigmainfo.WM),mz);
    end
    
    % update v for computing covariance, skips the log
    imz = model.inv(mz);
    for i=1:N
        v(i,:) = model.log(model.prod(Chiz(i,:),imz));
    end
else    
    % estimate mean but weighted of WM
    for k=1:steps
        for i=1:N
            % same as: se3_logdelta but with igk once
            v(i,:) = model.delta(Chiz(i,:),mz);
        end
        mz = model.step(mz,(sigmainfo.WM'*v)); % [A,S] [S,1]
    end
    
    % update v for computing covariance
    for i=1:N
        v(i,:) = model.delta(Chiz(i,:),mz);
    end
end

Czz = v'*sigmainfo.WC*v; % covariance ZZ - NOTE THAT WE USE DIFFERENTIAL

if nargin >= 4 && nargout > 2
    Cxz = vChi'*sigmainfo.WC*v; % cross XZ - NOTE THAT WE USE DIFFERENTIAL
end