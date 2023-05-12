function limites_benr = rearranja_limites_benr(limites_benr,b1,b2,b3)
min_b1_b3 = min([b1 b3]);

if min_b1_b3 < b2
    limites_benr.min = b2;
    limites_benr.max = b2;
else
    if limites_benr.min < b2
        limites_benr.min = b2;
    end

    if limites_benr.max < b2
        limites_benr.max = b2;
    end

    if limites_benr.max > min_b1_b3
        limites_benr.max = min_b1_b3;
    end

    if limites_benr.min > min_b1_b3
        limites_benr.min = min_b1_b3;
    end
end

end