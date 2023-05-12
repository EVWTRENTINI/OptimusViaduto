function [Nctp,Mctp] = Nctp_Mctp(fcd,xEpc2,n_conc,c1,c2,y,ymax,xalfa,mult_fcd)
%Calcula o resultado da integral da parabola sem condição de contorno
% Nctp-Normal concreto trapezio parabola
% Mctp-Momento concreto trapezio parabola

g=ymax-xalfa;
n1=n_conc+1;
n2=n_conc+2;
n3=n_conc+3;

eexp=((g+xEpc2-y)/xEpc2)^n1;
Nctp=-mult_fcd*fcd*(-(xEpc2*eexp*(c1*n2+c2*(g+xEpc2+n_conc*y+y)))/(n1*n2)-...
    c1*y-(c2*y^2)/2);

Mctp=(mult_fcd*fcd*(3*c1*((n1)*(n2)*(n3)*y*y+2*xEpc2*eexp*(((ymax-xalfa)...
    +xEpc2)*(n3)+(3+4*n_conc+n_conc*n_conc)*y))+2*c2*((n1)*(n2)*(n3)...
    *y*y*y+3*xEpc2*eexp*(2*(ymax-xalfa)*(ymax-xalfa)+2*xEpc2*xEpc2+2*...
    xEpc2*(n1)*y+(2+3*n_conc+n_conc*n_conc)*y*y+2*(ymax-xalfa)*(2*...
    xEpc2+(n1)*y)))))/(6*(n1)*(n2)*(n3));%codigo fonte do OblqCalco

end