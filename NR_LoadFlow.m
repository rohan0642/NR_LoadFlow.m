clc;
clear;

%% ---------------- BUS DATA ----------------
% Bus | Type | P(pu) | Q(pu) | V(pu) | delta(rad)
bus_data = [
    1  1   0     0     1.06   0;     % Slack
    2  2   0.5   0     1.04   0;     % PV
    3  3  -0.6  -0.3   1.00   0      % PQ
];

%% ---------------- LINE DATA ----------------
% From  To   R     X     B/2
line_data = [
    1   2   0.02  0.06  0.03;
    1   3   0.08  0.24  0.025;
    2   3   0.06  0.18  0.02
];

%% ---------------- Y-BUS FORMATION ----------------
nb = max(max(line_data(:,1:2)));
Y = zeros(nb, nb);

for k = 1:size(line_data,1)
    i = line_data(k,1);
    j = line_data(k,2);
    z = line_data(k,3) + 1i*line_data(k,4);
    y = 1/z;
    b = 1i*line_data(k,5);

    Y(i,i) = Y(i,i) + y + b;
    Y(j,j) = Y(j,j) + y + b;
    Y(i,j) = Y(i,j) - y;
    Y(j,i) = Y(i,j);
end

%% ---------------- INITIALIZATION ----------------
V = bus_data(:,5);
delta = bus_data(:,6);

P_spec = bus_data(:,3);
Q_spec = bus_data(:,4);

bus_type = bus_data(:,2);

tolerance = 1e-6;
max_iter = 10;
nbus = length(V);

% Number of equations
np = sum(bus_type ~= 1);   % non-slack buses
nq = sum(bus_type == 3);   % PQ buses

P = zeros(nbus,1);
Q = zeros(nbus,1);

%% ---------------- NEWTON–RAPHSON ITERATION ----------------
for iter = 1:max_iter

    % ---- Power Calculation ----
    P(:) = 0;
    Q(:) = 0;

    for i = 1:nbus
        for j = 1:nbus
            G = real(Y(i,j));
            B = imag(Y(i,j));
            P(i) = P(i) + V(i)*V(j)*( G*cos(delta(i)-delta(j)) + B*sin(delta(i)-delta(j)) );
            Q(i) = Q(i) + V(i)*V(j)*( G*sin(delta(i)-delta(j)) - B*cos(delta(i)-delta(j)) );
        end
    end

    % ---- Mismatch Calculation ----
    dP = P_spec - P;
    dQ = Q_spec - Q;

    mismatch = zeros(np + nq, 1);
    k = 1;

    for i = 1:nbus
        if bus_type(i) ~= 1
            mismatch(k) = dP(i);
            k = k + 1;
        end
    end

    for i = 1:nbus
        if bus_type(i) == 3
            mismatch(k) = dQ(i);
            k = k + 1;
        end
    end

    % ---- Convergence Check ----
    if max(abs(mismatch)) < tolerance
        fprintf('Converged in %d iterations\n', iter);
        break;
    end

alpha = 0.2;   % damping factor (0.1–0.3 is safe)

dx = alpha * mismatch;


    index = 1;
    for i = 1:nbus
        if bus_type(i) ~= 1
            delta(i) = delta(i) + dx(index);
            index = index + 1;
        end
    end

    for i = 1:nbus
        if bus_type(i) == 3
            V(i) = V(i) + dx(index);
            index = index + 1;
        end
    end

end

%% ---------------- RESULTS ----------------
disp('Final Bus Voltages (pu):');
disp(V);

disp('Final Bus Angles (degrees):');
disp(rad2deg(delta));
