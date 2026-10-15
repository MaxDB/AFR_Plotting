clear
close all

fig_name = "frc_base";

%--------
data_directory = get_project_path + "\examples\nonconservative\shallow_arch";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%--
Dyn_Data_0 = data_dir_execute(@initalise_dynamic_data,"shallow_arch_0");
Dyn_Data_1 = data_dir_execute(@initalise_dynamic_data,"shallow_arch_1");
Dyn_Data_14 = data_dir_execute(@initalise_dynamic_data,"shallow_arch_14");

ax = data_dir_execute(@compare_solutions,"physical amplitude","shallow_arch_1",2:3,"shallow_arch_14",2:3);
fig = ax.Parent;
delete(findobj(fig,"type","legend"))
%--
Model = Dyn_Data_14.Dynamic_Model.Model;
freq_1 = sqrt(Model.reduced_eigenvalues(1));
ax = scale_axis(ax,1,1/freq_1);
ax = set_y_axis(ax,Dyn_Data_1,Dyn_Data_14,data_dir_execute);
ax = scale_axis(ax,2,1/6.4);
%---


xlabel(ax,"$\omega/\omega_1$","Interpreter","latex")
ylabel(ax,"max$(\phi_1q_1/H)$","Interpreter","latex")
%---

save_fig(fig,fig_name)



function ax = set_y_axis(ax,Dyn_Data_1,Dyn_Data_14,data_dir_execute)
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    line_data = {line.DataTipTemplate.DataTipRows.Value};
    if size(line_data,2) == 2
        continue
    end
    orbit_data = line_data{4};
    dyn_data_label = line_data{3}{1};
    switch length(dyn_data_label)
        case 5
            Dyn_Data = Dyn_Data_1;
        case 7
            Dyn_Data = Dyn_Data_14;
    end
    Rom = Dyn_Data.Dynamic_Model;
    evecs = Rom.Model.reduced_eigenvectors;
    evecs = data_dir_execute(@load,evecs);
    evec_1_max = max(evecs(:,1));
    evec_1_max = 0.08980;

    orbit_id_str = line_data{4}{1};    
    orbit_id = split(strip(strip(orbit_id_str,"left",'('),"right",')'),",");
    sol_id = double(string(orbit_id{1}));
    Sol = data_dir_execute(@load_solution,Dyn_Data,sol_id);
    get_orbit = @(orbit_num) data_dir_execute(@get_orbit,Dyn_Data,sol_id,orbit_num);

    
    
    num_orbits = size(orbit_data,2);
    for iOrbit = 1:num_orbits
        orbit_id_str = orbit_data{iOrbit};
        orbit_id = split(strip(strip(orbit_id_str,"left",'('),"right",')'),",");
        
          
        orbit_num = double(string(orbit_id{2}));
        orbit = get_orbit(orbit_num);
        r1 = max(abs(orbit.xbp(:,1)));
        amp = evec_1_max*r1;
        line.YData(iOrbit) = amp;
    end

end


end
