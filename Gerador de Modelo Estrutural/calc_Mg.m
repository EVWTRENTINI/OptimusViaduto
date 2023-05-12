function Mg = calc_Mg(x,k,j,LC_cd_PP,viaduto,info)
%Calcula o momento proporcionado pelas ações permanentes na longarina



LC_cd_PP_lg=LC_cd_PP(LC_cd_PP(:,1)==info.longarinas.vao(k).longarina(j).membros,:);
cd=LC_cd_PP_lg(LC_cd_PP_lg(:,2)==3,:);

Mg=zeros(1,(viaduto.disc_cabos+3));

L=x(viaduto.disc_cabos+3)-2*x(2);

R=-sum((cd(:,4)-cd(:,3))*L.*cd(:,5)./2); %só da certo pq os carregamentos de enr são simetricos
[nt_cd,~]=size(cd);

Mg(1)=0;
Mg(viaduto.disc_cabos+3)=0;
Mg(2:viaduto.disc_cabos+2)=R.*(x(2:viaduto.disc_cabos+2)-x(2));
for n_cd=1:nt_cd
    
    for i=2:viaduto.disc_cabos+2
        l=x(i)-x(2);
        if l<=cd(n_cd,3)*L
            %Mg(i)=R*(l)-(PP+PPenr)*(l^2)/2;
        elseif and(l>cd(n_cd,3)*L,l<=cd(n_cd,4)*L)
            Mg(i)=Mg(i)+(l-cd(n_cd,3)*L)/2*(l-cd(n_cd,3)*L)*cd(n_cd,5);
            %Mg(i)=(PP)*(l^2)/2-PPenr*enr*L*(l-enr*L/2);
        elseif l>cd(n_cd,4)*L
            lw=(cd(n_cd,4)*L-cd(n_cd,3)*L);
            Mg(i)=Mg(i)+(lw/2+l-cd(n_cd,4)*L)*lw*cd(n_cd,5);
            %Mg(i)=R*(L-l)-(PP+PPenr)*((L-l)^2)/2;
        end
    end
end
%plot(x,Mg)
end