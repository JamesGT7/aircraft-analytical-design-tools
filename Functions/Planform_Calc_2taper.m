function[wing_span,c_r,c_k,c_t,wing_opp,wing_opp_2,wing_dihedral_opp,wing_kink_dihedral_opp,wing_sweep,x_wing_data,y_wing_data,wing_xlim,wing_ylim] = Planform_Calc_2taper(kink_distance_ratio,wing_area,wing_dihedral,AR,taper_ratio_t2r,taper_ratio_k2r,sweep_type,wing_sweep_input)

wing_span = sqrt(AR*wing_area) ;
%taper_ratio_t2k = taper_ratio_t2r/taper_ratio_k2r ; % Taper ratio between tip (numerator) and kink (denominator)
kink_distance = (kink_distance_ratio*wing_span/2) ; % Distance of kink from wing root, m

wing_dihedral_opp = 0.5*wing_span*tand(wing_dihedral) ; % m, wingtip height increase due to dihedral <--- IMPORTANT
wing_kink_dihedral_opp = wing_dihedral_opp*kink_distance_ratio ; % m

c_r = (2*wing_span)/(AR*((1-taper_ratio_t2r)*kink_distance_ratio+taper_ratio_k2r+taper_ratio_t2r)) ;
c_k = c_r*taper_ratio_k2r ;
c_t = c_r*taper_ratio_t2r ;

if sweep_type == 1            % LE Sweep Data Set
    wing_sweep = wing_sweep_input ;
%    wing_hyp = 0.5*wing_span/cosd(wing_sweep_input) ; % m, SWEEP TRIANGLE DISTANCE
    wing_opp = 0.5*wing_span*tand(wing_sweep_input) ; % m, SWEEP TRIANGLE DISTANCE
    wing_opp_2 = wing_opp ;
    
elseif sweep_type == 2        % 1/4 Chord Sweep Data Set
    wing_sweep = -atand(((kink_distance*tand(-wing_sweep_input)) + (c_k - c_r)/4 ) / kink_distance) ;
    wing_sweep_2 = -atand((((wing_span/2 - kink_distance)*tand(-wing_sweep_input)) + (c_t - c_k)/4 ) / (wing_span/2 - kink_distance)) ;
    
%    wing_hyp = 0.5*wing_span/cosd(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp = 0.5*wing_span*tand(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp_2 = 0.5*wing_span*tand(wing_sweep_2) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN

elseif sweep_type == 3        % 1/2 Chord Sweep Data Set
    wing_sweep = -atand(((kink_distance*tand(-wing_sweep_input)) + (c_k - c_r)/2 ) / kink_distance) ;
    wing_sweep_2 = -atand((((wing_span/2 - kink_distance)*tand(-wing_sweep_input)) + (c_t - c_k)/2 ) / (wing_span/2 - kink_distance)) ;
    
%    wing_hyp = 0.5*wing_span/cosd(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp = 0.5*wing_span*tand(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp_2 = 0.5*wing_span*tand(wing_sweep_2) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN

elseif sweep_type == 4        % TE Sweep Data Set
    wing_sweep = -atand(((kink_distance*tand(-wing_sweep_input)) + (c_k - c_r) ) / kink_distance) ;
    wing_sweep_2 = -atand((((wing_span/2 - kink_distance)*tand(-wing_sweep_input)) + (c_t - c_k) ) / (wing_span/2 - kink_distance)) ;
    
%    wing_hyp = 0.5*wing_span/cosd(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp = 0.5*wing_span*tand(wing_sweep) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
    wing_opp_2 = 0.5*wing_span*tand(wing_sweep_2) ; % m, SWEEP TRIANGLE DISTANCE, FOR WHOLE WINGSPAN
else
    error("ERROR: INVALID SWEEP_TYPE VALUE")
end

x_wing_data = [0, kink_distance_ratio*wing_span/2, wing_span/2, wing_span/2, kink_distance_ratio*wing_span/2, 0, 0];
y_wing_data = [c_r, c_r-(wing_opp*kink_distance_ratio), c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)), c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)) - c_t, c_r-(wing_opp*kink_distance_ratio)-c_k, 0, c_r];

wing_xlim = [-(wing_span/2)*0.4,(wing_span/2)*1.4] ;
wing_ylim = (wing_span/2)*0.9 ;

end