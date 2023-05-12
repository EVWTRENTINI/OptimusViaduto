figure;
plot(cabo_eq_enc_ime.x,Pinf)
title('Força de protensão no infinito')
xlabel('x (m)')
ylabel('P_{inf} (kN)')
ylim([min(Pinf*.8) max(Pinf*1.2)]);
xlim([0 max(cabo_eq_enc_ime.x)]);
drawnow
