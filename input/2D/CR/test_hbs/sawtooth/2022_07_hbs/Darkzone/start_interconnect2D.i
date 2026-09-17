[GlobalParams]
  density = 15800.0
  order = FIRST
  family = LAGRANGE
  energy_per_fission = 3.2e-11  # J/fission
  displacements = 'disp_x disp_y'
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
  coord_type = RZ
[]

[Mesh]
  patch_size = 50
  patch_update_strategy = auto
  partitioner = centroid
  centroid_partitioner_direction = y
  [fuel_mesh]
    type = SmearedPelletMeshGenerator
    clad_thickness = 0.4e-3
    pellet_outer_radius = 5e-3
    pellet_height = 25e-3
    clad_top_gap_height = 24e-3
    clad_gap_width = 0.1e-3
    top_bot_clad_height = 8e-3
    clad_bot_gap_height = 1e-3
    clad_mesh_density = customize
    pellet_mesh_density = customize
    nx_p = 10
    ny_p = 50
    nx_c = 3
    ny_c = 50
    ny_cu = 4
    ny_cl = 4
    pellet_quantity = 1
    elem_type = QUAD4
  []
[]

[Variables]
  [./Temperature]
    initial_condition = 298.0
  [../]
[]

[AuxVariables]
  # Aux variables for output
  [./creep_strain_mag]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./gap_cond]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./solid_swell]
    block = pellet
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./gas_swell]
    block = pellet
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./total_hoop_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [energy_density]
    order = CONSTANT
    family = MONOMIAL
    block = pellet
    initial_condition = 0.0
  []
[]

[Functions]
  [./power_history]
    type = PiecewiseLinear
    x = '0 2e5   109989115 110376000'
    y = '0 8.0e4 8.0e4 0' # LHGR
  [../]
  [./coolant_press_ramp]
    type = PiecewiseLinear
    x = '0 110376000'
    y = '0.151e6 0.151e6'
  [../]
  [./coolant_temp_ramp]
    type = PiecewiseLinear
    x = '0 2e5   109989115 110376000'
    y = '298.0  648.0  648.0  350.0'
  [../]
  [./axial_peaking_factors]
    type = ParsedFunction
    value = 1.0
  [../]
  [./engr_radial_strain_fuel]
    type = ParsedFunction
    value = 'fuel_disp_rad / 2.50e-03'
    vals = 'max_fuel_radial_disp'
    vars = 'fuel_disp_rad'
  [../]
  [./engr_axial_strain_fuel]
    type = ParsedFunction
    value = 'fuel_disp_axial / 100.0e-3'
    vals = 'max_fuel_elongation'
    vars = 'fuel_disp_axial'
  [../]
  [./fission_rate_scale_factor]
    type = ParsedFunction
    value = 3.97887357729738E+14
    # 1/cross_sectional_area_of_fuel/energy_per_fission =
  [../]
  [./fission_history]
    type = CompositeFunction
    functions = 'power_history fission_rate_scale_factor'
    # This converts it to a fission rate density.
  [../]
[]

[Modules/TensorMechanics/Master]
  temperature = Temperature
  add_variables = true
  strain = FINITE
  generate_output = 'stress_xx stress_yy stress_zz vonmises_stress hydrostatic_stress creep_strain_xx creep_strain_yy creep_strain_zz elastic_strain_xx elastic_strain_yy elastic_strain_zz strain_xx strain_yy strain_zz hoop_stress'
  [./fuel]
    extra_vector_tags = 'ref'
    block = pellet
    eigenstrain_names = 'fuel_thermal_strain gas_swelling_eigenstrain solid_swelling_eigenstrain'
    additional_generate_output = 'volumetric_strain'
  [../]
  [./clad]
    extra_vector_tags = 'ref'
    block = clad
    eigenstrain_names = 'clad_thermal_eigenstrain'
    additional_generate_output = 'hoop_creep_strain hoop_elastic_strain'
  [../]
[]

[Kernels]
  # Define kernels for the various terms in the PDE system
  [./gravity]
    type = Gravity
    variable = disp_y
    value = -9.81
    extra_vector_tags = 'ref'
  [../]
  [./heat]
    type = HeatConduction
    variable = Temperature
    extra_vector_tags = 'ref'
  [../]
  [./heat_ie]
    type = HeatConductionTimeDerivative
    variable = Temperature
    extra_vector_tags = 'ref'
  [../]
  [./heat_source]
    type = FissionRateHeatSource
    variable = Temperature
    fission_rate = 'fission_rate'
    extra_vector_tags = 'ref'
    block = pellet
  [../]
[]

[AuxKernels]
  [./creep_strain_mag]
    type = RankTwoScalarAux
    rank_two_tensor = creep_strain
    variable = creep_strain_mag
    scalar_type = EffectiveStrain
    execute_on = timestep_end
  [../]
  [./conductance]
    type = MaterialRealAux
    property = gap_conductance
    variable = gap_cond
    boundary = 10
  [../]
  [./gas_swell]
    type = MaterialRealAux
    variable = gas_swell
    property = gas_swelling
    execute_on = timestep_end
  [../]
  [./solid_swell]
    type = MaterialRealAux
    variable = solid_swell
    property = solid_swelling
    execute_on = timestep_end
  [../]
  [./total_hoop_strain]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = total_hoop_strain
    index_j = 2
    index_i = 2
    execute_on = timestep_end
    block = clad
  [../]
  [time_integral_fission]
    type = VariableTimeIntegrationAux
    block = pellet
    variable = energy_density
    variable_to_integrate = fission_rate
    coefficient = 3.2e-11 # energy_per_fission
    order = 2
    execute_on = timestep_end
  []
[]

[Contact]
  [./pellet_clad_mechanical]
    primary = 5
    secondary = 10
    penalty = 1e12
    model = frictionless
    formulation = kinematic
    normalize_penalty = true
    tangential_tolerance = 1e-3
    normal_smoothing_distance = 0.1
  [../]
[]

[ThermalContact]
  [./thermal_contact]
    type = GapHeatTransfer
    variable = Temperature
    primary = 5
    secondary = 10
    quadrature = true
    gap_conductivity = 61.0
    min_gap = 0.10e-3
  [../]
[]

[BCs]
  [no_x_all]
    type = DirichletBC
    variable = disp_x
    boundary = 12
    value = 0.0
  []
  [no_y_fuel]
    type = DirichletBC
    variable = disp_y
    boundary = 20
    value = 0.0
  []
  [no_y_clad]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  []
  [./Pressure]
    [./coolantPressure]
      boundary = '1 2 3'
      function = coolant_press_ramp
    [../]
  [../]
  [./PlenumPressure]
    [./plenumPressure]
      boundary = 9
      initial_pressure = 0.084e6 # Pa
      startup_time = 0
      R = 8.3143
      temperature = ave_temp_interior
      volume = gas_volume
      output = plenum_pressure
      material_input = fis_gas_released
    [../]
  [../]
[]

[CoolantChannel]
  [./convective_clad_surface]
    boundary = '2'
    variable = Temperature
    inlet_temperature   = coolant_temp_ramp
    inlet_pressure      = coolant_press_ramp
    inlet_massflux      = 5000.0   # kg/m^2-sec
    coolant_material    = sodium
    rod_diameter        = 0.011 # m
    rod_pitch           = 0.01408 # m (Pitch-to-diameter Ratio = 1.28)
    linear_heat_rate    = power_history
    axial_power_profile = axial_peaking_factors
    subchannel_geometry = triangular
    outputs = all
    output_properties = 'coolant_temperature coolant_channel_htc'
  [../]
[]

[Materials]
  [./fission_rate]
    type = GenericFunctionMaterial
    prop_names = 'fission_rate'
    prop_values = fission_history
    block = pellet
    outputs = all
  [../]
  [./burnup]
    type = UPuZrBurnup
    block = pellet
    outputs = all
  [../]
  [./fuel_elasticity_tensor]
    type = UPuZrElasticityTensor
    X_Zr = 0.225
    X_Pu = 0.0
    block = pellet
    temperature = Temperature
  [../]
  [./fuel_elastic_stress]
    type = ComputeMultipleInelasticStress
    tangent_operator = nonlinear
    inelastic_models = 'fuel_upuzrcreep'
    block = pellet
  [../]
  [./fuel_upuzrcreep]
    type = UPuZrCreepUpdate
    block = pellet
    temperature = Temperature
    porosity = porosity
    max_inelastic_increment = 2e-3
  [../]
  [./fuel_thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    block = pellet
    thermal_expansion_coeff = 1.18e-5
    temperature = Temperature
    stress_free_temperature = 298.0
    eigenstrain_name = fuel_thermal_strain
  [../]
  [./gas_swelling] # Replace this with your gaseous swelling model
    type = UPuZrGaseousEigenstrain
    eigenstrain_name = gas_swelling_eigenstrain
    temperature = Temperature
    initial_porosity = 0.26
    bubble_number_density = 8.61e17
    # Preserving old behavior with interconnection for now.
    interconnection_initiating_porosity = 0.26
    interconnection_terminating_porosity = 0.28
    anisotropic_factor = 0.0
    outputs = all
    output_properties = 'porosity gaseous_porosity'
    block = pellet
  [../]
  [./solid_swelling]
    type = BurnupDependentEigenstrain
    eigenstrain_name = solid_swelling_eigenstrain
    block = pellet
    swelling_name = 'solid_swelling'
  [../]
  [./metal_fuel_thermal]
    type = UPuZrThermal
    block = pellet
    X_Zr = 0.225
    X_Pu = 0.0
    spheat_model = savage
    thcond_model = lanl
    porosity = porosity
    temperature = Temperature
  [../]
  [./fuel_density]
    type = Density
    block = pellet
  [../]
  [./Fission_Gas_Release] # Also look at this. But probably don't have to change it
    type = UPuZrFissionGasRelease
    block = pellet
    critical_porosity = 0.27 # Probably have to change this with the new value
    fractional_fgr_initial = 0.252
    fractional_fgr_post = 0.801
    fission_rate = fission_rate
  [../]
  [./clad_elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.88e11
    poissons_ratio = 0.236
    block = clad
  [../]
  [./clad_stress]
    type = ComputeMultipleInelasticStress
    tangent_operator = nonlinear
    inelastic_models = 'clad_ht9creep'
    block = clad
  [../]
  [fast_flux]
    type = FastNeutronFlux
    block = clad
    factor = 3e13 # This was recommended in FastNeutronFluxAux for LHGR
                  # However, this gives 1.35e18 which is not what AL used
                  #  before of 2.47e19. Not sure which is right.
    calculate_fluence = true
    rod_ave_lin_pow = power_history
    axial_power_profile = axial_peaking_factors # which is just 1
    outputs = all
  []
  [./clad_ht9creep]
    type = HT9CreepUpdate
    block = clad
    temperature = Temperature
  [../]
  [./thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    block = clad
    thermal_expansion_coeff = 1.2e-5
    temperature = Temperature
    stress_free_temperature = 298.0
    eigenstrain_name = clad_thermal_eigenstrain
  [../]
  [./clad_thermal]
    type = ThermalHT9
    block = clad
    temperature = Temperature
  [../]
  [./clad_density]
    type = Density
    block = clad
    density = 7874.0
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Dampers]
  [./limitT]
    type = MaxIncrement
    variable = Temperature
    max_increment = 50
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  l_max_its = 60
  l_tol = 8e-3
  nl_max_its = 40
  nl_rel_tol = 5e-4
  nl_abs_tol = 1e-7

  end_time = 110376000  # 3.5 years. If need faster run, then 1 year should be fine
  dtmin = 10
  dtmax = 5e6

  [./Quadrature]
    order = fifth
    side_order = seventh
  [../]
  [./TimeStepper]
    type = IterationAdaptiveDT
    timestep_limiting_postprocessor = creep_timestep
    dt = 1e2
    time_t = '0   1e5   1.54656e7 1.5552e7'
    time_dt = '1e2 1e2    1e2    1e2'
    iteration_window = 4
    optimal_iterations = 10
  [../]
[]

[Postprocessors]
  [./ave_temp_interior]
    type = SideAverageValue
    boundary = 9
    variable = Temperature
    execute_on = 'initial linear'
  [../]
  [./ave_FST]
    type = SideAverageValue
    boundary = 10
    variable = Temperature
  [../]
  [./peak_ave_FST]
    type = TimeExtremeValue
    value_type = max
    postprocessor = ave_FST
  [../]
  [./ave_CIT]
    type = SideAverageValue
    boundary = 5
    variable = Temperature
  [../]
  [./peak_ave_CIT]
    type = TimeExtremeValue
    value_type = max
    postprocessor = ave_CIT
  [../]
  [./avg_clad_temp]
    type = ElementAverageValue
    variable = Temperature
    block = clad
  [../]
  [./max_clad_temp]
    type = ElementExtremeValue
    variable = Temperature
    value_type = max
    block = clad
  [../]
  [./peak_clad_temp]
    type = TimeExtremeValue
    value_type = max
    postprocessor = max_clad_temp
  [../]
  [./avg_fuel_temp]
    type = ElementAverageValue
    variable = Temperature
    block = pellet
  [../]
  [./max_fuel_temp]
    type = ElementExtremeValue
    variable = Temperature
    value_type = max
    block = pellet
  [../]
  [./peak_fuel_temp]
    type = TimeExtremeValue
    value_type = max
    postprocessor = max_fuel_temp
  [../]
  [peak_coolant_temperature]
    type = ElementExtremeValue
    variable = coolant_temperature
    value_type = max
    block = clad
    outputs = all
  []
  [./max_hydro]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = max
    block = pellet
  [../]
  [./min_hydro]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = pellet
  [../]
  [./max_porosity]
    type = ElementExtremeValue
    variable = porosity
    value_type = max
    block = pellet
  [../]
  [./clad_inner_vol]
    type = InternalVolume
    boundary = 7
  [../]
  [./pellet_volume]
    type = InternalVolume
    boundary = 8
  [../]
  [./gas_volume]
    type = InternalVolume
    boundary = 9
    execute_on = 'initial timestep_end'
  [../]
  [./clad_fuel_gap]
    type = NodalMaxValue
    variable = penetration
    boundary = 10
  [../]
  [./max_cont_press]
    type = NodalMaxValue
    variable = contact_pressure
    boundary = 10
  [../]
  [./flux_from_clad]
    type = SideDiffusiveFluxIntegral
    variable = Temperature
    boundary = 5
    diffusivity = thermal_conductivity
  [../]
  [./flux_from_fuel]
    type = SideDiffusiveFluxIntegral
    variable = Temperature
    boundary = 10
    diffusivity = thermal_conductivity
  [../]
  [./rod_total_power]
    type = ElementIntegralPower
    variable = Temperature # Dummy variable
    use_material_fission_rate = true
    fission_rate_material = fission_rate
    block = pellet
  [../]
  [./LHGR_W_per_cm]
    type = FunctionValuePostprocessor
    function = power_history
    scale_factor = 0.01
  [../]
  [./average_burnup]
    type = ElementAverageValue
    block = pellet
    variable = burnup
  [../]
  [./max_burnup]
    type = ElementExtremeValue
    value_type = max
    block = pellet
    variable = burnup
  [../]
  [./min_burnup]
    type = ElementExtremeValue
    value_type = min
    block = pellet
    variable = burnup
  [../]
  [./fis_gas_produced]
    type = ElementIntegralFisGasProduce
    block = pellet
  [../]
  [./fis_gas_released]
    type = ElementIntegralFisGasRelease
    block = pellet
    execute_on = 'initial timestep_end'
  [../]
  [./creep_timestep]
    type = MaterialTimeStepPostprocessor
    block = pellet
  [../]
  [./hydrostatic_stress]
    type = ElementAverageValue
    variable = hydrostatic_stress
    execute_on = 'initial timestep_end'
    block = pellet
  [../]
  [./solid_swelling]
    type = ElementAverageValue
    variable = solid_swell
    block = pellet
  [../]
  [./gas_swelling]
    type = ElementAverageValue
    variable = gas_swell
    block = pellet
  [../]
  [./volumetric_strain]
    type = ElementAverageValue
    variable = volumetric_strain
    block = pellet
  [../]
  [./porosity]
    type = ElementAverageValue
    variable = porosity
    block = pellet
  [../]
  [./gaseous_porosity]
    type = ElementAverageValue
    variable = gaseous_porosity
    block = pellet
  [../]
  [./fis_gas_percent]
    type = FGRPercent
    fission_gas_released = fis_gas_released
    fission_gas_generated = fis_gas_produced
  [../]
  [./max_clad_hoop_creep]
    type = ElementExtremeValue
    value_type = max
    block = clad
    variable = hoop_creep_strain
  [../]
  [./max_clad_creep_strain_mag]
    type = ElementExtremeValue
    value_type = max
    block = clad
    variable = creep_strain_mag
  [../]
  [./max_total_hoop_strain]
    type = ElementExtremeValue
    value_type = max
    block = clad
    variable = total_hoop_strain
  [../]
  [./max_fuel_radial_strain]
    type = ElementExtremeValue
    value_type = max
    block = pellet
    variable = strain_xx
  [../]
  [./max_fuel_axial_strain]
    type = ElementExtremeValue
    value_type = max
    block = pellet
    variable = strain_yy
  [../]
  [./max_fuel_elongation]
    type = NodalMaxValue
    variable = disp_y
    boundary = 11
  [../]
  [./max_fuel_radial_disp]
    type = NodalMaxValue
    variable = disp_x
    boundary = 10
  [../]
  [./engr_strain_fuel_radial]
    type = FunctionValuePostprocessor
    function = engr_radial_strain_fuel
  [../]
  [./engr_strain_fuel_axial]
    type = FunctionValuePostprocessor
    function = engr_axial_strain_fuel
  [../]
  [./max_clad_elongation]
    type = NodalMaxValue
    variable = disp_y
    boundary = 3
  [../]
  [etot_bison]
    type = ElementIntegralVariablePostprocessor
    block = 3
    variable = energy_density
    execute_on = 'initial timestep_end'
  []
[]

[PerformanceMetricOutputs]
  outputs = performance_metrics_file
[]

[Outputs]
  interval = 1
  color = true
  exodus = true
  perf_graph = true
  csv = true
  sync_times = '1e3 5e3 1e4 5e4 1e5 5e6 1e6 5e6 1e7 1.54656e7 1.5552e7'
  file_base = start_inter
  [./out2]
    type = CSV
    file_base = start_inter_out2
    interval = 1
  [../]
  [./console]
    type = Console
    max_rows = 25
    interval = 1
    output_linear = true
  [../]
  [./chkfile]
    type = CSV
    file_base = start_inter_chkfile
    show = 'peak_ave_FST peak_ave_CIT peak_fuel_temp peak_clad_temp average_burnup max_burnup fis_gas_percent max_clad_hoop_creep max_clad_creep_strain_mag max_fuel_elongation max_clad_elongation max_total_hoop_strain max_fuel_radial_strain max_fuel_axial_strain'
    execute_on = 'FINAL'
  [../]
  [./performance_metrics_file]
    type = CSV
    file_base = start_inter_performance
    show = 'simulation_alive_time number_linear_iterations number_nonlinear_iterations time_step_size total_linear_iterations total_nonlinear_iterations physical_memory_use number_dofs number_nonlinear_variables residual_compute_time jacobian_compute_time'
  [../]
[]

[Debug]
  show_var_residual = 'disp_x disp_y Temperature'
  show_var_residual_norms = true
[]
