#![allow(arithmetic_overflow)]
use rustler::{Atom, NifStruct, NifTuple};

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.Param"]
struct Param {
    a: f64,
    b: f64,
    c: f64,
    d: f64,
    peak_threshold: f64,
    timestep: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.NeuronState"]
struct NeuronState {
    pub potential: f64,
    pub recovery: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.InputState"]
struct InputState {
    pub current: f64,
    pub counter: u8,
}

mod event_atom {
    rustler::atoms! {
        nil,
        pulse,
    }
}

#[derive(NifTuple)]
struct NifResult {
    pub state: NeuronState,
    pub event: Atom,
}

fn dv(v: f64, u: f64, i: f64) -> f64 {
    // v: potentail of the neuron
    // u: membrane recovery variable
    // i: I_stim
    0.0002 * v * v + 5.0 * v + 140.0 - u + i
}

fn du(v: f64, u: f64, a: f64, b: f64) -> f64 {
    a * (b * v - u)
}

fn peak(v: f64, peak_threshold: f64) -> bool {
    v >= peak_threshold
}

fn update(_v: f64, u: f64, c: f64, d: f64) -> (f64, f64) {
    return (c, u + d);
}

/**
 * Implementation of nextstep in `Elixir.Glowworm.Models.Izhikevich`.
 *
 * input:
 *
 * * NeuronState(`Elixir.Glowworm.Models.Izhikevich.NeuronState`)
 * * Param(`Elixir.Glowworm.Models.Izhikevich.Param`)
 * * Input(`Elixir.Glowworm.Models.Izhikevich.InjectState`)
 *
 * return: `{NeuronState, EventAtom | nil}`
 *
 * * new NeuronState in next step.
 * * Event that can trigger propogate pulse or raise error.
*/
// fn nextstep(_param: Vec<f64>, state: Vec<f64>) -> Vec<f64>

#[rustler::nif]
fn nextstep(param: Param, state: NeuronState, input: InputState) -> NifResult {
    // 0. Parse param
    let current: (f64, f64) = (state.potential, state.recovery);
    let current_i: f64 = input.current;
    let time_step: f64 = param.timestep;
    // 1. Calculate nextstep
    let k1: (f64, f64) = (
        dv(current.0, current.1, current_i),
        du(current.0, current.1, param.a, param.b),
    );
    let k2: (f64, f64) = (
        dv(
            current.0 + k1.0 * time_step / 2.0,
            current.1 + time_step / 2.0,
            current_i,
        ),
        du(
            current.0 + time_step / 2.0,
            current.1 + k1.1 * time_step / 2.0,
            param.a,
            param.b,
        ),
    );
    let k3: (f64, f64) = (
        dv(
            current.0 + k2.0 * time_step / 2.0,
            current.1 + time_step / 2.0,
            current_i,
        ),
        du(
            current.0 + time_step / 2.0,
            current.1 + k2.1 * time_step / 2.0,
            param.a,
            param.b,
        ),
    );
    let k4: (f64, f64) = (
        dv(current.0 + k3.0, current.1 + time_step, current_i),
        du(current.0 + time_step, current.1 + k3.1, param.a, param.b),
    );
    let mut next_potential: f64 = (k1.0 + 2.0 * k2.0 + 2.0 * k3.0 + k4.0) / 6.0;
    let mut next_recovery: f64 = (k1.1 + 2.0 * k2.1 + 2.0 * k3.1 + k4.1) / 6.0;
    let mut event: Atom = event_atom::nil();
    // callback.
    if peak(next_potential, param.peak_threshold) {
        (next_potential, next_recovery) = update(next_potential, next_recovery, param.c, param.d);
        event = event_atom::pulse();
    }
    let _next_counter: u8 = input.counter + 1;

    NifResult {
        state: NeuronState{
            potential: next_potential,
            recovery: next_recovery,
            // TODO: Add counter
        },
        event: event,
    }
}

rustler::init!("Elixir.Glowworm.Models.Izhikevich", [nextstep]);
