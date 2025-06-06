function ax = cut_y_section(ax,y_boundary,cut_direction)
manifold = findall(ax,"Type","Surface");

x_manifold = manifold.XData;
y_manifold = manifold.YData;
z_manifold = manifold.ZData;


cut_index = y_manifold < y_boundary;
if cut_direction == -1
    cut_index = ~cut_index;
end

x_cut = x_manifold(cut_index);
y_cut = ones(size(x_cut))*y_boundary;

num_points = numel(x_manifold);
x_lin = reshape(x_manifold,num_points,1);
y_lin = reshape(y_manifold,num_points,1);
z_lin = reshape(z_manifold,num_points,1);

z_interp = scatteredInterpolant(x_lin,y_lin,z_lin);
z_cut = z_interp(x_cut,y_cut);

y_manifold(cut_index) = y_cut;
z_manifold(cut_index) = z_cut;

manifold.YData = y_manifold;
manifold.ZData = z_manifold;


all_lines = findall(ax,"Type","Line");
num_lines = size(all_lines,1);
for iLine = 1:num_lines
    line = all_lines(iLine);
    switch line.Tag
        case {"grid_line","outline"}
            x_line = line.XData;
            y_line = line.YData;
            z_line = line.ZData;

            if isempty(y_line)
                continue
            end

            cut_index = y_line < y_boundary;
            if cut_direction == -1
                cut_index = ~cut_index;
            end
            cut_boundary = diff(cut_index);

            boundary_index = [find(cut_boundary == -1);find(cut_boundary == 1)];
            
            
            if size(boundary_index,2) == 0
                
                delete_line = y_line(1) < y_boundary;
                if cut_direction == -1
                    delete_line = ~delete_line;
                end
                if delete_line
                    line.XData = [];
                    line.YData = [];
                    line.ZData = [];
                end
                continue
            end

            internal_cut = boundary_index(1) > boundary_index(2);
            boundary_index = sort(boundary_index,"ascend");
            
            updated_cut_index = cut_index;
            internal_direction = [1,0];
            for iBoundary = 1:2
                boundary_span = boundary_index(iBoundary):(boundary_index(iBoundary)+1);
                if internal_cut
                    limit_index = boundary_span(3-iBoundary);
                else
                    limit_index = boundary_span(iBoundary);
                end
                updated_cut_index(limit_index) = 0;
                x_line(limit_index) = interp1(y_line(boundary_span),x_line(boundary_span),y_boundary);
                z_line(limit_index) = interp1(y_line(boundary_span),z_line(boundary_span),y_boundary);
                y_line(limit_index) = y_boundary;
                if internal_cut && line.Tag ~= "outline"
                    x_line(limit_index + internal_direction(iBoundary)) = nan;
                    y_line(limit_index + internal_direction(iBoundary)) = nan;
                    z_line(limit_index + internal_direction(iBoundary)) = nan;
                    updated_cut_index(limit_index + internal_direction(iBoundary)) = 0;
                end

                
            end

            y_line(updated_cut_index) = [];
            x_line(updated_cut_index) = [];
            z_line(updated_cut_index) = [];


            line.XData = x_line;
            line.YData = y_line;
            line.ZData = z_line;

            if line.Tag == "outline"
                outline = line;
                if internal_cut
                    outline_end = boundary_index(1)+[1,2];
                else
                    outline_end = [length(x_line),1];
                end
            end
    end
end
% bounding_points = [bounding_points_two,flip(bounding_points_one,2)];
[~,cut_order] = sort(x_cut,"ascend");
bounding_points = [x_cut(cut_order)';y_cut(cut_order)';z_cut(cut_order)'];

end_point = outline.XData(outline_end(1));
    
if abs(diff([end_point,bounding_points(1,1)])) > abs(diff([end_point,bounding_points(1,end)]))
    bounding_points = flip(bounding_points,2);
end

if internal_cut
    end_data = [outline.XData(outline_end(2):end);
                outline.YData(outline_end(2):end);
                outline.ZData(outline_end(2):end)];
else
    end_data = [outline.XData(1);
                outline.YData(1);
                outline.ZData(1)];
end

outline.XData = [outline.XData(1:outline_end(1)),bounding_points(1,:),end_data(1,:)];
outline.YData = [outline.YData(1:outline_end(1)),bounding_points(2,:),end_data(2,:)];
outline.ZData = [outline.ZData(1:outline_end(1)),bounding_points(3,:),end_data(3,:)];
end