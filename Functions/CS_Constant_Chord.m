% Control Surface Sizing Calculations - Constant Chord Ratio, Edge Mounted

% This Function calculates the control surface size and shape, dependent on
% the input values of the Htail used in the previous functions

% This function assumes that the control surface chord is a constant ratio of
% the tail where it is located, and the the elevators are always placed at
% the ends of the trailing edge of the Htail

function[Htail_x_control_surface_data,Htail_y_control_surface_data,Htail_S_control_ratio] = CS_Constant_Chord(CS_area_ratio_desired,Htail_opp_2,Htail_adj_2,H_span,Htail_sweep,elevator_chord_ratio,H_c_r,H_c_t,Htail_opp)

if elevator_chord_ratio < CS_area_ratio_desired
    warning("Warning: You're asking for more control surface area than is available!")
end

Htail_area = H_span*((H_c_t+H_c_r)/2) ;
elevator_area_desired_half = Htail_area*CS_area_ratio_desired/2 ; % m^2

Htail_trailing_edge_sweep_taper2 = atand((Htail_opp_2)/(Htail_adj_2)) ; % Sweep of the trailing edge of Htail

Htail_quad_a = 0.5*(tand(Htail_sweep)-tand(Htail_trailing_edge_sweep_taper2)) ;
Htail_quad_b = H_c_t ;
Htail_quad_c = -(elevator_area_desired_half/elevator_chord_ratio) ;

Htail_S_control = ((-Htail_quad_b) + sqrt((Htail_quad_b^2) - (4*Htail_quad_a*Htail_quad_c)))/(2*Htail_quad_a) ; % Control surface span, m

Htail_c_control_min = H_c_t * elevator_chord_ratio ; % shortest chord of the control surface, m
Htail_c_control_max = (H_c_t + Htail_S_control*(tand(Htail_sweep)-tand(Htail_trailing_edge_sweep_taper2)))*elevator_chord_ratio ; % longest chord of the control surface, m

Htail_x_control_surface_data = [(H_span/2)-Htail_S_control,(H_span/2),(H_span/2),(H_span/2)-Htail_S_control,(H_span/2)-Htail_S_control] ;
Htail_y_control_surface_data = [H_c_r-Htail_opp-H_c_t+Htail_opp_2*(Htail_S_control/Htail_adj_2)+Htail_c_control_max,H_c_r-Htail_opp-H_c_t+Htail_c_control_min,H_c_r-Htail_opp-H_c_t,H_c_r-Htail_opp-H_c_t+Htail_opp_2*(Htail_S_control/Htail_adj_2),H_c_r-Htail_opp-H_c_t+Htail_opp_2*(Htail_S_control/Htail_adj_2)+Htail_c_control_max] ;

Htail_S_control_ratio = (Htail_S_control)/(H_span/2) ; % ratio of control surface width to Htail span
end