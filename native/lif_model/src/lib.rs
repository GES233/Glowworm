#![allow(arithmetic_overflow)]
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
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.LIF.NeuronState"]
struct NeuronState {
    pub potential: f64,
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

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn nextstep(_param: Param, state: NeuronState, _input: InputState, runner: RunnerState) -> NifResult {
    NifResult {
        neuron: state,
        runner: RunnerState{
            event: runner.event,
            counter: runner.counter + 1
        }
    }
}

rustler::init!("Elixir.Glowworm.Models.LIF", [add, nextstep]);
