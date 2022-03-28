%load_data.m

%sel = input("use ISPGR data? enter y/n \n", 's');
sel = 'y';
if sel == 'n'
    load('force_curves.mat')
    %% Active/Passive Force and Length
    fa = flaCurve(:,2);
    %fa = fa(3:end-1);
    la = flaCurve(:,1);
    %la = la(3:end-1);
     
    fp = flpCurve(:,2);
    lp = flpCurve(:,1);
    %% INTERPOLATION
    t = linspace(min(la), max(la), length(la)); %current linspace
    ti = linspace(0, 1.7, 100)'; %extrapolated linspace
    
    %l_int = interp1(t, la, ti)';
    %t = linspace(min(lp), max(lp), length(lp));
    %fp_int = interp1(t,fp, ti)';
    
    fp_int = interp1(flpCurve(:,1), flpCurve(:,2), ti);
    fa_int = interp1(flaCurve(:,1), flaCurve(:,2), ti);
    
    tf = linspace(min(fa), max(fa), length(fa));
    tfi = linspace(min(fa), max(fa),100)'; %scale to 47 elements
    
    fLenCurve = [ti, fp_int];


    fLenCurve(:,2) = fLenCurve(:,2) + fa_int; %total force summed!
    
    %flaCurve = [la_int fa_int]; %interpolated force length active
   
else %use ISPGR data
    load('FL_FV_curves_ISPGR_abstract.mat');
    %fv_vel_norm = flip(fv_vel_norm);
   % fv_stress_norm = flip(fv_stress_norm);
   % ls = linspace(min(fv_vel_norm), max(fv_vel_norm), 100)';
    ls = linspace(-1, 1, 100)';
    ls = flip(ls);
    fv_int = interp1(fv_vel_norm', fv_stress_norm', ls, 'nearest', 'extrap');
    
    fvCurve = [-ls, fv_int];

    ls2 = linspace(0, max(fl_len_norm), 100)'; %double size of data
    
    fl_int(:,1) = interp1(fl_len_norm', fl_stress_norm', ls2, 'spline', 0);
    %fl_int(:,2) = interp1(fl_len_norm', fl_stress_norm', ls2, 'makima', 0);
    %fl_int(:,3) = interp1(fl_len_norm', fl_stress_norm', ls2, 'v5cubic', 0);
    %fl_int(:,4) = interp1(fl_len_norm', fl_stress_norm', ls2, "nearest", 0);
    %fLenCurve = [fl_len_norm', fl_stress_norm'];
    fLenCurve = [ls2, fl_int(:,1)]; %interpolated data
    findNan = find(isnan(fLenCurve(:,2)));

    fLenCurve(findNan,:) = [];

    plot(ls2, fl_int(:,1))
    %legend("")
    xlabel("Length")
    ylabel("Force")

   
    h(2) = figure;
    plot(fvCurve(:,1), fvCurve(:,2))
    

end

