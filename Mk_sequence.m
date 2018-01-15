function [ m ] = Mk_sequence(L,M)
for N=1:1:2^L
    if N<=128
        a(1,N)=(N-1)*pi/2^L/2;
        aseq(1,N)=a(1,N)*M(1,N);
    else 
        a(1,N)=((2^L)+1-N)*pi/(2^L/2);
        aseq(1,N)=a(1,N)*M(1,N);
    end
end
m=M.*aseq;
end

