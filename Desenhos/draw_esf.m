function draw_esf(tipo_esf,esc_esf,Nx,Vy,Vz,Tx,My,Mz,xb,tot_ponto,nb,cm,jb,joints,draw_not)
%Desenha os diagramas de esforço com o vetor de esforço organizado em cell array

%%Transforma em o cell array em matriz

% Nx=zeros(size(xb),'single');
% Vy=zeros(size(xb),'single');
% Vz=zeros(size(xb),'single');
% Tx=zeros(size(xb),'single');
% My=zeros(size(xb),'single');
% Mz=zeros(size(xb),'single');
% 
% for n=1:nb
%     Nx(1:tot_ponto(n),n)=Nxc{n};
%     Vy(1:tot_ponto(n),n)=Vyc{n};
%     Vz(1:tot_ponto(n),n)=Vzc{n};
%     Tx(1:tot_ponto(n),n)=Txc{n};
%     My(1:tot_ponto(n),n)=Myc{n};
%     Mz(1:tot_ponto(n),n)=Mzc{n};
% end

%% Desenha
[~,ndraw_not]=size(draw_not);
hold on
for n=1:nb
    for ldraw_not=1:ndraw_not
        if draw_not(ldraw_not)==n
            desenhar=0;
            break
        else
            desenhar=1;
            
        end
    end
    if desenhar==1
        
        vert=zeros(tot_ponto(n)*2,3);
        vert(1:tot_ponto(n))=xb(1:tot_ponto(n),n);%Preenche com os vertices sobre a barra
        vert(tot_ponto(n)+1:tot_ponto(n)*2,1)=flip(xb(1:tot_ponto(n),n));
        if     tipo_esf==1%se for esforço normal, desenhar no z local
            dir_esf=3;
            valor_esf=Nx.*esc_esf;
        elseif tipo_esf==2%se for esforço cortante y, desenhar no y local
            dir_esf=2;
            valor_esf=Vy.*esc_esf;
        elseif tipo_esf==3%se for esforço cortante z, desenhar no z local
            dir_esf=3;
            valor_esf=Vz.*esc_esf;
        elseif tipo_esf==4%se for esforço de torção, desenhar no z local
            dir_esf=3;
            valor_esf=Tx.*esc_esf;
        elseif tipo_esf==5%se for esforço de momento y, desenhar no z local
            dir_esf=3;
            valor_esf=-My.*esc_esf;
        elseif tipo_esf==6%se for esforço de momento z, desenhar no y local
            dir_esf=2;
            valor_esf=-Mz.*esc_esf;
        end
        vert(tot_ponto(n)+1:tot_ponto(n)*2,dir_esf)...
            =flip(valor_esf(1:tot_ponto(n),n));
        fac=[1:tot_ponto(n)*2];
        
        
        vert=vert*cm(:,:,n);
        for diri=[1 2 3]
            vert(:,diri)=vert(:,diri)+joints(jb(n,1),diri);
        end
        patch('Faces',fac,'Vertices',vert,'FaceColor','red','FaceAlpha',1);
    end
end
hold off