function ENV = COMB2ENV_cell(ENV,PRECOMB,QaMcMM,Mcc,iC,ncont,nb,tot_ponto)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% COMB_Nx=zeros(max(tot_ponto),nb,ncont,'single');
% COMB_Vy=zeros(max(tot_ponto),nb,ncont,'single');
% COMB_Vz=zeros(max(tot_ponto),nb,ncont,'single');
% COMB_Tx=zeros(max(tot_ponto),nb,ncont,'single');
% COMB_My=zeros(max(tot_ponto),nb,ncont,'single');
% COMB_Mz=zeros(max(tot_ponto),nb,ncont,'single');

COMB_Nx = cell(1,ncont);
COMB_Vy = cell(1,ncont);
COMB_Vz = cell(1,ncont);
COMB_Tx = cell(1,ncont);
COMB_My = cell(1,ncont);
COMB_Mz = cell(1,ncont);
for i=1:ncont
    COMB_Nx{i}=PRECOMB.Nx+QaMcMM(Mcc(iC,2)).Nx(:,:,i);
    COMB_Vy{i}=PRECOMB.Vy+QaMcMM(Mcc(iC,2)).Vy(:,:,i);
    COMB_Vz{i}=PRECOMB.Vz+QaMcMM(Mcc(iC,2)).Vz(:,:,i);
    COMB_Tx{i}=PRECOMB.Tx+QaMcMM(Mcc(iC,2)).Tx(:,:,i);
    COMB_My{i}=PRECOMB.My+QaMcMM(Mcc(iC,2)).My(:,:,i);
    COMB_Mz{i}=PRECOMB.Mz+QaMcMM(Mcc(iC,2)).Mz(:,:,i);
end


COMB_Nx=reshape(cell2mat(COMB_Nx),max(tot_ponto),nb,[]);
COMB_Vy=reshape(cell2mat(COMB_Vy),max(tot_ponto),nb,[]);
COMB_Vz=reshape(cell2mat(COMB_Vz),max(tot_ponto),nb,[]);
COMB_Tx=reshape(cell2mat(COMB_Tx),max(tot_ponto),nb,[]);
COMB_My=reshape(cell2mat(COMB_My),max(tot_ponto),nb,[]);
COMB_Mz=reshape(cell2mat(COMB_Mz),max(tot_ponto),nb,[]);





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

