% Calculates the Planform Sizing of a Single-Taper Wing

% This was converted from a Htail code, however this should work with any single-taper lifting surface

% Make sure to use the equivalent inputs/outputs in your function call

function[x_Htail_data,y_Htail_data,H_span,H_c_r,H_c_t,Htail_opp,Htail_sweep,Htail_dihedral_opp,Htail_opp_2,Htail_adj_2,Htail_xlim,Htail_ylim] = Planform_Calc_1taper(Htail_area,AR_H,Htail_TR,Htail_dihedral,Htail_sweep,sweep_type)

H_span = sqrt(AR_H*Htail_area) ;
%Htail_chord_avg = H_span/AR_H


H_c_r = (2*H_span)/(AR_H*(1+Htail_TR)) ; % Htail Root Chord, m
H_c_t = H_c_r * Htail_TR ; % Htail Tip Chord, m


if sweep_type == 1 % LE Sweep

elseif sweep_type == 2 % Quarter Chord Sweep
    Htail_sweep = -atand((((H_span/2)*tand(-Htail_sweep)) + (H_c_t - H_c_r)/4 ) / (H_span/2));
elseif sweep_type == 3 % Half Chord Sweep
    Htail_sweep = -atand((((H_span/2)*tand(-Htail_sweep)) + (H_c_t - H_c_r)/2 ) / (H_span/2));
elseif sweep_type == 4 % TE Sweep
    Htail_sweep = -atand((((H_span/2)*tand(-Htail_sweep)) + (H_c_t - H_c_r) ) / (H_span/2));
end

Htail_dihedral_opp = 0.5*H_span*tand(Htail_dihedral) ;

Htail_opp = 0.5*H_span*tand(Htail_sweep); % m, SWEEP TRIANGLE DISTANCE

x_Htail_data = [0, H_span/2, H_span/2, 0, 0];
y_Htail_data = [H_c_r, H_c_r-Htail_opp, H_c_r*(1-Htail_TR)-Htail_opp, 0, H_c_r];

Htail_opp_2 = (y_Htail_data(3)-y_Htail_data(4));
Htail_adj_2 = (x_Htail_data(4)-x_Htail_data(3));


Htail_xlim = [-(H_span/2)*0.4,(H_span/2)*1.4] ;
Htail_ylim = (H_span/2)*0.9 ;
end