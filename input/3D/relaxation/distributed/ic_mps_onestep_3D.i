[Debug]
  show_actions = true
[]

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
[]

[GlobalParams]
  op_num = 25
  var_name_base = etam
  # grain_num = 20
  int_width = 480
  polycrystal_ic_uo = voronoi
  invalue = 1.0
  outvalue = 0.0
  numbub = 20
  bubspac = 4000
  radius = 480
  profile = TANH
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    coloring_algorithm = jp
    output_adjacency_matrix = false
    # coloring_algorithm = bt # We must use bt to force the UserObject to assign one grain to each op
    rand_seed = 5 #4586
    file_name = grains30_3D_seed5.txt #grains17_3D_seed5.txt grains19_3D_seed4586.txt
  []
  [grain_tracker]
    type = GrainTracker
    threshold = 0.2
    connecting_threshold = 0.08
  []
  [term]
    type = Terminator
    expression = 'grain_tracker < 15'
  []
[]

[Variables]
  [PolycrystalVariables]
  []
[]

[AuxVariables]
  [bubble]
    order = FIRST
    family = LAGRANGE
  []
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
  [time]
  []
  #For use of GrainTracker
  [unique_grains]
    order = FIRST
    family = MONOMIAL
  []
  [var_indices]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  []
  [time]
    type = FunctionAux
    variable = time
    function = 't'
  []

  #additional_for_grain_tracker
  [unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
  []
  [var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
  []
[]

[ICs]
  [PolycrystalICs]
    [PolycrystalVoronoiVoidIC]
    []
  []
  [c_IC]
    type = PolycrystalVoronoiVoidIC
    variable = bubble
    structure_type = voids
  []
  [bnds_ic]
    type = BndsCalcIC
    variable = bnds
  []
[]

[BCs]
  [Periodic]
    [x_y_z_direction_periodic]
      auto_direction = 'x y z'
    []
  []
[]

[Kernels]
  [PolycrystalKernel]
    c = bubble
  []
[]

[Materials]
  [Copper]
    type = GBEvolution
    T = 1200 # K
    wGB = 480 # nm
    GBmob0 = 2.5e-6 #m^4/(Js) from Schoenfelder 1997
    Q = 0.23 #Migration energy in eV
    GBenergy = 0.708 #GB energy in J/m^2
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = false
  []
[]

[Postprocessors]
  [num_DOF]
    type = NumDOFs
  []
  [dt]
    type = TimestepSize
  []
  [elapsed]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
  []
  [num_nonlinear_residuals]
    type = NumNonlinearIterations
  []
  [num_linear_residuals]
    type = NumLinearIterations
  []
  [numgrain]
    type = ElementExtremeValue
    variable = unique_grains
  []
  [bubble_fraction_new]
    type = ElementAverageValue
    variable = bubble
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -pc_factor_levels'
  petsc_options_value = 'asm      ilu              1             0'
  petsc_options = '-snes_view'
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
  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 5
    growth_factor = 1.2
    cutback_factor = 0.8
    # dt = 0.5
    dt = 1
    # adapt_log = true
  []
[]

[Outputs]
  [nemesis]
    type = Nemesis
    # interval = 10
  []
  perf_graph = true
  checkpoint = true
  csv = true
[]
