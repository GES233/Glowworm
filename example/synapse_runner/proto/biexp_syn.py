# https://www.tusharchauhan.com/writing/models-of-synaptic-conductance-iii/
from math import exp, log, pow

import numpy as np
import matplotlib.pyplot as plt

TAU_S = 25
K = 0.5
# maximum amplitude
G_AMP = 5

# T_peak
TAU_R = (K * TAU_S) / (1 - K) * log(1 / K)
NORM = exp(- TAU_R / TAU_S) - exp(- TAU_R / (TAU_S * K))

x = np.arange(0, 100, 0.5)
y = []

def g(x):
    """
    $$
    g_{syn}(t) = \\frac{e^{-t/\\tau_1} - e^{-t/\\tau_2}}{e^{-t_{peak/\\tau_1} - e^{-t_{peak}/\\tau_2}}
    $$

    where $t_{peak} = \\frac{k\\tau_s}{1 - k}\\log{\\frac{1}{k}}}$
    """
    return (
        G_AMP *
        (exp(- x / TAU_S) - exp(- x / (K * TAU_S))) /
        NORM
        )

def dg(g, h):
    return (pow(K, (-1 / (1 - K))) * h - g) / TAU_S

# g_amp = h0
def dh(h):
    return (
        (-h) / (K * TAU_S)
        # Add prevoius spike here.
        # + sum(g_amp * delta(delta_t))
         )

for i in x:
    y.append(g(i))

plt.plot(x, y)
plt.show()
