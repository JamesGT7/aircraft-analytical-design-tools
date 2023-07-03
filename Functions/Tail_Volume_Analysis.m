% Tail Volume Calculation of Either Horizontal or Vertical Tail

% C_H is the Tail Volume Coefficient
% S_H_S is the Tail to Wing Area Ratio
% dimension_length can be one of two things:
% For the Htail: the Mean Aerodynamic Chord (MAC) of the wing
% For the Vtail: the total span of the wing (wingspan)

function[Htail_area,l_H] = Tail_Volume_Analysis(wing_area,C_H,S_H_S,dimension_length)

Htail_area = S_H_S * wing_area ; % Horizontal Tail Area, m^2

l_H = (C_H * wing_area * dimension_length)/(Htail_area) ; % Tail Moment Arm, m

end