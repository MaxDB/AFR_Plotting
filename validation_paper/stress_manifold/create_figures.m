clear
close "all"

Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];
Manifold_One.system = "mass_spring_roller_1";
Manifold_Two.system = "mass_spring_roller_12";

curret_directory = pwd;
data_directory = get_project_path+"\examples\3_dof_mass_spring";

cd(data_directory)
compare_stress_manifold({Manifold_One,Manifold_Two},"opts",Plot_Settings);