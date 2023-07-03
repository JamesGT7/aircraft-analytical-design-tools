function[y_mac_wing_data_root_1,y_mac_wing_data_root_2,y_mac_wing_data_kink_1,y_mac_wing_data_kink_2,y_mac_wing_data_kink_3,y_mac_wing_data_kink_4,y_mac_wing_data_tip_1,y_mac_wing_data_tip_2,x_mac_wing_data_1,x_mac_wing_data_2,x_mac_wing_data_3,x_mac_inner_point,y_mac_inner_point,y_mac_data_inner,x_mac_outer_point,y_mac_outer_point,x_mac_outer_point_wing,y_mac_data_outer,y_mac_wing_data_inner_1,y_mac_wing_data_inner_2,y_mac_wing_data_outer_1,y_mac_wing_data_outer_2,mac_total,mac_graph_data_y,wing_graph_AC,quarter_chord_x,quarter_chord_y] = Planform_MAC_2taper(wing_span,kink_distance_ratio,c_r,c_k,c_t,wing_opp,wing_opp_2)


% Double MAC Graphical Calculation
% Positions are array ordered [REAR,FRONT] for all calculation lines

y_wing_data = [c_r, c_r-(wing_opp*kink_distance_ratio), c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)), c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)) - c_t, c_r-(wing_opp*kink_distance_ratio)-c_k, 0, c_r];

y_mac_wing_data_root_1 = [-c_k,0] ; % Kink Rear
y_mac_wing_data_root_2 = [c_r,c_k+c_r] ; % Kink Front

y_mac_wing_data_kink_1 = [c_r-(kink_distance_ratio*wing_opp)-c_k-c_r, c_r-(kink_distance_ratio*wing_opp)-c_k] ; % Root Rear
y_mac_wing_data_kink_2 = [c_r-(kink_distance_ratio*wing_opp), 2*c_r-(kink_distance_ratio*wing_opp)] ; % Root Front
y_mac_wing_data_kink_3 = [c_r-(kink_distance_ratio*wing_opp)-c_k-c_t, c_r-kink_distance_ratio*wing_opp-c_k] ; % Tip Rear
y_mac_wing_data_kink_4 = [c_r-(kink_distance_ratio*wing_opp), c_r-(kink_distance_ratio*wing_opp)+c_t] ; % Tip Front


y_mac_wing_data_tip_1 = [c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio))-c_t-c_k, c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)) - c_t] ; % Kink Rear
y_mac_wing_data_tip_2 = [c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)), c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio))+c_k] ; % Kink Front


x_mac_wing_data_1 = [0,0] ;
x_mac_wing_data_2 = [kink_distance_ratio*wing_span/2,kink_distance_ratio*wing_span/2] ;
x_mac_wing_data_3 = [wing_span/2,wing_span/2] ;


m_1 = (y_mac_wing_data_kink_2(2)-y_mac_wing_data_root_1(1))/(x_mac_wing_data_2(1)-x_mac_wing_data_1(1)) ; % ROOT REAR TO KINK FRONT
m_2 = (y_mac_wing_data_kink_1(1)-y_mac_wing_data_root_2(2))/(x_mac_wing_data_2(1)-x_mac_wing_data_1(1)) ; % ROOT FRONT TO KINK REAR

m_3 = (y_mac_wing_data_tip_2(2)-y_mac_wing_data_kink_3(1))/(x_mac_wing_data_3(1)-x_mac_wing_data_2(1)) ; % KINK REAR TO TIP FRONT
m_4 = (y_mac_wing_data_tip_1(1)-y_mac_wing_data_kink_4(2))/(x_mac_wing_data_3(1)-x_mac_wing_data_2(1)) ; % KINK FRONT TO TIP REAR

x_mac_inner_point = (y_mac_wing_data_root_2(2)-y_mac_wing_data_root_1(1))/(m_1-m_2) ;
y_mac_inner_point = x_mac_inner_point*m_1+y_mac_wing_data_root_1(1) ;

rear_trig_opp = (y_wing_data(4)-y_wing_data(5)) ; % Longitudinal distance between trailing edge wingtip and trailing edge wing kink
rear_trig_opp_root = (y_wing_data(5)-y_wing_data(6)) ; % Longitudinal distance between trailing edge wingtip and trailing edge wing kink

mac_inner_opp = (c_r - wing_opp*(2*x_mac_inner_point/wing_span)) ;

c_inner = mac_inner_opp - (rear_trig_opp_root*(x_mac_inner_point/(kink_distance_ratio*wing_span/2))) ;
y_mac_data_inner = [mac_inner_opp,mac_inner_opp-c_inner] ;

x_mac_outer_point = ((y_mac_wing_data_kink_4(2)-y_mac_wing_data_kink_3(1))/(m_3-m_4)) ;
y_mac_outer_point = x_mac_outer_point*m_3+y_mac_wing_data_kink_3(1) ;

x_mac_outer_point_wing = ((y_mac_wing_data_kink_4(2)-y_mac_wing_data_kink_3(1))/(m_3-m_4))+kink_distance_ratio*wing_span/2 ;

mac_outer_opp = c_r - (wing_opp*kink_distance_ratio) - (wing_opp_2*(x_mac_outer_point_wing - (wing_span*kink_distance_ratio/2))/((wing_span/2) - (wing_span*kink_distance_ratio/2))*(1-kink_distance_ratio)) ;

c_outer = mac_outer_opp - (y_wing_data(5)+rear_trig_opp*x_mac_outer_point/((1-kink_distance_ratio)*wing_span/2)) ;
y_mac_data_outer = [mac_outer_opp,mac_outer_opp - c_outer] ;

y_mac_wing_data_inner_1 = [y_mac_data_inner(2)-c_outer,y_mac_data_inner(2)] ; % INNER MAC REAR
y_mac_wing_data_inner_2 = [y_mac_data_inner(1),y_mac_data_inner(1)+c_outer] ; % INNER MAC FRONT

y_mac_wing_data_outer_1 = [y_mac_data_outer(2)-c_inner,y_mac_data_outer(2)] ; % OUTER MAC REAR
y_mac_wing_data_outer_2 = [y_mac_data_outer(1),y_mac_data_outer(1)+c_inner] ; % OUTER MAC FRONT

m_5 = (y_mac_wing_data_outer_2(2)-y_mac_wing_data_inner_1(1))/(x_mac_outer_point_wing-x_mac_inner_point) ;
m_6 = (y_mac_wing_data_outer_1(1)-y_mac_wing_data_inner_2(2))/(x_mac_outer_point_wing-x_mac_inner_point) ;

x_mac_total = (y_mac_wing_data_inner_2(2)-y_mac_wing_data_inner_1(1))/(m_5-m_6) ;
y_mac_total = (m_5*x_mac_total+y_mac_wing_data_inner_1(1)) ;

x_mac_total_point = x_mac_total+x_mac_inner_point ;

mac_total = [x_mac_total_point,y_mac_total] ;

mac_total_opp = (c_r - wing_opp*(2*x_mac_total_point/wing_span)) ;

if x_mac_total_point >= (wing_span*kink_distance_ratio/2)
    MAC_graph_output = mac_total_opp - (y_wing_data(5)+rear_trig_opp*(x_mac_total_point-(wing_span*kink_distance_ratio/2))/((1-kink_distance_ratio)*wing_span/2)) ;
else
    MAC_graph_output = mac_total_opp - (rear_trig_opp_root*(x_mac_total_point/(kink_distance_ratio*wing_span/2))) ;
end

mac_graph_data_y = [mac_total_opp,mac_total_opp-MAC_graph_output] ;

y_AC = mac_total_opp - (0.25*MAC_graph_output) ;
wing_graph_AC = [x_mac_total_point,y_AC] ;

quarter_chord_x = [0,(wing_span*kink_distance_ratio/2),wing_span/2] ;
quarter_chord_y = [c_r*0.75,(c_r-(wing_opp*kink_distance_ratio)-(c_k*0.25)),c_r-(wing_opp*kink_distance_ratio)-(wing_opp_2*(1-kink_distance_ratio)) - (c_t*0.25)] ;


