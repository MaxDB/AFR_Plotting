function [x1,x2,f] = get_stress_manifold(x1_lim)
omega_1 = 1;
omega_2 = 5;
%----
NUM_POINTS = 200;
BRANCH_DEF = -1;
MAIN_BRANCH_SORT = [1,3,2];
SUB_BRANCH_SORT = [1,2];
%----

x1_vec = linspace(x1_lim(1),x1_lim(2),NUM_POINTS);

x2_complex = stress_manifold(x1_vec,omega_1,omega_2);
f_complex = reduced_restoring_force(x1_vec,omega_1,omega_2);

real_roots = isapprox(imag(x2_complex),0);

% main_index = real_roots;
% main_index(:,sum(real_roots,1) == 3) = 0;
% main_index(MAIN_BRANCH,sum(real_roots,1) == 3) = 1;

x2_complex(~real_roots) = nan;
x2_sols = real(x2_complex);

f_complex(~real_roots) = nan;
f_sols = real(f_complex);

% sort branches
% above and below x2 = -1
x1_all = repmat(x1_vec,1,3);
x2_all = reshape(x2_sols',1,NUM_POINTS*3);
f_all = reshape(f_sols',1,NUM_POINTS*3);

branch_span = zeros(0,2);
branch_counter = 0;
in_branch = false;
for iPoint = 1:3*NUM_POINTS
    point = x2_all(iPoint);
    if isnan(point)
        if in_branch
           in_branch = false;
           branch_span(branch_counter,2) = iPoint-1;
        else
           continue
        end
    else
        if in_branch
            continue
        else
            in_branch = true;
            branch_counter = branch_counter + 1;
            branch_span(branch_counter,1) = iPoint;
        end
    end
end
if in_branch %ends in a branch
    branch_span(branch_counter,2) = iPoint;
end

main_branch_index = {};
sub_branch_index = {};
num_branches = branch_counter;
main_branch_counter = 0;
sub_branch_counter = 0;
for iBranch = 1:num_branches
    branch_index = branch_span(iBranch,1):branch_span(iBranch,2);
    x2_branch = x2_all(branch_index);
    
   
    new_main_index = branch_index(x2_branch >= BRANCH_DEF);
    new_sub_index = branch_index(x2_branch < BRANCH_DEF);

    if ~isempty(new_main_index)
        main_branch_counter = main_branch_counter + 1;
        main_branch_index{main_branch_counter} = new_main_index; %#ok<*AGROW>
    end

    if ~isempty(new_sub_index)
        sub_branch_counter = sub_branch_counter + 1;
        sub_branch_index{sub_branch_counter} = new_sub_index;
    end
end

if num_branches > 1
    main_branch_index = main_branch_index(MAIN_BRANCH_SORT);
    sub_branch_index = sub_branch_index(SUB_BRANCH_SORT);
    sub_branch_index(2) = {flip(sub_branch_index{2})};

    main_index = horzcat(main_branch_index{:});
    sub_index = horzcat(sub_branch_index{:});
    sub_index(end+1) = sub_index(1);

    x1 = {x1_all(main_index),x1_all(sub_index)};
    x2 = {x2_all(main_index),x2_all(sub_index)};
    f = {f_all(main_index),f_all(sub_index)};
else
    main_index = horzcat(main_branch_index{:});
    x1 = {x1_all(main_index)};
    x2 = {x2_all(main_index)};
    f = {f_all(main_index)};
end
end

