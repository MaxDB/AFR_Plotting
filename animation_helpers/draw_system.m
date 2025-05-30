function System = draw_system(Model,ax)
mass_radius = 0.2;

% set up axes
axes(ax);
axis off
box off
daspect([1 1 1])


% def system
L = Model.Parameters.L;
Lr = L + mass_radius;
Ld = L + 2*mass_radius;

springs{1} = Spring(1,ax,[0,L;Lr,Lr],["wall","free"]);
springs{2} = Spring(2,ax,[Lr,Lr;0,L],["ground","free"]);
springs{3} = Spring(3,ax,[2*Lr + mass_radius,2*Lr + mass_radius;0,L],["ground","free"]);
springs{4} = Spring(4,ax,[Ld,Ld+L;Lr,Lr],["free","free"]);
springs{5} = Spring(5,ax,[Lr,Lr;Ld,Ld+L],["free","ground"]);

masses{1} = Mass(1,ax,[Lr,Lr],mass_radius);
masses{2} = Mass(2,ax,[Ld + Lr,Lr],mass_radius,["roller east"]);

connections{1} = dictionary("west",1,"south",2,"east",-4,"north",-5);
connections{2} = dictionary("west",4,"south",3,"east",0,"north",0);

dofs = {{1,"east"},{1,"north"},{2,"north"}};

System = Mass_Spring_System(masses,springs,dofs,connections,ax);



end