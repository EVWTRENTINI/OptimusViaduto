function [CIV] = calc_CIV(Vlong)
%Coeficiente de impacto vertical
        CIV=(1+1.06*(20/(Vlong+50)));
        if CIV>1.35
            CIV=1.35;
        end
end

