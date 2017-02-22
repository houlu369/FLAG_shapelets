
TRAIN_class_labels = TRAIN(:,1);     % Pull out the class labels.
TRAIN(:,1) = [];                     % Remove class labels from training set.
TEST_class_labels = TEST(:,1);       % Pull out the class labels.
TEST(:,1) = [];                      % Remove class labels from testing set.

TRAIN_class_labels(TRAIN_class_labels==-1)=0;
TEST_class_labels(TEST_class_labels==-1)=0;

%make class labels from all data sets start from 1
if min(TRAIN_class_labels)==0
    TRAIN_class_labels = TRAIN_class_labels +1;
    TEST_class_labels = TEST_class_labels +1;
end

K = length(unique(TRAIN_class_labels));
[N,Q] = size(TRAIN);
N1 = size(TEST,1);

% z-normalize all the timeseries 
for k = 1:N
    TRAIN(k,:) =zscore(TRAIN(k,:)) ;
end
for k = 1:N1
    TEST(k,:) =zscore(TEST(k,:)) ;
end

C = comC(TRAIN, TRAIN_class_labels,K);