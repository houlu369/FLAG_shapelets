addpath('data');
addpath('functions');
% addpath('libsvm-3.20');

names = {'Adiac','Beef','ChlorineConcentration','Coffee','DiatomSizeReduction',...
    'DP_Little','DP_Middle','DP_Thumb','ECGFiveDays','FaceFour', ...
    'Gun_Point','ItalyPowerDemand','Lighting7','MedicalImages','MoteStrain',...
    'MP_Little','MP_Middle','Herrings', 'PP_Little','PP_Middle',...
    'PP_Thumb','SonyAIBORobotSurface','Symbols','synthetic_control','Trace','TwoLeadECG' };

fp = fopen('results.txt','w');
fprintf(fp,'%25s %25s %25s','data set', 'test accuracy', 'discovery time(s)');
fprintf(fp,'\r\n');

% \alpha_1 and \alpha_2 from cross-validation
alpha1 = [ 0.10, 0.10, 0.08, 0.10, 0.02,...
    0.04, 0.10, 0.04, 0.04, 0.02,...
    0.02, 0.08, 0.10, 0.04, 0.04,...
    0.04, 0.06, 0.08, 0.02, 0.10,...
    0.02, 0.04, 0.08, 0.08, 0.02, 0.10];
alpha2 = [ 0.03, 0.03, 0.01, 0.01, 0.02,...
    0.04, 0.03, 0.01, 0.03, 0.04,...
    0.03, 0.05, 0.05, 0.01, 0.04,...
    0.01, 0.02, 0.01, 0.01, 0.01,...
    0.01, 0.04, 0.04, 0.02, 0.02, 0.02];

acc = zeros(length(names),1);
distime = zeros(length(names),1);

for fi = 1:26
    
    % initialization
    name = names{fi};
    TRAIN = importdata(['data/',name,'_TRAIN']);
    TEST = importdata(['data/',name,'_TEST']);
    initialization;
    
    % shapelets learning
    shapelets =[];
    index = [];
    randn('seed',1);
    t = tic;
    if fi==11 || fi==15
        v = admm(C, 1,2,alpha1(fi), alpha2(fi));
        block = extracts (v);
        [shapelets,index] = AutoShapeletGeneration(block,1,TRAIN,TRAIN_class_labels);
        
    else
        for classiter = 1:K
            v = admmmul(C, classiter,alpha1(fi), alpha2(fi));
            block = extracts (v);           
            [shapeletstmp,indextmp] = AutoShapeletGeneration(block,classiter,TRAIN,TRAIN_class_labels);
            shapelets = [shapelets;shapeletstmp];
            index = [index;indextmp];     
        end
    end
    
    distime(fi) = toc(t);
    %use z-normalized euclidean distance to transform the data
    D_tr = transnew(TRAIN',shapelets,index);
    D_ts =transnew(TEST',shapelets,index);    

    % svm classifier
    SVMStruct = svmtrain(TRAIN_class_labels,D_tr,'-t 0 -c 100');
    [~,accu,~] = svmpredict(TEST_class_labels,D_ts,SVMStruct);
    acc(fi) = accu(1);
    
    % save the results
    fprintf(fp,'%25s ',name);
    fprintf(fp,'%25.1f ',acc(fi));
    fprintf(fp,'%25.1f ',distime(fi));
    fprintf(fp,'\r\n');
end
fclose(fp);


