// Implement the model.

fn dv(v: f64, u: f64, i: f64) -> f64 {
    // v: potentail of the neuron
    // u: membrane recovery variable
    // i: I_stim
    0.04 * v ^ 2 + 5 * v + 140 - u + i
}

fn du(v: f64, u: f64, a: f64, b: f64) -> f64 {
  a * (b * v - u)
}

fn peak(v: f64, peak_threshold: f64) -> bool {
    v >= peak_threshold
}

fn update(v: f64, u: f64, c: f64, d: f64) -> Tuple<f64, f64> {
    return (c, u + d)
}
