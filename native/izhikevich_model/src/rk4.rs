/**
 * y_{n+1} = y_n + (k_1 + 2 k_2 + 2 k_3 + k_4)/6
 * k_1 = f(x_n,         y_n)
 * k_2 = f(x_n + h / 2, y_n + k_1 * h / 2)
 * k_3 = f(x_n + h / 2, y_n + k_2 * h / 2)
 * k_4 = f(x_n + h,     y_n + k_3)
*/