%2-peak Guassian script, not a function
%reguries following m-files:
    %create2PeakGuassianFits12Ori_allFitsPlot
    %generateIndividualFigure2PGfit
    %calc_osiSK
    
    
    
xdata=[0 30 60 90 120 150 180 210 240 270 300 330]';  %orientations, defult is 12 starting at 0 degrees

%past mean response values here (ie, 12 values for 12 orientations:
%(needs to be of size 1row x12columns
aydata= [18.6493102185519,21.3159775519837,15.3159760517725,9.14930784321461,6.14930709309809,9.98264138491251,8.64930771819485,18.3159768018789,16.8159764268267,11.4826417599606,11.9826418849799,11;];

%preparing data to pass to fitting function
ydata1=aydata';
p=1;
len=length(xdata);
    ydata2(p+1:len,1)= aydata(p:end-1); ydata2(p,1)= aydata(end:end);
    ydata3(p+2:len,1)= aydata(p:end-2); ydata3(p:p+1,1)= aydata(end-1:end);
    ydata4(p+3:len,1)= aydata(p:end-3); ydata4(p:p+2,1)= aydata(end-2:end);
    ydata5(p+4:len,1)= aydata(p:end-4); ydata5(p:p+3,1)= aydata(end-3:end);
    ydata6(p+5:len,1)= aydata(p:end-5); ydata6(p:p+4,1)= aydata(end-4:end);
    ydata7(p+6:len,1)= aydata(p:end-6); ydata7(p:p+5,1)= aydata(end-5:end);
    ydata8(p+7:len,1)= aydata(p:end-7); ydata8(p:p+6,1)= aydata(end-6:end);
    ydata9(p+8:len,1)= aydata(p:end-8); ydata9(p:p+7,1)= aydata(end-7:end);
    ydata10(p+9:len,1)= aydata(p:end-9); ydata10(p:p+8,1)= aydata(end-8:end);
    ydata11(p+10:len,1)= aydata(p:end-10); ydata11(p:p+9,1)= aydata(end-9:end);
    ydata12(p+11:len,1)= aydata(p:end-11); ydata12(p:p+10,1)= aydata(end-10:end);
    ydata1=ydata1';
f='x'  %enter file or cell ID here
ancelleyeID=(f);  %additional option to add second ID, defult is to re-use f, but can put anything (string) 

%fitting the data here (uses stat toolbox):
[Aout,h1]=create2PeakGuassianFits12Ori_allFitsPlot(xdata,ydata1,ydata2,ydata3,ydata4,ydata5,ydata6,ydata7,ydata8,ydata9,ydata10,ydata11,ydata12,f,ancelleyeID);


analysis.OSImodulation2peakG= Aout{1,3};  
analysis.HWHMbandwidth2peakG= Aout{1,1};
analysis.fitAdjRsq= Aout{1,5};
analysis.twopeakGAout= Aout;

%now calculating OSI as 1-circular varience:
analysis.OSI_CV=calc_osiSK(aydata,xdata);
