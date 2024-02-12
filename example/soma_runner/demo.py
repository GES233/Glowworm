import sys
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--count")


if __name__ == "__main__":
    args = parser.parse_args()

    TOTAL_COUNT = int(args.count)

    file = Path.cwd() / "example/soma_runner/r_temp.csv"

    df = pd.read_csv(file)
    # cycles / timestep, timestep
    t = np.arange(0, (TOTAL_COUNT) / 100, 0.01)

    f, axarr = plt.subplots(2, sharex=True)
    f.suptitle("Chattering Cell in Izhikevich Model")

    axarr[0].plot(t, df["v"], color="#1f77b4")
    axarr[0].set_title("potential(v)", color="gray")

    axarr[1].plot(t.copy(), df["u"], color="#ffaa7f")
    axarr[1].set_title("recovery(u)", color="gray")

    plt.xlim(-5.0, (TOTAL_COUNT + 200) / 100)
    plt.show()
