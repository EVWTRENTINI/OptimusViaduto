%Desenha estrutura

[nbroty,~]=size(broty);%numero de barras com rotula em y
[zzz,ndraw_not]=size(draw_not);
[nbrig_ex,~]=size(brig_ex);%numero de barras rigidas extensiveis
nbardesenhadas=0;
n_e_rig_ex=zeros(1,nb);%a barra n é rigida extensivel?
for n=1:nb
  
    for lbrig_ex=1:nbrig_ex
        if brig_ex(lbrig_ex,1)==n
            n_e_rig_ex(n)=1;%A barra N é rigida extensivel? 1 se sim, 0 se não
            break
        end
    end

    for ldraw_not=1:ndraw_not
         if draw_not(ldraw_not)==n
             desenhar=0;
             break
         else
             desenhar=1;
         end
    end
    if desenhar==1
    plot3([joints((jb(n,1)),1) joints((jb(n,2)),1)],...          %[X1 X2]
          [joints((jb(n,1)),2) joints((jb(n,2)),2)],...          %[Y1 Y2]
          [joints((jb(n,1)),3) joints((jb(n,2)),3)],'color','k');%[Z1 Z2]
    
      nbardesenhadas=nbardesenhadas+1;
      if nbardesenhadas==1
          hold on
      end
    for lbry=1:nbroty
        if broty(lbry,1)==n %A barra atual possui rotula?
            for rotula=[2 3]
                if broty(lbry,rotula)==1
                    if rotula==2
                        amplii=9.7;
                        amplif=.3;
                    else
                        amplii=.3;
                        amplif=9.7;
                    end
                end
                if broty(lbry,rotula)==1
            scatter3((amplii*joints((jb(n,1)),1)+amplif*joints((jb(n,2)),1))/10,...
                     (amplii*joints((jb(n,1)),2)+amplif*joints((jb(n,2)),2))/10,...
                     (amplii*joints((jb(n,1)),3)+amplif*joints((jb(n,2)),3))/10,...
                      'MarkerEdgeColor','k',...
                      'MarkerFaceColor','k');
                end
            end
        end
    end%Desenha rotulas
    else
        bcolor='g';
        if n_e_rig_ex(n)==1
            bcolor='b';
        end
        plot3([joints((jb(n,1)),1) joints((jb(n,2)),1)],...                          %[X1 X2]
              [joints((jb(n,1)),2) joints((jb(n,2)),2)],...                           %[Y1 Y2]
              [joints((jb(n,1)),3) joints((jb(n,2)),3)],'color',bcolor,'LineWidth',2);%[Z1 Z2]
    
      nbardesenhadas=nbardesenhadas+1;
      if nbardesenhadas==1
          hold on
      end    
        
        
        
        
        
    end
    
%     text((joints((jb(n,1)),1)+joints((jb(n,2)),1))/2,...
%          (joints((jb(n,1)),2)+joints((jb(n,2)),2))/2,...
%          (joints((jb(n,1)),3)+joints((jb(n,2)),3))/2,num2str(n))
%         
     
end

% % %% Desenha apoios flexiveis em lx e ly 
% [naflex,~]=size(aflex);
% escaf=2;
% h1=.075*escaf;
% h2=.10*escaf;
% v1=.075*escaf;
% v2=.10*escaf;
% nvoltas=0;
%    
% molal=[];
% 
% %começo da mola
%     molal(1,:)=[0 0 0];
%     molal(2,:)=[molal(1,1)+h1       molal(1,2)          molal(1,3)];
%     molal(3,:)=[molal(2,1)+h2/2     molal(2,2)          molal(2,3)-v2/2];
%     molal(4,:)=[molal(3,1)          molal(3,2)          molal(3,3)+v2/2];
%     %nvoltas
%     for i=1:nvoltas
%         [lmolal,~]=size(molal);
%         
%         molal(lmolal+1,:)=[molal(lmolal+0,1)     molal(lmolal+0,2)     molal(lmolal+0,3)+v2/2];
%         molal(lmolal+2,:)=[molal(lmolal+1,1)+h2  molal(lmolal+1,2)     molal(lmolal+1,3)-v2];
%         molal(lmolal+3,:)=[molal(lmolal+2,1)     molal(lmolal+2,2)     molal(lmolal+2,3)+v2/2];
%     end
%     
%     %final da mola
%     [lmolal,~]=size(molal);
%     molal(lmolal+1,:)=[molal(lmolal,1)          molal(lmolal,2)         molal(lmolal,3)+v2/2];
%     molal(lmolal+2,:)=[molal(lmolal+1,1)+h2/2   molal(lmolal+1,2)       molal(lmolal+1,3)-v2/2];
%     molal(lmolal+3,:)=[molal(lmolal+2,1)+h1     molal(lmolal+2,2)       molal(lmolal+2,3)];
%     molal(lmolal+4,:)=[molal(lmolal+3,1)        molal(lmolal+3,2)       molal(lmolal+3,3)+v1/2];
%     molal(lmolal+5,:)=[molal(lmolal+4,1)        molal(lmolal+4,2)       molal(lmolal+4,3)-v1];
% 
% molalrt=[];
% 
% 
% for laflex=1:naflex
%     
%     for j=2:4
%         if not(aflex(laflex,j)==0)
%             
%             xo=joints(aflex(laflex,1),1);
%             yo=joints(aflex(laflex,1),2);
%             zo=joints(aflex(laflex,1),3);
%             text(xo,yo,zo,['   ' num2str(aflex(laflex,2)/1E6,3) ' MN/m'])
%             
%             %desenha a mola
%             
%             [lmolal,~]=size(molal);
%             molalr=molal;
%             if j==3
%                 molalr=molal*[0 1 0;...
%                               1 0 0;...
%                               0 0 1];
%             elseif j==4
%                 molalr=molal*[0 0 -1;...
%                               0 1  0;...
%                               1 0  0];
%             end
%             molalrt(:,1)=molalr(:,1)+xo;
%             molalrt(:,2)=molalr(:,2)+yo;
%             molalrt(:,3)=molalr(:,3)+zo;
%             
%             for i=1:lmolal-1
%                 plot3([molalrt(i,1) molalrt(i+1,1)],...          %[X1 X2]
%                       [molalrt(i,2) molalrt(i+1,2)],...          %[Y1 Y2]
%                       [molalrt(i,3) molalrt(i+1,3)],...          %[Z1 Z2]
%                       'color','g','LineWidth',1);
%             end
%         end
%     end
% end
hold off
axis equal vis3d
