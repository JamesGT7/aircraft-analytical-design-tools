%% APC Propeller Calculator and Graph Plotter
clear
clc
% NOTE : This is APC's analytical data! No experimental data is shown here!
%% Constants

rho = 1.225 ; % kg/m^3
g = 9.81 ; % m/s^2

% System Variables
set_spacing = 30 ; % This is the spacing between two sets of RPM data in a file post-processing. Default is 30

% Aircraft Data
Mass_MTOW = 1.2 ; % kg
Weight_MTOW = Mass_MTOW*g ; % N

Velocity_cruise = 10 ; % m/s
Range_mission = 22910 ; % m
Time_mission = Range_mission/Velocity_cruise ; % s

disp(['Estimated mission time: ',num2str(Time_mission/60),' min'])

CD_estimated = 0.06 ;
Area_planform = 0.77857 ; % m^2
Drag_aircraft = (0.5)*rho*(Velocity_cruise^2)*CD_estimated*Area_planform;

disp(['Predicted Aircraft Drag (in Cruise): ', num2str(Drag_aircraft),', N'])

TW_target = 0.4 ;
Thrust_target_max = Weight_MTOW*TW_target ; % N

No_motor = 1 ; % Number of motors
Thrust_per_motor_target_max = Thrust_target_max/No_motor ;
Thrust_per_motor_target_cruise = Drag_aircraft/No_motor ;

% Motor Data
Cells_battery = 3 ; % 6s battery
Voltage_cell = 3.7 ; % V
Voltage_battery = Cells_battery*Voltage_cell ; 

KV_motor = 1150 ;
RPM_motor = KV_motor*Voltage_battery ; 

disp(['Predicted Max Motor RPM = ',num2str(floor(RPM_motor/1000)),',',num2str(RPM_motor-floor(RPM_motor/1000)*1000)])

%-----------------------------------------------------------------------------------------------------------------------------------
% MOTOR/ESC DATA
Power_motor_output_TO = 1650 ; % W, Change this after you find the data from the graphs
Power_motor_output_cruise = 780 ; % W, Change this after you find the data from the graphs
Efficiency_motor = 0.9 ;

disp(['Predicted Max Motor Power Draw = ', num2str((max(Power_motor_output_cruise,Power_motor_output_TO))/(Efficiency_motor)),' W'])

Power_motor_input_TO = Power_motor_output_TO/Efficiency_motor ; % W
Current_motor_burst = Power_motor_input_TO/Voltage_battery ; % A

Power_motor_input_cruise = Power_motor_output_cruise/Efficiency_motor ; % W
Current_motor_cruise = Power_motor_input_cruise/Voltage_battery ; % A
%-----------------------------------------------------------------------------------------------------------------------------------
% BATTERY DATA
Capacity_battery_raw = Time_mission*Power_motor_input_cruise ; % J, based solely on cruise for whole flight

Capacity_battery_mult = 0.83333 ; % Multiplier for battery capacity with buffer of (1/mult), to account for additional mass with buffer
%^^ HIGHLY advised to use at least 20% (0.83333)!!!!! IMechE aircraft get more points for higher final battery percentage, up to 70% (2023 UAS Challenge)
Capacity_battery_amphour = ((Capacity_battery_raw/3600)/Voltage_battery)/Capacity_battery_mult ; % Ah, see comment above

disp(['Predicted Battery Capacity (Raw) = ', num2str(((Capacity_battery_raw/3600)/Voltage_battery)*1000),' mAh'])
disp(['Predicted Battery Capacity (With ',num2str(((1/Capacity_battery_mult)-1)*100), '% buffer) = ', num2str(Capacity_battery_amphour*1000),' mAh'])

E_star = 160 ; % Wh/kg, Battery Energy Density
%^^ This is a rather conservative estimate for a 6S battery
Mass_Battery_estimate = (Capacity_battery_amphour*Voltage_battery)/E_star;

disp(['Predicted Battery Total Mass = ~',num2str(Mass_Battery_estimate*1000),' g'])
%% Read & Format DAT File
% This section reads a standard APC PER3 propeller data file, and converts
% it into a set of data columns concatenated into a matrix. Also clears
% the raw data table from workspace.

% NOTE: Data in matrix is shown as: [V, J, RPM, Pe, PWR, Torque, Thrust]
% NOTE 2: 3 Digit prop pitches are in tenths i.e.: 125 = 12.5 inches of pitch

Foldername = ('Prop Data'); % This is the name of the subfolder that the DAT files are in!
Filename = ('PER3_7x7E.dat'); % This is the name of the file in that subfolder!
% Halcyon can use a 14x7E prop at 430kV or above with a 6s battery

Proptitlename = Filename(6:end-4) ;

Proppath = [Foldername,'/',Filename] ;

Propfileraw = readmatrix(Proppath,'Filetype','text','Range',5,'Delimiter',' ') ;

Propdata = Propfileraw(:,[8,9,10,16,17,18,19,22,23,24,40,41,42,43, 45,46,47,48,49,50, 51,52,53,54,55,56,57]) ;
Propdata(isnan(Propdata)) = 0;

Propdata = Propdata(any(Propdata,2),:);

%Velocity
Propdata(:,1) = Propdata(:,1)+Propdata(:,2)+Propdata(:,3) ;
Propdata(:,[2,3]) = [] ;

%Advance Ratio
Propdata(:,2) = Propdata(:,2)+Propdata(:,3)+Propdata(:,4) ;
Propdata(:,[3,4]) = [] ;

%Propeller Efficiency
Propdata(:,4) = Propdata(:,4)+Propdata(:,5)+Propdata(:,6) ;
Propdata(:,[5,6]) = [] ;

%RPM
Propdata(:,5) = Propdata(:,5)+Propdata(:,6)+Propdata(:,7)+Propdata(:,8) ;
Propdata(:,[6,7,8]) = [] ;

%Torque
Propdata(:,6) = Propdata(:,6)+Propdata(:,7)+Propdata(:,8)+Propdata(:,9)+Propdata(:,10)+Propdata(:,11) ;
Propdata(:,[7,8,9,10,11]) = [] ;

%Thrust
Propdata(:,7) = Propdata(:,7)+Propdata(:,8)+Propdata(:,9)+Propdata(:,10)+Propdata(:,11)+Propdata(:,12)+Propdata(:,13);
Propdata(:,[8,9,10,11,12,13]) = [] ;

nrows = height(Propdata);
rpmsets = nrows/31;

for i = 1:rpmsets
    lowval = 1 + ((set_spacing+1)*(i-1)) ;
    highval = (set_spacing+1) + ((set_spacing+1)*(i-1)) ;


    Propdata(lowval,3) = Propdata(lowval,2)+Propdata(lowval,3) ;

    Propdata(lowval:highval,3) = Propdata(lowval,3);

    Propdata(lowval,1:7) = 0;
end
Propdata = Propdata(any(Propdata,2),:);

%clear Propfileraw

unit_correction = [0.44704, 1, 1, 1, 0.7457, 0.11298, 4.44822] ;
column_values = [{'Velocity (m/s)'},{'Advance Ratio'},{'RPM'},{'Propeller Efficiency'},{'Power Output (kW)'},{'Torque (Nm)'},{'Thrust (N)'}] ;
% Unit corrections are [mph->m/s, 1, 1, 1, hp->kW, In-lbf->Nm, lbf->N]
% Thus, all units are in base SI
%% Grid Plots
% This section takes the data matrix, and creates a set of grid plots for
% each data type, or a single multilayered plot

% NOTE: Matrix Columns in order: [V, J, RPM, Pe, PWR, Torque, Thrust]
% (This is for X and Y datasets) [1, 2, 3  , 4 , 5  , 6     , 7     ]
% V is velocity, J is advance ratio, Pe is effeciency performance


% 1 for grid plots, 2 for multilayered plot
multiplots = 1 ;

x_dataset = 1 ;
y_dataset = 7 ;

if multiplots == 1 || multiplots == 2
    for i = 1:rpmsets
        lowval = 1 + (set_spacing*(i-1)) ;
        highval = set_spacing + (set_spacing*(i-1)) ;
   


        if i == 1 && multiplots == 1
            figure(1)
            tiledlayout('flow','TileSpacing','compact')
        elseif i > 1 && multiplots == 1
            nexttile
            plot(Propdata(lowval:highval,x_dataset)*unit_correction(x_dataset),Propdata(lowval:highval,y_dataset)*unit_correction(y_dataset))

        elseif i == 1 && multiplots == 2
            figure(1)
            plot(Propdata(lowval:highval,x_dataset)*unit_correction(x_dataset),Propdata(lowval:highval,y_dataset)*unit_correction(y_dataset))
            hold on
        elseif i > 1 && multiplots == 2
            plot(Propdata(lowval:highval,x_dataset)*unit_correction(x_dataset),Propdata(lowval:highval,y_dataset)*unit_correction(y_dataset))
        end

        xlabel(column_values(x_dataset))
        ylabel(column_values(y_dataset))
        if x_dataset == 7
            xline(Thrust_per_motor_target_max,'r-')
            xline(Thrust_per_motor_target_cruise,'b-')
        elseif y_dataset == 7
            yline(Thrust_per_motor_target_max,'r-')
            yline(Thrust_per_motor_target_cruise,'b-')
        end

        if y_dataset == 1
            yline(Velocity_cruise,'k--')
        elseif x_dataset == 1
            xline(Velocity_cruise,'k--')
        end
        title([Proptitlename,' Propeller, ',num2str(Propdata(lowval,3)),' RPM'])

    end
    hold off
end

%% Interpolated Plots
% This section take the data matrix and a desired RPM, and interpolates the
% nearest two data sets into an single data plot that can be read. It also
% includes the main data sets as dashed line plots.

% NOTE: Matrix Columns in order: [V, J, RPM, Pe, PWR, Torque, Thrust]
% (This is for X and Y datasets) [1, 2, 3  , 4 , 5  , 6     , 7     ]

interpplots = 1 ; 

%RPM_desired = 11500 ;
RPM_desired = RPM_motor ;

x_dataset = 1 ;
y_dataset = 5 ;

if interpplots == 1
    rpmrangeshort = zeros(rpmsets,2) ;

    for i = 1:rpmsets
        lowval = 1 + (set_spacing*(i-1)) ;
        highval = set_spacing + (set_spacing*(i-1)) ;

        rpmrangeshort(i,1) = Propdata(lowval,3) ;
        rpmrangeshort(i,2) = lowval ;
    end

    if rpmrangeshort(end,1) < RPM_desired
        error("Your desired RPM is too high. Either use a lower estimate, or find an APC propeller with higher RPM data")
    end

    for i = 2:length(rpmrangeshort)
        if  (RPM_desired >= rpmrangeshort(i-1)) && (RPM_desired <= rpmrangeshort(i))
            rpm_low = rpmrangeshort(i-1,:) ;
            rpm_high = rpmrangeshort(i,:) ;
            break
        end
    end
    
    interpolated_x = zeros(1, rpm_high(2)-1-rpm_low(2)) ;
    interpolated_y = zeros(1, rpm_high(2)-1-rpm_low(2)) ;
    for i = rpm_low(2):(rpm_high(2)-1)
        interpolated_x(i+1-rpm_low(2)) = Propdata(i,x_dataset) + (RPM_desired-rpm_low(1))*((Propdata(i+set_spacing,x_dataset)-Propdata(i,x_dataset))/(rpm_high(1)-rpm_low(1))) ;
        
        interpolated_y(i+1-rpm_low(2)) = Propdata(i,y_dataset) + (RPM_desired-rpm_low(1))*((Propdata(i+set_spacing,y_dataset)-Propdata(i,y_dataset))/(rpm_high(1)-rpm_low(1))) ;
    end
    
    figure()
    plot(interpolated_x*unit_correction(x_dataset),interpolated_y*unit_correction(y_dataset),'-')
    hold on
    plot(Propdata((rpm_low(2):(rpm_low(2)+set_spacing-1)),x_dataset)*unit_correction(x_dataset),Propdata((rpm_low(2):(rpm_low(2)+set_spacing-1)),y_dataset)*unit_correction(y_dataset),'--')
    plot(Propdata((rpm_high(2):(rpm_high(2)+set_spacing-1)),x_dataset)*unit_correction(x_dataset),Propdata((rpm_high(2):(rpm_high(2)+set_spacing-1)),y_dataset)*unit_correction(y_dataset),'--')
    
    xlabel(column_values(x_dataset))
    ylabel(column_values(y_dataset))

    if y_dataset == 7
        yline(Thrust_per_motor_target_max,'r-')
        yline(Thrust_per_motor_target_cruise,'b-')
    elseif x_dataset == 7 
        xline(Thrust_per_motor_target_max,'r-')
        xline(Thrust_per_motor_target_cruise,'b-')
    end

 

    if y_dataset == 1
        yline(Velocity_cruise,'k--')
    elseif x_dataset == 1
        xline(Velocity_cruise,'k--')
    end
    
    warning('off','MATLAB:legend:IgnoringExtraEntries')
    legend([num2str(RPM_desired),' RPM (interpolated)'],[num2str(rpm_low(1)),' RPM'],[num2str(rpm_high(1)),' RPM'], '', '')
    warning('on','MATLAB:legend:IgnoringExtraEntries')
    title([Proptitlename,' Propeller, ',num2str(RPM_desired),' RPM (interpolated)'])
    hold off
end

