

effectivity_newInfra=0.1
effectivity_mantenimiento=0.2
decay_infra=0.1
time_simulation=2
Budget=1200
scenario=1
repetition=1

#Generate and id for the simulation based on the value
#of the arguments
sim_id_output=sprintf("effectivity_newInfra=%s-effectivity_mantenimiento=%s-decay_infra=%s-Budget=%s-scenario=%s.rds",effectivity_newInfra,effectivity_mantenimiento,decay_infra,Budget,scenario)
path_to_output<-"../outputs/" #change path to use it in patung

#climate scenario
#run setup.R and cycle.R
source("setup.R")
source("cycle.R")
