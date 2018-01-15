function [ x ] = Binaray_to_Dec( L,information )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=0;
N=length(information);
for n=1:1:N
    x1=information(1,n)*2^(L-n);
    x=x+x1;
end
end

