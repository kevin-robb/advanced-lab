close all %close all plots. optional command


% read in data file from double slit with laser
filename = 'aug29_ds_laser.csv';
delimiterIn = ',';
headerlinesIn = 1;
%ds_laser_data = importdata(filename,delimiterIn,headerlinesIn);
ds_laser_data = readtable(filename);
% this data has ind. var. "Posiiton", the micrometer position in mm
% and dep. var. "Voltage", the output voltage in volts. This voltage
% will be our intensity approximation. 

% x-coordinate
x_exp_start = 2.8;
x_exp_end = 8.8;
x_exp_point_density = 10;
x_exp = x_exp_start:(1/x_exp_point_density):x_exp_end;

% create fit and plot data

% c = (I_0, a, d, lambda)
guess = [1.044, 0.1, 0.1, 6.0];

nlm = fitnlm(x_exp,ds_laser_data.Voltage,fraun_ds,guess);

x_fit_start = -100;
x_fit_end = 100;
x_fit_point_density = 25;
x_fit = x_fit_start:(1/x_fit_point_density):x_fit_end;
c_fit = nlm.Coefficients.Estimate';
A_fit = fraun_ds(c_fit,x_fit);


% define function the data should fit. fraunhofer appx.
% c = (I_0, a, d, lambda)
% x = Position. get angle to center from double slit (Position - 5.35)/500
function I = fraun_ds(c,x)
    % theta = (x-5.35)./500;
    theta = 0.001;
    alpha = pi*c(2)/c(4)*sin(theta);
    beta = pi*c(3)/c(4)*sin(theta);
    I = c(1)*(sin(alpha)/alpha)^2*(cos(beta))^2;
end