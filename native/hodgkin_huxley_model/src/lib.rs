#![allow(arithmetic_overflow, non_snake_case)]

// TODO: Add structs.

#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

rustler::init!("Elixir.Glowworm.Models.HodgkinHuxley", [add]);
