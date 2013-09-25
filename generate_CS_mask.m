function CSmsk = generate_CS_mask(image)

CSmsk = zeros(size(image.CSma));
N = 9; % hard coded coefficient for image.zoomFactor 2
for(i=1:size(image.basePoints,1))

    ii = image.basePoints(i,2)-N:image.basePoints(i,2)+N;
    jj = image.basePoints(i,1)-N:image.basePoints(i,1)+N;
    %in case near edge:
    Nii=N;
    Njj=N;
    while max(ii) > size(image.CSma,1)
        Nii=Nii-1;
        ii = image.basePoints(i,2)-Nii:image.basePoints(i,2)+Nii;
    end
    while max(jj) > size(image.CSma,2)
        Njj=Njj-1;
        ii = image.basePoints(i,2)-Njj:image.basePoints(i,2)+Njj;
    end
    CSsub = image.CSma(ii,jj);      

    i
    mCS = cellseg_sk(CSsub, image.zoomFactor);
    CSmsk(ii,jj) = mCS * i;

    if length(ii)<N/2 ||  length(jj)<N/2, 
        beep;
        disp('too close to edge, please re-do or consider eliminating cell number:')
        disp(i)
    end
end
end