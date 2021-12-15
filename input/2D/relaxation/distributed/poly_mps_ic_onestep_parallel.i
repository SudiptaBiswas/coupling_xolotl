[Mesh]
 [gmg]
  type = DistributedRectilinearMeshGenerator
  dim = 2
  nx = 125
  ny = 125
  xmin = 0
  xmax = 20000
  ymin = 0
  ymax = 20000
  partition = square
  []
[]

[GlobalParams]
  op_num = 12
  var_name_base = etam
  int_width = 480
  polycrystal_ic_uo = voronoi
  invalue = 1.0
  outvalue = 0.0
  numbub = 8
  bubspac = 4000
  radius = 400
  profile = TANH
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    rand_seed = 1258
    file_name = grains12.txt #generated using MeshingGennie from Trillinos
  [../]
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
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
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
    [../]
  [../]
  [./c_IC]
    type = PolycrystalVoronoiVoidIC
    variable = bubble
    structure_type = voids
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
    T = 1200 # K
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
  num_steps = 100
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
  [./nemesis]
    type = Nemesis
  [../]
  perf_graph = true
  csv = true
[]
