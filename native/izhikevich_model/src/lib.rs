use rustler::{Atom, NifStruct, NifTuple};

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.Param"]
struct Param {
    a: f64,
    b: f64,
    c: f64,
    d: f64,
    rest_threshold: f64,
    time_step: f64,
}

#[derive(Debug, NifStruct)]
#[module = "Glowworm.Models.Izhikevich.NeuronState"]
struct NeuronState {
    pub potential: f64,
    pub recovery: f64,
    pub current: f64,
}

mod event_atom {
    rustler::atoms! {
        nil,
        pulse,
    }
}

#[derive(NifTuple)]
struct NifResult {
    state: NeuronState,
    event: Atom,
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
fn nextstep(_param: Param, state: NeuronState) -> NifResult {
    NifResult {
        state: state,
        event: event_atom::nil(),
    }
}

rustler::init!("Elixir.Glowworm.Models.Izhikevich", [nextstep]);
