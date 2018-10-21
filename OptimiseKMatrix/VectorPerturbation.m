function [VecPerturbed,dp] = VectorPerturbation(Vec,k)

% Check k range
if (k<1 || k>3) || floor(k) ~= k % error if out of range or not an integer
    error('k is out of range or not an integer')
end

VecPerturbed = Vec;

Target = Vec(k,1);
dp = Generatedp(Target);
VecPerturbed(k,1) = Vec(k,1)+dp;


if dp == 0
    error('dp has to be non-zero') % check
end


end