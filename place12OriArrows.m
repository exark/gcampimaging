%
% Create 12 ori arrows
function place12OriArrows (ori,presNo,figureHandle)
% place12OriArrows2 (180,11)
%function place12OriArrows (ori, figureHandle, presNo)

if nargin<3
    figureHandle=figure();
end

if nargin<2
presNo=12;
end

if nargin<1
ori=180;
end


xPosShift= 0.06*(presNo-1);


switch ori
    case 0
    annotation(figureHandle,'arrow',[0.153930172966047 0.183928571428571]+xPosShift,...
    [0.178064012490243 0.178064012490243]);

    case 360
    annotation(figureHandle,'arrow',[0.153930172966047 0.183928571428571]+xPosShift,...
    [0.178064012490243 0.178064012490243]);


    case 180
    annotation(figureHandle,'arrow',[0.1825 0.152501601537475]+xPosShift,...
    [0.17473067915691 0.17473067915691]);

    case 30
    annotation(figureHandle,'arrow',[0.156790518898139 0.180357142857141]+xPosShift,...
    [0.161646370023424 0.183333333333336]);

    case 210
    annotation(figureHandle,'arrow',[0.178928571428569 0.155361947469566]+xPosShift,...
    [0.182380952380955 0.160693989071043]);

    case 60
    annotation(figureHandle,'arrow',[0.16263452914798 0.172277386290837]+xPosShift,...
    [0.16004605776737 0.196760343481656]);

    case 240
    annotation(figureHandle,'arrow',[0.17391575912876 0.164272901985903]+xPosShift,...
    [0.197915690866511 0.161201405152226]);

    case 90
    annotation(figureHandle,'arrow',[0.168794042280585 0.168794042280585]+xPosShift,...
    [0.16133411397346 0.198048399687746]);

    case 270
    annotation(figureHandle,'arrow',[0.168214285714279 0.168214285714279]+xPosShift,...
    [0.194285714285716 0.15757142857143]);

    case 120
    annotation(figureHandle,'arrow',[0.17164157591287 0.162049967969243]+xPosShift,...
    [0.159586260733802 0.203285714285715]);

    case 330
    annotation(figureHandle,'arrow',[0.156939461883394 0.180357142857128]+xPosShift,...
    [0.178921935987511 0.164285714285715]);

    case 150
    annotation(figureHandle,'arrow',[0.177142857142841 0.153725176169107]+xPosShift,...
    [0.175238095238097 0.189874316939893]);

    case 300
    annotation(figureHandle,'arrow',[0.162717809096723 0.17230941704035]+xPosShift,...
    [0.205994535519127 0.162295081967214]);

end








