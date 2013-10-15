function osi = calc_osiSK(spikerate, oris)
% requires that oris be sorted in ascending order (and spikerate matches correct sort)

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
