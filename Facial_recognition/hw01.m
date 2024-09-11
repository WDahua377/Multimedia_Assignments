clear
% Read File
first = true;
correct = 0;
testcnt = 0;

for i = 1:1287 %training
    file = dir(['Proj1_dataset\dataset\training\*.bmp']); % get all data in the folder
    filename = file(i).name;
    X = imread(['Proj1_dataset\dataset\training\' filename]);
    if first
        allPic = X(:)';
        first = false;
    else
        allPic = [allPic; X(:)'];
    end
end

for i = 1:1287 %testing
    file = dir(['Proj1_dataset\dataset\test\*.bmp']);
    filename = file(i).name;
    X = imread(['Proj1_dataset\dataset\test\' filename]);
    test_file = X(:)';
    who = nn_sad(allPic, test_file); %sad
    if (ceil(who/13.0)) == ceil(i/13.0)
        correct = correct + 1;
    end
    testcnt = testcnt + 1;
end

A=(correct/testcnt)*100; %ans
A

function who = nn_sad(allPic, test_file)
    mindis = sum(abs(double(allPic(1, :)) - double(test_file))); %initialize
    who = 1;
    for i=1:size(allPic,1) %1:1287
        dis = sum(abs(double(allPic(i, :)) - double(test_file))); %distance
        if mindis > dis %minimum
            who = i;
            mindis = dis;
        end
    end
end