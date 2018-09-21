function [Parameters] = MNFbyDGParameters();

%%% NUMBER OF COMPONENTS IN REDUCED DIM REPRESENTATION %%%
Parameters.NComps    = 3;
%%% CHOICES: 1 <= NComps <= Number of Bands

%%% NOISE MASK FOR ESTIMATING NOISE %%%
Parameters.NoiseMask = [-0.5, 1, -0.5];
%%% CHOICES: 
%%%      There are infinitely many.  The following 4 lines of code represent
%%%      a generalization of the one above:
%%%
%%%      Ws                  = 2*K+1;
%%%      Coeff               = -(1/((Ws*Ws) - 1));
%%%      NoiseMask           = Coeff*ones(Ws, Ws); 
%%%      NoiseMask(K+1, K+1) = 1;

Parameters.Method    = 'ConstructEig';
%%% CHOICES of Method ((1) appears to be most stable):
%%%   (1) 'ConstructEig' 
%%%       Eigenvalues/vectors computed directly from derivation       %%%
%%%   (2) 'DirectEig'
%%%       Eigenvalues/vectors computed using Ordinary   Eigen Problem %%%
%%%   (3) 'GenEig'
%%%       Eigenvalues/vectors computed using Generalized Eigen Problem %%%

%%% STABILIZE EIGEN CALCULATIONS USING DIAGONAL LOADING.  %%%
%%% IF DIAGLOAD > 1, THEN Cx <- Cx +  DIAGLOAD*IdentityMatrix%%%
Parameters.DIAGLOAD = 2;

%%% MAKE THE TRANSFORM HAVE MEAN ZERO %%%
Parameters.ZEROMEAN = false;

