function [ap] = join_ap(ap1,ap2)
%
%
ap=ap1;
for i=1:ap2.n
    ap.x(ap1.n+i)=ap2.x(i);
    ap.y(ap1.n+i)=ap2.y(i);
    ap.A(ap1.n+i)=ap2.A(i);
    ap.camada(ap1.n+i)=ap2.camada(i);
end
ap.n=ap1.n+ap2.n;

end

