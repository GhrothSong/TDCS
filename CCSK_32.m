clear;
warning off;

%%                  system parameter
MVec = [32];% M-ary CCSK
SymNum = 4;% bit number per transmission
errLimit = 500;% error threshold to stop simulation
esnoVec = [0:7];% snr vector
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  simulation parameter
Len = length(esnoVec);
SimLen = length(MVec);
IterNum = 10000;% simulation times
BER = zeros(SimLen,Len);
%%                  CCSK »ù±¾Âë×Ö
stage = 10; % number of stages
ptap1 = [1 3 5 7 9]; % position of taps for 1st
regi1 = [1 1 1 0 0 1 0 1 0 1]; % initial value of register for 1st

m1   = mseq(stage,ptap1,regi1);
% bipolar conversion
        CCSK_seq_set = 1 - 2*m1;
%%                  simulation
for m_index = 1:SimLen
    M = MVec(m_index);
    k = log2(M);
    BitNum = k*SymNum;   
    % CCSK FMW
    b = [];
    b = zeros(M,M);
    b(1,:) = CCSK_seq_set(1,1:M);
    % CCSK
    for kk = 2:M
        b(kk,:) = [b(kk-1,2:end) b(kk-1,1)];
    end
    
    for sim_index = 1:Len
        % real signal with snr compensation
        snr = esnoVec(sim_index)-10*log10(M/k);
        
        % initial the counter
        errorcnt = 0;
        loops = 0;
        while(errorcnt < errLimit && loops < IterNum)
            % random bit sequency
            Source = randi([0,1],1,BitNum);
            % CCSK 
            codeword_tx = [];
            Sym = [];
            for sym_index = 1:SymNum
                % bit codeword
                start_index = (sym_index-1)*k+1;
                stop_index = sym_index*k;
                bitSnap = Source(start_index:stop_index);
                % codeword mapping
                codeword_index = 0;
                for bit_index = 1:k
                    codeword_index = codeword_index + bitSnap(bit_index)*2^(k-bit_index);
                end
                Sym(:,sym_index) = b(codeword_index+1,:);
                % save the codeword
                codeword_tx(sym_index) = codeword_index;
            end
            % pass through the channel
            H = randn(1,SymNum) + 1i*randn(1,SymNum);
            H = H./abs(H);
            H_mat = repmat(H,M,1);
            Sym = Sym.*H_mat;
            % awgn
            Sym_rec = awgn(Sym,snr);
            % CCSK demodulation
            codeword_dec = [];
            for sym_index = 1:SymNum
                Sym_snap = Sym_rec(:,sym_index);
                % coherent
                Sym_snap = Sym_snap.*conj(H_mat(:,sym_index));
                % fft
                sym_fft = fft(Sym_snap);
                % correlation
                sym_fft_correlation = sym_fft.*fft(b(1,:))';
                % ifft
                sym_rec = ifft(sym_fft_correlation);
                % max magnitude
                magnitude = real(sym_rec);
                [value,idx] = max(magnitude);
                % decision
                codeword_dec(sym_index) = M + 1-idx;
                codeword_dec(find(codeword_dec==M)) = 0;
            end
            % ber
            [err_cnt,ber] = biterr(codeword_dec,codeword_tx,k);
            % update the error bit number                       
            errorcnt = errorcnt + err_cnt;
            % update the iteration
            loops = loops + 1;
            % ber
            BER(m_index,sim_index) = BER(m_index,sim_index) + ber;
        end
        BER(m_index,sim_index) = BER(m_index,sim_index)/loops;
    end  % loop for snr
    
end  % loop for M-ary
%%                  plot the result
figure(1);
semilogy(esnoVec,BER(1,:),'b-o','linewidth',2);hold on;
xlabel('SNR(dB)');
ylabel('BER');
grid on;
title('CCSK BER performance of a TDCS using CSK modulation');