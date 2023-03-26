% N1, N2 and U are vectors of given length N
function [N1, N2, U] = generate_signals(N)
  N = int32(N);
  N1 = random('Normal',0,1,N,1);
  N2 = random('Normal',2,2,N,1);
  U = random('Uniform',1,3,N,1);
end