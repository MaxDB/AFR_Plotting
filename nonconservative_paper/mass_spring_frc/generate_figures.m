clear
close all

fig_names = ["low_damping","mid_damping","high_damping"];

%--------
data_directory = get_project_path + "\examples\nonconservative\mass_spring_system";
data_dir_execute = @(fun,varargin) dir_execute(data_directory,fun,varargin{:});

%--
Dyn_Data_0 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_0");
Dyn_Data_12 = data_dir_execute(@initalise_dynamic_data,"mass_spring_roller_12");

for iPlot = 1:3
    sol_0 = iPlot+1;
    sol_12 = iPlot;

    resonance_0 = data_dir_execute(@get_special_point,Dyn_Data_0,sol_0,"RES");
    Sol_0 = data_dir_execute(@load_solution,Dyn_Data_0,sol_0);

    resonance_12 = data_dir_execute(@get_special_point,Dyn_Data_12,sol_12,"RES");
    Sol_12 = data_dir_execute(@load_solution,Dyn_Data_12,sol_12);

    ax = data_dir_execute(@compare_solutions,"energy","mass_spring_roller_0",[1,sol_0],"mass_spring_roller_12",sol_12);
    fig = ax.Parent;
    leg = findobj(fig,"type","legend");
    delete(leg)

    hold(ax,"on")
    plot(ax,Sol_0.frequency(resonance_0),Sol_0.energy(resonance_0),"x","Tag","res_0")
    plot(ax,Sol_12.frequency(resonance_0),Sol_12.energy(resonance_0),"x","Tag","res_12")
    hold(ax,"off")

    save_fig(fig,fig_names(iPlot))
end