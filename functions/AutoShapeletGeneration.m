function [shapelets, index] = AutoShapeletGeneration(block,i,TRAIN,TRAIN_class_labels)

    [B, ~] = size(block);
    z = find(TRAIN_class_labels==i);
    I = length(z);
    numofshapelets = B.*I;
   shapelets = cell(numofshapelets,1);
   index = zeros(numofshapelets,1);
%     shapelets = cell(1,B);
    for t = 1:B
        for k = 1:I
            temp1 = TRAIN(z(k),:).*block(t,:);
            nn = find(temp1~=0);
            temp = TRAIN(z(k),:);
            shapelets{(t-1)*I+k} = temp(nn);
            index((t-1)*I+k) = nn(1);
        end
    end

end

