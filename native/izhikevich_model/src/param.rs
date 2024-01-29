use rustler::NifStruct;

#[derive(NifStruct)]
#[module = "Glowworm.Models.Izhikevich.Param"]
struct Param {
  pub a: f64,
  pub b: f64,
  pub c: f64,
  pub d: f64,
  pub rest_threshold: f64,
  pub time_step: f64,
}
