function [ xn ] = CCSK( S,Nc,L,A,m )
       x=0;
       for n=0:1:Nc-1
        for k=0:1:2^L-1 
            x=A(1,k+1)*exp(1j*m(1,k+1))*exp(-1j*2*pi*S*k/Nc)*exp(1j*2*pi*k*n/Nc);
            xn(1,n+1)=x+x;
        end
           xn(1,n+1)=xn(1,n+1)/sqrt(Nc);
       end 
end

