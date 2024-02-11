import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

file = (Path.cwd() / "example/soma_runner/r_temp.csv")

df = pd.read_csv(file)
# cycles / timestep, timestep
t = np.arange(0, (256*256+1)/100, 0.01)

# plt.figure(1)
f, axarr = plt.subplots(2, sharex=True)
f.suptitle('Chattering Cell in Izhikevich Model')

axarr[0].plot(t, df['v'], color='#1f77b4')
axarr[0].set_title('potential(v)', color='gray')

axarr[1].plot(t.copy(), df['u'], color='#ffaa7f')
axarr[1].set_title('recovery(u)', color='gray')

plt.xlim(-5.0, 660.0)
plt.show()

if __name__ == '__main__':
    # TODO: Get timestep in args from elixir.
    pass
