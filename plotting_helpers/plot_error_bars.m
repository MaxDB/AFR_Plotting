function plot_error_bars(ax,x,y,y_range,colour)
line_style = {"Color","k"};
marker_style = {"Marker","o","MarkerEdgeColor","k","MarkerFaceColor",get_plot_colours(colour),"MarkerSize",3};
tip_style = {"Marker","_","Color","k","MarkerSize",4};

x_fractional_length = 0.03;
x_range = diff(ax.XLim);
bar_length = x_range*x_fractional_length;


xlim(ax,ax.XLim)
ylim(ax,ax.YLim)



y_max = y_range(2,:) + y;
max_diff = diff([y;y_max])./y;

y_min = y_range(1,:) + y;
min_diff = diff([y_min;y])./y;


num_points = size(x,2);
for iPoint = 1:num_points
    x_line = [x(iPoint),x(iPoint)];
    y_line = [y_min(iPoint),y_max(iPoint)];
    plot(ax,x_line,y_line,"-",line_style{:})
    

    
    y_max_bar = y_max(iPoint);
    y_min_bar = y_min(iPoint);
    
    plot(ax,x(iPoint),y_max_bar,tip_style{:})
    plot(ax,x(iPoint),y_min_bar,tip_style{:})
    plot(ax,x(iPoint),y(iPoint),marker_style{:})
end

end