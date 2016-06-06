close all;
n_episodes = 8000;

n_features = 2;

n_steps = 100;
max_time = 50;

steps = linspace(0, max_time, n_steps);

x = zeros(n_features, n_steps);
reward = zeros(1, n_steps);

w = 0.3*rand(n_features, n_steps);
V = zeros(1, n_steps);
Vtot = zeros(1, n_steps);
delta = zeros(1, n_steps);


mu = 0.2;

reward(:) = 2*exp(-1 * (steps - max_time/1.1).^2);

hold on;
pr = plot(steps, reward, 'R');
px1 = plot(steps, x(1,:), 'Y');
px2 = plot(steps, x(2,:), 'Y');
pv = plot(steps, V, 'G');
pd = plot(steps, delta, 'B');
axis([0 max_time -5 15]);
hold off;




for episode = 1:n_episodes
    
    x(1,:) = 2*exp(-0.5 * (steps - max_time/8).^2) + 0.5;
    x(1,1:10) = 0;
    
    x(2,:) = 0.01*rand(1, n_steps);%1*exp(-0.0002 * (steps - max_time/2.5).^2);
    x(2,1:20) = 0;
    
    if episode > 2000
        reward(:) = zeros(1,n_steps);
    end
    episode
    
    for t = 2:n_steps-1
        
        V(t) = sum( x(:, t) .* w(:, t) );
        Vdot = V(t) - V(t-1);
        delta(t) = reward(t-1) + V(t) - V(t-1);
        
        w(:, t-1) = w(:, t-1) + mu * x(:,t-1) * delta(t);
    
    end
    
    
    % update plots
    pr.YData = reward;
    pd.YData = delta;
    px1.YData = x(1,:);
    px2.YData = x(2,:);
    pv.YData = V;
    pause(0.01);
end