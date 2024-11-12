#![allow(arithmetic_overflow, non_snake_case)]
use rustler::{Atom, NifStruct, NifTuple};

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.Param"]
struct Param {
    a: f64,
    b: f64,
    c: f64,
    d: f64,
    peak_threshold: f64,
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
}

mod event_atom {
    rustler::atoms! {
        nil,
        pulse,
    }
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Runners.Soma.RunnerState"]
struct RunnerState {
  pub event: Atom,
  pub counter: u8,
  pub timestep: f64,
}

#[derive(NifTuple)]
struct NifResult {
    pub neuron: NeuronState,
    pub runner: RunnerState,
}

fn dv(v: f64, u: f64, i: f64) -> f64 {
    // v: potentail of the neuron
    // u: membrane recovery variable
    // i: I_stim
    0.04 * v * v + 5.0 * v + 140.0 - u + i
}

fn du(v: f64, u: f64, a: f64, b: f64) -> f64 {
    a * (b * v - u)
}

fn peak(v: f64, peak_threshold: f64) -> bool {
    v >= peak_threshold
}

fn update(_v: f64, u: f64, c: f64, d: f64) -> (f64, f64) {
    // Update status when peak.
    return (c, u + d);
}

fn izh_callback(next_potential: f64, next_recovery: f64, condition: bool, param: Param) -> (f64, f64) {
    if condition {
        update(next_potential, next_recovery, param.c, param.d)
    } else {
        (next_potential, next_recovery)
    }
}

fn runner_state_oprate(runner: RunnerState, peak: bool) -> RunnerState {
    // Wrap all operate to `RunnerState`.
    let next_counter: u8 = runner.counter + 1;
    let event: Atom = if peak {event_atom::pulse()} else {event_atom::nil()};

    RunnerState{
        event: event,
        counter: next_counter,
        timestep: runner.timestep,
    }
}

/**
 * Implementation of nextstep in `Elixir.Glowworm.Models.Izhikevich`.
 *
 * input:
 *
 * * NeuronState(`Elixir.Glowworm.Models.Izhikevich.NeuronState`)
 * * Param(`Elixir.Glowworm.Models.Izhikevich.Param`)
 * * Input(`Elixir.Glowworm.Models.Izhikevich.InputState`)
 * * RunnerState(`Elixir.Glowworm.Runners.Soma.RunnerState`)
 *
 * return: `{NeuronState, RunnerState}`
 *
 * * new NeuronState in next step.
 * * RunnerState contains event that can trigger propogate
 *   pulse or raise error, and counter to count ticks.
*/

#[rustler::nif]
fn nextstep(param: Param, state: NeuronState, input: InputState, runner: RunnerState) -> NifResult {
    // 0. Parse param
    let current: (f64, f64) = (state.potential, state.recovery);
    let current_i: f64 = input.current;
    let time_step: f64 = runner.timestep;
    // 1. Calculate nextstep
    let k1: (f64, f64) = (
        dv(current.0, current.1, current_i),
        du(current.0, current.1, param.a, param.b),
    );
    let k2: (f64, f64) = (
        dv(
            current.0 + k1.0 * time_step / 2.0,
            current.1 + k1.1 * time_step / 2.0,
            current_i,
        ),
        du(
            current.0 + k1.0 * time_step / 2.0,
            current.1 + k1.1 * time_step / 2.0,
            param.a,
            param.b,
        ),
    );
    let k3: (f64, f64) = (
        dv(
            current.0 + k2.0 * time_step / 2.0,
            current.1 + k2.1 * time_step / 2.0,
            current_i,
        ),
        du(
            current.0 + k2.0 * time_step / 2.0,
            current.1 + k2.1 * time_step / 2.0,
            param.a,
            param.b,
        ),
    );
    let k4: (f64, f64) = (
        dv(current.0 + k3.0 * time_step, current.1 + time_step * k3.1, current_i),
        du(current.0 + time_step * k3.0, current.1 + k3.1 * time_step, param.a, param.b),
    );
    let mut next_potential: f64 = current.0 + (k1.0 + 2.0 * k2.0 + 2.0 * k3.0 + k4.0) * time_step / 6.0;
    let mut next_recovery: f64 = current.1 + (k1.1 + 2.0 * k2.1 + 2.0 * k3.1 + k4.1) * time_step / 6.0;

    // callback.
    let peak: bool = peak(next_potential, param.peak_threshold);
    (next_potential, next_recovery) = izh_callback(
        next_potential,
        next_recovery,
        peak,
        param
    );

    NifResult {
        neuron: NeuronState{
            potential: next_potential,
            recovery: next_recovery,
        },
        runner: runner_state_oprate(runner, peak)
    }
}

// #[rustler::nif]
// fn check_stable(state1: NeuronState, state2: NeuronState, input: InputState) {}

rustler::init!("Elixir.Glowworm.Models.Izhikevich", [nextstep]);
