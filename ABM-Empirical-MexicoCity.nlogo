extensions [GIS bitmap profiler matrix csv];
globals [
  exp_r;;                      ;; Wealth depresiation rate
  price_tinaco                 ;; Price adaptation measure (tinato to storage water)
  price_garrafon               ;; Price coping strategy (buy water)


;;Importacion de agua
  Tot_water_Imported_Cutzamala ;;total water that enter to MC every day by importation from Cutzamala. for now a constant int he future connected as a network
  Tot_water_Imported_Lerma     ;;total water that enter to MC every day by importation from Lerma system. for now a constant int he future connected as a network
  water_produced               ;;Water produced by the city wells

;; agua en tuberias

  background_fugas             ;; % water lost every day by fugas
  max-elevation                ;;max altitude
  min-elevation                ;;max altitude

;;############################################################################################################################################

;;Alternative 1 for government decisions to repare supply infrastructure
;;Alternative 2 for government decisions to create new infrastructure
;;Alternative 3 water distribution
;;Alternative 4 Water extraction
;;Alternative 5 Water importation

  SM   ;standarized measure from the value function
  dist ;the reported value of distance from the ideal point function
;#####################################################################################
;;Government decision-making process
;#####################################################################################
  ;;Pesos para decisiones Government priorizations
  w_Abast_Repara             ;;importance of water scarcity
  w_age_Repara               ;;importance of state (age) of infrastructure
  w_SP_Repara                ;;importance of social presure
  w_falla_Repara             ;;importance of number of non working infra

  ;;pesos decision nuevo pozo (infra)
  w_Abast_new                ;;importance of water scarcity
  w_age_new                  ;;importance of state (age) of infrastructure
  w_SP_new                   ;;importance of social presure
  w_falta_new                ;;importance of social presure

  ;;pesos decision abastecimiento
  w_Abast_dist               ;;importance of water scarcity
  w_SP_dist                  ;;importance of social presure
  w_PH_dist                  ;;importance of hydraulic pressure

;;auxiliar variables that define limits of value functions for all criteria
 ;;Mobilizations


  presion_hidraulica_max        ;;min hydraulic pressure
  Antiguedad-infra_max          ;;the area with the oldest infrastructure
  desviacion_agua_max           ;;max level of perception of deviation
  pop_growth_max                ;;max change of popualtion per ageb
  desperdicio_agua_max          ;;max perception of water being waste
  eficacia_servicio_max         ;;ideal state of efficancy desired by actors
  garbage_max                   ;;max level of garbage percived as intolerable
  infra_abast_max               ;;max % of houses per ageb covered by the water supply network
  infra_dranage_max             ;;max % of houses per ageb covered by the water dranage network
  flooding_max                  ;;max level of flooding (encharcamientos) recored over the last 10 years
  fallas_max                ;;max number of fugas
  max_water_in                  ;;
  Abastecimiento_max
  Capacidad_max
  houses_with_dranage_max
  Petición_Delegaciones_max
  Presion_social_max
  Presión_de_medios_max
  water_quality_max
  disease_burden_max
  monto_max
  scarcity_max
;#####################################################################################
;#####################################################################################
;#####################################################################################
;;Resident decition making process
;#####################################################################################



;;############################################################################################################################################

;;auxiliar variables
  days                         ;; Days counter
  counter


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GIS maps variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  Agebs_map                                                          ;includes economic index water-related infrastructure
  ageb_encharc                                                       ;data set of ageb taht includes the floodings events
  Limites_delegacionales                                             ;limits of borrows
  mascara                                                            ;mask of the area of the work showing in the plot
  city_image                                                         ;a google image with the terrain
  pozos_sacmex                                                       ;weels for the water supply (piece of infratructure)
  elevation                                                          ;elevation of the city

  network_cutzamala                                                  ;large-scale supply network
  network_lerma                                                      ;large-scale supply network
  Water_contamination
  Urban_growth                                                       ;change in population, urban coverage, or other perception of more pressure to the service of water
  failure_of_dranage                                                 ;(translated from residents mental model concept "obstruccion de alcantarillado")
  presion_hidraulica_map                                             ;water in the pipes. related to tandeo and fugas. places with more fugas may have less pressure. places with less pressure would have more tandeo.
  Presión_de_medios
]
;#############################################################################################################################################
;#############################################################################################################################################
;create Agents
breed [Colonias Colonia]
breed [Agebs Ageb]
breed [Pozos pozo]
breed [Cutzamala tramo]
breed [Lumbreras Lumbrera]
breed [drenaje_profundo tramo]
breed [Delegaciones Delegacion]
breed [Alternatives_IZ action_IZ]
breed [Alternatives_Xo action_Xo]
breed [Alternatives_MC action_MC]
breed [Alternatives_SACMEX action_SACMEX]
breed [Alternatives_OCVAM action_OCVAM]
directed-link-breed [active-links active-link]
;#############################################################################################################################################
;#############################################################################################################################################
;define patch variables
patches-own[
  altitude          ;; real altitude
  Ageb_ID           ;; AGEB in
  colonias_ID       ;; Neighborhood in
  delegation_ID     ;; Delegation in
  LU_type           ;;land use type [Regular, irregular] (not included yet)
]


Delegaciones-own[Petición_Delegaciones]
;#############################################################################################################################################
;#############################################################################################################################################
;define AGEBS
Agebs-own[
  ID                                  ;;ID from shape file
  group_kmean                         ;; define to witch group an ageb belongs to, based on sosio-economic charactersitics
  pozos_agebs                         ;;set the pozos in ageb
  name_delegation                     ;;the name of the delegation the ageb belongs to
  paches_set_agebs                    ;;the set of patches that bellow to the ageb
  Monto
  Num_protestas_pAgeb                 ;;social pressure index per ageb
  production_water_perageb            ;; produccion de agua {definir escala e.g resolucion temporal !!!!}
  Abastecimiento                      ;;Necesidad de la población en cuanto a servicios hidráulicos (agua potable, drenaje)
  Antiguedad-infra                    ;;mean age of wells in ageb
  Cost_perHab                         ;;cost per habitante that would be invested if infra is repare
  Falla                               ;;Fallas de infraestructura hidráulica ocasionadas por conexiones clandestinas, obstrucción por basura y procesos biofísicos
  hundimientos
  presion_hidraulica                  ;;or an index of low volume of water in the pipes (tandeo)
  dist_water_extraction
  dist_reparation                     ;;distance from ideal point for decision to repare infrastructure
  dist_new                            ;;distance from ideal point for decision to create new infrastructure
  dist_waterdistribution              ;;distance from ideal point for decision to distribute water
  dist_waterimportation
  ; variables that define residents
  poblacion                    ;; Population size ageb
  pop_growth                   ;; Population growth
  av_inc                       ;; Average montly income
  Income-index                 ;; Actual income
  alpha                        ;; % water_in that is storaged acording to AGEB capasity (e.g. adaptation rate)
  Presion_social            ;; Number of people involved in the protest
  SC                           ;; Social capital 1 high 0 lowest

  damage                       ;; Cost of harm
  Flooding                     ;; mean number of encharcamientos during between 2004 and 2014
  days_wno_water               ;; Days with no water

;;Charactersitics of the agebs that define criteria
  houses_with_dranage          ;; % of houses connected to the dranage from ENEGI survey instrument
  houses_with_abastecimiento   ;; % houses connected to distribution network
  disease_burden               ;; Number of gastrointestinal cases per ageb (from disease model)
  water_quality                 ;; Perception fo water quality
  garbage                      ;; Garbage as the perception of the cause behind obstruction of dranages
  water_needed                 ;; Total water needed based on population size of colonia and water requirements per peson
  water_in                     ;; Water that enters to the colonias
  water_distributed_pipes      ;; Water imported (not produced in) to the colonia
  water_distributed_trucks     ;; Water imported (not produced in) to the colonia
  tandeo                       ;; Hours a week without water?
  scarcity                      ;; When water_needed >  water_produced, deficit > 0
  surplus                      ;; When water_needed <  water_produced, surplus > 0
  eficacia_servicio            ;; Gestión del servicio de Drenaje y agua potable (ej. interferencia política, no llega la pipa, horario del tandeo, etc)
  desperdicio_agua             ;;Por fugas, falta de conciencia del uso del agua
  desviacion_agua              ;;Se llevan el agua a otros lugares
  Capacidad                    ;;the Capacidad de la infraestructura hidráulica

;#residents decisions metrics

  d_Compra_agua                          ;;distance from ideal point for Compra_agua (buying water)
  d_Captacion_agua                       ;;distance from ideal point for Captacion_agua (buying tinaco, ranfall storage)
  d_Movilizaciones                       ;;distance from ideal point for Movilizaciones
  d_Modificacion_vivienda                ;;distance from ideal point for Modificacion_vivienda
  d_Accion_colectiva                     ;;distance from ideal point for Accion_colectiva
]

;#############################################################################################################################################
;#############################################################################################################################################

Pozos-own[
  Name
  col_ID           ;;location of well in neighborhood
  ageb_ID_pz       ;;location of well in AGEB
  Production       ;;water production [ m3/day]
  extraction_rate  ;;total extraction (defined by zones 1 to 32)
  age_pozo         ;;age of well
  p_failure        ;;probability of infrastructure failure here 1 if not infra here
  H                ;;1 if the well is working 0 otherwise
]

;#############################################################################################################################################
;#############################################################################################################################################
;define alternatives for residents using MC Iz Xo
;each alternative is consider an object with properties
;ID of the mental model
;name of the action
;varibles that influence the alternative
;maximal level of the variable to define
;value function

Alternatives_IZ-own[ID name_action C1_name C1 C1_MAX w_C1 V w_limit]
Alternatives_Xo-own[ID name_action C1_name C1 C1_MAX w_C1 V w_limit]
Alternatives_MC-own[ID name_action C1_name C1 C1_MAX w_C1 V w_limit]
Alternatives_SACMEX-own[ID name_action C1_name C1 C1_MAX w_C1 V w_limit]  ;value obtained for the action when calcualting the limiting matrix in super decition
Alternatives_OCVAM-own[ID CLUSTER name_action C1_name C1 C1_MAX w_C1 V w_limit]   ;value obtained for the action when calcualting the limiting matrix in super decition


;#############################################################################################################################################
;#############################################################################################################################################
Cutzamala-own [val new-val from_lumb to_lumb diameter_entrada valbula] ; a node's past and current quantity, represented as size

;#############################################################################################################################################
;#############################################################################################################################################
to setup
  clear-all
  ;profiler:start
  load-gis
  ;;set global variables
  set max-elevation gis:maximum-of elevation           ;;to visualize elevation
  set min-elevation gis:minimum-of elevation           ;;to visualize elevation
  set days 1                                           ;; count days
  set exp_r 0.001                                      ;; welath depreciation
  set price_garrafon 38  ;need parameters               ;;cost of coping (buying water)
  set price_tinaco 7000  ;need parameters ;;cost of adaptation

;variable hidricas

  set Tot_water_Imported_Cutzamala 14 * 60 * 60 * 24 ;[m3/s][s/min][min/hour][hours/day]   ;;total water imported from Cutzamala System
  set Tot_water_Imported_Lerma 5 * 60 * 60 * 24                                            ;;total water imported from Lerma System


  define_agebs       ;;to create the agebs
  resident_alternativesCriteria

 set background_fugas (8 * 60 * 60 * 24) / (count agebs)  ;;asuming fugas are homogeneously happening (not realistic)




 ;profiler:stop          ;; stop profiling
 ;print profiler:report  ;; view the results
 ;profiler:reset         ;; clear the data
 reset-ticks

end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to GO
  ;if ticks = 1 [movie-start "out.mov"]
  tick
  profiler:start
  update_globals
  produce_water
  ask agebs [
    residents_needs
    collect-info-system            ;;government (SACMEX) collect information at the level of Agebs to take decitions
    ]

  counter_days
  SACMEX_decisions               ;;decisions by government
  ask agebs [
    residents_satisfaction
    residents_define_distance_metric
    Landscape_visualization          ;;visualization of social and physical processes
  ]
  ask pozos [
    cal-exposure
    update_Infrastructure_state           ;;to update the state of infra and the probability of failure of wells
  ]

  if visualization = "GoogleEarth" [
    bitmap:copy-to-pcolors City_image false
  ]
 profiler:stop          ;; stop profiling
 print profiler:report  ;; view the results
 profiler:reset         ;; clear the data
 reset-ticks
end

;#############################################################################################################################################
;#############################################################################################################################################
to show_limitesDelegaciones
  gis:set-drawing-color white
  ;gis:draw desalojo_profundo 1
  gis:draw Limites_delegacionales 2
end

;#############################################################################################################################################
;#############################################################################################################################################
to show_AGEBS
  gis:set-drawing-color white
  ;gis:draw desalojo_profundo 1
  gis:draw Agebs_map 0.3
end

;#############################################################################################################################################
;#############################################################################################################################################
to cal-exposure  ;;to define based on the probability of failure if a well si working or is not (define here a probability of falla from pressure (leakages) age (wells)
  let rn random-float 1
     if (P_failure > rn and H = 1)[
       set H 0]
end

;#############################################################################################################################################
;#############################################################################################################################################
to produce_water ;define production of water per area, the needs for the population and any surplus in production
  set water_produced sum [H * production] of pozos + Tot_water_Imported_Cutzamala + Tot_water_Imported_Lerma
  ;print water_produced
end
;#############################################################################################################################################
;#############################################################################################################################################

to residents_needs                                                              ;; to define if population is gettign the water they need
  set water_needed poblacion * water_requirement_perPerson
  set water_distributed_pipes  water_needed * houses_with_abastecimiento   ;;this can be updated using tandeo
  set water_produced water_produced - water_distributed_pipes
  ifelse water_distributed_pipes < water_needed[

    set scarcity water_needed - water_distributed_pipes]
  [
    set scarcity 0
  ]

end
;#############################################################################################################################################
;#############################################################################################################################################

to residents_satisfaction    ;;define based on value fucntiona nd compromize programing the probability they will act acording to the value of the criteria

  set water_in water_in + water_distributed_pipes + water_distributed_trucks               ;;update total water obtained from pipes and trucks

  let final_deficit water_needed - water_in
  ifelse final_deficit > 0[
    set days_wno_water days_wno_water + (1 - houses_with_abastecimiento)
  ]
  [
    set days_wno_water 0
    set final_deficit 0
  ]
  set desviacion_agua ifelse-value (water_in > 0)[(count pozos_agebs) / water_in][0]

end

to residents_define_distance_metric

;We call the actions
;###############################################################################################################################

if group_kmean = 1 or group_kmean = 3[ ;#residents Xochimilco

 ask Alternatives_Xo [
   update_criteria_action
   calculate_value_functions
   let ddd (distance_ideal V w_C1 1)
   if name_action = "Movilizaciones"[
     ask myself [set d_Movilizaciones ddd]
   ]

   if name_action = "Modificacion_vivienda" [
     ask myself [set d_Modificacion_vivienda ddd]
   ]

   if name_action = "Captacion_agua" [
     ask myself [set d_Captacion_agua ddd]
   ]

   if name_action = "Accion_colectiva" [
     ask myself [set d_Accion_colectiva ddd]
   ]

   if name_action = "Compra_agua" [
     ask myself [set d_Compra_agua ddd]
   ]
 ]

]
;###############################################################################################################################
if group_kmean = 2 or group_kmean = 0[ ;#Residents Iztapalapa
  ask Alternatives_Iz [
    update_criteria_action
    calculate_value_functions
    let  ddd (distance_ideal V w_C1 1)
    if name_action = "Movilizaciones"[
      ask myself [set d_Movilizaciones ddd]
    ]
    if name_action = "Modificacion_vivienda"[
      ask myself [set d_Modificacion_vivienda ddd]
    ]

    if name_action = "Captacion_agua"[
      ask myself [set d_Captacion_agua ddd]
    ]

    if name_action = "Accion_colectiva"[
      ask myself [set d_Accion_colectiva ddd]
    ]

    if name_action = "Compra_agua"[
      ask myself [set d_Compra_agua ddd]
    ]
  ]
]
;###############################################################################################################################
if group_kmean = 4 [ ;#Residents Magdalena Contreras
  ask Alternatives_MC [
    update_criteria_action
    calculate_value_functions
    let ddd (distance_ideal V w_C1 1)
    if name_action = "Movilizaciones"[
      ask myself [set d_Movilizaciones ddd]
    ]


    if name_action = "Modificacion_vivienda"[
      ask myself [set d_Modificacion_vivienda ddd]
    ]

    if name_action = "Captacion_agua"[
      ask myself [set d_Captacion_agua ddd]
    ]
    if name_action = "Accion_colectiva" [
      ask myself [set d_Accion_colectiva ddd]
    ]

    if name_action = "Compra_agua" [
      ask myself [set d_Compra_agua ddd]
    ]
  ]
]
end


;#############################################################################################################################################
;#############################################################################################################################################
to consume_water                          ;population consume water

  let sp water_in - water_needed          ;define surpluss of water
  if alpha > 0 and sp > 0 [               ;if the level of adaptation is larger thatn 0 and surpluss is possitive
    set water_in alpha * sp               ;save water based on the level of adaptation (e.g. storage capasity)
  ]
  if alpha = 0 [                          ;if storage capasity =0 then the water save in the ageb is 0
    set water_in 0
  ]
  set Presion_social Presion_social - 0.1 * Presion_social  ;to reduce social presure
  if Presion_social < 0 [set Presion_social 0]
end
;#############################################################################################################################################
;#############################################################################################################################################
to update_globals  ;; update the maximum or minimum of values use by the model to calculate the value function of different actors
      set Antiguedad-infra_max max [Antiguedad-infra] of agebs
      set desperdicio_agua_max max [desperdicio_agua] of agebs;;max level of perception of deviation
      set desviacion_agua_max max [desviacion_agua] of agebs
      set garbage_max 1
      set water_quality_max 1
      set infra_abast_max max [houses_with_abastecimiento] of agebs
      set houses_with_dranage_max max [houses_with_dranage] of agebs
      set flooding_max max [flooding] of agebs ;;max level of flooding (encharcamientos) recored over the last 10 years
      set fallas_max max [Falla] of agebs
      set Abastecimiento_max max [Abastecimiento] of agebs
      set disease_burden_max max [disease_burden] of agebs
      set monto_max max [monto] of agebs
      set scarcity_max max [scarcity] of agebs
end
;#############################################################################################################################################
;#############################################################################################################################################
to update_Infrastructure_state    ;;update age and probability of failure and also is color if well is working
    set age_pozo age_pozo + 1
     set P_failure 1 - exp(- age_pozo / (365 * 500))
     if H = 0  [set color (1 - H) * 15
       set shape "x"
       ]
     if H = 1 [
       set shape "circle 2"
       set color sky]
end
;#############################################################################################################################################
;#############################################################################################################################################
to counter_days
  if ticks mod 365 = 0[
    set days 0
  ]
  set days days + 1
end
;#############################################################################################################################################
;#############################################################################################################################################
;; read GIS layers
to load-gis
  set elevation gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/rastert_dem1.asc"                                                             ;elevation
  set pozos_sacmex gis:load-dataset  "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/Join_pozosColoniasAgebs.shp"                                 ;wells
  set Limites_delegacionales gis:load-dataset  "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/limites_deleg_DF_2013.shp"
  set agebs_map gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/ageb7.shp";                                                      ;AGEB shape file

  set ageb_encharc gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/DF_agebs_escalante_Project_withEncharcamientos.shp"
  set mascara gis:load-dataset "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/mask.shp"                                                          ;Mask of study area
                                                                                                                                                   ;set Asentamientos_Irr gis:load-dataset "/GIS_layers/Asentamientos_Humanos_Irregulares_DF.shp"
  gis:set-world-envelope-ds gis:envelope-of mascara

  set city_image  bitmap:import "c:/Users/abaezaca/Documents/MEGADAPT/GIS_layers/DF_googleB.jpg"                                                   ; google earth image
  bitmap:copy-to-pcolors City_image false

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;load GIS variables into patches;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  gis:apply-raster  elevation altitude
  gis:apply-coverage agebs_map "POLY_ID" ageb_ID
  gis:apply-coverage agebs_map "NOM_MUN" delegation_ID
end
;#############################################################################################################################################
;#############################################################################################################################################

to define_agebs
  (foreach gis:find-features agebs_map "NOM_LOC" "Total AGEB urbana"   gis:find-features ageb_encharc "NOM_LOC" "Total AGEB urbana"
    [ let centroid gis:location-of gis:centroid-of ?
      if not empty? centroid
      [
        create-agebs 1
        [ set xcor item 0 centroid              ;define coodeantes of ageb at the center of the polygone
          set ycor item 1 centroid
          set name_delegation gis:property-value ?1 "NOM_MUN"                                                      ;;name of delegations
          set poblacion ifelse-value (gis:property-value ?1 "POBTOT" > 0)[gis:property-value ?1 "POBTOT"][1]        ;;population size per ageb
          set ID gis:property-value ?1 "POLY_ID"                                                                   ;;ageb ID
          set houses_with_abastecimiento gis:property-value ?1 "VPH_AGUADV" / (1 + gis:property-value ?1 "VPH_AGUADV" + gis:property-value ?1 "VPH_AGUAFV")  ;;houses with abastecimiento
          set houses_with_dranage gis:property-value ? "VPH_DRENAJ" / (1 + gis:property-value ? "VPH_DRENAJ" + gis:property-value ? "VPH_NODREN")         ;; numero de casas con toma de drenage from encuesta ENGHI
          set hundimientos gis:property-value ?2 "HUND"
          set group_kmean gis:property-value ?2 "KMEANS5"
          set av_inc ifelse-value ((gis:property-value ?1 "I05_INGRES") = nobody )[0][(gis:property-value ?1 "I05_INGRES")]
          set Income-index  ifelse-value (av_inc > 0) [av_inc][1]
          set flooding ifelse-value ((gis:property-value ?2 "Mean_encha") = nobody )[0][(gis:property-value ?2 "Mean_encha")]
          set desviacion_agua 1
          set eficacia_servicio 1            ;; Gestión del servicio de Drenaje y agua potable (ej. interferencia política, no llega la pipa, horario del tandeo, etc)
          set desperdicio_agua 1            ;;Por fugas, falta de conciencia del uso del agua
          set presion_hidraulica 1
          set garbage 1
          set pop_growth 1

          set color grey
          set shape "house"
          set size 0.5
          set hidden? false
        ]
      ]
    ])

  ask agebs [set paches_set_agebs patch-set patches with [ageb_ID = round ([ID] of myself)]]   ;define the patches that belon to each ageb


;#############################################################################################################################################
;#############################################################################################################################################
;define infrastructure as agents
  foreach gis:feature-list-of pozos_sacmex
    [ let centroid gis:location-of gis:centroid-of ?
      if not empty? centroid
      [ create-pozos 1
        [ set xcor item 0 centroid
          set ycor item 1 centroid
          set ageb_ID_pz gis:property-value ? "POLY_ID"
          set shape "circle 2"
          set size 2
          set color sky
          set age_pozo (1 + random 20) * 365
          set P_failure 1 - exp(- age_pozo / (365 * 500))
          set H 1
          set extraction_rate 87225 ;m3/dia
          ]
      ]
    ]

    ask pozos [set production extraction_rate * (1 / count pozos)] ; set daily production of water in [mts^3/s]*[s/min]*[min/hour]*[hours/day]*[1/tot pozos]=[mts^3/(day*pozo)]
    ;let tpz 0
    ask agebs [
      set pozos_agebs turtle-set pozos with [ageb_ID_pz = [ID] of myself]

    ]
end
;#############################################################################################################################################
;#############################################################################################################################################
to show_pozos
  ask pozos [
    ifelse hidden? = false [
      set hidden? true
      set size 2
    ]
    [
      set hidden? false
    ]
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################

to update_criteria_action
  let i 0
  (foreach C1_name
    [
    if ? = "Antiguedad"[
      set C1 replace-item i C1 ([Antiguedad-infra] of myself)
      set C1_max replace-item i C1_max Antiguedad-infra_max  ;change with update quantity for speed
    ]
     if ? = "Capacidad"[
       set C1 replace-item i C1 [Capacidad] of myself
       set C1_max replace-item i C1_max  Capacidad_max ;change with update quantity for speed
    ]
    if ? = "Falla"[
      set C1 replace-item i C1 [Falla] of myself
      set C1_max replace-item i C1_max fallas_max ;change with update quantity for speed
      ]
      if ? = "Falta"[
      set C1  replace-item i C1 [houses_with_dranage] of myself
      set C1_max replace-item i C1_max infra_abast_max   ;change with update quantity for speed

      ]
      if ? = "Presion_hidraulica"[
       set C1 replace-item i C1 [Presion_hidraulica] of myself
       set C1_max replace-item i C1_max presion_hidraulica_max ;change with update quantity for speed

      ]
      if ? = "Monto"[
        set C1 replace-item i C1 [Monto] of myself
        set C1_max replace-item i C1_max Monto_max ;change with update quantity for speed

      ]
      if ? = "Calidad_agua"[
        set C1 replace-item i C1 [water_quality] of myself
        set C1_max replace-item i C1_max water_quality_max  ;change with update quantity for speed

      ]
      if ? = "Escasez de agua"[
        set C1 replace-item i C1 [scarcity] of myself
        set C1_max replace-item i C1_max scarcity_max  ;change with update quantity for speed

      ]
      if ? = "Inundaciones"[
        set C1 replace-item i C1 [Flooding] of myself
        set C1_max replace-item i C1_max Flooding_max  ;change with update quantity for speed

      ]
      if ? = "Abastecimiento"[
        set C1 replace-item i C1 [Abastecimiento] of myself
        set C1_max replace-item i C1_max Abastecimiento_max  ;change with update quantity for speed

      ]
      if ? = "Peticion de Delegaciones"[
        set C1 replace-item i C1 [Petición_Delegaciones] of Delegaciones-here
        set C1_max replace-item i C1_max Petición_Delegaciones_max ;change with update quantity for speed
      ]
      if ? = "Presion de medios"[
        set C1 replace-item i C1 Presión_de_medios
        set C1_max replace-item i C1_max Presión_de_medios_max ;change with update quantity for speed
      ]
      if ? = "Presion social"[
        set C1 replace-item i C1 [Presion_social] of myself
        set C1_max replace-item i C1_max Presion_social_max;change with update quantity for speed
      ]

      if ? = "Crecimiento urbano"[
        set C1 replace-item i C1 [pop_growth] of myself
        set C1_max replace-item i C1_max pop_growth_max  ;change with update quantity for speed

      ]

      if ? = "Contaminacion de agua"[
        set C1 replace-item i C1 [water_quality] of myself
        set C1_max replace-item i C1_max water_quality_max  ;change with update quantity for speed
      ]

      if ? = "Salud"[
        set C1 replace-item i C1 [disease_burden] of myself
        set C1_max replace-item i C1_max disease_burden_max;change with update quantity for speed
      ]


      if ? = "Infraestructura insuficiente" [
        set C1 replace-item i C1 [houses_with_dranage] of myself
        set C1_max replace-item i C1_max houses_with_dranage_max  ;change with update quantity for speed

      ]
       if ? = "Desperdicio de agua" [
        set C1 replace-item i C1 [desperdicio_agua] of myself
        set C1_max replace-item i C1_max desperdicio_agua_max  ;change with update quantity for speed
       ]

       if ? = "Eficacia del servicio" [
         set C1 replace-item i C1 [houses_with_dranage] of myself
         set C1_max replace-item i C1_max  houses_with_dranage_max ;change with update quantity for speed
       ]

      set i i + 1
  ]
  )
end


to calculate_value_functions

   set V (map [VF ?1 [0.1 0.3 0.7 0.9] ["" "" "" ""] ?2 [0.0625 0.125 0.25  0.5 1]] C1 C1_max)

end

to SACMEX_decisions
 ;;; Define value functions
 ;;here goberment clasifies each ageb based on distan from ideal point to rank them and thus priotirized interventions
 ;we call each action in the context of a particular ageb nad we modify the value of the criteria acording to the state of the ageb we set the value functions and define the distant metric based on compromisez programing function with exponent =2
  ask  agebs [
    ;;Tranform from natural scale to standarized scale given action 1 (Reparation of pozos)
    ;#################################################################################################################################################


;#Alternative Mantenimiento Infrastructura
    ask Alternatives_SACMEX [
      update_criteria_action
      calculate_value_functions
      let ddd (distance_ideal V w_C1 2)
      if name_action = "Mantenimiento"[
        ask myself[set dist_reparation ddd]
      ]

    ;#################################################################################################################################################

;#Alternative: New Infrastructure
      if name_action = "Nueva_infraestructura"[
        ask myself[set dist_new ddd]
      ]
      ;#################################################################################################################################################
      ;#Alternativa 3 Distribution of water
      if name_action = "Distribucion_Agua"[
        ask myself[set dist_waterdistribution ddd]
      ]

      ;#################################################################################################################################################
      ;#Alternativa 4 Importacion agua
       if name_action = "Importacion_Agua"[
         ask myself [set dist_waterdistribution ddd]
       ]

    ;#################################################################################################################################################
;#Alternativa 5 Extraccion agua
        if name_action = "Extraccion_Agua"[
          ask myself[set dist_water_extraction ddd]
        ]
    ]
  ]

  ;;water distribution decition per ageb
  foreach sort-on [1 - dist_waterdistribution] agebs[
    ask ? [
      if water_produced > 0 and poblacion > 1 [
        set water_distributed_trucks scarcity
        set water_produced water_produced - water_distributed_trucks
      ]
    ]
  ]

  ;;;;water extraction
    ask agebs [ask pozos_agebs [set production (extraction_rate * [dist_water_extraction] of myself) / (count pozos)]]
end
;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to export_view  ;;export snapshots of the landscape
  if ticks > 20 and ticks < 40[
    let directory "c:/Users/abaezaca/Documents/MEGADAPT/model_results/Movie-ABM/"
    export-interface  word directory word ticks "water_supply_wells_MexicoCity.png"
  ]
end
;#############################################################################################################################################
;#############################################################################################################################################

;#############################################################################################################################################
;#############################################################################################################################################
to collect-info-system  ;;govertment information to take decisions
  set production_water_perageb ifelse-value  (count pozos_agebs > 0) [sum [Production] of pozos_agebs][0]            ;;;C2_A1;;;
  set Num_protestas_pAgeb Presion_social                                                                          ;;;C3_A1;;;
  set Antiguedad-infra ifelse-value (count pozos_agebs > 0) [mean [age_pozo] of pozos_agebs][0]

  set Abastecimiento poblacion * water_requirement_perPerson - sum [H * production] of pozos_agebs               ;;;C4_A1;;;
end

;#############################################################################################################################################
;#############################################################################################################################################


;#############################################################################################################################################
;#############################################################################################################################################
to Landscape_visualization ;;TO REPRESENT DIFFERENT INFORMATION IN THE LANDSCAPE
  if visualization != "GoogleEarth"[
    ask paches_set_agebs [
      if Visualization = "Accion_Colectiva" and ticks > 1[set pcolor scale-color green [d_Accion_colectiva] of myself 0 1]    ;; harmful events
      if Visualization = "Movilizaciones" and ticks > 1 [set pcolor scale-color red ([d_Movilizaciones] of myself) 0 1] ;;visualize vulnerability
      if visualization = "Compra_Agua" and ticks > 1 [set pcolor scale-color red [d_Compra_agua] of myself 0 1] ;;visualized social pressure
      if visualization = "Modificacion_vivienda"and ticks > 1 [set pcolor scale-color magenta [d_Modificacion_vivienda] of myself 0 1] ;;visualized social pressure
      if visualization = "Extraction Priorities" and ticks > 1 [set pcolor scale-color sky [dist_water_extraction] of myself 0 1] ;;visualized social pressure
      if visualization = "K_groups" and ticks > 1 [set pcolor  15 +  10 * [group_kmean] of myself] ;;visualized social pressure
    ]
  ]

end
;#############################################################################################################################################
;#############################################################################################################################################
to-report VF [A B C D EE]    ;This function reports a standarized value for the relationship between value of criteria and motivation to act
  ;A the value of a biophysical variable in its natural scale
  ;B a list of percentage values of the biofisical variable that reflexts on the cut-offs to define the limits of the range in the linguistic scale
  ;C list of streengs that define the lisguistice scale associate with a viobisical variable
  ;D the ideal or anti ideal point of the criteria define based on the linguistic scale (e.g. intolerable ~= anti-ideal)
  ;EE a list of standard values to map the natural scales


    if A > (item 3 B) * D [set SM (item 4 EE)]
    if A > (item 2 B) * D and  A <= (item 3 B) * D [set SM(item 3 EE)]
    if A > (item 1 B) * D and  A <= (item 2 B) * D [set SM (item 2 EE)]
    if A > (item 0 B) * D and  A <= (item 1 B) * D [set SM (item 1 EE)]
    if A <= (item 0 B) * D [set SM (item 0 EE)]

Report SM
  ;return a list of
end
;#############################################################################################################################################
;#############################################################################################################################################
to-report distance_ideal[VF_list weight_list h_Cp]
  ;this function calcualte a distance to ideal point using compromized programing metric
  ;arguments:
     ;VF_list: a list of value functions
     ;weight_list a list of weights from the alternatives criteria links (CA_links)
     ;h_Cp to control the type of distance h_Cp=2 euclidian; h_Cp=1 manhattan
     set dist ((sum (map [(?1 ^ h_Cp) * (?2 ^ h_Cp)] weight_list VF_list)) ^ (1 / h_Cp))

     report dist
end

;#############################################################################################################################################
;#############################################################################################################################################
;This procedure define each alternative as a object define by the:
;ID: identification of the mental model network where weights are elicit
;name_action: the name of the alternative
;w a set of weight that connect each criteria
to resident_alternativesCriteria
  let MMIz csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/I080316_OTR.weighted.csv"
  let MMIz_limit csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/I080316_OTR.limit.csv"
  let actions (list item 1 item 2 MMIz_limit
    item 1 item 3 MMIz_limit
    item 1 item 4 MMIz_limit
    item 1 item 5 MMIz_limit
    item 1 item 6 MMIz_limit)
  let jj 0
  foreach actions [

    create-Alternatives_IZ 1[
      set ID "IO80316"
      set name_action ?
      set label name_action
      set C1 (list 0 0 0 0 0 0 0 0 0)
      set C1_max (list 0 0 0 0 0 0 0 0 0)
      set V (list 0 0 0 0 0 0 0 0 0)
      set w_C1 (
        list item 6 item 7 MMIz_limit
        item 6 item 8 MMIz_limit
        item 6 item 9 MMIz_limit
        item 6 item 10 MMIz_limit
        item 6 item 11 MMIz_limit
        item 6 item 12 MMIz_limit
        item 6 item 13 MMIz_limit
        item 6 item 14 MMIz_limit
        item 6 item 15 MMIz_limit)

      set C1_name (
        list item 1 item 7 MMIz_limit
        item 1 item 8 MMIz_limit
        item 1 item 9 MMIz_limit
        item 1 item 10 MMIz_limit
        item 1 item 11 MMIz_limit
        item 1 item 12 MMIz_limit
        item 1 item 13 MMIz_limit
        item 1 item 14 MMIz_limit
        item 1 item 15 MMIz_limit)
;      set w_limit item (jj + 2) item (jj + 2) MMIz / 1
    ]

  set jj jj + 1
]


  inspect one-of Alternatives_IZ

  let MMXo_L csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/X062916_OTR_a.limit.csv"
  let MMXo_W csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/X062916_OTR_a.weighted.csv"
  set jj 0

  set actions (list item 1 item 2 MMXo_L
    item 1 item 3 MMXo_L
    item 1 item 4 MMXo_L
    item 1 item 5 MMXo_L
    item 1 item 6 MMXo_L)

  foreach actions [
    create-Alternatives_Xo 1[
      set ID "XO62916_a"
      set name_action ?
      set label name_action
      set C1 (list 0 0 0 0 0 0 0 0 0)
      set C1_max (list 0 0 0 0 0 0 0 0 0)
      set V (list 0 0 0 0 0 0 0 0 0)
      set w_C1 (list item 6 item 7 MMXo_L
        item 6 item 8 MMXo_L
        item 6 item 9 MMXo_L
        item 6 item 10 MMXo_L
        item 6 item 11 MMXo_L
        item 6 item 12 MMXo_L
        item 6 item 13 MMXo_L
        item 6 item 14 MMXo_L
        item 6 item 15 MMXo_L)

      set C1_name (list item 1 item 7 MMXo_L
        item 1 item 8 MMXo_L
        item 1 item 9 MMXo_L
        item 1 item 10 MMXo_L
        item 1 item 11 MMXo_L
        item 1 item 12 MMXo_L
        item 1 item 13 MMXo_L
        item 1 item 14 MMXo_L
        item 1 item 15 MMXo_L)

      set w_limit (item (jj + 2) item (jj + 2) MMXo_L) /(item 5 item 5 MMXo_L + item 4 item 4 MMXo_L + item 3 item 3 MMXo_L + item 6 item 6 MMXo_L + item 2 item 2 MMXo_L)
    ]
  set jj jj + 1
  ]
       ;#################################################
       let MMMC csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/MC080416_OTR_a.weighted.csv"
       let MMMC_limit csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/MC080416_OTR_a.limit.csv"
       let MMMCb csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/MC080416_OTR_b.weighted.csv"
       let MMMCb_limit csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/MC080416_OTR_b.limit.csv"

       set actions (list item 1 item 2 MMMCb_limit
         item 1 item 3 MMMCb_limit
         item 1 item 4 MMMCb_limit
         item 1 item 5 MMMCb_limit
         item 1 item 6 MMMCb_limit)
       set jj 0
       foreach actions [
         create-Alternatives_MC 1 [
           set ID "MC080416b"
           set name_action ?
           set label name_action
;           print item 6 (item 7 MMMCb_limit)
           set C1 (list 0 0 0 0 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0 0 0 0 0)
           set w_C1 (list item 6 item 7 MMMCb_limit
             item 6 item 8 MMMCb_limit
             item 6 item 9 MMMCb_limit
             item 6 item 10 MMMCb_limit
             item 6 item 11 MMMCb_limit
             item 6 item 12 MMMCb_limit
             item 6 item 13 MMMCb_limit
             item 6 item 14 MMMCb_limit
             item 6 item 15 MMMCb_limit
             item 6 item 16 MMMCb_limit)

           set C1_name (list item 1 item 7 MMMCb_limit
             item 1 item 8 MMMCb_limit
             item 1 item 9 MMMCb_limit
             item 1 item 10 MMMCb_limit
             item 1 item 11 MMMCb_limit
             item 1 item 12 MMMCb_limit
             item 1 item 13 MMMCb_limit
             item 1 item 14 MMMCb_limit
             item 1 item 15 MMMCb_limit
             item 1 item 16 MMMCb_limit)


          ; set w_limit item (? + 2) item (? + 2) MMMCb_limit /(item 5 item 5 MMMCb_limit + item 4 item 4 MMMCb_limit + item 3 item 3 MMMCb_limit + item 6 item 6 MMMCb_limit + item 2 item 2 MMMCb_limit)
         ]
       ]

       set actions (list item 1 item 2 MMMC_limit
         item 1 item 3 MMMC_limit
         item 1 item 4 MMMC_limit
         item 1 item 5 MMMC_limit
         item 1 item 6 MMMC_limit)

       set jj 0
       foreach actions [
         create-Alternatives_MC 1[
           set ID "MC080416"
           set name_action "Accion_colectiva"
           set label name_action
           set C1 (list 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0)
           set w_C1 (list item 2 item 7 MMMC_limit
             item 2 item 8 MMMC_limit
             item 2 item 9 MMMC_limit
             item 2 item 10 MMMC_limit
             item 2 item 11 MMMC_limit
             item 2 item 12 MMMC_limit)

           set C1_name (list item 1 item 7 MMMC_limit
             item 1 item 8 MMMC_limit
             item 1 item 9 MMMC_limit
             item 1 item 10 MMMC_limit
             item 1 item 11 MMMC_limit
             item 1 item 12 MMMC_limit)


           set w_limit item (jj + 2) item (jj + 2) MMMC_limit /(item 5 item 5 MMMC_limit + item 4 item 4 MMMC_limit + item 3 item 3 MMMC_limit + item 6 item 6 MMMC_limit + item 2 item 2 MMMC_limit)

         ]
         set jj jj + 1
       ]


       ;#########################################
;#SACMEX NETWORK
       let MMSACMEX csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/DF101215_GOV_AP modificado PNAS.weighted.csv"
       let MMSACMEX_limit csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/DF101215_GOV_AP modificado PNAS.limit.csv"

       set actions (list item 1 item 2 MMSACMEX_limit
         item 1 item 3 MMSACMEX_limit
         item 1 item 4 MMSACMEX_limit
         item 1 item 5 MMSACMEX_limit
         item 1 item 6 MMSACMEX_limit)
       set jj 0
       print actions
       foreach actions [
         create-Alternatives_SACMEX 1[
           set ID "DF101215_GOV"
           set name_action ?
           set label name_action
           set C1 (list 0 0 0 0 0 0 0 0 0 0 0)
           set C1_max (list 0 0 0 0 0 0 0 0 0 0 0)
           set V (list 0 0 0 0 0 0 0 0 0 0 0)
           set w_C1 (
             list item 2 item 7 MMSACMEX_limit
             item 2 item 8 MMSACMEX_limit
             item 2 item 9 MMSACMEX_limit
             item 2 item 10 MMSACMEX_limit
             item 2 item 11 MMSACMEX_limit
             item 2 item 12 MMSACMEX_limit
             item 2 item 13 MMSACMEX_limit
             item 2 item 14 MMSACMEX_limit
             item 2 item 15 MMSACMEX_limit
             item 2 item 16 MMSACMEX_limit
             item 2 item 17 MMSACMEX_limit)

           set C1_name (list item 1 item 7 MMSACMEX
             item 1 item 8 MMSACMEX
             item 1 item 9 MMSACMEX
             item 1 item 10 MMSACMEX
             item 1 item 11 MMSACMEX
             item 1 item 12 MMSACMEX
             item 1 item 13 MMSACMEX
             item 1 item 14 MMSACMEX
             item 1 item 15 MMSACMEX
             item 1 item 16 MMSACMEX
             item 1 item 17 MMSACMEX)
print name_action
print w_C1
           set w_limit item (jj + 2) item (jj + 2) MMSACMEX_limit /(item 5 item 5 MMSACMEX_limit + item 4 item 4 MMSACMEX_limit + item 3 item 3 MMSACMEX_limit + item 6 item 6 MMSACMEX_limit + item 2 item 2 MMSACMEX_limit)

         ]
         set jj jj + 1
       ]


       let MMOCVAM csv:from-file  "c:/Users/abaezaca/Documents/MEGADAPT/ABM-empirical-V1/Mental-Models/OCVAM_Version_sin_GEO.limit.csv"

       ;create-Alternatives_OCVAM 1[
       ;    set ID "OCVAM"
       ;    set label name_action
       ;    set w_C1 (list item 6 item 2 MMOCVAM
       ;    item 6 item 3 MMOCVAM
       ;    item 6 item 4 MMOCVAM
       ;    item 6 item 5 MMOCVAM
       ;    item 6 item 6 MMOCVAM
       ;    item 6 item 7 MMOCVAM
       ;    item 6 item 8 MMOCVAM
       ;    item 6 item 9 MMOCVAM
       ;    item 6 item 10 MMOCVAM
       ;    item 6 item 11 MMOCVAM
       ;
       ;    item 6 item 12 MMOCVAM
       ;    item 6 item 13 MMOCVAM
       ;    item 6 item 14 MMOCVAM
       ;    item 6 item 15 MMOCVAM
       ;    item 6 item 16 MMOCVAM
       ;    item 6 item 17 MMOCVAM
       ;    item 6 item 18 MMOCVAM
       ;    item 6 item 19 MMOCVAM
       ;    item 6 item 20 MMOCVAM
       ;    item 6 item 21 MMOCVAM
       ;
       ;    item 6 item 22 MMOCVAM
       ;    item 6 item 23 MMOCVAM
       ;    item 6 item 24 MMOCVAM
       ;    item 6 item 25 MMOCVAM
       ;    item 6 item 26 MMOCVAM)
       ;
       ;
       ;
       ;    set C1_name (list item 1 item 2 MMOCVAM
       ;    item 1 item 3 MMOCVAM
       ;    item 1 item 4 MMOCVAM
       ;    item 1 item 5 MMOCVAM
       ;    item 1 item 6 MMOCVAM
       ;    item 1 item 7 MMOCVAM
       ;    item 1 item 8 MMOCVAM
       ;    item 1 item 9 MMOCVAM
       ;    item 1 item 10 MMOCVAM
       ;    item 1 item 11 MMOCVAM
       ;
       ;    item 1 item 12 MMOCVAM
       ;    item 1 item 13 MMOCVAM
       ;    item 1 item 14 MMOCVAM
       ;    item 1 item 15 MMOCVAM
       ;    item 1 item 16 MMOCVAM
       ;    item 1 item 17 MMOCVAM
       ;    item 1 item 18 MMOCVAM
       ;    item 1 item 19 MMOCVAM
       ;    item 1 item 20 MMOCVAM
       ;    item 1 item 21 MMOCVAM
       ;    item 1 item 23 MMOCVAM
       ;    item 1 item 24 MMOCVAM
       ;    item 1 item 25 MMOCVAM
       ;    item 1 item 26 MMOCVAM)
       ;
       ;    set w_limit  0.02017 /(0.05471 + 0.05212 + 0.01843 + 0.05545 + 0.02017)
       ;  ]
       ;

end



;#############################################################################################################################################
;#############################################################################################################################################
;code ends here
;#############################################################################################################################################
;#############################################################################################################################################

;;coodinates google image

;              lat              long
;top-left      19.578775°       -99.620393°
;top-right     19.583922°       -98.792704°
;Bottom-right   19.171378°       -98.766428°
;Bottom-left    19.164627°      -99.615584°
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@#$#@#$#@
GRAPHICS-WINDOW
467
20
1067
641
-1
-1
2.94
1
40
1
1
1
0
0
0
1
0
200
0
200
1
1
1
days
30.0

BUTTON
44
30
107
63
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
107
30
170
63
NIL
GO
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
169
30
232
63
NIL
GO
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
46
578
244
623
Visualization
Visualization
"Accion_Colectiva" "Movilizaciones" "Compra_Agua" "Modificacion_vivienda" "Extraction Priorities" "GoogleEarth" "K_groups"
1

BUTTON
278
429
450
498
NIL
show_limitesDelegaciones
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
276
504
448
571
NIL
show_pozos
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
276
579
446
643
NIL
show_AGEBS
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
79
548
192
583
Visualización
18
0.0
1

SLIDER
58
319
258
352
water_requirement_perPerson
water_requirement_perPerson
0.007
0.4
0.3452
0.0001
1
NIL
HORIZONTAL

SLIDER
58
283
258
316
recursos_para_mantencion
recursos_para_mantencion
1
60
4
1
1
NIL
HORIZONTAL

SLIDER
59
359
261
392
water_production
water_production
1
40
7
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment_evolution" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="150"/>
    <metric>mean V_list</metric>
    <metric>mean gini_V</metric>
    <metric>mean W_list</metric>
    <metric>mean gini_W</metric>
    <metric>mean S_list</metric>
    <metric>total_cost_plot</metric>
    <metric>mean [p_failure] of patches with [IS &gt; 0]</metric>
    <metric>mean [W] of colonias</metric>
    <metric>mean [Sens_ave] of colonias</metric>
    <metric>mean [exposure] of colonias</metric>
    <enumeratedValueSet variable="prop_cost_bud">
      <value value="4.3E-5"/>
      <value value="8.5E-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Effective_protest">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Scenarios_GovDecisions">
      <value value="&quot;BAU&quot;"/>
      <value value="&quot;More New Infra&quot;"/>
      <value value="&quot;Social responsability/pressure&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="type_of_simulation">
      <value value="&quot;Evolution&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

small-arrow-link
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 120 180
Line -7500403 true 150 150 180 180

@#$#@#$#@
0
@#$#@#$#@
