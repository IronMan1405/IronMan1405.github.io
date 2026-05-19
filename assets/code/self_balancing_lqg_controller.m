clc; clear; close all;

m = 0.36;   % kg
l = 0.07;   % m
g = 9.81;

I = m*l^2;  % kg·m^2

% x = [theta; theta_dot]
% u = torque

A = [ 0        1;
      m*g*l/I  0 ];

B = [ 0;
      1/I ];

C = eye(2);           % measure both states
D = zeros(2,1);

Q = diag([50, 1]);
R = 0.1;

K = lqr(A, B, Q, R);

disp('LQR gain K =');
disp(K);

W = diag([1e-6, 1e-4]);
V = diag([1e-4, 1e-3]);

[L,~,~] = lqe(A, eye(2), C, W, V);

disp('Kalman gain L =');
disp(L);

tau_max = 0.16;  % Nm

dt = 0.001;
Tend = 5;
t = 0:dt:Tend;

x       = zeros(2, length(t));   % true state
x_hat   = zeros(2, length(t));   % estimated state
y       = zeros(2, length(t));   % measurements
u_hist  = zeros(1, length(t));

x(:,1)     = [0.05; 0];   % initial tilt
x_hat(:,1)= [0; 0];       % estimator starts wrong on purpose

for k = 1:length(t)-1

    y(:,k) = x(:,k) + sqrt(V)*randn(2,1);

    u = -K * x_hat(:,k);

    u = max(min(u, tau_max), -tau_max);

    xdot = A*x(:,k) + B*u;
    x(:,k+1) = x(:,k) + xdot*dt;

    x_hat_dot = A*x_hat(:,k) + B*u ...
              + L*(y(:,k) - C*x_hat(:,k));

    x_hat(:,k+1) = x_hat(:,k) + x_hat_dot*dt;

    u_hist(k) = u;
end

% figure('Color','w');
figure;

subplot(3,1,1)
plot(t, x(1,:),'w','LineWidth',1.6); hold on;
plot(t, x_hat(1,:),'r--','LineWidth',1.3);
ylabel('\theta (rad)')
legend('True','Estimated')
title('LQG Balance Controller')
grid on

subplot(3,1,2)
plot(t, x(2,:),'w','LineWidth',1.6); hold on;
plot(t, x_hat(2,:),'r--','LineWidth',1.3);
ylabel('\thetȧ (rad/s)')
legend('True','Estimated')
grid on

subplot(3,1,3)
plot(t, u_hist,'LineWidth',1.6)
ylabel('Torque (Nm)')
xlabel('Time (s)')
grid on
