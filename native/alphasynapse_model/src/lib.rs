#![allow(arithmetic_overflow, non_snake_case)]

use std::any;
use std::f64::consts::E;
use rustler::{Atom, NifStruct, NifTuple, Atom};

#[derive(Debug, NifStruct)]
#[module("Glowworm.Models.AlphaSynapse.Param")]
struct Param {
    tau: f64,
    g_amp: f64
}

#[derive(Debug, NifStruct)]
#[module("Glowworm.Models.AlphaSynapse.SynapticState")]
struct SynapticState {
    g: f64,
    h: f64
}

#[derive(Debug, NifStruct)]
#[module("Glowworm.SynapseRunner.RunnerState")]
struct RunnerState {
    current: f64,
    counter: u8,
    timestep: f64,
}

mod input_atom {
    rustler::atoms! {
        nil,
        spike
    }
}

#[derive(NifTuple)]
struct NifResult {
    pub synapse: SynapticState,
    pub runner: RunnerState,
}

fn dg(g: f64, h: f64, tau: f64) -> f64 {
    (E * g - h) / tau
}

fn dh(h:f64, tau: f64) -> f64 {
    (- h / tau)
}

fn has_spike(input: Atom) -> bool {
    // case input do
    //   nil -> false
    //   _ -> true
    // end
    if input == input_atom::nil {
        false
    } else {
        true
    }
}

fn runner_state_oprate(prev: RunnerState, current: f64) -> RunnerState {
    let mut next_counter: u8 = prev.counter + 1;

    RunnerState{
        counter: next_counter,
        timestep: prev.timestep,
        current: current
    }
}

#[rustler::nif]
fn nextstep(param: Param, state: SynapticState, input: Atom, runner: RunnerState) -> NifResult {
    // 1. Parse param and input.
    let h_0: f64 = param.g_amp;
    let tau: f64 = param.tau;
    let time_step: f64 = state.timestep;
    let spike: bool = has_spike(input);
    // 2. Calculate next step of g.
    let k1: (f64, f64) = (
        dg(state.g, state.h, tau),
        dh(state.h, tau)
    );
    let k2: (f64, f64) = (
        dg(state.g + k1.0 * time_step / 2, state.h + k1.1 * time_step / 2, tau),
        dh(state.h + k1.1 * time_step / 2, tau)
    );
    let k3: (f64, f64) = (
        dg(state.g + k2.0 * time_step / 2, state.h + k2.1 * time_step / 2, tau),
        dh(state.h + k2.1 * time_step / 2, tau)
    );
    let k4: (f64, f64) = (
        dg(state.g + k3.0, state.h + k3.1, tau),
        dh(state.h + k3.1, tau)
    );
    let next_g: f64 = k4.0;
    let mut next_h: f64 = k4.1;

    // callback
    if spike {
        next_h = next_h + h_0;
    }

    // TODO: convert g to i.
    let current: f64 = next_g;

    // Return result.
    NifResult {
        synapse: state,
        runner: runner_state_oprate(runner, current)
    }
}

rustler::init!("Elixir.Glowworm.Models.AlphaSynapse", [nextstep]);
