% M-file, torque_speed_curve.m 
% Plot the torque-speed curve of the induction motor from Example 7-5.

% Initialize the values needed in this program.
rl = 0.641;          % Stator resistance (ohms)
xl = 1.106;          % Stator reactance (ohms)
r2 = 0.332;          % Rotor resistance (ohms)
x2 = 0.464;          % Rotor reactance (ohms)
xm = 26.3;           % Magnetization branch reactance (ohms)
v_phase = 460 / sqrt(3); % Phase voltage (volts)
n_sync = 1800;       % Synchronous speed (r/min)
w_sync = 188.5;      % Synchronous speed (rad/s)

% Calculate the Thevenin voltage and impedance
z_th = ((rl + 1j*xl) * (1j*xm)) / (rl + 1j*(xl + xm));
v_th = v_phase * z_th;

% Calculate the torque-speed characteristic for slips between 0 and 1.
s = (0:1/50:1);    % Slip
s(1) = 0.001;      % Avoid divide by zero problems
run = (1 - s) * n_sync; % Mechanical speed (r/min)

% Preallocate arrays for torque values
t_ind1 = zeros(1, length(s));
t_ind2 = zeros(1, length(s));
t_ind3 = zeros(1, length(s));

% Calculate torque for original and doubled rotor resistance
for ii = 1:length(s)
    r_th = rl * s(ii) / (s(ii) + 1);
    x_th = xl * xm / (xl + xm);
    
    t_ind1(ii) = (3 * abs(v_th)^2 * r2 / s(ii)) / ...
                 (w_sync * ((r_th + r2/s(ii))^2 + (x_th + x2)^2));
             
    t_ind2(ii) = (3 * abs(v_th)^2 * (2*r2) / s(ii)) / ...
                 (w_sync * ((r_th + (2*r2)/s(ii))^2 + (x_th + x2)^2));
    t_ind3(ii) = (3 * abs(v_th)^2 * (0.5*r2) / s(ii)) / ...
                 (w_sync * ((r_th + (0.5*r2)/s(ii))^2 + (x_th + x2)^2));
end

% Plot the torque-speed curves
figure;
plot(run, t_ind1, 'k-', 'LineWidth', 2.0);
hold on;
plot(run, t_ind2, 'r-.', 'LineWidth', 2.0);
hold on;
plot(run , t_ind3 , 'b-' , 'LineWidth',2.0)
xlabel('n (rpm)', 'FontWeight', 'Bold');
ylabel('\tau_{ind} (N.m)', 'FontWeight', 'Bold');
title('Induction motor torque-speed characteristic', 'FontWeight', 'Bold');
legend('Original R_{2}', 'Doubled R_{2}','Halved R_{2}', 'Location', 'Best');
grid on;
hold off;