#![allow(arithmetic_overflow)]
use rustler::{Atom, NifStruct, NifTuple};

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.Param"]
struct Param {
    tau: f64,
    timestep: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.SynState"]
struct SynState {
    conductance: f64,
    current: f64,
    x: f64,
    u: f64
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.Input"]
struct Input {
    // TODO: Add spike.
    potentail: f64
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.AlphaSynapse.SynState"]
struct SynState {
    conductance: f64,
    current: f64,
    // Implement shor-term plasticity.
    // ref: https://www.youtube.com/watch?v=AiExcSomrvc&t=432s
    x: f64,
    u: f64
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.SynapseRunner.RunnerState"]
struct RunnerState {
  pub current: f64,
  pub counter: u8,
}

#[derive(NifTuple)]
struct NifResult {
    pub synapse: SynState,
    pub runner: RunnerState,
}

fn calculate_conductance_without_pulse() -> f64 {0.0}

fn calculate_conductance_when_pulse() -> f64 {0.0}

fn calculate_current(conductance: f64) -> f64 {
    // I = gs(V-E)
    if conductance != 0 {
        // ...
    }
    else {0.0}
}

#[rustler::nif]
fn nextstep(_param: Param, state: SynState, _input: Input, runner_state: RunnerState) -> NifTuple{
    NifStruct{
        synapse: state,
        runner: runner_state
    }
}

rustler::init!("Elixir.Glowworm.Models.AlphaSynapse", [nextstep]);
