% This fuction calculates the thickness, camber, and shape of a NACA
% 4-digit aerofoil given the name of the NACA aerofoil as input AS A STRING

function[x, y_c, y_l, y_u, y_l_s, y_u_s] = NACA_4dig_gen(NACA_Aerofoil_Name)
M = str2double(NACA_Aerofoil_Name(6))/100 ; % NACA Max Camber
P = str2double(NACA_Aerofoil_Name(7))/10 ; % NACA Max Camber Position
if P == 0
    P = 1e-8 ;
end
T = str2double(NACA_Aerofoil_Name(8:9))/100 ; % NACA Max Thickness

syms x y_c d_y_c__d_x y_t theta x_u x_l

y_c = (M/(P^2))*(2*P*x - x^2) * heaviside(1-(x/P)) + (M/(1-P)^2)*(1 - 2*P + 2*P*x - x^2) * heaviside((x/P)-1) ; % The Heaviside function is used as an alternative to Macaulay brackets, which MATLAB does not include
d_y_c__d_x = ((2*M)/(P^2))*(P - x) * heaviside(1-(x/P)) + ((2*M)/((1-P)^2))*(P-x) * heaviside((x/P)-1) ;

y_t = (T/0.2)*(0.2969*x^0.5 + -0.126*x + -0.3516*x^2 + 0.2843*x^3 + -0.1036*x^4) ;

theta = atan(d_y_c__d_x) ;

%x_l = x - y_t*sin(theta) ; % Use these to accurately calculate the curvature of the aerofoil surfaces
%x_u = x + y_t*sin(theta) ;

y_l = y_c - y_t*cos(theta) ;
y_u = y_c + y_t*cos(theta) ;


x = linspace(0,1,100) ;
y_l_s = double(subs(y_l)) ;
y_u_s = double(subs(y_u)) ;
end