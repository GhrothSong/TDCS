function[mseq]=M_sequence_generator(fbconnection) 
n=length(fbconnection);
b=(2^n)-1;
x=round(1+rand(1)*(b-1));
N=2^n-1;  
register=[zeros(1,n-1) 1];  %Initial state of the Shift Register
mseq(1)=register(n);        %M-sequence output first symbol 
for i=2:N      
newregister(1)=mod(sum(fbconnection.*register),2);     
for j=2:n          
newregister(j)=register(j-1);     
end
register=newregister;     
mseq(i)=register(n); 
end
mseq=[mseq mseq(x)];
end

