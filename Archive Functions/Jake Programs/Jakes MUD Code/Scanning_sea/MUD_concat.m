function [B1,t,B2,L,B3]=MUD_concat(Ew,tw,delta_t,lam)
c=3e8;
N_pulses=size(Ew,2);
Ht=ones(size(Ew(:,1)));
Unk_of_t=fftc(Ew);
[Valid_unk,Valid_H,begin1,end1,x1]=temporal_filter(Unk_of_t,tw,N_pulses,Ht);
% 9.25 Calibrating each time window:
%[Valid_unk]=calibrate1(Valid_unk);
% 9.5 Concatenating the data with a weighted sums routine:
%[B1,t,B2,L]=new_weight2((Unk_of_t),tw,delta_t,Ht',F);
[B1,t,B2,L,B3]=new_weight4((flipud(Valid_unk)),tw,delta_t,Valid_H,lam,c,x1);