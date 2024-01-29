/**
 * Implementation of nextstep in `Elixir.Glowworm.Models.Izhikevich`.
 * 
 * input:
 * 
 * * NeuronState(`Elixir.Glowworm.Models.Izhikevich.NeuronState`)
 * * Param(`Elixir.Glowworm.Models.Izhikevich.Param`)
 * 
 * return: `{Event | nil, NeuronState}`
 * 
 * * new NeuronState in next step.
 * * Event that can trigger propogate pulse or raise error.
*/
#[rustler::nif]
fn nextstep(a: i64, b: i64) -> i64 {
    a + b
}

rustler::init!("Elixir.Glowworm.Models.Izhikevich", [nextstep]);
