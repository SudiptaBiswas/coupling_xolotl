[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 125
  ny = 125
  xmin = 0
  xmax = 20000
  ymin = 0
  ymax = 20000
[]

[GlobalParams]
  op_num = 11
  var_name_base = etam

  # SolutionUserObject parameters
  mesh = step1_exodus.e
  system_variables = 'etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10 bubble'
  timestep = 226

  int_width = 480
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
  [../]
  [./soln_uo]
    type = SolutionUserObject
  [../]
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bubble]
    order = FIRST
    family = LAGRANGE
  [../]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./time]
  [../]
  # For use of GrainTracker
  [./unique_grains]
    order = FIRST
    family = MONOMIAL
  [../]
  [./var_indices]
    order = FIRST
    family = MONOMIAL
  [../]

  [./halos]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo0]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo1]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo2]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo3]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo4]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo5]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo6]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo7]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo8]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo9]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo10]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
  [./time]
    type = FunctionAux
    variable = time
    function = 't'
  [../]

  #additional_for_grain_tracker
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
  [../]
  [./halos]
    type = FeatureFloodCountAux
    variable = halos
    flood_counter = grain_tracker
    field_display = HALOS
    execute_on = 'initial timestep_end'
  [../]
  [./halo0]
    type = FeatureFloodCountAux
    variable = halo0
    map_index = 0
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo1]
    type = FeatureFloodCountAux
    variable = halo1
    map_index = 1
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo2]
    type = FeatureFloodCountAux
    variable = halo2
    map_index = 2
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo3]
    type = FeatureFloodCountAux
    variable = halo3
    map_index = 3
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo4]
    type = FeatureFloodCountAux
    variable = halo4
    map_index = 4
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo5]
    type = FeatureFloodCountAux
    variable = halo5
    map_index = 5
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo6]
    type = FeatureFloodCountAux
    variable = halo6
    map_index = 6
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo7]
    type = FeatureFloodCountAux
    variable = halo7
    map_index = 7
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo8]
    type = FeatureFloodCountAux
    variable = halo8
    map_index = 8
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo9]
    type =  FeatureFloodCountAux
    variable = halo9
    map_index = 9
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
  [./halo10]
    type =  FeatureFloodCountAux
    variable = halo10
    map_index = 10
    flood_counter = grain_tracker
    field_display = HALOS
  [../]
[]

[ICs]
  [./bubble_IC]
    variable = bubble
    type = SmoothCircleFromFileIC
    invalue = 1.0
    outvalue = 0.0
    file_name = 'bubble_position_periodic.txt'
    profile = TANH
  [../]
  [./IC_etam0]
    type = FunctionIC
    variable = etam0
    function = sol_func_etam0
  [../]
  [./IC_etam1]
    type = FunctionIC
    variable = etam1
    function = sol_func_etam1
  [../]
  [./IC_etam2]
    type = FunctionIC
    variable = etam2
    function = sol_func_etam2
  [../]
  [./IC_etam3]
    type = FunctionIC
    variable = etam3
    function = sol_func_etam3
  [../]
  [./IC_etam4]
    type = FunctionIC
    variable = etam4
    function = sol_func_etam4
  [../]
  [./IC_etam5]
    type = FunctionIC
    variable = etam5
    function = sol_func_etam5
  [../]
  [./IC_etam6]
    type = FunctionIC
    variable = etam6
    function = sol_func_etam6
  [../]
  [./IC_etam7]
    type = FunctionIC
    variable = etam7
    function = sol_func_etam7
  [../]
  [./IC_etam8]
    type = FunctionIC
    variable = etam8
    function = sol_func_etam8
  [../]
  [./IC_etam9]
    type = FunctionIC
    variable = etam9
    function = sol_func_etam9
  [../]
  [./IC_etam10]
    type = FunctionIC
    variable = etam10
    function = sol_func_etam10
  [../]
[]

[Functions]
  [./sol_func_etam0]
    type = SolutionFunction
    from_variable = etam0
    solution = soln_uo
  [../]
  [./sol_func_etam1]
    type = SolutionFunction
    from_variable = etam1
    solution = soln_uo
  [../]
  [./sol_func_etam2]
    type = SolutionFunction
    from_variable = etam2
    solution = soln_uo
  [../]
  [./sol_func_etam3]
    type = SolutionFunction
    from_variable = etam3
    solution = soln_uo
  [../]
  [./sol_func_etam4]
    type = SolutionFunction
    from_variable = etam4
    solution = soln_uo
  [../]
  [./sol_func_etam5]
    type = SolutionFunction
    from_variable = etam5
    solution = soln_uo
  [../]
  [./sol_func_etam6]
    type = SolutionFunction
    from_variable = etam6
    solution = soln_uo
  [../]
  [./sol_func_etam7]
    type = SolutionFunction
    from_variable = etam7
    solution = soln_uo
  [../]
  [./sol_func_etam8]
    type = SolutionFunction
    from_variable = etam8
    solution = soln_uo
  [../]
  [./sol_func_etam9]
    type = SolutionFunction
    from_variable = etam9
    solution = soln_uo
  [../]
  [./sol_func_etam10]
    type = SolutionFunction
    from_variable = etam10
    solution = soln_uo
  [../]
[]

[BCs]
  [./Periodic]
    [./x_y_direction_periodic]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
    c = bubble
  [../]
[]


[Materials]
  [./Copper]
    type = GBEvolution
    T = 500 # K
    wGB = 480 # nm
    GBmob0 = 2.5e-6 #m^4/(Js) from Schoenfelder 1997
    Q = 0.23 #Migration energy in eV
    GBenergy = 0.708 #GB energy in J/m^2
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./num_DOF]
    type = NumDOFs
  [../]
  [./dt]
    type = TimestepSize
  [../]
  [./elapsed]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
  [../]
  [./num_nonlinear_residuals]
    type = NumNonlinearIterations
  [../]
  [./num_linear_residuals]
    type = NumLinearIterations
  [../]
  [./bubble_fraction_new]
    type = ElementAverageValue
    variable = bubble
    # outputs = csv
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -pc_factor_levels'
  petsc_options_value = 'asm      lu              1             2'
  nl_max_its = 15
  l_max_its = 15
  l_tol = 1.0e-3
  num_steps = 120
  nl_rel_tol = 1.0e-8
  # end_time = 1e8
  nl_abs_tol = 1e-9
  [./TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 5
    growth_factor = 1.2
    cutback_factor = 0.8
    # dt = 0.5
    dt = 1
    # adapt_log = true
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
  [../]
  perf_graph = true
  csv = true
[]
