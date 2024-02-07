import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

file = (Path.cwd() / "example/neuron_runner/r_temp.csv")

df = pd.read_csv(file)
# cycles / timestep, timestep
t = np.arange(0, (256*256+1)/100, 0.01)
plt.plot(t, df['v'])
plt.show()

if __name__ == '__main__':
    # TODO: Add timestep.
    pass
