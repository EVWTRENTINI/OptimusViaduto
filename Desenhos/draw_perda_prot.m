figure;
plot(cabo_eq_enc_ime.x,Perda_total*100)
title('Perda de protensão')
xlabel('x (m)')
ylabel('Perda total (%)')
ylim([min(Perda_total*.5) max(Perda_total*1.5*100)]);
xlim([0 max(cabo_eq_enc_ime.x)]);
drawnow