addpath(genpath('./m'))


## Определить задачу построения интервальной регрессии 
##     y = X * beta = beta1 + beta2 * x 


x = [0; 64; 128; 192; 256; 320; 384; 448];        
y_down = [0; 6; 7; 11; 14; 20; 25; 29];
y_up = [0; 7; 11; 17; 24; 26; 30; 30];
epsilon_y = [1; 1; 1; 1; 1; 1; 1; 1];
epsilon_x = [13; 13; -11; 56; 38; 52; 42; 78; 62; 119; 37; 82; 24; 79; 28; 15];


X = [ x.^0 x ];                               # матрица значений переменных при beta1 и beta2
lb = [-inf 0];                                # нижние границы beta1 и beta2
irp_steam_down = ir_problem(X, y_down, epsilon_y, lb);
irp_steam_up = ir_problem(X, y_up, epsilon_y, lb);


figure 
xlimits = [-1 500];
hold on
ir_scatter(irp_steam_down,'r.')              # интервальные измерения
ir_scatter(irp_steam_up, 'b.')
grid on
set(gca, 'fontsize', 12)
xlabel('x')
ylabel('y')


##Создаем брусы совместности
##Их всего будет 8 - сколько значений y
n = size(y_down);
bars_y = zeros(1, 2*n);
bars_x = zeros(1, 2*n);
offset = 0;
for i=1:1:n
  bars_y(offset+i) = min(y_down(i) - epsilon_y(i), y_up(i) - epsilon_y(i));
  bars_y(offset+i+1) = max(y_down(i) + epsilon_y(i), y_up(i) + epsilon_y(i));
  bars_x(offset+i) = x(i) - epsilon_x(offset+i);
  bars_x(offset+i+1) = x(i) + epsilon_x(offset+i+1);
  offset += 1;
end  


figure
grid on
hold on
ir_scatter(irp_steam_down,'r.')              # интервальные измерения
ir_scatter(irp_steam_up, 'b.')
xlim([-20 500])
ylim([-5 35])
for i = 1:2:15
  rectangle('Position',[bars_x(i) bars_y(i) bars_x(i+1)-bars_x(i) bars_y(i+1)-bars_y(i)])  
end    
plot([0 448],[0 30],'--r')
set(gca, 'fontsize', 12)
xlabel('x')
ylabel('y')


A_1 = [[-13 13] ,[1 1]; [75 120], [1 1]];
b_1 = [-1 1; 5 8];

A_2 = [[90 180] ,[1 1]; [150 270], [1 1]];
b_2 = [6 12; 10 18];

A_3 = [[194 375] ,[1 1]; [283 402], [1 1]];
b_3 = [13 25; 19 27];

A_4 = [[360 463] ,[1 1]; [420 463], [1 1]];
b_4 = [24 31; 28 31];


printf('----1-th system----\n')
my_subdiff(A_1, b_1)

printf('----2-th system----\n')
my_subdiff(A_2, b_2)

printf('----3-th system----\n')
my_subdiff(A_3, b_3)

printf('----4-th system----\n')
my_subdiff(A_4, b_4)


figure
beta_1 = [-1.5, 3.5];
beta_2 = [0.05, 0.07];
y = zeros(8, 1);
eps = zeros(8, 1);
for i=1:1:8
  x_cur = x(i);
  y_down = x_cur * beta_2(1) + beta_1(1);
  y_up = x_cur * beta_2(2) + beta_1(2); 
  y_middle = (y_down + y_up) / 2;
  y(i) = y_middle;
  eps(i) = y_middle - y_down;
end

for i = 1:2:15
  rectangle('Position',[bars_x(i) bars_y(i) bars_x(i+1)-bars_x(i) bars_y(i+1)-bars_y(i)])  
end    

irp_steam_scores = ir_problem(X, y, eps, lb);
xlimits = [-1 500];
hold on
ir_scatter(irp_steam_down,'r.')         
ir_scatter(irp_steam_up, 'b.')
ir_scatter(irp_steam_scores, 'g.')
grid on
set(gca, 'fontsize', 12)
xlabel('x')
ylabel('y')


