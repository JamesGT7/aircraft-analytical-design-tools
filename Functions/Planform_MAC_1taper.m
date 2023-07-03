% Graphical MAC Method (GMM), For Single Taper Wing
%
% LE is the LEADING EDGE
% c_r is the WING ROOT CHORD
% c_t is the WINGTIP CHORD
% wing_opp is the chordwise distance between LE ROOT AND LE TIP
% taper_ratio_t2r is the ratio of CHORD of WINGTIP to WING ROOT
%
% for the GMM
% x/y_mac_wing_data are the CHORD ADDITIONS
% mac_graph_line_1/2 are the GRADIENT LINES
% mac_point is the GRADIENT LINES COINCIDENT POINT
% mac_distance_ratio is the distance ratio of spanwise MAC to SEMISPAN
%
function[y_mac_wing_data_1,y_mac_wing_data_2,y_mac_wing_data_3,y_mac_wing_data_4,x_mac_wing_data_1,x_mac_wing_data_2,mac_graph_line_x_points,mac_graph_line_1_data,mac_graph_line_2_data,mac_graph_data_y,mac_graph_data_x,wing_graph_AC,quarter_chord_x,quarter_chord_y] = Planform_MAC_1taper(wing_span,c_t,c_r,wing_opp)

taper_ratio_t2r = c_t/c_r ;

y_mac_wing_data_1 = [-c_t,0] ;
y_mac_wing_data_2 = [c_r,c_t+c_r] ;
y_mac_wing_data_3 = [c_r-wing_opp+c_r,c_r-wing_opp] ;
y_mac_wing_data_4 = [c_r*(1-taper_ratio_t2r)-wing_opp,c_r*(1-taper_ratio_t2r)-wing_opp-c_r] ;

x_mac_wing_data_1 = [0,0] ;
x_mac_wing_data_2 = [wing_span/2,wing_span/2] ;

mac_graph_line_1_grad = ((c_r-wing_opp+c_r)-(-c_t))/((wing_span/2)-(0)) ; % (y2-y1)/(x2-x1)
mac_graph_line_2_grad = ((c_r*(1-taper_ratio_t2r)-wing_opp-c_r)-(c_t+c_r))/((wing_span/2)-(0)) ; % (y2-y1)/(x2-x1)

mac_graph_line_x_points = [0,wing_span/2] ;
mac_graph_line_1_data = mac_graph_line_1_grad*mac_graph_line_x_points + (-c_t) ;
mac_graph_line_2_data = mac_graph_line_2_grad*mac_graph_line_x_points + (c_t+c_r) ;

mac_point_x = ((c_t+c_r)-(-c_t))/((mac_graph_line_1_grad)-(mac_graph_line_2_grad)) ;
%mac_point_y = mac_graph_line_1_grad*mac_point_x + (-c_t) ;
mac_distance_ratio = mac_point_x/(wing_span/2) ;

rear_trig_opp = (c_r-wing_opp-c_t) ;
mac_graph_data_y = [c_r-(wing_opp*mac_distance_ratio),rear_trig_opp*mac_distance_ratio] ;
mac_graph_data_x = [mac_point_x, mac_point_x] ;


MAC_graph_output = abs((mac_graph_data_y(1)-mac_graph_data_y(2))) ;
wing_graph_AC = [mac_point_x,mac_graph_data_y(1)-(0.25*MAC_graph_output)] ;

quarter_chord_x = [0, wing_span/2] ;
quarter_chord_y = [c_r*0.75, c_r-wing_opp-(c_t*0.25)] ;

%quarter_chord_opp_panel_1 = (quarter_chord_y(1)-quarter_chord_y(2)) ;
%quarter_chord_adj_panel_1 = (quarter_chord_x(2)-quarter_chord_x(1)) ;

%quarter_chord_angle_panel_1 = atand(quarter_chord_opp_panel_1/quarter_chord_adj_panel_1) ;
end