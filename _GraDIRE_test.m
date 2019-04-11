% GraDIRE script

% pj_filename         = 'data_turb3/pj_new_Turbu3_1015.mat';
% angle_filename      = 'data_turb3/angles_usedin_refine_1015.mat';
pj_filename         = 'data_Dennis/projs_allposi.mat';
angle_filename      = 'data_Dennis/angles.mat';

% results_filename    = 'results/GD_tomo_res.mat';
% filenameFinalRecon  = 'results/GD_tomo_recon.mat';
results_filename    = 'results_Dennis/GD_tomo_res.mat';
filenameFinalRecon  = 'results_Dennis/GD_tomo_recon.mat';

%% GraDIRE parameters

GraDIRE = GraDIRE_Reconstructor();

GraDIRE.filename_Projections    = pj_filename;
GraDIRE.filename_Angles         = angle_filename ;
GraDIRE.filename_Results        = results_filename;

GraDIRE = GraDIRE.set_parameters(...
    'oversamplingRatio' ,3    ,'numIterations'       ,50 ,... 
    'monitor_R'         ,true ,'monitorR_loopLength' ,10 ,... 
    'griddingMethod'    ,1    ,'vector3'             ,[1 0 0]);

GraDIRE = readFiles(GraDIRE);
GraDIRE = CheckPrepareData(GraDIRE);
GraDIRE = runGridding(GraDIRE); 
GraDIRE = reconstruct(GraDIRE);
% SaveResults(GENFIRE);
%%

[Rfactor,Rarray,simuProjs]=Tian_calc_Rfactor_realspace...
    (GraDIRE.reconstruction,GraDIRE.InputProjections,GraDIRE.InputAngles);
final_Rec       = GraDIRE.reconstruction;
final_Rfactor   = Rfactor;
final_Rarray    = Rarray;
final_simuProjs = simuProjs;

% GraDIRE = ClearCalcVariables(GraDIRE);

save(filenameFinalRecon, 'final_Rec','final_Rfactor','final_Rarray','final_simuProjs');


