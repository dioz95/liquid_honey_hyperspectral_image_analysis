close all
clear all
clc

rng(1);

numFolding  = 10;
nComp       = 15;

[FileName,PathName,~] = uigetfile('*.MAT', 'Pilih file Feature Set', 'MultiSelect', 'off');
if isequal(FileName, 0)
    msgbox('Pembatalan dilakukan', 'Canceled');
    return
end

load([PathName FileName]);

% Check Type of Class
UnikKelas_2     = unique(kelas_2);
kelas_2_idx     = cell(size(UnikKelas_2));
kelas_2_str     = cell(size(UnikKelas_2));
for i=1:size(UnikKelas_2,1)
    kelas_2_str{i}  = upper(UnikKelas_2{i,1});
    kelasIdx        = strfind(kelas_2, kelas_2_str{i});
    kelas_2_idx{i}  = find(not(cellfun('isempty', kelasIdx)));
end

Transmittance = [cropTransmittance];

% Select target variable
target = 'ec';

switch target
    case 'brix'
        atributVal = atribut_1_val;
    case 'ph'
        atributVal = atribut_2_val;
    otherwise 'ec'
        atributVal = atribut_3_val;
end

CVO         = cvpartition(kelas_2,'k',numFolding);

rmseGPRTr    = zeros(CVO.NumTestSets,1);
rmseGPRTe    = zeros(CVO.NumTestSets,1);
rmspeGPRTr   = zeros(CVO.NumTestSets,1);
rmspeGPRTe   = zeros(CVO.NumTestSets,1);
corrCoeffTr   = zeros(CVO.NumTestSets,1);
corrCoeffTe   = zeros(CVO.NumTestSets,1);
testNo        = zeros(CVO.NumTestSets,1);

for i = 1:CVO.NumTestSets
    testNo(i) = i;
    trIdx = CVO.training(i);
    teIdx = CVO.test(i);
     
    % Train PLS
    [XL,YL,XS,YS,Beta,PCTVAR,MSE,stats] = plsregress(Transmittance(trIdx,:),atributVal(trIdx), nComp);
     
    % Train GPR Model
    XStr            = Transmittance(trIdx,:)*XL;
    gprStruct       = fitrgp(XStr,atributVal(trIdx));
    
    % Predict Training Data using gprStruct
    atributValGPRTr  = predict(gprStruct, XStr);
    rmseGPRTr(i)     = errPerf(atributVal(trIdx),atributValGPRTr,'mse');
    rmspeGPRTr(i)    = errPerf(atributVal(trIdx,:),atributValGPRTr,'rmspe');
    
    % Predict Testing Data using gprStruct
    XSte             = Transmittance(teIdx,:)*XL;
    atributValGPRTe  = predict(gprStruct, XSte);
    rmseGPRTe(i)     = errPerf(atributVal(teIdx),atributValGPRTe,'mse');
    rmspeGPRTe(i)    = errPerf(atributVal(teIdx,:),atributValGPRTe,'rmspe');
    
    % Testing - Correlation coefficients on Training Data
     [p,S,mu]        = polyfit(atributVal(trIdx),atributValGPRTr,1);
     RTr             = corrcoef(atributVal(trIdx),atributValGPRTr);
     corrCoeffTr(i)  = RTr(1,2);
     
     % Testing - Correlation coefficients on Testing Data
     [p,S,mu]        = polyfit(atributVal(teIdx),atributValGPRTe,1);
     RTe             = corrcoef(atributVal(teIdx),atributValGPRTe);
     corrCoeffTe(i)  = RTe(1,2);

end

% Plot Variance per Component
 figure;
 plot(1:nComp,cumsum(100*PCTVAR(2,:)),'-bo');
 xlabel('Number of PLS components');
 ylabel('Percent Variance Explained in Y');
 
% Plot predicted vs true
figure;
plot(atributVal(teIdx),atributVal(teIdx),'bo');
hold on;
plot(atributVal(teIdx),atributValGPRTe,'r^');
xlabel('True');
ylabel('Predicted');
legend('Data','GPR predictions');
hold off 

% Plot linear regression
figure;
plotregression(atributVal(teIdx),atributValGPRTe,'Regression')

errorTable = table(testNo, rmspeGPRTr, rmspeGPRTe, corrCoeffTr, corrCoeffTe);
disp(errorTable);

% disp(['Rata-rata RMSE PLS-GPR on Training Data ' num2str(mean(rmseGPRTr), '%.2f')]);
% disp(['Rata-rata RMSE PLS-GPR on Testing Data ' num2str(mean(rmseGPRTe), '%.2f')]);
disp(['Rata-rata RMSPE PLS-GPR on Training Data ' num2str(mean(rmspeGPRTr),'%.2f'),'%']);
disp(['Rata-rata RMSPE PLS-GPR on Testing Data ' num2str(mean(rmspeGPRTe),'%.2f'),'%']);
disp(['Rata-rata Correlation Coefisient on Training Data ' num2str(mean(corrCoeffTr), '%.2f')]);
disp(['Rata-rata Correlation Coefisient on Testing Data ' num2str(mean(corrCoeffTe), '%.2f')]);