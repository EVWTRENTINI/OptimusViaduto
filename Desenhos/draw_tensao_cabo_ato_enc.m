%% Desenha tensão no ato
figure
for i=1:ntc
    plot(cabo(i).x,cabo(i).Sigx)
    hold on
end
plot(cabo_eq_ato.x,cabo_eq_ato.Sig,':','LineWidth',2)
%hold off %para desenhar junto
ylim([100 max(cabo_eq_ato.Sig)*1.02]);
xlim([0 max(cabo_eq_ato.x)]);
title('Tensão no ato e após encunhamento')
xlabel('x (m)')
ylabel('Tensão no cabo (kN/cm²)')
%% Desenha tensão após o encunhamento
for i=1:ntc
    plot(cabo(i).x,cabo(i).Sigx_enc)
    hold on
end
plot(cabo_eq_enc.x,cabo_eq_enc.Sig,'--','LineWidth',2)
hold off
drawnow
