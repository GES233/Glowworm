use rustler::NifStruct;

#[derive(NifStruct)]
#[module = "Glowworm.Models.Izhikevich.NeuronState"]
struct NeuronState {
  pub potential: f64,
  pub recovery: f64,
  pub current: f64,
}
