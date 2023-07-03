%Control Surface Sizing Calculations - Spanwise Pivot, Central Mounted

% This Function calculates the elevator control surface size and shape, dependent on
% the input values of the Htail used in the previous functions

% This Function assumes that the leading edge of the control surface (the
% pivot) is aligned with the span of the tail, and is always placed with
% midspan at the centre of the trailing edge of the Htail

function[Htail_x_control_surface_data,Htail_y_control_surface_data] = CS_Spanwise_Pivot(CS_area_ratio_desired,Htail_span_ratio,Htail_opp_2,Htail_adj_2,H_span,H_c_r,H_c_t,Htail_opp,Htail_sweep)

    Htail_area = H_span*((H_c_t+H_c_r)/2) ;
    elevator_area_desired = Htail_area*CS_area_ratio_desired ; % m^2
    
    if Htail_span_ratio < 1        
        H_span = H_span*Htail_span_ratio ;
        Htail_opp = Htail_opp*Htail_span_ratio ;
        Htail_opp_2 = Htail_opp_2*Htail_span_ratio ;
        Htail_adj_2 = Htail_adj_2*Htail_span_ratio ;
        H_c_r = H_c_r*Htail_span_ratio ;
        H_c_t = H_c_t*Htail_span_ratio ;
        Htail_area = H_span*((H_c_t+H_c_r)/2) ;
    end

    Htail_rear_triangle = 0.5 * (H_span) * abs(Htail_opp_2) ;
    
    if Htail_opp_2 < 0
        Htail_rectangle = (H_span * H_c_t) + Htail_opp_2 ;
    else
        Htail_rectangle = (H_span * H_c_t) ;
    end


    if elevator_area_desired > (Htail_rear_triangle + Htail_rectangle)
       
        if elevator_area_desired > Htail_area
            warning("Warning: You're asking for more control surface area than is available!")
        end

        A_3 = (Htail_area - elevator_area_desired)/2 ;
        y_3 = Htail_opp - sqrt(A_3 * tand(Htail_sweep)*2);
        
        y_1 = y_3 + Htail_opp_2 + H_c_t ;
        
%         A_test = (1/2)*(Htail_opp - y_3)*(H_span/2)*(1 - y_3/Htail_opp) ;
        

        Htail_x_control_surface_data = [0, (H_span/2)*(1 - y_3/Htail_opp), H_span/2, H_span/2, 0, 0] ;
        Htail_y_control_surface_data = [y_1, y_1, H_c_r-Htail_opp,Htail_opp_2,0,y_1] ;
        
        disp("OUTPUT 1")

%         area_calc_ratio = (Htail_area - (Htail_opp - y_3)*(H_span/2)*(1 - y_3/Htail_opp)) /(elevator_area_desired) ;

    elseif elevator_area_desired > Htail_rear_triangle
        
        A_2 = elevator_area_desired - Htail_rear_triangle ;
        y_2 = A_2/(H_span) ;
    
        y_1 = y_2 + abs(Htail_opp_2) ;
    

%         area_calc_ratio = 2*(((1/2) * abs(Htail_opp_2) * (H_span/2)) + ((y_2)*(H_span/2))) /elevator_area_desired ;

        if Htail_opp_2 >= 0
            

            Htail_x_control_surface_data = [0, H_span/2, H_span/2, 0, 0] ;
            Htail_y_control_surface_data = [y_1, y_1, Htail_opp_2, 0, y_1] ;
        
            
        else
            

            Htail_x_control_surface_data = [0, H_span/2, H_span/2, 0, 0] ;
            Htail_y_control_surface_data = [y_2, y_2, Htail_opp_2, 0, y_2] ;

        end
    else
        theta = atan(Htail_opp_2/Htail_adj_2) ;
        y_1 = sqrt(elevator_area_desired*tan(abs(theta))) ;
        
%         area_calc_ratio = 2*((1/2) * y_1 * (H_span/2)*(y_1/Htail_opp_2)) /elevator_area_desired ;

        if Htail_opp_2 >= 0            


            Htail_x_control_surface_data = [0, (H_span/2)*(y_1/abs(Htail_opp_2)), 0, 0] ;
            Htail_y_control_surface_data = [y_1, y_1, 0, y_1] ;
        
            
            
        else

            Htail_x_control_surface_data = [(H_span/2)*(-y_1/Htail_opp_2), H_span/2, H_span/2, (H_span/2)*(-y_1/Htail_opp_2)] ;
            Htail_y_control_surface_data = [-y_1,-y_1,Htail_opp_2,-y_1] ;
            
        end
    end

end