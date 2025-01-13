clear
all_fig = findall(0, 'type', 'figure');
close(all_fig)
%select orbit and time point via sliders

Plot_Settings.plot_type = "physical";
Plot_Settings.coords = [3,2,1];
Manifold_One.system = "mass_spring_roller_1";
Manifold_Two.system = "mass_spring_roller_12";
Manifold_Two.plot_validation_orbit = false;
solution_num = 1;

%------------------------------------------------------------------------
curret_directory = pwd;
data_directory = get_project_path + "\examples\3_dof_mass_spring";

cd(data_directory)
compare_solutions("amplitude",Manifold_One.system,solution_num,Manifold_Two.system,solution_num,"validation",[1,0])

Dyn_Data = initalise_dynamic_data(Manifold_One.system);
Sol = Dyn_Data.load_solution(solution_num);

Rom = Dyn_Data.Dynamic_Model;
Static_Data = load_static_data(Rom);
Validated_Sol = Dyn_Data.load_solution(solution_num,"validation");
Static_Data = Static_Data.add_validation_data(Validated_Sol.validation_modes);
Rom = Reduced_System(Static_Data);
Dyn_Data.Dynamic_Model = Rom;
cd(curret_directory)

num_orbits = Sol.num_orbits;

Manifold_Plot_Data.Plot_Settings = Plot_Settings;
Manifold_Plot_Data.Manifold_One = Manifold_One;
Manifold_Plot_Data.Manifold_Two = Manifold_Two;
Manifold_Plot_Data.solution_num = solution_num;
%------------------------------------------------------------------------
%setup ui
fig = uifigure;
ui_grid = uigridlayout(fig,[2,1]);
ui_grid.RowHeight = {'1x','fit'};


%--------------------------------------------------------------------
%manifold plot
manifold_ax = uiaxes(ui_grid);

%--------------------------------------------------------------------
%sliders and buttons
options_panel = uipanel(ui_grid);
options_grid = uigridlayout(options_panel,[1,4]);
options_grid.ColumnWidth = {'fit','fit','fit','fit','fit','fit'};
%------

orbit_editfield = uieditfield(options_grid,"numeric");
orbit_editfield.RoundFractionalValues = true;
orbit_editfield.AllowEmpty = true;
orbit_editfield.Placeholder = "Orbit ID";
orbit_editfield.Limits = [1,num_orbits];
orbit_editfield.Value = [];
%------

time_slider = uislider(options_grid);
time_slider.Limits = [0,1];
%------

plot_validation_orbit = uicheckbox(options_grid,"Text","Validation orbit");
plot_validation_orbit.Value = true;

plot_validation_manifold = uicheckbox(options_grid,"Text", "Validation manifold");
plot_validation_manifold.Value = false;

plot_comparative_orbit = uicheckbox(options_grid,"Text", "Comparative orbit");
plot_comparative_orbit.Value = false;

Options_Data.plot_validation_orbit = plot_validation_orbit;
Options_Data.plot_validation_manifold = plot_validation_manifold;
Options_Data.plot_comparative_orbit = plot_comparative_orbit;
Options_Data.Plot_Settings = Plot_Settings;
%------

plot_orbit_button = uibutton(options_grid,"push","Text","Plot orbit(s)");
%------


Orbit_Callback_Data.Manifold_Plot_Data = Manifold_Plot_Data;
Orbit_Callback_Data.ax = manifold_ax;
Orbit_Callback_Data.current_directory = curret_directory;
Orbit_Callback_Data.data_directory = data_directory;
orbit_editfield.ValueChangedFcn = ...
    @ (orbit_editfield, event_data) orbit_editfield_callback(orbit_editfield, event_data, Orbit_Callback_Data, time_slider, Options_Data);
Init_Editfield.Value = [];
orbit_editfield_callback(orbit_editfield, Init_Editfield, Orbit_Callback_Data, time_slider, Options_Data);
%------

Time_Slider_Callback_Data.ax = manifold_ax;
Time_Slider_Callback_Data.Dyn_Data = Dyn_Data;
Time_Slider_Callback_Data.sol_num = solution_num;
Time_Slider_Callback_Data.current_directory = curret_directory;
Time_Slider_Callback_Data.data_directory = data_directory;
Time_Slider_Callback_Data.Plot_Settings = Plot_Settings;
time_slider.ValueChangingFcn = ...
    @ (time_slider, event_data) time_slider_callback(time_slider, event_data, Time_Slider_Callback_Data, orbit_editfield, Options_Data);
%------

plot_validation_manifold.ValueChangedFcn = ...
    {@ manifold_checkbox_callback,manifold_ax};
plot_validation_orbit.ValueChangedFcn = ...
    {@ validation_orbit_checkbox_callback,manifold_ax};
plot_comparative_orbit.ValueChangedFcn = ...
    {@ comparative_orbit_checkbox_callback,manifold_ax};
%------

plot_orbit_button.ButtonPushedFcn = ...
    {@ plot_orbit_button_callback,manifold_ax,Plot_Settings};
%--------------------------------------------------------------------
%%% Callbacks
function orbit_editfield_callback(~, event_data, Orbit_Callback_Data, time_slider, Options_Data)
ax = Orbit_Callback_Data.ax;
Manifold_Plot_Data = Orbit_Callback_Data.Manifold_Plot_Data;
Manifold_One = Manifold_Plot_Data.Manifold_One;
Manifold_Two = Manifold_Plot_Data.Manifold_Two;
Plot_Settings = Manifold_Plot_Data.Plot_Settings;

sol_num = Manifold_Plot_Data.solution_num;
orbit_id = event_data.Value;

if ~isempty(orbit_id)
    Manifold_One.orbit = [sol_num,orbit_id];
    Manifold_Two.orbit = ["1","closest","1"];
else
    Manifold_One.orbit = orbit_id;
end

% Manifold_One.plot_validation_manifold = Options_Data.plot_validation_manifold.Value;
 Manifold_One.plot_validation_manifold = 1;

data_directory = Orbit_Callback_Data.data_directory;
current_directory = Orbit_Callback_Data.current_directory;

cla(ax)
cd(data_directory)
ax = compare_stress_manifold({Manifold_One,Manifold_Two},"opts",Plot_Settings,"axes",ax);
cd(current_directory)

setup_time_slider(time_slider,orbit_id,ax, Options_Data)
end

function time_slider_callback(~, event_data, Time_Slider_Callback_Data, orbit_editfield, Options_Data)
t_value = round(event_data.Value);
ax = Time_Slider_Callback_Data.ax;

% if Options_Data.plot_validation_manifold 
% 
% end
comparative_orbit_lines = {};
comparative_orbit_time_lines = {};
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case "o"
            switch length(line_tag{2})
                case 1
                    orbit_line = line;
                    x_orbit = line.XData(t_value);
                    y_orbit = line.YData(t_value);
                    z_orbit = line.ZData(t_value);
                case 3
                    comp_orbit_num = str2double(line_tag{4});
                    comparative_orbit_lines{comp_orbit_num} = line; %#ok<AGROW>

            end
        case "vo"
            x_vorbit = line.XData(t_value);
            y_vorbit = line.YData(t_value);
            z_vorbit = line.ZData(t_value);
        case "ot"
            orbit_id = line_tag{2};
            switch length(orbit_id)
                case 1
                    orbit_time_line = line;
                case 3
                    comp_orbit_num = str2double(line_tag{4});
                    comparative_orbit_time_lines{comp_orbit_num} = line; %#ok<AGROW>
            end
            
            
        case "vot"
            validation_orbit_time_line = line;
        
        case "vm"
            validation_manifold_line = line;
        otherwise
            continue
    end
end

orbit_time_line.XData = x_orbit;
orbit_time_line.YData = y_orbit;
orbit_time_line.ZData = z_orbit;
orbit_time_line.Visible = "on";

validation_orbit_time_line.XData = x_vorbit;
validation_orbit_time_line.YData = y_vorbit;
validation_orbit_time_line.ZData = z_vorbit;
validation_orbit_time_line.Visible = Options_Data.plot_validation_orbit.Value;


num_comparative_orbits = size(comparative_orbit_lines,2);
[~,~,~,orbit_time] = orbit_line.DataTipTemplate.DataTipRows.Value;
time_point = orbit_time(t_value);
for iComp = 1:num_comparative_orbits
    comp_orbit_line = comparative_orbit_lines{iComp};
    comp_orbit_time_point = comparative_orbit_time_lines{iComp};

    [~,~,~,comp_orbit_time] = comp_orbit_line.DataTipTemplate.DataTipRows.Value;
    x_comp_orbit = comp_orbit_line.XData;
    y_comp_orbit = comp_orbit_line.YData;
    z_comp_orbit = comp_orbit_line.ZData;

    x_comp_point = interp1(comp_orbit_time,x_comp_orbit,time_point);
    y_comp_point = interp1(comp_orbit_time,y_comp_orbit,time_point);
    z_comp_point = interp1(comp_orbit_time,z_comp_orbit,time_point);

    comp_orbit_time_point.XData = x_comp_point;
    comp_orbit_time_point.YData = y_comp_point;
    comp_orbit_time_point.ZData = z_comp_point;
    comp_orbit_time_point.Visible = Options_Data.plot_comparative_orbit.Value;
end



%------------------------------------
if ~Options_Data.plot_validation_manifold.Value
    return
end

Dyn_Data = Time_Slider_Callback_Data.Dyn_Data;
orbit_id = orbit_editfield.Value;
sol_num = Time_Slider_Callback_Data.sol_num;
orbit_data = [sol_num,orbit_id];

data_directory = Time_Slider_Callback_Data.data_directory;
current_directory = Time_Slider_Callback_Data.current_directory;


x_lim = ax.XLim;
y_lim = ax.YLim;
z_lim = ax.ZLim;
ax_lims = zeros(3,2);
coords_order = Options_Data.Plot_Settings.coords;
ax_lims(coords_order(1),:) = x_lim;
ax_lims(coords_order(2),:) = y_lim;
ax_lims(coords_order(3),:) = z_lim;

cd(data_directory)
x_hat_t = get_validation_whisker(t_value,Dyn_Data,orbit_data,ax_lims);
cd(current_directory)

plot_coords = Time_Slider_Callback_Data.Plot_Settings.coords;


validation_manifold_line.XData = x_hat_t(:,:,plot_coords(1));
validation_manifold_line.YData = x_hat_t(:,:,plot_coords(2));
validation_manifold_line.ZData = x_hat_t(:,:,plot_coords(3));

validation_manifold_line.Visible = "on";
end
%-------------------------------------
function manifold_checkbox_callback(~,event_data,ax)

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case "vm"
            line.Visible = event_data.Value;
        otherwise
            continue
    end
end

end
%-------------------------------------
function validation_orbit_checkbox_callback(~,event_data,ax)

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case "vo"
            line.Visible = event_data.Value;
        case "vot"
            line.Visible = event_data.Value;
        otherwise
            continue
    end
end

end

function comparative_orbit_checkbox_callback(~,event_data,ax)

lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case "o"
            if length(line_tag{2}) > 1
                line.Visible = event_data.Value;
            end
        case "ot"
           if length(line_tag{2}) > 1
                line.Visible = event_data.Value;
            end
        otherwise
            continue
    end
end

end

function plot_orbit_button_callback(plot_orbit_button,event_data,manifold_ax,Plot_Settings)
coords = Plot_Settings.coords;
num_dofs = length(coords);

figure;
tiledlayout("flow")
orbit_axes = cell(1,num_dofs);
for iCoord = 1:num_dofs
    ax = nexttile;
    hold(ax,"on")
    box(ax,"on")
    xlabel(ax,"t (s)")
    ylabel(ax,"x_{" + coords(iCoord) + "}")
    orbit_axes{iCoord} = ax;
end


lines = manifold_ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case {"o","vo"}
            if line.Visible == "off"
                continue
            end
            line_data = [line.XData; line.YData; line.ZData];
            [~,~,~,orbit_time] = line.DataTipTemplate.DataTipRows.Value;
            
            colour = line.Color;
            line_width = line.LineWidth;
            line_style = {"Color",colour,"LineWidth",line_width};
            for iCoord = 1:num_dofs
                ax = orbit_axes{iCoord};
                plot(ax,orbit_time,line_data(iCoord,:),line_style{:})
            end
        
        otherwise
            continue
    end
end

hold(ax,"off")
end
%--------------------------------------------------------------------
function setup_time_slider(time_slider,orbit_id,ax, Options_Data)
slider_active = ~isempty(orbit_id);
time_slider.Enable = slider_active;

time_line = 0;

if ~slider_active
    return
end
num_comparative_orbits = 0;
comparative_orbit_colour = zeros(0,3);
comparative_orbit_ids = {};
lines = ax.Children;
num_lines = size(lines,1);
for iLine = 1:num_lines
    line = lines(iLine);
    if ~isprop(line,"tag")
        continue
    end
    line_tag = split(line.Tag,"-");
    switch line_tag{1}
        case "o"
            switch length(line_tag{2})
                case 1
                    num_time_points = size(line.XData,2);
                    time_slider.Limits = [1,num_time_points];
                    orbit_colour = line.Color;
                    line_width = line.LineWidth;
                case 3
                    num_comparative_orbits = num_comparative_orbits + 1;
                    comparative_orbit_colour(num_comparative_orbits,:) = line.Color; 
                    line.Visible = Options_Data.plot_comparative_orbit.Value;
                    line.Tag = line.Tag + "-" + num_comparative_orbits;
                    comparative_orbit_ids{num_comparative_orbits} = line.Tag; %#ok<AGROW>
            end

        case "vo"
            vorbit_colour = line.Color;
            line.Visible = Options_Data.plot_validation_orbit.Value;
        case "ot"
            time_line = 1;
            line.Visible = "off";
        case "vot"
            line.Visible = "off";
        case "vm"
            line.Visible = "off";
        otherwise
            continue
    end
end
if time_line
    return
end

POINT_SIZE = 10;
point_settings = {"Marker","o","MarkerSize",POINT_SIZE,"MarkerFaceColor",[0,0,0],"Visible","off","LineWidth",line_width};
hold(ax,"on")
plot3(ax,0,0,0,point_settings{:},"MarkerEdgeColor",orbit_colour,"Color",orbit_colour,"Tag","ot-1","DisplayName","$\tilde{o}(t)$")
plot3(ax,0,0,0,point_settings{:},"MarkerEdgeColor",vorbit_colour,"Color",vorbit_colour,"Tag","vot-1","DisplayName","$\hat{o}(t)$")
for iComp = 1:num_comparative_orbits
    comp_colour = comparative_orbit_colour(iComp,:);
    comp_id = comparative_orbit_ids{iComp};
    comp_tag = comp_id(1) + "t" + comp_id(2:end);
    plot3(ax,0,0,0,point_settings{:},"MarkerEdgeColor",comp_colour,"Color",comp_colour,"Tag",comp_tag,"DisplayName","$\hat{o}(t)$")
end
hold(ax,"off")
end
%--------------------------------------------------------------------
function x_hat = get_validation_whisker(t_value,Dyn_Data,orbit_data,ax_lims)
PLOT_RESOLUTION = 2;
SCALE_CUTOFF = 0.5;
MAX_SCALE_FACTOR = 1.5;

[Orbit, Validation_orbit] = Dyn_Data.get_orbit(orbit_data(1),orbit_data(2),1);
Rom = Dyn_Data.Dynamic_Model;

z = Orbit.xbp';
num_r_modes = size(z,1)/2;
r_t = z(1:num_r_modes,t_value);



x_tilde_t = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_t);
x_hat_grad_t = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_t);

[~,t_max] = max(Validation_orbit.h,[],2);
[~,t_min] = min(Validation_orbit.h,[],2);

r_max = z(1:num_r_modes,t_max);
r_min = z(1:num_r_modes,t_min);

x_tilde_max = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_max);
x_tilde_min = Rom.Physical_Displacement_Polynomial.evaluate_polynomial(r_min);




lim_diff = diff(ax_lims,1,2);
num_h_modes = size(Validation_orbit.h,1);
orbit_lim = zeros(num_h_modes,2);
for iMode = 1:num_h_modes
    h_max = Validation_orbit.h(:,t_max(iMode));
    h_min = Validation_orbit.h(:,t_min(iMode));

    x_hat_grad_max = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_max(iMode));
    x_hat_grad_min = Rom.Low_Frequency_Coupling_Gradient_Polynomial.evaluate_polynomial(r_min(iMode));

    x_hat_max = x_tilde_max(:,iMode) + x_hat_grad_max*h_max;
    x_hat_min = x_tilde_min(:,iMode) + x_hat_grad_min*h_min;

    x_hat_diff = diff([x_hat_min,x_hat_max],1,2);
    diff_comp = abs(x_hat_diff./lim_diff);
    scale_factor = 1;
    if all(diff_comp < SCALE_CUTOFF) 
        scale_factor = SCALE_CUTOFF/max(diff_comp);
    end
    orbit_lim(iMode,:) = min(scale_factor,MAX_SCALE_FACTOR)*[h_min(iMode),h_max(iMode)];
end
%-------


x = linspace(orbit_lim(1,1),orbit_lim(1,2),PLOT_RESOLUTION);
y = linspace(orbit_lim(2,1),orbit_lim(2,2),PLOT_RESOLUTION);

[X,Y] = meshgrid(x,y);

num_points = PLOT_RESOLUTION^2;
X_array = reshape(X,1,num_points);
Y_array = reshape(Y,1,num_points);
h_array = [X_array;Y_array];


x_hat = x_tilde_t + x_hat_grad_t*h_array;
num_dof = size(x_hat,1);
x_hat = reshape(x_hat,[num_dof,size(X)]);
x_hat = permute(x_hat,[2,3,1]);
end