alias Glowworm, as: G
alias Glowworm.SomaRunner, as: SR
alias :gen_statem, as: GenStateM

{:ok, soma_runner} = SR.start_link()

GenStateM.stop(soma_runner)
