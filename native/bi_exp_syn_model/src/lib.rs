#![allow(arithmetic_overflow, non_snake_case)]
use rustler::{Atom, NifStruct, NifTuple};

/**
 * Deeply referenced Tushar Chauhan's article:
 * https://www.tusharchauhan.com/writing/models-of-synaptic-conductance-iii/
*/

#[derive(Debug, NifStruct)]
#[module("Glowworm.Models.BiExpSynapse.Param")]
struct Param {
    tau_decay: f64,
    k: f64,
    g_amp: f64
}

#[derive(Debug, NifStruct)]
#[module("Glowworm.Models.BiExpSynapse.SynapticState")]
struct SynapticState {
    g: f64,
    h: f64
}

#[derive(Debug, NifStruct)]
#[module("Glowworm.SynapseRunner.RunnerState")]
struct RunnerState {
    current: f64,
    counter: u8,
    extra: [] // list(number()) | nil
}

#[derive(NifTuple)]
struct NifResult {
    pub synapse: SynapticState,
    pub runner: RunnerState,
}

#[rustler::nif]
fn nextstep() -> NifResult {
    // ...
}

rustler::init!("Elixir.Glowworm.Models.BiExpSynapse", [nextstep]);
