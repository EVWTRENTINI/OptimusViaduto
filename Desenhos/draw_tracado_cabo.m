%% Desenha traçado do cabo
figure
for i=1:ntc
    plot(cabo(i).x,cabo(i).y)
    hold on
end
plot(cabo_eq_ato.x,cabo_eq_ato.y,':','LineWidth',2)
plot(cabo_eq_enc.x,cabo_eq_enc.y,'--','LineWidth',2)
title('Traçado dos cabos')
xlabel('x (m)')
ylabel('y (m)')
 xlim([0 max(cabo_eq_ato.x)]);
hold off
drawnow