%
function generateIndividualFigure2PGfit(ancelleyeID,f,orilabel,cf,yraw,GoddnessOfFit)


A1= cf.A1*100;
A2= cf.A2*100;
C= cf.C*100;
mu= cf.mu*100;
sig= cf.sig*100;
rsquared= GoddnessOfFit.rsquare;
adjrsquare= GoddnessOfFit.adjrsquare;


    x=0:35999;
    for i=1:360*100
        %y(i)=A1*exp(-0.5*(x(i)-mu)^2/sig^2) + A2*exp(-0.5*(x(i)-(180+mu))^2/sig^2) + C;
        y(i)=A1*exp(-0.5*(x(i)-mu)^2/sig^2) + A2*exp(-0.5*(x(i)-(100*180+mu))^2/sig^2) + C;
    end
    
    [Rpref,AnglePref]=max(y);
    xorth=180*100;
    OSImodulation= (Rpref - (A1*exp(-0.5*(xorth-mu)^2/sig^2) + A2*exp(-0.5*(xorth-(100*180+mu))^2/sig^2) + C)) /...
                   (Rpref + (A1*exp(-0.5*(xorth-mu)^2/sig^2) + A2*exp(-0.5*(xorth-(100*180+mu))^2/sig^2) + C));
               
               
    oris= 0:30:330;
    h1=figure();
    %fignum=fignum+1;
    plot(x/100,y/100);
    hold on
    plot(oris,yraw, '*k');   
    set(gca, 'XTick', 0:30:330)
    set(gca, 'XTickLabel', orilabel );
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
    
    
    
%     [cf1, G1, O1] = fit(xdata(ok_),ydata1(ok_),ft_,fo_);
%     A1= FitCoef.(listCF{bestFitInxed}).A1*100;
% A2= FitCoef.(listCF{bestFitInxed}).A2*100;
% C= FitCoef.(listCF{bestFitInxed}).C*100;
% mu= FitCoef.(listCF{bestFitInxed}).mu*100;
% sig= FitCoef.(listCF{bestFitInxed}).sig*100;