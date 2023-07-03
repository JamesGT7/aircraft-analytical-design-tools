% This Function finds the Area (A), the 2nd Moment of Area (I), and the
% Polar Moment of Area (J) of an aerofoil, given the upper and lower surface
% points of the aerofoil IN ASCENDING ORDER OF CHORD (x)

function[A,centroid_x,I_x,I_y,J,expr_upper,expr_lower,index1,index2] = AIJ_aerofoil(upper_surface_points,lower_surface_points)

warning('off','all')

%------------------------------

delta1sum = zeros(1,20) ;
delta2sum = zeros(1,20) ;

for i = 1:10
[upper_surface_points_find,S1] = polyfit(upper_surface_points(:,1),upper_surface_points(:,2), i) ;
[lower_surface_points_find,S2] = polyfit(lower_surface_points(:,1),lower_surface_points(:,2), i) ;

[~,delta1] = polyval(upper_surface_points_find,[upper_surface_points(:,1),upper_surface_points(:,2)],S1) ;
[~,delta2] = polyval(lower_surface_points_find,[lower_surface_points(:,1),lower_surface_points(:,2)],S2) ;

delta1sum(i) = sum(abs(delta1),"all");
delta2sum(i) = sum(abs(delta2),"all");
end

[~,index1] = min(delta1sum) ;
[~,index2] = min(delta2sum) ;

upper_surface_points_eq = polyfit(upper_surface_points(:,1),upper_surface_points(:,2), index1) ;
lower_surface_points_eq = polyfit(lower_surface_points(:,1),lower_surface_points(:,2), index2) ;

syms x y 

expr_upper = poly2sym(upper_surface_points_eq) ;
expr_lower = poly2sym(lower_surface_points_eq) ;

%------------------------------

% upper_surface_points_eq = polyfit(upper_surface_points(:,1),upper_surface_points(:,2), 20) ;
% lower_surface_points_eq = polyfit(lower_surface_points(:,1),lower_surface_points(:,2), 20) ;
% 
% syms x y 
% 
% expr_upper = poly2sym(upper_surface_points_eq) ;
% expr_lower = poly2sym(lower_surface_points_eq) ;

%------------------------------

A = double(vpa(int(expr_upper,0,max(upper_surface_points(:,1))) - int(expr_lower,0,max(upper_surface_points(:,1))))) ;

centroid_x_1_upper = int(x*expr_upper,x,0,max(upper_surface_points(:,1))) ;
centroid_x_1_lower = int(x*expr_lower,x,0,max(lower_surface_points(:,1))) ;

centroid_x = double((1/A)*(centroid_x_1_upper - centroid_x_1_lower)) ;

% Centroid calculation is quite precise, only loses about 0.05% precision due to numerical approximation, compared to Fusion360

I_x_integral_1 = int(y^2,y,expr_lower,expr_upper);
I_x_integral_2 = int(I_x_integral_1,x,0,max(upper_surface_points(:,1)));
I_x = double(vpa(I_x_integral_2,5)) ;

I_y_integral_1 = int(x^2,y,expr_lower,expr_upper);
I_y_integral_2 = int(I_y_integral_1,x,0,max(upper_surface_points(:,1)));
I_y = double(vpa(I_y_integral_2,5)) ;

J = I_x+I_y ;

warning('on','all')
end