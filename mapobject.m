% function result = mapObjectinvarience(varargin)
% cd('D:\Users\USER\Downloads\Psychtoolbox\Psychtoolbox\');
% savepath
% SetupPsychtoolbox;%for some reason every time I restart I have to set it up all over. type no and then yes and wait.
clear all;close all; clc
objectpath1='D:\doyeon_kim\object invariance\obejctinvarience\s_chromosome.obj'; 
objectpath2='D:\doyeon_kim\object invariance\obejctinvarience\tripod.obj'; 
objectname1='chromosome';
objectname2='tripod';
% p = inputParser;
% p.addParameter('rig',0);
% p.addParameter('objectpath',objectpath);
% p.addParameter('scale',0.08);

% % at the current setting, each stim presentation is 1.5s.
% % parameters that affect stim duration: 'orientations' (length of vector),'tFreq', 'nCycles'
% p.parse(varargin{:});
%
% result = p.Results;
global win; %#ok<*GVMIS>
% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;
splitdegree=10;
Nsplit=360/splitdegree+1;
perpixellighting = 0;
textureon = 0;
dotson = 0;
normalson = 0;
% scale=result.scale;
scale=0.15;
display= 1;
KbName('UnifyKeyNames');
closer = KbName('r');
farther = KbName('e');
quitkey = KbName('ESCAPE');
rotateleft = KbName('a');
rotateright = KbName('d');
rotateup = KbName('w');
rotatedown = KbName('s');
objs1 = LoadOBJFile(objectpath1);
screenid=max(Screen('Screens'));
oldskip = Screen('Preference','SkipSyncTests', 1);
InitializeMatlabOpenGL;
if display>1
    rect = [];
else
    rect = [0 0 500 800];
end
PsychImaging('PrepareConfiguration');
[win , winRect] = PsychImaging('OpenWindow', screenid, [128 128 128], [0 0 800 500]);
moglmorpher('reset');
meshid1 = moglmorpher('addMesh', objs1{1}); %#ok<AGROW,NASGU>
count = moglmorpher('getMeshCount') %#ok<NOPRT,NASGU>
Screen('BeginOpenGL', win);
if perpixellighting==1
    shaderpath = [PsychtoolboxRoot '/PsychDemos/OpenGL4MatlabDemos/GLSLDemoShaders/'];
    glsl=LoadGLSLProgramFromFiles([shaderpath 'Pointlightshader'],1);
    glUseProgram(glsl);
end
ar=winRect(4)/winRect(3);
glEnable(GL.LIGHTING);
glEnable(GL.COLOR_MATERIAL);
glEnable(GL.LIGHT0);
glEnable(GL.DEPTH_TEST);
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.5 0.5 0.5 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ .7 .7 .7 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR, [ 0.2 0.2 0.2 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS,12);
glEnable(GL.NORMALIZE);
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(25.0,1/ar,0.1,200.0);
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
glLightfv(GL.LIGHT0,GL.POSITION,[0 0 20 0]);
glLightfv(GL.LIGHT0,GL.DIFFUSE, [ 1 1 1 1 ]);
glLightfv(GL.LIGHT0,GL.SPECULAR, [ 1 1 1 1 ]);
glLightfv(GL.LIGHT0,GL.AMBIENT, [ 0.2 0.2 0.2 1 ]);
glPointSize(3.0);
glLineWidth(2.0);
glPolygonOffset(0, 0);
if ~IsGLES
    glEnable(GL.POLYGON_OFFSET_LINE);
else
    if dotson ~= 0
        fprintf('Non zero dotson settings are not supported on OpenGL-ES hardware. Reverting to zero.\n');
        dotson = 0;
    end
end
glEnable(GL.BLEND);
glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
theta=0;
rotatev=[ 0 1 0 ];
w=[ 0 1 ];
zz = 0.0;
xang = 237;
yang = 90.0;
eye_halfdist=3;
Screen('EndOpenGL', win);
ifi = Screen('GetFlipInterval', win);
vbl=Screen('Flip', win);
tstart=vbl;
framecount = 0;
waitframes = 1;
t = GetSecs;
objectimage1=struct();
for N= 1:Nsplit
    Screen('BeginOpenGL', win);
    glLoadIdentity;
    gluLookAt(-eye_halfdist, 0, zz, 0, 0, 0, 0, 1, 0);
    Screen('EndOpenGL', win);
    Screen('BeginOpenGL', win);
    glClear(GL.DEPTH_BUFFER_BIT);
    drawShape(xang,yang, scale,theta, rotatev, dotson, normalson);
    yang=yang+splitdegree;
    Screen('EndOpenGL', win);
    imageArray1=Screen('GetImage', win, [], 'drawBuffer');
    objectimage1(N).imagearray=rgb2gray(imageArray1);
    Screen('DrawingFinished', win);
    % 회전
    % theta=mod(theta+0.1, 360);
    % rotatev=rotatev+0.01*[ sin((pi/180)*theta) sin((pi/180)*2*theta) sin((pi/180)*theta/5) ];
    % rotatev=rotatev/sqrt(sum(rotatev.^2));
    moglmorpher ('renderMorph', meshid1);

    % [KeyIsDown, ~, KeyCode] = KbCheck;
    % if KeyIsDown
    %     if ( KeyIsDown==1 && KeyCode(closer)==1 )
    %         zz=zz-0.1;
    %         KeyIsDown=0;
    %     end
    %     if ( KeyIsDown==1 && KeyCode(farther)==1 )
    %         zz=zz+0.1;
    %         KeyIsDown=0;
    %     end
    %     if ( KeyIsDown==1 && KeyCode(rotateright)==1 )
    %         yang=yang+1.0;
    %         KeyIsDown=0;
    %     end
    %     if ( KeyIsDown==1 && KeyCode(rotateleft)==1 )
    %         yang=yang-1.0;
    %         KeyIsDown=0;
    %     end
    %     if ( KeyIsDown==1 && KeyCode(rotateup)==1 )
    %         xang=xang+1.0;
    %         KeyIsDown=0;
    %     end
    %     if ( KeyIsDown==1 && KeyCode(rotatedown)==1 )
    %         xang=xang-1.0;
    %         KeyIsDown=0;
    %     end
    %
    %     if ( KeyIsDown==1 && KeyCode(quitkey)==1 )
    %         break;
    %     end
    % end
    framecount = framecount + 1;
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
end
objs2 = LoadOBJFile(objectpath2);
screenid=max(Screen('Screens'));
oldskip = Screen('Preference','SkipSyncTests', 1);
InitializeMatlabOpenGL;
if display>1
    rect = [];
else
    rect = [0 0 500 800];
end
PsychImaging('PrepareConfiguration');
[win , winRect] = PsychImaging('OpenWindow', screenid, [128 128 128], [0 0 800 500]);
moglmorpher('reset');
meshid2 = moglmorpher('addMesh', objs2{1}); %#ok<AGROW,NASGU>
count = moglmorpher('getMeshCount') %#ok<NOPRT,NASGU>
Screen('BeginOpenGL', win);
if perpixellighting==1
    shaderpath = [PsychtoolboxRoot '/PsychDemos/OpenGL4MatlabDemos/GLSLDemoShaders/'];
    glsl=LoadGLSLProgramFromFiles([shaderpath 'Pointlightshader'],1);
    glUseProgram(glsl);
end
ar=winRect(4)/winRect(3);
glEnable(GL.LIGHTING);
glEnable(GL.COLOR_MATERIAL);
glEnable(GL.LIGHT0);
glEnable(GL.DEPTH_TEST);
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 0.5 0.5 0.5 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ .7 .7 .7 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR, [ 0.2 0.2 0.2 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS,12);
glEnable(GL.NORMALIZE);
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(25.0,1/ar,0.1,200.0);
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
glLightfv(GL.LIGHT0,GL.POSITION,[0 0 20 0]);
glLightfv(GL.LIGHT0,GL.DIFFUSE, [ 1 1 1 1 ]);
glLightfv(GL.LIGHT0,GL.SPECULAR, [ 1 1 1 1 ]);
glLightfv(GL.LIGHT0,GL.AMBIENT, [ 0.2 0.2 0.2 1 ]);
glPointSize(3.0);
glLineWidth(2.0);
glPolygonOffset(0, 0);
if ~IsGLES
    glEnable(GL.POLYGON_OFFSET_LINE);
else
    if dotson ~= 0
        fprintf('Non zero dotson settings are not supported on OpenGL-ES hardware. Reverting to zero.\n');
        dotson = 0;
    end
end
glEnable(GL.BLEND);
glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
theta=0;
rotatev=[ 0 1 0 ];
w=[ 0 1 ];
zz = 0.0;
xang = 237;
yang = 90.0;
eye_halfdist=3;
Screen('EndOpenGL', win);
ifi = Screen('GetFlipInterval', win);
vbl=Screen('Flip', win);
tstart=vbl;
framecount = 0;
waitframes = 1;
t = GetSecs;
objectimage2=struct();

for N= 1:Nsplit
    Screen('BeginOpenGL', win);
    glLoadIdentity;
    gluLookAt(-eye_halfdist, 0, zz, 0, 0, 0, 0, 1, 0);
    Screen('EndOpenGL', win);
    Screen('BeginOpenGL', win);
    glClear(GL.DEPTH_BUFFER_BIT);
    drawShape(xang,yang, scale,theta, rotatev, dotson, normalson);
    yang=yang+splitdegree;
    Screen('EndOpenGL', win);
    imageArray2=Screen('GetImage', win, [], 'drawBuffer');
    objectimage2(N).imagearray=rgb2gray(imageArray2);
    Screen('DrawingFinished', win);
    moglmorpher ('renderMorph', meshid2);
    if 0
        mverts = moglmorpher('getGeometry'); %#ok<UNRCH>
        scatter3(mverts(1,:), mverts(2,:), mverts(3,:));
        drawnow;
    end
    framecount = framecount + 1;
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
end
vbl = Screen('Flip', win);
fps = framecount / (vbl - tstart) %#ok<NOPRT,NASGU>
moglmorpher('reset');
sca;
ListenChar(0);
Screen('Preference','SkipSyncTests', oldskip);
% return

save_path='D:\doyeon_kim\object invariance\obejctinvarience';
screenSize = get(0, 'ScreenSize');
figure('Position', screenSize);
for N = 2:Nsplit
    subplot(6,6,N-1);imagesc(objectimage1(N).imagearray);colormap gray
end
filename1 = sprintf('%s turned around- light directly coming from upfront.png',objectname1);
saveas(gcf, fullfile(save_path, filename1));

figure('Position', screenSize);
for N = 2:Nsplit
    subplot(6,6,N-1);imagesc(objectimage2(N).imagearray);colormap gray
end

filename2 = sprintf('%s turned around- light directly coming from upfront.png',objectname2);
saveas(gcf, fullfile(save_path, filename2));
%%
correlationMatrix = zeros(Nsplit-1, Nsplit-1);

for i = 2:Nsplit
    for j = 2:Nsplit
        correlation = corr(double(objectimage1(i).imagearray(:)), double(objectimage2(j).imagearray(:)));
        correlationMatrix(i-1,j-1) = correlation;
    end
end

eh=sort(correlationMatrix(:), 'descend');
eh=eh(~isnan(eh));
top10=eh(1:10,1);
for i=1:10
    [row, col] = find(correlationMatrix ==  top10(i));
    disp([row,col])
end
% heatmap 그리기
figure('Position', screenSize);
h = heatmap(1:Nsplit-1, 1:Nsplit-1, correlationMatrix);
title(sprintf('Correlation Heatmap between object 1 %s and object 2 %s',objectname1,objectname2));
colormap(h, slanCM('bwr'));
h.XLabel = objectname2;%축,j
h.YLabel = objectname1;
h.ColorbarVisible = 'on'; % 컬러바
h.CellLabelFormat = '%0.4f';
filename = sprintf('(light directly coming from upfront) reshaped heatmap of correlation between %s and %s.png',objectname1,objectname2);
saveas(gcf, fullfile(save_path, filename));
close all
