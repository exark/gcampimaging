function generate_onsets_figure(image)

figure()
plot(image.PDm);
hold on
plot(image.stimOnsets,image.PDm(image.stimOnsets), 'r*')
hold off
title StimOnsets