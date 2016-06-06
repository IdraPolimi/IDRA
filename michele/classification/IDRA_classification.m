close all;



target_column = 5;
n_classes = 3; %they are labaled from 1 to n


%    simpleclass_dataset   - Simple pattern recognition dataset.
%    cancer_dataset        - Breast cancer dataset.
%    crab_dataset          - Crab gender dataset.
%    glass_dataset         - Glass chemical dataset.
%    iris_dataset          - Iris flower dataset.
%    thyroid_dataset       - Thyroid function dataset.
%    wine_dataset          - Italian wines dataset.

[data, targets] = glass_dataset;
data = data';
targets = targets';

ch = ClassificationHelper();

[training_indeces, test_indeces, validation_indeces] = ch.SplitData(data, 0.5, 0.5);

training_data = data(training_indeces,:);
training_target = targets(training_indeces, :);


test_data = data(test_indeces,:);
test_target = targets(test_indeces, :);

%%
close all;
n_centroids = 8;
gain = 2;


ia = IA_classification(0.5, gain);
ia.UseGPU = true;
tset_length = length(training_data);

input = ia.NewFilterNode(size(training_data, 2), @NoFilter);

im = ia.NewIntentionalModule(input.index, tset_length-2, n_centroids);


%--- Train Intentional Architecture ---
for ii = 1:tset_length
    input.SetInput(training_data(ii,:));
    ia.Update();
end
%------------------------------------


[train_sim, train_ica] = ch.ProcessIntentionalModule(ia, input.index, im, training_data);

[test_sim, test_ica] = ch.ProcessIntentionalModule(ia, input.index, im, test_data);



train_X = training_data';
train_T = training_target';

net1 = trainSoftmaxLayer(train_X,train_T);

train_X = test_data';
train_T = test_target';

train_Y = net1(train_X);

%%

sim_X = train_sim';
sim_T = training_target';

net2 = trainSoftmaxLayer(sim_X,sim_T);

sim_X = test_sim';
sim_T = test_target';

sim_Y = net2(sim_X);

%%

ica_X = train_ica';
ica_T = training_target';

net3 = trainSoftmaxLayer(ica_X,ica_T);

ica_X = test_ica';
ica_T = test_target';

ica_Y = net3(ica_X);

plotconfusion(train_T, train_Y, 'Raw', sim_T, sim_Y,'Simil', ica_T, ica_Y,'ICA');

%%
    