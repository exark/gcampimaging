function varargout = cpselect_sk(varargin)
%CPSELECT Control point selection tool. 
%   CPSELECT is a graphical user interface that enables you to select
%   control points from two related images.
%
%   CPSELECT(INPUT,BASE) returns control points in CPSTRUCT. INPUT is the
%   image that needs to be warped to bring it into the coordinate system of the
%   BASE image. INPUT and BASE can be either variables that contain grayscale,
%   truecolor, or binary images or strings that identify files containing these
%   same types of images.
%
%   CPSELECT(INPUT,BASE,CPSTRUCT_IN) starts CPSELECT with an initial set of
%   control points that are stored in CPSTRUCT_IN. This syntax allows you to
%   restart CPSELECT with the state of control points previously saved in
%   CPSTRUCT_IN.
%
%   CPSELECT(INPUT,BASE,XYINPUT_IN,XYBASE_IN) starts CPSELECT with a set of
%   initial pairs of control points. XYINPUT_IN and XYBASE_IN are M-by-2
%   matrices that store the INPUT and BASE coordinates respectively.
%
%   H = CPSELECT(INPUT,BASE,...) returns a handle H to the tool. CLOSE(H)
%   closes the tool.
%
%   CPSELECT(...,PARAM1,VAL1,PARAM2,VAL2,...) starts CPSELECT, specifying
%   parameters and corresponding values that control various aspects of the
%   tool. Parameter names can be abbreviated, and case does not matter.
%
%   Parameters include:
%
%   'Wait'             Logical scalar that controls whether CPSELECT
%                      waits for the user to finish the task of selecting
%                      points. If set to FALSE (the default) you can
%                      run CPSELECT at the same time as you run other 
%                      programs in MATLAB. If set to TRUE, you must
%                      finish the task of selecting points before doing
%                      anything else in MATLAB. 
%
%                      The value affects the output arguments:
%                        
%                         H = CPSELECT(...,'Wait',false) returns a handle 
%                         H to the tool. CLOSE(H) closes the tool.
%
%                         [XYINPUT_OUT,XYBASE_OUT] = CPSELECT(...,'Wait',true)
%                         returns the selected pairs of points. XYINPUT_OUT 
%                         and XYBASE_OUT are P-by-2 matrices that store the 
%                         INPUT and BASE coordinates respectively.
%
%   Class Support
%   -------------
%   The images can be truecolor, grayscale, or binary. A truecolor image can be
%   uint8, uint16, single, or double. A grayscale image can be uint8, uint16,
%   int16, single, or double. A binary image is of class logical.
%
%   Example 1
%   ---------
%   Start tool with saved images.
%
%       cpselect('westconcordaerial.png','westconcordorthophoto.png')
%
%   Example 2
%   ---------
%   Start tool with workspace images and points.
%
%       I = checkerboard;
%       J = imrotate(I,30);
%       base_points = [11 11; 41 71];
%       input_points = [14 44; 70 81];
%       cpselect(J,I,input_points,base_points);
%
%   Example 3
%   ---------  
%   Register an aerial photo to an orthophoto.
%  
%       aerial = imread('westconcordaerial.png');
%       figure, imshow(aerial)
%       figure, imshow('westconcordorthophoto.png')
%       load westconcordpoints % load some points that were already picked     
%
%       % Ask CPSELECT to wait for you to pick some more points
%       [aerial_points,ortho_points] = ...
%          cpselect(aerial,'westconcordorthophoto.png',...
%                     input_points,base_points,...
%                     'Wait',true);
%
%       t_concord = cp2tform(aerial_points,ortho_points,'projective');
%       info = imfinfo('westconcordorthophoto.png');
%       aerial_registered = imtransform(aerial,t_concord,...
%                                       'XData',[1 info.Width],...
%                                       'YData',[1 info.Height]);
%       figure, imshow(aerial_registered)                         
%
%   See also CPCORR, CP2TFORM, CPSTRUCT2PAIRS, IMTRANSFORM, IMTOOL.

%   Copyright 2005-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.17 $  $Date: 2011/10/11 15:49:06 $

%   Input-output specs
%   ------------------ 
%   INPUT,BASE:   filenames each containing a grayscale or truecolor image
%
%                OR 
%
%                real, full matrix
%                can be intensity or truecolor
%                uint8, uint16, double, or logical
%
%        Note: INPUT can be a filename while BASE is a variable or vice versa.
%
%   CPSTRUCT:    structure containing control point pairs with fields:
%                   inputPoints
%                   basePoints
%                   inputBasePairs
%                   ids
%                   inputIdPairs
%                   baseIdPairs
%                   isInputPredicted
%                   isBasePredicted
%
%   XYINPUT_IN, XYBASE_IN: M-by-2 matrices with control point coordinates.
%                          real, full, finite

[input, base, cpstruct, args] = ParseInputs(varargin{:});

% if args.Wait && nargout~=2
%   error(message('images:cpselect:Expected2OutputArgs'))
% end

% get names to label images
inputImageName = getImageName(varargin{1},inputname(1));
baseImageName = getImageName(varargin{2},inputname(2));

toolIdStream = idStreamFactory('CpselectInstance');
toolNumber = toolIdStream.nextId(); 

toolName = getString(message('images:cpselectUIString:toolName',toolNumber));

%Create invisible figure
hFig = figure('Toolbar','none',...
              'Menubar','none',...
              'HandleVisibility','callback',...
              'IntegerHandle','off',...
              'NumberTitle','off',...
              'Tag','cpselect',...
              'Name',toolName,...
              'Visible','off',...       % turn visibility off to prevent flash
              'DeleteFcn',@deleteTool,...
              'Position',getInitialPosition());
          
suppressPlotTools(hFig);

          
% Set default 'HitTest','off' as workaround to HG issue
% We only want to manually turn on 'HitTest' for objects that will have
% a 'ButtonDownFcn' set.
turnOffDefaultHitTestFigChildren(hFig);

[hScrollPanels,hImInput,hImBase,hSpInput,hSpBase] = ...
    leftRightImscrollpanel(hFig,input,base);
[hOverviewPanels,hImOvInput,hImOvBase] = ...
    leftRightImoverviewpanel(hFig,hImInput,hImBase);

% Stores the id returned by IPTADDCALLBACK for the image object's
% ButtonDownFcn callback.
ovInputImageButtonDownFcnId = [];
ovBaseImageButtonDownFcnId = [];

% Create titles
inputDetailLabel = getString(message('images:cpselectUIString:inputDetailLabel',inputImageName));
baseDetailLabel = getString(message('images:cpselectUIString:baseDetailLabel',baseImageName));

hMagPanel = lockRatioMagPanel(hFig,hImInput,hImBase,inputDetailLabel,baseDetailLabel);

% Turn on HitTest so ButtonDownFcn will fire when images are clicked
set([hImInput hImBase hImOvInput hImOvBase],'HitTest','on')

% Overall flow panel
hflow = uiflowcontainer('v0',...
                        'Parent',hFig,...
                        'FlowDirection','topdown',...
                        'Margin',1);

%Reparent subpanels 
set(hMagPanel,'Parent',hflow);
set(hMagPanel,'HeightLimits',[30 30]); % pin height

set(hScrollPanels,'Parent',hflow)
set(hOverviewPanels,'Parent',hflow)

% Get the scroll panel API to programmatically control the view
apiInput = iptgetapi(hSpInput);
apiBase = iptgetapi(hSpBase);

cpModeManager = makeUIModeManager(@makeDefaultModeCurrent);

toolbar = uitoolbar(hFig);

pointButtons = makePointButtons(toolbar);
buttons = navToolFactory(toolbar);
% %sk added

% 
% % pan
% s.iconConstructor            = @makeToolbarIconFromPNG;
% s.iconRoot                   = iconRoot;    
% s.icon                       = 'tool_hand.png';
% s.properties.TooltipString   = getString(message('images:imtoolUIString:panTooltipString'));
% s.properties.Tag             = 'pan toolbar button';
% tools.panTool = makeToolbarItem(s);

[addItem, addPredictItem, zoomInItem, zoomOutItem, panItem,...
 editMenuItems overviewMenuItem] = deal([]);
createMenubar % initialize menu items

% Set up modes such that tool and menu items stay in sync
% Must be defined after calling createToolbar, createMenubar  
activateAddPointMode = cpModeManager.addMode(...
  pointButtons.addPoint,  addItem,       @makeAddModeCurrent);
cpModeManager.addMode(...
  pointButtons.addPredict,addPredictItem,@makeAddPredictModeCurrent);
cpModeManager.addMode(...
  buttons.zoomInTool,     zoomInItem,    @makeZoomInModeCurrent);
cpModeManager.addMode(...
  buttons.zoomOutTool,    zoomOutItem,   @makeZoomOutModeCurrent);
cpModeManager.addMode(...
  buttons.panTool,        panItem,       @makePanModeCurrent);



pointItems = struct('addMenuItem',addItem,...
                    'addPredictMenuItem',addPredictItem,...
                    'addButton',pointButtons.addPoint,...
                    'addPredictButton',pointButtons.addPredict,...
                    'activateAddPointMode',activateAddPointMode);
cpAPI = cpManager(cpstruct,hImInput,hImOvInput,hImBase,hImOvBase,...
                  editMenuItems,pointItems);

% Initializing for function scope
cpstruct2Export = [];

% Start tool ready to add points
activateAddPointMode();

% Set up pointer manager
iptPointerManager(hFig);

set(hFig,'Visible','on'); % turn on visibility after all drawn to avoid flash

% Initialize magnification of images.
% Note: Need to call DRAWNOW here to make sure figure has come up before 
%       calling setMagnification or images won't be centered.
drawnow 
findInitMag = @(api) 2 * findZoomMag('in', api.findFitMag());
apiInput.setMagnification(findInitMag(apiInput))
apiBase.setMagnification(findInitMag(apiBase))

if args.Wait 
  uiwait(hFig)
  
  % Resuming because user either selected file->close from menus or clicked
  % close button of figure.  Both code paths lead to UIRESUME being called
  % which brings us back to here.
  if ishghandle(hFig)
      % If the figure handle still exists, we need to get the data out of it and
      % close the figure.
      cpstruct2Export = getCpstruct2Export();      
      close(hFig)   
  end
  
  [inputPoints,basePoints] = cpstruct2pairs(cpstruct2Export);
  
  varargout{1} = inputPoints;
  varargout{2} = basePoints;
  varargout{3} = cpstruct2Export;  %sk
  
else  
  set(hFig,'CloseRequestFcn',@closeRequestCpselect);
  
  if (nargout > 0)
    % Only return handle if caller requested it.
    varargout{1} = hFig;
  end

end

  %-------------------------------------
  function cpstruct = getCpstruct2Export
      cpstruct = cppairsvector2cpstruct(cpAPI.getInputBasePairs());
  end

  %-----------------------------------
  function setDetailImageMode(fun,ptr)

    removeDetailImageMode      
    
    enterFcn = @(f,cp) setptr(f,ptr);    
    iptSetPointerBehavior(hImInput, enterFcn);
    iptSetPointerBehavior(hImBase,  enterFcn);

    apiInput.setImageButtonDownFcn(fun)
    apiBase.setImageButtonDownFcn(fun)    
    
  end

  %-----------------------------
  function removeDetailImageMode
    
    fun = [];
    apiInput.setImageButtonDownFcn(fun)
    apiBase.setImageButtonDownFcn(fun)    
    
  end

  %-------------------------------
  function setAllImageCursors(ptr)
      
    enterFcn = @(f,cp) set(f, 'Pointer', ptr);
    
    iptSetPointerBehavior(hImInput,   enterFcn);
    iptSetPointerBehavior(hImBase,    enterFcn);
    iptSetPointerBehavior(hImOvInput, enterFcn);
    iptSetPointerBehavior(hImOvBase,  enterFcn);
    
  end
  
  %--------------------------------
  function setAllImageMode(fun,ptr)

    removeAllImageMode      

    setAllImageCursors(ptr)

    apiInput.setImageButtonDownFcn(fun)
    apiBase.setImageButtonDownFcn(fun)    
        
    if ~isempty(fun)
      ovInputImageButtonDownFcnId = iptaddcallback(hImOvInput,'ButtonDownFcn',fun);
      ovBaseImageButtonDownFcnId = iptaddcallback(hImOvBase,'ButtonDownFcn',fun);      
    else
      ovInputImageButtonDownFcnId = [];
      ovBaseImageButtonDownFcnId = [];
    end
    
  end

  %--------------------------
  function removeAllImageMode

    fun = [];
    
    apiInput.setImageButtonDownFcn(fun)
    apiBase.setImageButtonDownFcn(fun)    
  
    if ~isempty(ovInputImageButtonDownFcnId)
      iptremovecallback(hImOvInput,'ButtonDownFcn',ovInputImageButtonDownFcnId);
    end
    
    if ~isempty(ovBaseImageButtonDownFcnId)
      iptremovecallback(hImOvBase,'ButtonDownFcn',ovBaseImageButtonDownFcnId);
    end
    
  end

  %----------------------------------------
  function makeDefaultModeCurrent(varargin)

    fun = '';
    ptr = 'arrow';

    setAllImageMode(fun,ptr)

  end

  %---------------------------------------
  function makeZoomInModeCurrent(varargin)

    fun = @imzoomin;
    ptr = 'glassplus';    
    
    setDetailImageMode(fun,ptr)

  end

  %----------------------------------------
  function makeZoomOutModeCurrent(varargin)

    fun = @imzoomout;
    ptr = 'glassminus';
    
    setDetailImageMode(fun,ptr)

  end

  %------------------------------------
  function makePanModeCurrent(varargin)

    fun = @impan;
    ptr = 'hand';
    
    setDetailImageMode(fun,ptr)

  end

  %------------------------------------
  function makeAddModeCurrent(varargin)

    removeAllImageMode
    
    ptr = 'crosshair';
    setAllImageCursors(ptr)
    
    funInput = cpAPI.addInputPoint;
    funBase = cpAPI.addBasePoint;    

    wireInputImages(funInput)
    wireBaseImages(funBase)

  end
  
  %-------------------------------------------
  function makeAddPredictModeCurrent(varargin)

    removeAllImageMode      
    
    ptr = 'crosshair';
    setAllImageCursors(ptr)    
    
    funInput = cpAPI.addInputPointPredictBase;
    funBase = cpAPI.addBasePointPredictInput;    
 
    wireInputImages(funInput)
    wireBaseImages(funBase)

  end
    
  %---------------------------------
  function wireInputImages(funInput)
    
    apiInput.setImageButtonDownFcn(funInput)
        
    if ~isempty(funInput)
      ovInputImageButtonDownFcnId = iptaddcallback(hImOvInput,'ButtonDownFcn',funInput);
    else
      ovInputImageButtonDownFcnId = [];
    end

  end

  %-------------------------------
  
  function wireBaseImages(funBase)

    apiBase.setImageButtonDownFcn(funBase)    
        
    if ~isempty(funBase)
      ovBaseImageButtonDownFcnId = iptaddcallback(hImOvBase,'ButtonDownFcn',funBase);
    else
      ovBaseImageButtonDownFcnId = [];
    end
    
  end

  %----------------------------
  function deleteTool(varargin)
  
    if args.Wait
        cpstruct2Export = getCpstruct2Export();
    end
      
    % This call to delete is for performance purposes.  With larger numbers of
    % control points, delete occurs faster if hggroups defining control points
    % and their associated APIs containing callback functions are deleted in
    % advance of normal deletion order.
    delete(findobj(hFig,'Type','hggroup'));
    
    toolIdStream.recycleId(toolNumber);
    iptremovecallback(hFig,'KeyPressFcn',cpAPI.getKeyPressId())
    iptremovecallback(hFig,'WindowKeyPressFcn',cpAPI.getWindowKeyPressId())

  end  
  
  
  %---------------------------
  function createMenubar
  
    filemenu = uimenu(hFig,...
        'Label', getString(message('images:cpselectUIString:fileMenubarLabel')),...
        'Tag','file menu');
 
    
    editmenu = uimenu(hFig,...
        'Label', getString(message('images:cpselectUIString:editMenubarLabel')),...
        'Tag','edit menu');    
    
    viewmenu = uimenu(hFig,...
        'Label', getString(message('images:cpselectUIString:viewMenubarLabel')),...
        'Tag','view menu');
    
    toolmenu = uimenu(hFig,...
        'Label',getString(message('images:cpselectUIString:toolsMenubarLabel')),...
        'Tag','tools menu');
    
%     newFile = uimenu(hFig, 'Label','Load Multiple Image Files');
%     uimenu(newFile, 'Label','Select Next File', 'Callback',@loadmat)

    matlab.ui.internal.createWinMenu(hFig);


    helpmenu = uimenu(hFig,...
        'Label',getString(message('images:cpselectUIString:helpMenubarLabel')),...
        'Tag','help menu');
    
    % File menu items
    s = [];
    s.Parent = filemenu;

    if ~args.Wait
      % only add Export menu item if 'Wait',false
      s.Label = getString(message('images:cpselectUIString:exportPointsMenubarLabel'));
      s.Accelerator = 'E';
      s.Callback = @exportPoints;
      s.Tag = 'export points menu';
      uimenu(s);
    end

    s.Label = getString(message('images:cpselectUIString:closeMenubarLabel'));
    s.Accelerator = 'W';
    s.Callback = @closeCpselect;
    s.Tag = 'close menu';
    uimenu(s);
    
    % Edit menu items
    s = [];
    s.Parent = editmenu;
    
    s.Label = getString(message('images:cpselectUIString:deleteActivePairMenubarLabel'));
    s.Callback = @deleteActivePair;
    s.Tag = 'delete active pair menu';
    editMenuItems.deleteActivePair = uimenu(s);

    s.Label = getString(message('images:cpselectUIString:deleteActiveInputPointMenubarLabel'));
    s.Callback = @deleteActiveInputPoint;
    s.Tag = 'delete active input point menu';
    editMenuItems.deleteActiveInputPoint = uimenu(s);
    
    s.Label = getString(message('images:cpselectUIString:deleteActiveBasePointMenubarLabel'));
    s.Callback = @deleteActiveBasePoint;
    s.Tag = 'delete active base point menu';
    editMenuItems.deleteActiveBasePoint = uimenu(s);

    % View menu items    
    s = [];
    s.Parent = viewmenu;

    s.Label = getString(message('images:cpselectUIString:overviewImagesMenubarLabel'));
    s.Checked = 'on';
    s.Callback = @toggleShowOverview;
    s.Tag = 'overview images menu';
    overviewMenuItem = uimenu(s);
    
    % Tools menu items
    s = [];
    s.Parent = toolmenu;

    s.Label = getString(message('images:cpselectUIString:addPointsMenubarLabel'));
    s.Tag = 'add points menu';
    addItem = uimenu(s);

    s.Label = getString(message('images:cpselectUIString:addPredictMatchesMenubarLabel'));
    s.Tag = 'add points predict matches menu';
    addPredictItem = uimenu(s);
    
    s.Label = getString(message('images:commonUIString:zoomInMenubarLabel'));
    s.Tag = 'cpselect zoom in menu';
    zoomInItem = uimenu(s);

    s.Label = getString(message('images:commonUIString:zoomOutMenubarLabel'));
    s.Tag = 'cpselect zoom out menu';
    zoomOutItem = uimenu(s);

    s.Label = getString(message('images:commonUIString:panMenubarLabel'));
    s.Tag = 'cpselect pan menu';
    panItem = uimenu(s);

   
    
    % Help menu items     
    s.Parent = helpmenu;
    s.Label = getString(message('images:cpselectUIString:cpselectHelpMenubarLabel'));
    s.Callback = @showCPSTHelp;
    s.Tag = 'cpselect help menu';
    uimenu(s);
    iptstandardhelp(helpmenu);
    
  end
  
  %------------------------------------------
  function okPressed = exportPoints(varargin)

    cpstruct2Export = getCpstruct2Export();
    [inputPoints,basePoints] = cpstruct2pairs(cpstruct2Export);

    if isempty(inputPoints)
        warndlg(getString(message('images:cpselectUIString:pairsWarnDlg')));
        return
    end
    
    checkboxlabels = {getString(message('images:cpselectUIString:inputPointsOfValidPairs')),...
                      getString(message('images:cpselectUIString:basePointsOfValidPairs')),...
                      getString(message('images:cpselectUIString:structWithAllPoints'))};
    
    defaultvarnames = {'input_points',...
                       'base_points',...
                       'cpstruct'};
    
    exportTitle = getString(message('images:cpselectUIString:exportTitle'));
    
    selected = [true true false];
    
    items2export = {inputPoints, basePoints, cpstruct2Export};
    
    [~,okPressed] = ...
        export2wsdlg(checkboxlabels,defaultvarnames,items2export,...
                     exportTitle,selected);
    
  end

  %-------------------------------
  function closeCpselect(varargin)

    if ~args.Wait
      unsavedPoints = cpAPI.getNeedToSave();
      
      if unsavedPoints
        saveIfUserRequestsSave()
      else
        delete(hFig)
      end

    else
      % Waiting for user to hit close which they've done.
      uiresume(hFig)
      
    end      
    
  end

  %------------------------------
  function saveIfUserRequestsSave

      button = questdlg(getString(message('images:cpselectUIString:saveQuestDlgText')),...
                        getString(message('images:cpselectUIString:dialogTitle')));
      
      if isempty(button)
          % user hit close button on dialog
          return
      end
      
      if strcmp(button,'Yes')
          okPressed = exportPoints();
          
          if okPressed
              delete(hFig)
          end
          
      elseif strcmp(button,'No')
          delete(hFig)
          
      end

  end
  
  %--------------------------------------
  function closeRequestCpselect(varargin)

    try
      unsavedPoints = cpAPI.getNeedToSave();
    
      if unsavedPoints
        button = questdlg(getString(message('images:cpselectUIString:closeRequestDlgText')),...
                          getString(message('images:cpselectUIString:dialogTitle')),...
                          getString(message('images:commonUIString:ok')),...
                          getString(message('images:commonUIString:cancel')),...
                          getString(message('images:commonUIString:ok')));
        
        if isempty(button)
          % user hit close button on dialog
          return
        end
        
        if strcmp(button,getString(message('images:commonUIString:ok')))
          delete(hFig)
        end
        
      else
        delete(hFig)
        
      end

    catch m_exception
      % For some reason cpAPI not initialized
      delete(hFig)
    end
    
  end

  %----------------------------------------
  function toggleShowOverview(src,varargin)
    
    % If you just clicked on a menu item, it has the 'Checked' 
    % status from prior to your click.
    previouslyChecked = strcmp(get(src,'Checked'),'on');          
    showOverview = ~previouslyChecked;
  
    state = logical2onoff(showOverview);
    set(overviewMenuItem,'Checked',state)
    set(hOverviewPanels,'Visible',state)
    
  end
  
end % cpselect
   
%-------------------------------------------------------------
function [input, base, cpstruct, args] = ParseInputs(varargin)

  % defaults
  args.Wait = false;
  first_param_idx = [];
  
  % initialize empty cpstruct
  cpstruct = struct('inputPoints',{},...
                    'basePoints',{},...
                    'inputBasePairs',{},...
                    'ids',{},...
                    'inputIdPairs',{},...
                    'baseIdPairs',{},...
                    'isInputPredicted',{},...
                    'isBasePredicted',{});

  narginchk(2,6); 

  input = parseImage(varargin{1});
  base = parseImage(varargin{2});
  
  switch nargin
   case 2
    % CPSTRUCT = CPSELECT(INPUT,BASE)
    return;
    
   case 3
    % CPSTRUCT = CPSELECT(INPUT,BASE,CPSTRUCT)

    % TO DO: add more validation on cpstruct
    if iscpstruct(varargin{3})
      cpstruct = varargin{3};
    else
      error(message('images:cpselect:CPSTRUCTMustBeStruct'));
    end
    
   case 4
    
    if ischar(varargin{3})
      first_param_idx = 3;
    else
      
      % CPSTRUCT = CPSELECT(INPUT,BASE,XYINPUT_IN,XYINPUT_OUT)    
      cpstruct = loadAndValidatePoints(varargin{3:4});
      
    end
    
  otherwise  
    
    if ischar(varargin{5})
      first_param_idx = 5;
      
      % CPSTRUCT = CPSELECT(INPUT,BASE,XYINPUT_IN,XYINPUT_OUT,PARAM,VAL,...)    
      cpstruct = loadAndValidatePoints(varargin{3:4});
      
    else
      error(message('images:cpselect:expected5thArgString'))
      
    end
      
  end

  if ~isempty(first_param_idx)
    %parse param name/value pairs
    valid_params = {'Wait'};
    args = parseParamValuePairs(varargin(first_param_idx:end),valid_params,...
                                first_param_idx-1,...
                                mfilename);
  end
  
end

%--------------------------------------------------------------
function cpstruct = loadAndValidatePoints(xyinput_in,xybase_in)
  
  validateattributes(xyinput_in,{'double'},...
                {'real','nonsparse','finite','2d','nonempty'},...
                mfilename,'XYINPUT_IN',3);
  validateattributes(xybase_in, {'double'},...
                {'real','nonsparse','finite','2d','nonempty'},...
                mfilename,'XYBASE_IN',4);
      
      
  if size(xyinput_in,1) ~= size(xybase_in,1) || ...
        size(xyinput_in,2) ~= 2 || size(xybase_in,2) ~= 2  
    error(message('images:cpselect:expectedMby2'));
  end
      
  cpstruct = xy2cpstruct(xyinput_in,xybase_in);

end
    
%------------------------------------------------------------------------
function args = parseParamValuePairs(in,valid_params,num_pre_param_args,...
                                     function_name)

  if rem(length(in),2)~=0
    error(message('images:cpselect:oddNumberArgs'))
  end    

  for k = 1:2:length(in)
    prop_string = validatestring(in{k}, valid_params, function_name,...
                               'PARAM', num_pre_param_args + k);
    
    switch prop_string
     case 'Wait'
      validateattributes(in{k+1}, {'logical'},...
                    {'scalar'}, ...
                    mfilename, 'WAIT', num_pre_param_args+k+1);
      args.(prop_string) = in{k+1};
      
     otherwise
      error(message('images:cpselect:unrecognizedParameter', prop_string, function_name));
      
    end
  end

end

%-------------------------------
function [img] = parseImage(arg)

img = []; %#ok<NASGU>

if ischar(arg)
    try 
        info = imfinfo(arg);
        if strncmp(info.ColorType,'indexed',length(info.ColorType))
            error(message('images:cpselect:imageMustBeGrayscale', arg))
        end
        img = imread(arg);
    catch m_exception
        error(message('images:cpselect:imageNotValid', arg))
    end
else 
    img = arg;
end

end

%----------------------------------------------------
function cpstruct = xy2cpstruct(xyinput_in,xybase_in)

% Create a cpstruct given two lists of equal numbers of points.

M = size(xyinput_in,1);
ids = (0:M-1)';
isPredicted = zeros(M,1);

% assign fields to cpstruct
cpstruct.inputPoints = xyinput_in;
cpstruct.basePoints = xybase_in;
cpstruct.inputBasePairs = bsxfun(@plus, ones(size(ids,1), 2), ids);
cpstruct.ids = ids;
cpstruct.inputIdPairs = cpstruct.inputBasePairs;
cpstruct.baseIdPairs = cpstruct.inputBasePairs;
cpstruct.isInputPredicted = isPredicted;
cpstruct.isBasePredicted = isPredicted;

end

%------------------------------
function showCPSTHelp(varargin)

    topic = 'cpselect_gui';
    helpview([docroot '/toolbox/images/images.map'],topic);

end    

%-------------------------------------------
function buttons = makePointButtons(toolbar)

  % Common properties
  s.toolConstructor            = @uitoggletool;
  s.properties.Parent          = toolbar;
  s.iconConstructor            = @makeToolbarIconFromPNG;
  s.iconRoot                   = ipticondir;    
  
  % Add points
  s.icon                       = 'point.png';
  s.properties.TooltipString   = getString(message('images:cpselectUIString:addPointsTooltip'));
  s.properties.Tag             = 'add points';    
  buttons.addPoint             = makeToolbarItem(s);
  
  % Add points and predict matches
  s.icon                       = 'point_predicted.png';
  s.properties.TooltipString   = getString(message('images:cpselectUIString:addPredictMatchesTooltip'));
  s.properties.Tag             = 'add points and predict matches';  
  buttons.addPredict           = makeToolbarItem(s);
  
  

end

%------------------------------------
function initPos = getInitialPosition
    
    wa = getWorkArea();
    
    % Specify fraction of work area to fill
    SCALE = 0.8; 
            
    w = SCALE*wa.width;
    h = SCALE*wa.height;
    x = wa.left + (wa.width - w)/2;
    y = wa.bottom + (wa.height - h)/2; 
    
    initPos = round([x y w h]);
    
end

%---------- sk added
%callbacks and subfunctions

 function loadmat (obj, evt)
        orginaldir=pwd;
%         [f,p,i] = uigetfile(['/*.mat'],'Pick a r.mat file', orginaldir);
%         if ~i; return; end
%         vars = load([p f]);
        loadmatIndicator=1
    end
