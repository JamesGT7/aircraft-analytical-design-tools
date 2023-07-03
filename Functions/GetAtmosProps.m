% Calculates Air Pressure, Temperature, Density, and Local Speed of Sound

function[pres,temp,dens,spdsound] = GetAtmosProps(alt_in_metres,offtemp,offlapse)
%alt in METRES
%offtemp in DEGREES
%offlapse in DEGREES/METRE


%List of Constants, Part 1
R=287.05287;
gamma = 1.4;
g = 9.8065;

%List of Constants, Part 2
T0=288.15;
L0=-0.0065;
T11=216.65;
P0=101325;
H11=11000;
P11=22632.559;

%if statement to work out which set of equations to use
if alt_in_metres < 11000
    %equations for altitude below 11,000m, troposphere
    temp=(alt_in_metres*(L0+offlapse))+(T0+offtemp);
    pres = P0*(1+((L0+offlapse)/(T0+offtemp))*alt_in_metres)^(-g/(R*L0+offlapse));
elseif (11000<= alt_in_metres) && (alt_in_metres <= 20000)
    %equations for altitude between 11,000m and 20,000m, lower stratosphere
    temp = T11+offtemp;
    pres = P11*exp((-g/(R*(T11))*(alt_in_metres-H11)));
else
    %TBD if needed; equations above 20,000m, upper stratosphere
    disp("Error, altitude value too great");
end



%density and speed of sound equations
dens = pres/(R*temp);
spdsound = sqrt(gamma*R*temp);