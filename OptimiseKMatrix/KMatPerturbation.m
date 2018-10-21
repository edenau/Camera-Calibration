function [KMatPerturbed,dp] = KMatPerturbation(KMatrix,k)

% Check k range
if (k<1 || k>5) || floor(k) ~= k % error if out of range or not an integer
    error('k is out of range or not an integer')
end

KMatPerturbed = KMatrix;
dp = 0;

if k == 1
    Target = KMatPerturbed(1,1);
    dp = Generatedp(Target);
    KMatPerturbed(1,1) = Target+dp;
elseif k == 2
    Target = KMatPerturbed(1,2);
    dp = Generatedp(Target);
    KMatPerturbed(1,2) = Target+dp;
elseif k == 3
    Target = KMatPerturbed(1,3);
    dp = Generatedp(Target);
    KMatPerturbed(1,3) = Target+dp;
elseif k == 4
    Target = KMatPerturbed(2,2);
    dp = Generatedp(Target);
    KMatPerturbed(2,2) = Target+dp;
elseif k == 5
    Target = KMatPerturbed(2,3);
    dp = Generatedp(Target);
    KMatPerturbed(2,3) = Target+dp;
end

if dp == 0
    error('dp has to be non-zero') % check
end

end