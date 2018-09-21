 function [DsX, DsWvs] = SpectralDwnSmp(X, Wvs, DwnSmpRate, varargin)
%function [DsX, DsWvs] = SpectralDwnSmp(X, Wvs, DwnSmpRate, varargin)
%
%%% FUNCTION TO REDUCE SPECTRAL DIM BY SMOOTHING & DOWNSAMPLING %%% 
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS:
%%%         X:           NROWS X NCOLS X B HYPERSPECTRAL CUBE
%%%         Wvs:         B WAVELENGTHS AT WHICH SPECTRA IN X WERE MEASURED
%%%         DwnSmpRate:  DOWNSAMPLING RATE, MUST BE ODD (3, 5, 7, ETC)
%%%         varargin{3}: CONVOLUTION MASK TO SMOOTH BEFORE DOWNSAMPLING
%%%                      MUST HAVE SIZE (1,1,DwnSmpRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUTS:
%%%         DsX: NROWS X NCOLS X APPROXIMATELY B/DwnSmpRate of DOWNSAMPLED SPECTRA
%%%              3RD DIM  APPROXIMATE BECAUSE B/DwnSmpRate MAY NOT BE INTEGER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% AUTHOR: Darth Gader
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% MAKE SURE DwnSmpRate IS ODD %%%
if((mod(DwnSmpRate, 2)) & (DwnSmpRate > 2))
    
    %%% IF > 3 ARGS, THE 4TH IS A USER-DEFINED CONVOLUTION MASK %%%
    if(nargin > 3)
        ConvMask = varargin{1};
        
        %%% ERROR CHECKING ON ConvMask CHARACTERISTICS %%%
        SzMask   = size(ConvMask)
        NumDims  = length(SzMask)
        if((NumDims < 3) | (NumDims > 3))
            error('ConvMask should be 3-dimensional')
        elseif(SzMask(1)*SzMask(2) ~= 1)
            error('ConvMask is formatted incorrectly');
        elseif (SzMask(3) ~= DwnSmpRate)
            error('ConvMask Size does not match Downsampling Rate');
        end
    else
        %%% DEFINE DEFAULT ConvMask TO DO LOCAL AVERAGE %%%
        ConvMask = ones(1,1,DwnSmpRate)/DwnSmpRate;
    end
    
    %%% CALCULATE CONVOLUTION %%%
    DsX = convn(X, ConvMask, 'same');
    
    %%% ADJUST FOR ERRORS AT EDGES OF IMAGE
    HalfWindSz                        = floor(DwnSmpRate/2);
    DsX(:, :, 1:HalfWindSz)           = X(:, :, 1:HalfWindSz);
    DsX(:, :, (end-HalfWindSz+1):end) = X(:, :, (end-HalfWindSz+1):end);
    
    %%% PICK EVERY nth WAVELENGTH %%%
    DsX   = DsX(:, :, DwnSmpRate:DwnSmpRate:end);
    DsWvs = Wvs(DwnSmpRate:DwnSmpRate:end);

else
    error('The downsampling rate must be odd...')
end