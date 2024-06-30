#![allow(arithmetic_overflow, non_snake_case)]

use std::any;
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
}

#[derive(NifTuple)]
struct NifResult {
    pub synapse: SynapticState,
    pub runner: RunnerState,
}

#[rustler::nif]
fn nextstep(_param: Param, state: SynapticState, _input: any, runner: RunnerState) -> NifResult {
    NifResult {
        synapse: state,
        runner: runner
    }
}

rustler::init!("Elixir.Glowworm.Models.AlphaSynapse", [nextstep]);
