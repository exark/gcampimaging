%assumes 12 angles, ydata1 is actual data, sorted if randomly presented.
%ydata2..12 are 30 degree steps of ydata1 to find best fit.
%ydata2..ydata12 created outside of this function
function [Aout,h1]=create2PeakGuassianFits12Ori_allFitsPlot(xdata,ydata1,ydata2,ydata3,ydata4,ydata5,ydata6,ydata7,ydata8,ydata9,ydata10,ydata11,ydata12,f,ancelleyeID)
listCF= {'cf1'; 'cf2'; 'cf3'; 'cf4'; 'cf5'; 'cf6'; 'cf7'; 'cf8'; 'cf9'; 'cf10'; 'cf11'; 'cf12';};
listGoddnessOfFit= {'g1'; 'g2'; 'g3'; 'g4'; 'g5'; 'g6'; 'g7';'g8'; 'g9'; 'g10'; 'g11'; 'g12';};
listOutputMisc= {'o1'; 'o2'; 'o3'; 'o4'; 'o5'; 'o6'; 'o7'; 'o8'; 'o9'; 'o10'; 'o11'; 'o12';};
listOMRaw= {'raw1';  'raw2'; 'raw3'; 'raw4'; 'raw5'; 'raw6'; 'raw7'; 'raw8'; 'raw9'; 'raw10'; 'raw11'; 'raw12';};
listOri={'o1'; 'o2'; 'o3'; 'o4'; 'o5'; 'o6'; 'o7'; 'o8'; 'o9'; 'o10'; 'o11'; 'o12';};
ori.o1= {'0';'30';'60';'90';'120';'150';'180';'210'; '240';'270';'300';'330'}; 
ori.o2= {'330';'0';'30';'60';'90';'120';'150';'180';'210'; '240';'270';'300'}; 
ori.o3= {'300';'330';'0';'30';'60';'90';'120';'150';'180';'210'; '240';'270'}; 
ori.o4= {'270';'300';'330';'0';'30';'60';'90';'120';'150';'180';'210'; '240'}; 
ori.o5= {'240';'270';'300';'330';'0';'30';'60';'90';'120';'150';'180'; '210'}; 
ori.o6= {'210';'240';'270';'300';'330';'0';'30';'60';'90';'120';'150'; '180'}; 
ori.o7= {'180';'210';'240';'270';'300';'330';'0';'30';'60';'90';'120';'150'}; 
ori.o8= {'150';'180';'210';'240';'270';'300';'330';'0';'30';'60';'90';'120'}; 
ori.o9= {'120';'150';'180';'210';'240';'270';'300';'330';'0';'30';'60';'90'}; 
ori.o10= {'90';'120';'150';'180';'210';'240';'270';'300';'330';'0';'30';'60'}; 
ori.o11= {'60';'90';'120';'150';'180';'210';'240';'270';'300';'330';'0';'30'}; 
ori.o12= {'30';'60';'90';'120';'150';'180';'210';'240';'270';'300';'330';'0'}; 
h1=0;
fignum=0;

% --- Create fit "fit 1"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata1);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf1, G1, O1] = fit(xdata(ok_),ydata1(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o1,cf1,ydata1,G1)


% --- Create fit "fit 2"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata2);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf2, G2, O2] = fit(xdata(ok_),ydata2(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o2,cf2,ydata2,G2)


% --- Create fit "fit 3"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata3);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf3, G3, O3] = fit(xdata(ok_),ydata3(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o3,cf3,ydata3,G3)



% --- Create fit "fit 4"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata4);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf4, G4, O4] = fit(xdata(ok_),ydata4(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o4,cf4,ydata4,G4)


% --- Create fit "fit 5"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata5);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf5, G5, O5] = fit(xdata(ok_),ydata5(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o5,cf5,ydata5,G5)


% --- Create fit "fit 6"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata6);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf6, G6, O6] = fit(xdata(ok_),ydata6(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o6,cf6,ydata6,G6)


% --- Create fit "fit 7"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata7);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf7, G7, O7] = fit(xdata(ok_),ydata7(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o7,cf7,ydata7,G7)


% --- Create fit "fit 8"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata8);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf8, G8, O8] = fit(xdata(ok_),ydata8(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o8,cf8,ydata8,G8)


% --- Create fit "fit 9"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata9);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf9, G9, O9] = fit(xdata(ok_),ydata9(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o9,cf9,ydata9,G9)


% --- Create fit "fit 10"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata10);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf10, G10, O10] = fit(xdata(ok_),ydata10(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o10,cf10,ydata10,G10)


% --- Create fit "fit 11"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata11);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf11, G11, O11] = fit(xdata(ok_),ydata11(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o11,cf11,ydata11,G11)


% --- Create fit "fit 12"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[0    0 -Inf   82.5    5],'Upper',[Inf Inf Inf  97.5 Inf]);
ok_ = isfinite(xdata) & isfinite(ydata12);

st_ = [8 8 10 90 20 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('A1*exp(-0.5*(x-mu)^2/sig^2) + A2*exp(-0.5*(x-(180+mu))^2/sig^2) + C',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A1', 'A2', 'C', 'mu', 'sig'});
% Fit the model
[cf12, G12, O12] = fit(xdata(ok_),ydata12(ok_),ft_,fo_);
generateIndividualFigure2PGfit(ancelleyeID,f,ori.o12,cf12,ydata12,G12)


%%%%%% done fitting

[adjrsquare,bestFitInxed]= max([G1.adjrsquare G2.adjrsquare G3.adjrsquare G4.adjrsquare G5.adjrsquare G6.adjrsquare G7.adjrsquare G8.adjrsquare G9.adjrsquare G10.adjrsquare G11.adjrsquare G12.adjrsquare]);

FitCoef.cf1=cf1; FitCoef.cf2=cf2; FitCoef.cf3=cf3; FitCoef.cf4=cf4; FitCoef.cf5=cf5; FitCoef.cf6=cf6; FitCoef.cf7=cf7; FitCoef.cf8=cf8; FitCoef.cf9=cf9;
  FitCoef.cf10=cf10; FitCoef.cf11=cf11; FitCoef.cf12=cf12;
GoddnessOfFit.g1=G1; GoddnessOfFit.g2=G2; GoddnessOfFit.g3=G3; GoddnessOfFit.g4=G4; GoddnessOfFit.g5=G5; GoddnessOfFit.g6=G6; GoddnessOfFit.g7=G7;
    GoddnessOfFit.g8=G8; GoddnessOfFit.g9=G9; GoddnessOfFit.g10=G10; GoddnessOfFit.g11=G11; GoddnessOfFit.g12=G12;
OutputMisc.o1=O1; OutputMisc.o2=O2; OutputMisc.o3=O3; OutputMisc.o4=O4; OutputMisc.o5=O5; OutputMisc.o6=O6; OutputMisc.o7=O7; OutputMisc.o8=O8;
    OutputMisc.o9=O9; OutputMisc.o10=O10; OutputMisc.o11=O11; OutputMisc.o12=O12;
OutputMisc.raw1=ydata1; OutputMisc.raw2=ydata2; OutputMisc.raw3=ydata3; OutputMisc.raw4=ydata4;  OutputMisc.raw5=ydata5; OutputMisc.raw6=ydata6; OutputMisc.raw7=ydata7;
    OutputMisc.raw8=ydata8; OutputMisc.raw9=ydata9; OutputMisc.raw10=ydata10; OutputMisc.raw11=ydata11; OutputMisc.raw12=ydata12;
% FitCoef.(listCF{bestFitInxed})
% GoddnessOfFit.(listGoddnessOfFit{bestFitInxed})
% OutputMisc.(listOutputMisc{bestFitInxed})

A1= FitCoef.(listCF{bestFitInxed}).A1*100;
A2= FitCoef.(listCF{bestFitInxed}).A2*100;
C= FitCoef.(listCF{bestFitInxed}).C*100;
mu= FitCoef.(listCF{bestFitInxed}).mu*100;
sig= FitCoef.(listCF{bestFitInxed}).sig*100;
rsquared= GoddnessOfFit.(listGoddnessOfFit{bestFitInxed}).rsquare;
yraw= OutputMisc.(listOMRaw{bestFitInxed});

    x=0:35999;
    for i=1:360*100
        %y(i)=A1*exp(-0.5*(x(i)-mu)^2/sig^2) + A2*exp(-0.5*(x(i)-(180+mu))^2/sig^2) + C;
        y(i)=A1*exp(-0.5*(x(i)-mu)^2/sig^2) + A2*exp(-0.5*(x(i)-(100*180+mu))^2/sig^2) + C;
    end
    
    [Rpref,AnglePref]=max(y);
    xorth=180*100;
    OSImodulation= (Rpref - (A1*exp(-0.5*(xorth-mu)^2/sig^2) + A2*exp(-0.5*(xorth-(100*180+mu))^2/sig^2) + C)) /...
                   (Rpref + (A1*exp(-0.5*(xorth-mu)^2/sig^2) + A2*exp(-0.5*(xorth-(100*180+mu))^2/sig^2) + C));
               
        if AnglePref>100*100
            Angleopposite=  AnglePref- 180*100;
        else
            Angleopposite=  AnglePref+ 180*100;
        end
    
     DSI=  (Rpref - (A1*exp(-0.5*(Angleopposite-mu)^2/sig^2) + A2*exp(-0.5*(Angleopposite-(100*180+mu))^2/sig^2) + C)) /...
               (Rpref + (A1*exp(-0.5*(Angleopposite-mu)^2/sig^2) + A2*exp(-0.5*(Angleopposite-(100*180+mu))^2/sig^2) + C));
           
%    if bestFitInxed<5,
%         if AnglePref>100*100, Apref= mu/100 +180 -((bestFitInxed-1)*30); else Apref= mu/100-((bestFitInxed-1)*30); end 
%    end
              
    switch bestFitInxed
        case 1, 
            if AnglePref>100*100, Apref= mu/100-90 + 270; else Apref= 90 + mu/100-90; end              
        case 2,
            if AnglePref>100*100, Apref= mu/100-90 + 240; else Apref= 60 + mu/100-90; end 
        case 3, 
            if AnglePref>100*100, Apref= mu/100-90 + 210; else Apref= 30 + mu/100-90; end 
        case 4,
            if AnglePref>100*100, Apref= mu/100-90 + 180; else Apref= 0 + mu/100-90; end     
        case 5, 
            if AnglePref>100*100, Apref= mu/100-90 + 150; else Apref= 330 + mu/100-90; end              
        case 6,
            if AnglePref>100*100, Apref= mu/100-90 + 120; else Apref= 300 + mu/100-90; end 
        case 7, 
            if AnglePref>100*100, Apref= mu/100-90 + 90; else Apref= 270 + mu/100-90; end 
        case 8,
            if AnglePref>100*100, Apref= mu/100-90 + 60; else Apref= 240 + mu/100-90; end
        case 9,
            if AnglePref>100*100, Apref= mu/100-90 + 30; else Apref= 210 + mu/100-90; end
        case 10,
            if AnglePref>100*100, Apref= mu/100-90 + 0; else Apref= 180 + mu/100-90; end
        case 11,
            if AnglePref>100*100, Apref= mu/100-90 + 330; else Apref= 150 + mu/100-90; end
        case 12,
            if AnglePref>100*100, Apref= mu/100-90 + 300; else Apref= 120 + mu/100-90; end
    end
           
     
Aout={};
Aout{1,1}= sig/100*1.1774; Aout{1,2}= C/100; Aout{1,3}= OSImodulation; Aout{1,4}= DSI; Aout{1,5}=adjrsquare; Aout{1,6}=rsquared;
Aout{2,1}= 'HwidthHmax(deg)'; Aout{2,2}= 'offset(Hz)'; Aout{2,3}= 'OSImodulation'; Aout{2,4}= 'DSI'; Aout{2,5}= 'fit: adjRsq'; Aout{2,6}= 'fit: R^2';

Aout{1,7}= Apref;
Aout{2,7}=  'p angle(degrees)'; %prefered angle Note, could be in error, not checked!!!

Aout{1,8}= mu/100; Aout{1,9}= bestFitInxed;
Aout{2,8}=  'mu (degrees)'; Aout{2,9}= 'bestFitIndex';
           
        
    oris= 0:30:330;
    h1=figure();
    fignum=fignum+1;
    plot(x/100,y/100);
    hold on
    plot(oris,yraw, '*k');   
    set(gca, 'XTick', 0:30:330)
    set(gca, 'XTickLabel', ori.(listOri{bestFitInxed}) );
    hold off
    xlabel 'Angle Presented(Degrees)'
    ylabel 'Response(Hz)'
    ylim( [min([0 C/100]) max( [max(y/100)+.2  max(yraw)])] ) ;
    title ({ancelleyeID; f})
    
    annotation(gcf,'textbox',[0.01171 0.01667 0.3526 0.05476],...
    'String',{['OSI: ' num2str(OSImodulation) '  bw: ' num2str(sig/100*1.1774) ]},...
    'FitBoxToText','off',...
    'LineStyle','none');

    annotation(gcf,'textbox',[0.7982 0.007143 0.1946 0.1],...
    'String',{['adjR: ' num2str(adjrsquare) ' Rsq: ' num2str(rsquared) ]},...
    'FitBoxToText','off',...
    'LineStyle','none');
%     



end


