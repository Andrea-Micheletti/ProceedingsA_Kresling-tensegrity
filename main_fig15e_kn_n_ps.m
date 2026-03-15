% Analysis of a kresling-tensegrity unit
% using a Stick-&-Spring model (dihedral springs)

clearvars; close all; % clear variables and close figures

figflag1 = 0 ; % flag to display figures

myview = [ -15 30 ] ; % camera view angles


%%          ***  INPUT PARAMETERS  ***

Nsteps=100; % number of incremental steps

delta=0.1; % dimensionless change in height

kc = 1; % cable stiffness constant 

krr=1; % cable/bars axial spring ratio 

kar=1; % axial spring constant scaling

ksr=0.0001; % angular spring constant scaling

epsc=0.002; 


% data of the unit

%n = 3 ;         %   number of bars per module
vv=[3, 4, 5, 6, 8]; % n values 

or = 1 ;        %   orientation

a = 4;          %   bottom base radius

b = 0.75 * a;   %   top base radius

h = 6;


dth=0; % overtwist (degrees)



dd=zeros(size(vv));


%% stiffness constants

% bar axial spring constant
kb=krr*kc; 

% angular spring constant ( k * l^2 )

ks0 = ksr * kc * a^2 ;


%% fminunc setup

options1 = optimoptions(@fminunc,...
    'Algorithm','quasi-newton',...
    'SpecifyObjectiveGradient',true,...
    'CheckGradients',false,...
    'FiniteDifferenceType','central',...
    'FiniteDifferenceStepSize',5e-5,...
    'StepTolerance',1e-08,...
    'Maxiterations',1e4,...
    'Display','none');

%% figure initalization

figure; axh=axes;
set(axh,'nextplot','add');
grid on
set(axh,'fontsize',17);

figure; axh2=axes;
set(axh2,'nextplot','add');
grid on
set(axh2,'fontsize',17);



dth=dth/180*pi; % overtwist conversion to radians







%% main loop

for kk=1:size(vv,2)

   n = vv(kk) ;         %   number of bars per module

    Nnodes=2*n; % # nodes
Nedges=4*n;  % # edges
Nwedges=0;  % # wedges
Nzedges=2*n;% # z-edges


% vector of spring constants
kav=[ kc*ones(n,1); kb*ones(n,1); kc*ones(2*n,1) ];

% angular spring vector (wedges)
ksv = ks0 * ones(Nwedges,1);

% angular spring vector (zedges)
kzv = ks0 * ones(Nzedges,1);

%% Constraints (simply supported, isostatic)

constrm=[
    (1:2*n)
    zeros(3,2*n)
    ];
constrm(2,1:2)=1;
constrm(3,1)=1;
constrm(4,1:3)=1;

constrm0=constrm;


%% Constraints (compression test)

% constrain the vertical displacement of all nodes and the rigid
% translations in the horizontal plane
constrm=[
    (1:2*n)
    zeros(2,2*n)
    ones(1,2*n)
    ];
constrm(2,1:2)=1;
constrm(3,1)=1;

constrm1=constrm;


%% Structure generation - Kresling unit with n-sided base

[nodes,edges,wedges,zedges,stypes,wtypes,ztypes]=...
    genmodtnz(n,a,b,h,dth,or);
%[nodes,edges,wedges,stypes,wtypes]=genmodtnb(n,a,b,h,dth,or);

nodesg=nodes;
    %% draw a picture of the structure (with panels)

    firstpicture(nodes,edges,-ones(Nedges,1));
    grid on
    set(gca,'nextplot','add');
    
    faces=[];
    for ii=1:n
        faces(ii,:)=[ii 1+mod(ii,n) ii+n];
        faces(ii+n,:)=[ii ii+n n+1+mod(ii+n-2,n)];
    end
    
    pa=patch('Faces',faces,'Vertices',nodes');
    set(pa,'facecolor',[0.7 1  0.7],'edgecolor',[0.9 1 1])
    
    li1=light('color','white','position',[10,10,10]);
    li2=light('color','white','position',[-10,-10,10]);
    li3=light('color','white','position',[0,0,-10]);

    %% display constraints
    
    % constraint color codes:
    
    % red circle: constrained in all directions
    
    % square: constrained in two directions
    % red square: x,y; blue square: y,z; green square: x,z
    
    % triangle: constrained in one direction
    % red triangle: z; blue triangle: x; green triangle: y
    
    constrm=constrm0;
    
    if figflag1
        constrpicture(nodes,edges,stypes,constrm);  view(myview);
        set(gcf,'name','External constraints (isostatic)');
        disp([' ']); disp(['Figure: External constraints (isostatic).']);
        disp(['Press a key to continue or CTRL+C to exit.']); disp([' ']);
    end
    
    constrm=constrm1;
    
    if figflag1
        constrpicture(nodes,edges,stypes,constrm);  view(myview);
        set(gcf,'name','External constraints (compression test)');
        disp([' ']); disp(['Figure: External constraints (compression test).']);
        disp(['Press a key to continue or CTRL+C to exit.']); disp([' ']);
    end
    
    %% Calculation of lengths and angles
    
    
    l0=length0(nodes,edges); % compute edge lengths
    
    la=l0(1);
    lc=l0(2*n+1);
    lp=l0(n+1);
    lb=l0(3*n+1);
    
    % selfstress state single basis vector
    if dth==0
    onesn=ones(n,1);
    selfstress=[b/lp*onesn; -onesn; lc/lp*onesn; a/lp*onesn];
    end






    lw=theta(nodes,wedges);     % compute wedge angles

    
    lz=zangles(nodes,zedges);     % compute the z-edge angles

    
    lwf=lw; % fabrication angles
    
    lzf=1*lz;     % assign the rest-angles of z-edges

    
% assign rest lengths w/ prestress
    lcf=lc/(1+epsc);
    psc=kc*(lc-lcf);
    prestress=(psc/selfstress(2*n+1))*selfstress;
    lf=l0-prestress./kav;


laf=lf(1);
lcf=lf(2*n+1);
lpf=lf(n+1);
lbf=lf(3*n+1);

    % this is the delta parameter of the paper
%dd(kk)=lpf^2-lcf^2-laf*lbf/sin(pi/n);
dd(kk)=(lpf^2-lcf^2-laf*lbf/sin(pi/n))/(a*b);

    
    %% Iterative process initialization
    
    eqlforcesm = zeros(3*Nnodes,Nsteps); % balanced load matrix initialization
    
    estressm = zeros(Nedges,Nsteps+1); % axial force matrix initialization
    
    forces=zeros(3*Nnodes,1); %force vector initialization
    
    %% First minimization (the energy is alrady at a minimum)
nodes=nodesg;
    constrm=constrm0; % isostatic
    
    % vector of constraints: 'constrv' is a 3*Nnodes vector of zeros and ones,
    % whose nonnull entries corresponds to constrained directions
    constrv=constraints(constrm,Nnodes);
    
    % 'coordsreduced' separates free coordinates ('place') from
    % constrained coordinates ('cplace')
    [place,cplace]=coordsreduced(nodes,constrv);
    
    %tic % start stopwatch
    [X,FVAL,EXITFLAG,OUTPUT,GRAD]=...
        fminunc(@(x) energyewz(x,cplace,constrv,edges,wedges,zedges,...
        lf,lwf,lzf,kav,ksv,kzv,forces),...
        place,options1);
    %toc
    XX=coordswhole(X,cplace,constrv);
    
    nodes(:)=XX;
    
    % updates lengths and angles
    l=length0(nodes,edges);
    lw=theta(nodes,wedges);
    lz=zangles(nodes,zedges);
    
    % compute stress
    estress=kav.*(l-lf);
    wstress=ksv.*(lw-lwf);
    zstress=kzv.*(lz-lzf);
    
%     % compute the gradient of the elastic energy according to (18)
%     % this should be equal to the external forces
%     engrad=eqlmate(nodes,edges)*estress...
%         +eqlmatw(nodes,wedges)*wstress...
%         +eqlmatz(nodes,zedges)*zstress;
    
    %% Compression test
    
    nodes0=nodes;
    
    constrm=constrm1;
    
    % vector of constraints: 'constrv' is a 3*Nnodes vector of zeros and ones,
    % whose nonnull entries corresponds to constrained directions
    constrv=constraints(constrm,Nnodes);
    
    estress0=estress;
    
    %options1.CheckGradients=false;
    %options1.Display='none';
    
    
    tic
    

    for ii=1:Nsteps
        % imposed vertical displacement of top nodes
        nodes(3,Nnodes-n+1:Nnodes)=(1-(ii/Nsteps)*delta)*h;
        
        [place,cplace]=coordsreduced(nodes,constrv);
        
        %'fminunc' balances the structure
        [X,FVAL,EXITFLAG,OUTPUT,GRAD]=...
            fminunc(@(x) energyewz(x,cplace,constrv,edges,wedges,zedges,...
            lf,lwf,lzf,kav,ksv,kzv,forces),...
            place,options1);
        
        XX=coordswhole(X,cplace,constrv);
        
        nodes(:)=XX;
        
        % updates lengths and angles
        l=length0(nodes,edges);
        lw=theta(nodes,wedges);
        lz=zangles(nodes,zedges);
        
        
        % compute stress
        estress=kav.*(l-lf);
        wstress=ksv.*(lw-lwf);
        zstress=kzv.*(lz-lzf);
        
        
        % nodal forces at equilibrium (active and reactive)
        eqlforces=eqlmate(nodes,edges)*estress...
            +eqlmatw(nodes,wedges)*wstress...
            +eqlmatz(nodes,zedges)*zstress;
        
        eqlforcesm(:,ii)=eqlforces; % save nodal forces
        
        estressm(:,ii)=estress; % save axial forces
        
        l2=length0(nodes,edges); % final length
        
    end
    toc

    %disp([' ']); disp(['End of the simulation.']);
    %disp(['Press a key to continue or CTRL+C to exit.']); disp([' ']); pause

%% post-processing

% force-vs-displacement plot
plot(axh,...
    [0 (((1:Nsteps)/Nsteps)*delta)],...
    [0, n*eqlforcesm(3,:)/kc/a],...
    'linewidth',2);


plot(axh2,...
    [0 (((1:Nsteps)/Nsteps)*delta)],...
    [0, n*eqlforcesm(3,:)/kc/a],...
    'linewidth',2);



%disp([' ']); disp(['Figure: force-vs-displacement plot']);
%disp(['Press a key to continue or CTRL+C to exit.']); 
%disp([' ']); pause




end


lgd=legend(axh,num2str(vv','%1.0f'),'Location','Northwest');
disp([' ']); disp(['Figure: force-vs-displacement plot']);
lgd=legend(axh2,num2str(dd','%1.3f'),'Location','Southwest');

saveas(axh,'fig_kn_n_ps.fig')
saveas(axh,'fig_kn_n_ps.pdf')



return

saveas(axh,'fig_kn_b2av_ps.pdf')

