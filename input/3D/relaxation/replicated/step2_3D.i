[Mesh]
  [gmg]
    type = DistributedRectilinearMeshGenerator
    dim = 3
    nx = 125
    ny = 125
    nz = 125
    xmin = 0
    xmax = 20000
    ymin = 0
    ymax = 20000
    zmin = 0
    zmax = 20000
    partition = square
  []
  parallel_type = distributed
[]

[GlobalParams]
  op_num = 25
  var_name_base = etam
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
  [../]
  [./soln_uo]
    type = SolutionUserObject
    mesh = step1_3D_nemesis.e
    system_variables = 'etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10 etam11 etam12 etam13 etam14 etam15 etam16 etam17 etam18 etam19 etam20 etam21 etam22 etam23 etam24 bubble'
    timestep = 652
    int_width = 480
  [../]
[]

[Problem]
  type = BubbleCreater
  bubble_var = 'etab'
  bnds_var = 'bnds'
  num_bub = 15
  radius_bub = 480
  rand_seed = 11
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
  #For use of GrainTracker
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

  [./halo11]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo12]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo13]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo14]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo15]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo16]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo17]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo18]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo19]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo20]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo21]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo22]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo23]
    order = FIRST
    family = MONOMIAL
  [../]
  [./halo24]
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
  [./halo11]
    type = FeatureFloodCountAux
    variable = halo11
    map_index = 11
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo12]
    type = FeatureFloodCountAux
    variable = halo12
    map_index = 12
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo13]
    type = FeatureFloodCountAux
    variable = halo13
    map_index = 13
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo14]
    type = FeatureFloodCountAux
    variable = halo14
    map_index = 14
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo15]
    type = FeatureFloodCountAux
    variable = halo15
    map_index = 15
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo16]
    type = FeatureFloodCountAux
    variable = halo16
    map_index = 16
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo17]
    type = FeatureFloodCountAux
    variable = halo17
    map_index = 17
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo18]
    type = FeatureFloodCountAux
    variable = halo18
    map_index = 18
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo19]
    type = FeatureFloodCountAux
    variable = halo19
    map_index = 19
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo20]
    type = FeatureFloodCountAux
    variable = halo20
    map_index = 20
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo21]
    type = FeatureFloodCountAux
    variable = halo21
    map_index = 21
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo22]
    type = FeatureFloodCountAux
    variable = halo22
    map_index = 22
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo23]
    type = FeatureFloodCountAux
    variable = halo23
    map_index = 23
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
  [./halo24]
    type = FeatureFloodCountAux
    variable = halo24
    map_index = 24
    field_display = HALOS
    flood_counter = grain_tracker
  [../]
[]

[ICs]
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
  [./IC_etam11]
    type = FunctionIC
    variable = etam11
    function = sol_func_etam11
  [../]
  [./IC_etam12]
    type = FunctionIC
    variable = etam12
    function = sol_func_etam12
  [../]
  [./IC_etam13]
    type = FunctionIC
    variable = etam13
    function = sol_func_etam13
  [../]
  [./IC_etam14]
    type = FunctionIC
    variable = etam14
    function = sol_func_etam14
  [../]
  [./IC_etam15]
    type = FunctionIC
    variable = etam15
    function = sol_func_etam15
  [../]
  [./IC_etam16]
    type = FunctionIC
    variable = etam16
    function = sol_func_etam16
  [../]
  [./IC_etam17]
    type = FunctionIC
    variable = etam17
    function = sol_func_etam17
  [../]
  [./IC_etam18]
    type = FunctionIC
    variable = etam18
    function = sol_func_etam18
  [../]
  [./IC_etam19]
    type = FunctionIC
    variable = etam19
    function = sol_func_etam19
  [../]
  [./IC_etam20]
    type = FunctionIC
    variable = etam20
    function = sol_func_etam20
  [../]
  [./IC_etam21]
    type = FunctionIC
    variable = etam21
    function = sol_func_etam21
  [../]
  [./IC_etam22]
    type = FunctionIC
    variable = etam22
    function = sol_func_etam22
  [../]
  [./IC_etam23]
    type = FunctionIC
    variable = etam23
    function = sol_func_etam23
  [../]
  [./IC_etam24]
    type = FunctionIC
    variable = etam24
    function = sol_func_etam24
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
  [./sol_func_etam11]
    type = SolutionFunction
    from_variable = etam11
    solution = soln_uo
  [../]
  [./sol_func_etam12]
    type = SolutionFunction
    from_variable = etam12
    solution = soln_uo
  [../]
  [./sol_func_etam13]
    type = SolutionFunction
    from_variable = etam13
    solution = soln_uo
  [../]
  [./sol_func_etam14]
    type = SolutionFunction
    from_variable = etam14
    solution = soln_uo
  [../]
  [./sol_func_etam15]
    type = SolutionFunction
    from_variable = etam15
    solution = soln_uo
  [../]
  [./sol_func_etam16]
    type = SolutionFunction
    from_variable = etam16
    solution = soln_uo
  [../]
  [./sol_func_etam17]
    type = SolutionFunction
    from_variable = etam17
    solution = soln_uo
  [../]
  [./sol_func_etam18]
    type = SolutionFunction
    from_variable = etam18
    solution = soln_uo
  [../]
  [./sol_func_etam19]
    type = SolutionFunction
    from_variable = etam19
    solution = soln_uo
  [../]
  [./sol_func_etam20]
    type = SolutionFunction
    from_variable = etam20
    solution = soln_uo
  [../]
  [./sol_func_etam21]
    type = SolutionFunction
    from_variable = etam21
    solution = soln_uo
  [../]
  [./sol_func_etam22]
    type = SolutionFunction
    from_variable = etam22
    solution = soln_uo
  [../]
  [./sol_func_etam23]
    type = SolutionFunction
    from_variable = etam23
    solution = soln_uo
  [../]
  [./sol_func_etam24]
    type = SolutionFunction
    from_variable = etam24
    solution = soln_uo
  [../]
[]

[BCs]
  [./Periodic]
    [./x_y_z_direction_periodic]
      auto_direction = 'x y z'
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
    full = false
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
  [./numgrain]
    type = ElementExtremeValue
    variable = unique_grains
  [../]
  [./bubble_fraction_new]
    type = ElementAverageValue
    variable = bubble
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -pc_factor_levels'
  petsc_options_value = 'asm      ilu              1             0'
#  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -pc_factor_levels'
#  petsc_options_value = 'asm      lu              1             2'
  nl_max_its = 15
  l_max_its = 15
  l_tol = 1.0e-3
  # nl_max_its = 20
  # l_max_its = 40
  # l_tol = 1e-04
  nl_rel_tol = 1.0e-8
  end_time = 1e8
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
  [./nemesis]
    type = Nemesis
  [../]
  perf_graph = true
  csv = true
[]

