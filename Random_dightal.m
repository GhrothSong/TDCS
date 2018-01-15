 function[bits] = Random_dightal(numbits)
 %%%%%%%%%%%%%%numbits是要产生的比特数；bits是二进制序列
         bits=randn(1,numbits)<0.5;
end

