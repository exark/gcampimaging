function CSsig = generate_CS_signal_map(image, CS)

ncells = size(image.basePoints,1);
for(i=1:ncells)
    idxCS = find(image.CSmsk==i); idxCS = idxCS(:);
    for(j=1:image.numFrames)
        imgCS = squeeze(CS(j,:,:));      
        
        %Calcium Signal, this is the primary output
        CSsig(i,j) = mean(imgCS(idxCS));  
    end
end
end