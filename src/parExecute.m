clear all 
Timevector = [1e3 0.5e3 0.1e3 0.05e3 0.01e3]; %1e3 0.5e3
AngVector = [170];
n = 30; %number of trials to run

cnt = 0;
for ii = 1:length(AngVector)
    for jj = 1:length(Timevector)
        for kk = 1:n
            cnt = cnt + 1;
            Vars(cnt,:) = [Timevector(jj) AngVector(ii)];
        end
    end
end

parfor mm = 1:length(Vars)
    ExpTime = Vars(mm,1);
    SearchSectorAngle = Vars(mm,2);
    [X] = parRobotLatticeModel(ExpTime,SearchSectorAngle);

    Xend(mm) = X
end

%save('Xend4.mat',"Xend","Vars")

% - Xend3.mat has all angles
% - Xend4.mat has only 170