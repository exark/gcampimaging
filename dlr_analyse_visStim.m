%created by Dario Ringach, used in Kuhlman Nature 2013 to analyze data aquired by Elaine Tring at UCLA. Modified July2013 sk
%see readme txt file in this folder
%Data aquired using ScanImage
%Currently requires 256x256 tiff images.  Interpolate to resize if
%necessary.
function [r] = dlr_analyse_visStim
originaldirectory=pwd;

genFigures=0;

r.image(1) = load_image_with_visStim;

%select cells for analysis across trials
[~, ~,x] = cpselect_sk(r.image(1).fuse,r.image(1).CSma, 'Wait',true); %modified toolbox cpselect so outputs ALL cells, not just pairs
% imcontrast(gca)  %possible to incorperate imcontrast to adjust image contrast
r.image(1).basePoints = round(x.basePoints);

% generate mask from image
r.image(1).CSmsk = generate_CS_mask(r.image(1));

% now pull the signals out...
r.image(1).CSsig = generate_CS_signal_map(r.image(1))

% % % r.filename = hgeneric(1, 1).Filename;
% % % r.mask = CSmsk;
% % % r.CSimage = CSma;
% % % r.CSsig= CSsig;
% % % r.PDm=PDm;
% % % r.numFrames=numFrames;
% % % r.x=x; %points, output from cpselect

%generate figure that labels cells
generate_labeled_figure(r.image(1));

r.image(1) = calculate_data(r.image(1));

%this plots stimonsets.
generate_onsets_figure(r.image(1));

% %plot raw fluorescence traces for each cell:

if genFigures

generate_raw_fluorescence_figure(r.image(1))

generate_ordered_fluorescence_figure(r.image(1))

end % if genFigures
% % save file with promt and name suggestion

mkdir('Analysis');
cd ('Analysis');
indexUS= strfind(f, '_');
indexUS_last=indexUS(end);
filenameprefix1= f(1:indexUS_last+3);
contrastStrValue= [num2str(r.visStimParamFile.contrast*100)];
sf = [filenameprefix1 '-' contrastStrValue];

[sf,sp]= uiputfile('.mat', ['Save responses for image file: ' filenameprefix1], sf);
save(sf,'r');

cd (originaldirectory);

%%%%%adding multiple image stuff%%%%
% [f2,p2]  = uigetfile('*.tif','Select another image of the same cell');  
% dir('*.mat');
% DirInfoImage=dir(f);
% DirInfoVSF=dir('*.mat');
% 
% for i=1:size(DirInfoVSF,1)
%     ad(i)=abs(diff([DirInfoImage.datenum DirInfoVSF(i).datenum]));
% end
% [~,indexMin]= min(ad); 
% mfSuggest=DirInfoVSF(indexMin).name;
% [mf2,mp2]  = uigetfile(mfSuggest,'Select your .mat vis stim file');
% 
% %read in header info of image file
% hgeneric=imfinfo([p2 f2]);
% header=hgeneric(1).ImageDescription;
% header=parseHeader(header);
% %ScanImage specifc:
% numFrames=header.acq.numberOfFrames;
% pxPline=header.acq.pixelsPerLine;
% linePfram=header.acq.linesPerFrame;
% numChans=header.acq.numberOfChannelsAcquire;
% zoomFactor=header.acq.zoomFactor;
% frameRate=header.acq.frameRate;
% 
% CS = zeros(numFrames,256,256);  %CS- calcium signal channel
% 
% for(i=1:numFrames)
%     CS(i,:,:)=imread(f2,'Index',GCaMPch+(i-1)*numChans);  %use 1+(i-1)*3 if first channel aquired is calcium signal and three channels were aquired
% end
% 
% CSm = squeeze(mean(CS,1));
% CSm = (CSm-min(CSm(:)))/(max(CSm(:))-min(CSm(:)));
% CSma = imadjust(CSm);
% 
% Xc = round(r.x.basePoints);
% 
% CSmsk = zeros(size(CSma));
% 
% N = 9;
% 
%     for(i=1:size(Xc,1))
%         
%         ii = Xc(i,2)-N:Xc(i,2)+N;
%         jj = Xc(i,1)-N:Xc(i,1)+N;
%         %in case near edge:
%         Nii=N;
%         Njj=N;
%         while max(ii) > size(CSma,1)
%             Nii=Nii-1;
%             ii = Xc(i,2)-Nii:Xc(i,2)+Nii;
%         end
%         while max(jj) > size(CSma,2)
%             Njj=Njj-1;
%             ii = Xc(i,2)-Njj:Xc(i,2)+Njj;
%         end
%         %
% %         max(ii)
% %         max(jj)
%         CSsub = CSma(ii,jj);      
%      
%         i
%         mCS_ii = cellseg_sk(CSsub, zoomFactor);
%         CSmsk(ii,jj) = mCS_ii * i;
%         
%         if length(ii)<N/2 ||  length(jj)<N/2, 
%             beep;
%             disp('too close to edge, please re-do or consider eliminating cell number:')
%             disp(i)
%         end
%     end
% 
% figure()
% set(gca,'XDir','reverse')
% imshow(CSma)
% hold on
% numcells= size(r.CSsig,1);
%     for i=1:numcells
%          [y,x]=find(CSmsk==i);
%          plot(x(1:6:end),y(1:6:end), '.')
%          set(gca,'YDir','reverse')
%          cellID=num2str(i);
%          text(x(1)-6,y(1), cellID,'FontSize', 16,'FontWeight','bold','Color',[1 0.694117647058824 0.392156862745098]);
%          hold on
%     end
%     hold off
%     ylim([0 256])
%     xlim([0 256])
%%%%%%%%%%%%%
f








