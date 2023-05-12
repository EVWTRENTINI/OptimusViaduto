function [ea,Ms1d]=ea_Ms1d_min(le,teta1,diam,Nsd,Ms1d)


%% Exentricidade acidental
ea=max([le/2*teta1 .015+.03*diam]);

%% Momento mínimo
Ms1d_min=Nsd*ea;

if Ms1d<Ms1d_min
    Ms1d=Ms1d_min;
end

end