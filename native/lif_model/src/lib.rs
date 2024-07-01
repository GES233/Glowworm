#![allow(arithmetic_overflow, non_snake_case)]
use rustler::{Atom, NifStruct, NifTuple};

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.LIF.Param"]
struct Param {
    r: f64,
    c: f64,
    tau: f64,
    peak_threshold: f64,
    reset_value: f64,
    reset_strategy: Atom,
}

mod valid_reset_strategy {
    rustler::atoms! {
        dec,
        reset,
        ignore
    }
}// TODO: raise error if invalid.

#[derive(Debug, NifStruct)]
#[module = "Glowworm.SomaRunner.RunnerState"]
struct RunnerState {
  pub event: Atom,
  pub counter: u8,
  pub timestep: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.LIF.NeuronState"]
struct NeuronState {
    pub potential: f64,
    remaining_refrac_time: f64,
    pub fire: bool,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.LIF.InputState"]
struct InputState {
    pub current: f64,
}

#[derive(NifTuple)]
struct NifResult {
    pub neuron: NeuronState,
    pub runner: RunnerState,
}

// fn dv(_current_potential: f64, _current_i: f64, _current_remain_time: f64, _param: Param) -> (f64, f64) {(0.0, 0.0)}

#[rustler::nif]
fn nextstep(_param: Param, state: NeuronState, _input: InputState, runner: RunnerState) -> NifResult {
    // 1. Parse param.
    let _timestep: f64 = runner.timestep;

    // 2. Calc next step.
    // use eula method.

    // 3. Set event.

    // 4. Result.
    NifResult {
        neuron: state,
        runner: RunnerState{
            event: runner.event,
            counter: runner.counter + 1,
            timestep: runner.timestep
        }
    }
}

rustler::init!("Elixir.Glowworm.Models.LIF", [nextstep]);
