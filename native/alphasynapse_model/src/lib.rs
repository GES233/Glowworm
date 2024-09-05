#![allow(arithmetic_overflow, non_snake_case)]

use rustler::{Atom, NifStruct, NifTuple};
use std::f64::consts::E;

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.Param"]
struct Param {
    pub tau: f64,
    pub g_amp: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.SynapticState"]
struct SynapticState {
    pub g: f64,
    pub h: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.SynapseRunner.RunnerState"]
struct RunnerState {
    pub current: f64,
    pub counter: u8,
    pub timestep: f64,
}

mod input_atom {
    rustler::atoms! {
        nil,
        spike
    }
}

#[derive(NifTuple)]
struct InputState {
  pub pulse: Atom,
  pub potential: f64,
}

#[derive(NifTuple)]
struct NifResult {
    pub synapse: SynapticState,
    pub runner: RunnerState,
}

fn dg(g: f64, h: f64, tau: f64) -> f64 {
    (E * h - g) / tau
}

fn dh(h: f64, tau: f64) -> f64 {
    -h / tau
}

fn has_spike(input: InputState) -> bool {
    // case input do
    //   nil -> false
    //   _ -> true
    // end
    if input.pulse == input_atom::nil() { false }
    else { true }
}

fn syn_callback(prev_h: f64, h_0: f64) -> f64 {
    prev_h + h_0
}

fn runner_state_oprate(prev: RunnerState, current: f64) -> RunnerState {
    let next_counter: u8 = prev.counter + 1;

    RunnerState {
        counter: next_counter,
        timestep: prev.timestep,
        current: current,
    }
}

// TODO: Replace input as `InputState`.
#[rustler::nif]
fn nextstep(param: Param, state: SynapticState, input: InputState, runner: RunnerState) -> NifResult {
    // 1. Parse param and input.
    let h_0: f64 = param.g_amp;
    let tau: f64 = param.tau;
    let time_step: f64 = runner.timestep;
    let spike: bool = has_spike(input);
    // 2. Calculate next step of g.
    let k1: (f64, f64) = (dg(state.g, state.h, tau), dh(state.h, tau));
    let k2: (f64, f64) = (
        dg(
            state.g + k1.0 * time_step / 2.0,
            state.h + k1.1 * time_step / 2.0,
            tau,
        ),
        dh(state.h + k1.1 * time_step / 2.0, tau),
    );
    let k3: (f64, f64) = (
        dg(
            state.g + k2.0 * time_step / 2.0,
            state.h + k2.1 * time_step / 2.0,
            tau,
        ),
        dh(state.h + k2.1 * time_step / 2.0, tau),
    );
    let k4: (f64, f64) = (
        dg(state.g + k3.0 * time_step, state.h + k3.1 * time_step, tau),
        dh(state.h + k3.1 * time_step, tau),
    );
    let next_g: f64 = state.g + (k1.0 + 2.0 * k2.0 + 2.0 * k3.0 + k4.0) * time_step / 6.0;
    let mut next_h: f64 = state.h + (k1.1 + 2.0 * k2.1 + 2.0 * k3.1 + k4.1) * time_step / 6.0;

    // callback
    if spike {
        next_h = syn_callback(next_h, h_0);
    }

    // TODO: convert g to i.
    let current: f64 = next_g;

    // Return result.
    NifResult {
        synapse: SynapticState {
            g: next_g,
            h: next_h,
        },
        runner: runner_state_oprate(runner, current),
    }
}

rustler::init!("Elixir.Glowworm.Models.AlphaSynapse", [nextstep]);
