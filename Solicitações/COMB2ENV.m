function ENV = COMB2ENV(ENV,PRECOMB,QaMcMM,Mcc,iC,ncont,CEP,CEPn,nb,tot_ponto)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



if ncont>0%caso tenha carga móvel na combinação
    PRECOMB2_Nx=zeros(max(tot_ponto),nb,ncont,'single');
    PRECOMB2_Vy=zeros(max(tot_ponto),nb,ncont,'single');
    PRECOMB2_Vz=zeros(max(tot_ponto),nb,ncont,'single');
    PRECOMB2_Tx=zeros(max(tot_ponto),nb,ncont,'single');
    PRECOMB2_My=zeros(max(tot_ponto),nb,ncont,'single');
    PRECOMB2_Mz=zeros(max(tot_ponto),nb,ncont,'single');
    
    for i=1:ncont
        PRECOMB2_Nx(:,:,i)=PRECOMB.Nx+QaMcMM(Mcc(iC,2)).Nx(:,:,i);
        PRECOMB2_Vy(:,:,i)=PRECOMB.Vy+QaMcMM(Mcc(iC,2)).Vy(:,:,i);
        PRECOMB2_Vz(:,:,i)=PRECOMB.Vz+QaMcMM(Mcc(iC,2)).Vz(:,:,i);
        PRECOMB2_Tx(:,:,i)=PRECOMB.Tx+QaMcMM(Mcc(iC,2)).Tx(:,:,i);
        PRECOMB2_My(:,:,i)=PRECOMB.My+QaMcMM(Mcc(iC,2)).My(:,:,i);
        PRECOMB2_Mz(:,:,i)=PRECOMB.Mz+QaMcMM(Mcc(iC,2)).Mz(:,:,i);
    end
else%caso não tenha carga móvel na combinação
    PRECOMB2_Nx=PRECOMB.Nx;
    PRECOMB2_Vy=PRECOMB.Vy;
    PRECOMB2_Vz=PRECOMB.Vz;
    PRECOMB2_Tx=PRECOMB.Tx;
    PRECOMB2_My=PRECOMB.My;
    PRECOMB2_Mz=PRECOMB.Mz;
end

[~,~,npre]=size(PRECOMB2_Nx);


if not(Mcc(iC,5)==0)
    for dir=[1 2]
        for i=1:npre
            for j=1:CEPn
                switch dir
                    case 1
                        COMB_Nx=PRECOMB2_Nx(:,:,i)+CEP.Nx(:,:,j);
                        COMB_Vy=PRECOMB2_Vy(:,:,i)+CEP.Vy(:,:,j);
                        COMB_Vz=PRECOMB2_Vz(:,:,i)+CEP.Vz(:,:,j);
                        COMB_Tx=PRECOMB2_Tx(:,:,i)+CEP.Tx(:,:,j);
                        COMB_My=PRECOMB2_My(:,:,i)+CEP.My(:,:,j);
                        COMB_Mz=PRECOMB2_Mz(:,:,i)+CEP.Mz(:,:,j);
                    case 2
                        COMB_Nx=PRECOMB2_Nx(:,:,i)-CEP.Nx(:,:,j);
                        COMB_Vy=PRECOMB2_Vy(:,:,i)-CEP.Vy(:,:,j);
                        COMB_Vz=PRECOMB2_Vz(:,:,i)-CEP.Vz(:,:,j);
                        COMB_Tx=PRECOMB2_Tx(:,:,i)-CEP.Tx(:,:,j);
                        COMB_My=PRECOMB2_My(:,:,i)-CEP.My(:,:,j);
                        COMB_Mz=PRECOMB2_Mz(:,:,i)-CEP.Mz(:,:,j);
                end
                
                
                
                COMB_max_Nx=max(COMB_Nx,[],3);
                COMB_max_Vy=max(COMB_Vy,[],3);
                COMB_max_Vz=max(COMB_Vz,[],3);
                COMB_max_Tx=max(COMB_Tx,[],3);
                COMB_max_My=max(COMB_My,[],3);
                COMB_max_Mz=max(COMB_Mz,[],3);
                
                COMB_min_Nx=min(COMB_Nx,[],3);
                COMB_min_Vy=min(COMB_Vy,[],3);
                COMB_min_Vz=min(COMB_Vz,[],3);
                COMB_min_Tx=min(COMB_Tx,[],3);
                COMB_min_My=min(COMB_My,[],3);
                COMB_min_Mz=min(COMB_Mz,[],3);
                
                
                
                for n=1:nb
                    for p=1:tot_ponto(n)
                        if ENV.MAX.Nx(p,n)<COMB_max_Nx(p,n)
                            ENV.MAX.Nx(p,n)=COMB_max_Nx(p,n);
                        end
                        if ENV.MIN.Nx(p,n)>COMB_min_Nx(p,n)
                            ENV.MIN.Nx(p,n)=COMB_min_Nx(p,n);
                        end
                        if ENV.MAX.Vy(p,n)<COMB_max_Vy(p,n)
                            ENV.MAX.Vy(p,n)=COMB_max_Vy(p,n);
                        end
                        if ENV.MIN.Vy(p,n)>COMB_min_Vy(p,n)
                            ENV.MIN.Vy(p,n)=COMB_min_Vy(p,n);
                        end
                        if ENV.MAX.Vz(p,n)<COMB_max_Vz(p,n)
                            ENV.MAX.Vz(p,n)=COMB_max_Vz(p,n);
                        end
                        if ENV.MIN.Vz(p,n)>COMB_min_Vz(p,n)
                            ENV.MIN.Vz(p,n)=COMB_min_Vz(p,n);
                        end
                        if ENV.MAX.Tx(p,n)<COMB_max_Tx(p,n)
                            ENV.MAX.Tx(p,n)=COMB_max_Tx(p,n);
                        end
                        if ENV.MIN.Tx(p,n)>COMB_min_Tx(p,n)
                            ENV.MIN.Tx(p,n)=COMB_min_Tx(p,n);
                        end
                        if ENV.MAX.My(p,n)<COMB_max_My(p,n)
                            ENV.MAX.My(p,n)=COMB_max_My(p,n);
                        end
                        if ENV.MIN.My(p,n)>COMB_min_My(p,n)
                            ENV.MIN.My(p,n)=COMB_min_My(p,n);
                        end
                        if ENV.MAX.Mz(p,n)<COMB_max_Mz(p,n)
                            ENV.MAX.Mz(p,n)=COMB_max_Mz(p,n);
                        end
                        if ENV.MIN.Mz(p,n)>COMB_min_Mz(p,n)
                            ENV.MIN.Mz(p,n)=COMB_min_Mz(p,n);
                        end
                    end
                end
                
                
            end
        end
    end
    
    
else
    COMB_Nx=PRECOMB2_Nx;
    COMB_Vy=PRECOMB2_Vy;
    COMB_Vz=PRECOMB2_Vz;
    COMB_Tx=PRECOMB2_Tx;
    COMB_My=PRECOMB2_My;
    COMB_Mz=PRECOMB2_Mz;
    
    
    
    
    COMB_max_Nx=max(COMB_Nx,[],3);
    COMB_max_Vy=max(COMB_Vy,[],3);
    COMB_max_Vz=max(COMB_Vz,[],3);
    COMB_max_Tx=max(COMB_Tx,[],3);
    COMB_max_My=max(COMB_My,[],3);
    COMB_max_Mz=max(COMB_Mz,[],3);
    
    COMB_min_Nx=min(COMB_Nx,[],3);
    COMB_min_Vy=min(COMB_Vy,[],3);
    COMB_min_Vz=min(COMB_Vz,[],3);
    COMB_min_Tx=min(COMB_Tx,[],3);
    COMB_min_My=min(COMB_My,[],3);
    COMB_min_Mz=min(COMB_Mz,[],3);
    
    
    
    for n=1:nb
        for p=1:tot_ponto(n)
            if ENV.MAX.Nx(p,n)<COMB_max_Nx(p,n)
                ENV.MAX.Nx(p,n)=COMB_max_Nx(p,n);
            end
            if ENV.MIN.Nx(p,n)>COMB_min_Nx(p,n)
                ENV.MIN.Nx(p,n)=COMB_min_Nx(p,n);
            end
            if ENV.MAX.Vy(p,n)<COMB_max_Vy(p,n)
                ENV.MAX.Vy(p,n)=COMB_max_Vy(p,n);
            end
            if ENV.MIN.Vy(p,n)>COMB_min_Vy(p,n)
                ENV.MIN.Vy(p,n)=COMB_min_Vy(p,n);
            end
            if ENV.MAX.Vz(p,n)<COMB_max_Vz(p,n)
                ENV.MAX.Vz(p,n)=COMB_max_Vz(p,n);
            end
            if ENV.MIN.Vz(p,n)>COMB_min_Vz(p,n)
                ENV.MIN.Vz(p,n)=COMB_min_Vz(p,n);
            end
            if ENV.MAX.Tx(p,n)<COMB_max_Tx(p,n)
                ENV.MAX.Tx(p,n)=COMB_max_Tx(p,n);
            end
            if ENV.MIN.Tx(p,n)>COMB_min_Tx(p,n)
                ENV.MIN.Tx(p,n)=COMB_min_Tx(p,n);
            end
            if ENV.MAX.My(p,n)<COMB_max_My(p,n)
                ENV.MAX.My(p,n)=COMB_max_My(p,n);
            end
            if ENV.MIN.My(p,n)>COMB_min_My(p,n)
                ENV.MIN.My(p,n)=COMB_min_My(p,n);
            end
            if ENV.MAX.Mz(p,n)<COMB_max_Mz(p,n)
                ENV.MAX.Mz(p,n)=COMB_max_Mz(p,n);
            end
            if ENV.MIN.Mz(p,n)>COMB_min_Mz(p,n)
                ENV.MIN.Mz(p,n)=COMB_min_Mz(p,n);
            end
        end
    end
end

end

