function hypervolume = calc_hypervolume(pop, n_archive, min_or_max, upper_bound)
ct = 0;
for i = 1:n_archive
    if pop{i}.violations == 0
        ct = ct + 1;
    end
end

fhv = zeros(ct,length(min_or_max));
ct = 0;
for i = 1:n_archive
    if pop{i}.violations == 0
        ct = ct + 1;
        fhv(ct,:) = pop{i}.fitness;
    end
end

%[10000000 10000 3000]
fhv=fhv.*(min_or_max);
[hypervolume] = lebesgue_measure(transpose(fhv), transpose(upper_bound));