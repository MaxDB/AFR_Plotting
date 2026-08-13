function System = draw_system(Model,ax,varargin)
mass_radius = 0.2;

%-------------------------------------------------------------------------%
num_args = length(varargin);
if mod(num_args,2) == 1
    error("Invalid keyword/argument pairs")
end
keyword_args = varargin(1:2:num_args);
keyword_values = varargin(2:2:num_args);

applied_force = [];
for arg_counter = 1:num_args/2
    switch keyword_args{arg_counter}
        case "force"
            applied_force = keyword_values{arg_counter};
        otherwise
            error("Invalid keyword: " + keyword_args{arg_counter})
    end
end
%-------------------------------------------------------------------------%


% set up axes
axes(ax);
axis off
box off
daspect([1 1 1])


% def system
L = Model.Parameters.L;
Lr = L + mass_radius;
Ld = L + 2*mass_radius;

springs{1} = Spring(1,ax,[0,L;Lr,Lr],["wall","free"],"thickness",5);
springs{2} = Spring(2,ax,[Lr,Lr;0,L],["ground","free"],"thickness",2);
springs{3} = Spring(3,ax,[2*Lr + mass_radius,2*Lr + mass_radius;0,L],["ground","free"],"thickness",3);
springs{4} = Spring(4,ax,[Ld,Ld+L;Lr,Lr],["free","free"],"thickness",5);
springs{5} = Spring(5,ax,[Lr,Lr;Ld,Ld+L],["free","ground"],"thickness",2);

masses{1} = Mass(1,ax,[Lr,Lr],mass_radius,"free","thickness",5,"force","north");
masses{2} = Mass(2,ax,[Ld + Lr,Lr],mass_radius,"roller east","thickness",5);

connections{1} = dictionary("west",1,"south",2,"east",-4,"north",-5);
connections{2} = dictionary("west",4,"south",3,"east",0,"north",0);

dofs = {{1,"east"},{1,"north"},{2,"north"}};

System = Mass_Spring_System(masses,springs,dofs,connections,ax);



end