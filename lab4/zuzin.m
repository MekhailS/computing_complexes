C = kinterval([2, 0.3;0.9, 3], [4, 0.5;1.1, 5]);
d = kinterval([-1;-2],[1;2]);
D = diag(diag(C));
E = innerminus(C, D);

tol = [0 0.2057 0.24953 0.2837 0 -0.2057 -0.24953 -0.2837 0;0.4 0.3548 0.003752 -0.4511 -0.4 -0.3548 -0.003752 0.4511 0.4];

n = 10;
x = kinterval([-1; -1], [1; 1]);
figure
plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))], [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))])
hold on
plot(mid(x(1)), mid(x(2)))
hold on
x_set = [x];
D_inv = diag(inv(diag(C)));
for i=1:n-1
    x = D_inv * innerminus(d, E * x);
    x_set = [x_set x];
    plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))], [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))], ':')
    hold on
    plot(mid(x(1)), mid(x(2)))
    hold on
end
x = D_inv * innerminus(d, E * x);
x_set = [x_set x];
plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))], [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))], 'r')
hold on
plot(mid(x(1)), mid(x(2)))
hold on


plot(tol(1,:), tol(2,:), '--')
figure
rads = rad(x_set);
plot(rads(1, :))
hold on
plot(rads(2, :))
hold on
legend('x1', 'x2')
