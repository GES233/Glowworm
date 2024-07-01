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
    TYPE = str(args.type)

    file = Path.cwd() / "example/synapse_runner/{TYPE}_temp.csv"

    df = pd.read_csv(file)
    # cycles / timestep, timestep
    t = np.arange(0, (TOTAL_COUNT) * TIMESTEP, TIMESTEP)

    ...