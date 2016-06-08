function [] = printf(varargin)
% PRINTF Replacement for the C function printf().
%
%   PRINTF() Behaves as the C function printf().  It just does:
%       fprintf(1,varargin{:}));
fprintf(1,varargin{:});