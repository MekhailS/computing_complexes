addpath(genpath('./m'))


## Определить задачу построения интервальной регрессии 
##     y = X * beta = beta1 + beta2 * x 


x = [12; 16; 20];        # количество затраченного топлива
y = [128; 180; 230];        # объем произведенного пара
epsilon = [6; 9; 11];  # верхняя граница ошибки для y_i

X = [ x.^0 x ];                               # матрица значений переменных при beta1 и beta2
lb = [-inf 0];                                # нижние границы beta1 и beta2
irp_steam = ir_problem(X, y, epsilon, lb);


## Графическое представление информационного множества
figure
ir_plotbeta(irp_steam)
grid on
set(gca, 'fontsize', 12)
xlabel('\beta_1')
ylabel('\beta_2')

## Внешние интервальние оценки параметров модели y = beta1 + beta2 * x 
b_int = ir_outer(irp_steam)


## Вершины информационного множества задачи построения интервальной регрессии
vertices = ir_beta2poly(irp_steam)

## Диаметр и наиболее удаленные вершины информационного множества 
[rhoB, b1, b2] = ir_betadiam(irp_steam)


## Внешние интервальние оценки параметров модели y = beta1 + beta2 * x 
b_int = ir_outer(irp_steam)

## Точечные оценки параметров 
b_maxdiag = (b1 + b2) / 2    # как середина наибольшей диагонали информационного множества

b_gravity = mean(vertices)   # как центр тяжести информационного множества 

b_lsm = (X \ y)'             # методом наименьших квадратов

## Точечные оценки
plot(b_maxdiag(1), b_maxdiag(2), ';Центр макс. диагонали;mo')
plot(b_gravity(1), b_gravity(2), ';Центр тяжести;k+')
plot(b_lsm(1), b_lsm(2), ';МНК;rx')
legend()

figure 
xlimits = [0 25];
ir_plotmodelset(irp_steam, xlimits)     # коридор совместных зависимостей
hold on
ir_scatter(irp_steam,'b.')              # интервальные измерения

grid on
set(gca, 'fontsize', 12)
xlabel('x')
ylabel('y')

figure 
x_p = [10; 12; 16; 22.5];
ir_plotmodelset(irp_steam, xlimits)
hold on
ir_scatter(irp_steam,'b.')
hold on 
X_p = [x_p.^0 x_p];
y_p = ir_predict(irp_steam, X_p);
ypmid = mean(y_p,2);
yprad = 0.5 * (y_p(:,2) - y_p(:,1));
ir_scatter(ir_problem(X_p,ypmid,yprad),'k.');
grid on
xlabel('x')
ylabel('y')
