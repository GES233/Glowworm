import sys
import argparse
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--count")
parser.add_argument("--timestep")
parser.add_argument("--type")


if __name__ == "__main__":
    # Command like
    # python example/synapse_runner/show.py --type #{type}
    # --count #{length(res)} --timestep #{Demo.get_timestep()}
    args = parser.parse_args()

    TOTAL_COUNT = int(args.count)
    TIMESTEP = float(args.timestep)
    TYPE = str(args.type).replace("-", "_")

    file = Path.cwd() / f"example/synapse_runner/{TYPE}_temp.csv"

    df = pd.read_csv(file)
    # cycles / timestep, timestep
    t = np.arange(0, (TOTAL_COUNT) * TIMESTEP, TIMESTEP)

    # Type-related.
    if "g" in TYPE:
        # Spike ~ Conductance.
        f, axarr = plt.subplots(2, sharex=True)
        f.suptitle("Alpha Synapse Model")

        axarr[0].plot(t, df["g"], color="#1f77b4")
        axarr[0].set_title("conductance(g)", color="gray")

        axarr[1].plot(t.copy(), df["h"], color="#ffaa7f")
        axarr[1].set_title("decay(h)", color="gray")

        plt.xlim(-5.0, (TOTAL_COUNT + 200) * TIMESTEP)
        plt.show()
        ...
    else:
        ...
