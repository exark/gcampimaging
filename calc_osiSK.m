function osi = calc_osiSK(spikerate, oris)
% requires that oris be sorted in ascending order (and spikerate matches correct sort)
%oris=[0 30 60 90 120 150 180 210 240 270 300 330];

if min(spikerate)>=0,
osi = sqrt(...
    sum(spikerate.*sind(2*oris)) ^2 ...
    + sum(spikerate.*cosd(2*oris))^2 ...
    )./sum(spikerate);
else
%disp([p f])
disp('neg value in spikerate for OSI index calc, forcing to zero')
spikerate(find(spikerate<0))=0;
osi = sqrt(...
    sum(spikerate.*sind(2*oris)) ^2 ...
    + sum(spikerate.*cosd(2*oris))^2 ...
    )./sum(spikerate);

end



end 
