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
  []
[]

[Modules]
  [./PhaseField]
    [./GrandPotential]
      switching_function_names = 'hb hm'
      anisotropic = 'false false'

      chemical_potentials = 'wv wg'
      mobilities = 'Dchiv Dchig'
      susceptibilities = 'chiv chig'
      free_energies_w = 'rhovbub rhovmatrix rhogbub rhogmatrix'

      gamma_gr = gm_final
      mobility_name_gr = L
      kappa_gr = kappa
      free_energies_gr = 'omegab omegam'

      additional_ops = 'bubble'
      gamma_grxop = gm_final
      mobility_name_op = L
      kappa_op = kappa
      free_energies_op = 'omegab omegam'
    [../]
  [../]
[]

[GlobalParams]
  op_num = 10
  var_name_base = etam
  grain_num = 10
  int_width = 480
  polycrystal_ic_uo = voronoi
  invalue = 1.0
  outvalue = 0.0
  numbub = 650
  bubspac = 800
  radius = 400
  profile = TANH
[]

[UserObjects]
  [voronoi]
    type = FauxPolycrystalVoronoi
    coloring_algorithm = jp
    output_adjacency_matrix = false
    # coloring_algorithm = bt # We must use bt to force the UserObject to assign one grain to each op
    rand_seed = 15 #4586
  []
[]

[Variables]
  [./wv]
  [../]
  [./wg]
  [../]
  [./bubble]
  [../]
  [./PolycrystalVariables]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./cg]
    order = FIRST
    family = MONOMIAL
  [../]
  [./cv]
    order = FIRST
    family = MONOMIAL
  [../]
  [./XolotlXeRate]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./bnds_aux]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'initial timestep_end'
  [../]
  [./cg]
    type = MaterialRealAux
    variable = cg
    property = cg_from_rhog
    execute_on = 'initial timestep_end'
  [../]
  [./cv]
    type = MaterialRealAux
    variable = cv
    property = cv_from_rhov
    execute_on = 'initial timestep_end'
  [../]
[]

[ICs]
  [./IC_wg]
    type = ConstantIC
    variable = wg
    value = 0.0
  [../]
  [./IC_wv]
    type = ConstantIC
    variable = wv
    value = 0.0
  [../]
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
  [./Periodic]
    [./x_y_z_direction_periodic]
      auto_direction = 'x y z'
    [../]
  [../]
[]

[Kernels]
  [./Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 1
    mask = VacRate0
  [../]
  [./Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 1
    mask = XeRate
  [../]
[]

[Materials]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9'
    phase_etas = 'bubble'
    #outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9'
    phase_etas = 'etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9'
    #outputs = exodus
  [../]
  #reference #1 Va, #2 cgbubeq, #3 cvbubeq, #4 YXe
  [./const]
    type = GenericConstantMaterial
    prop_names =  ' Va        cgbubeq   cvbubeq   T     YXe     int_width_original  int_width_mat energy_scale'
    prop_values = '0.0409      0.454      0.546  1800  0.2156       0.5                  480         400'
  [../]

  #gas_diffusivity_heterogeneity_throughout_the_domain
  [./Dg_eff]
    type = ParsedMaterial
    f_name = Dg
    material_property_names = 'D_grain'
    function = 'D_grain'
  [../]
  #diffusivity_along_the_bulk_of_fuel_matrix
  [./D_grain]
    type = DerivativeParsedMaterial
    f_name = D_grain
    material_property_names = 'D1 D2 D3'
    function = '(D1+D2+D3)*1e18' #unit conversion from m2/sec to nm2/sec
    derivative_order = 2
  [../]
  [./D1]
    type = DerivativeParsedMaterial
    f_name = D1
    material_property_names = 'T'
    function = '7.6e-10*exp(-35250/T)'
    derivative_order = 2
  [../]
  [./D2]
    type = DerivativeParsedMaterial
    f_name = D2
    material_property_names = 'T F_rate'
    function = '1.41e-25*(F_rate^0.5)*exp(-13800/T)*4.0'
    derivative_order = 2
  [../]
  [./D3]
    type = DerivativeParsedMaterial
    f_name = D3
    material_property_names = 'F_rate'
    function = '2e-40*F_rate'
    derivative_order = 2
  [../]
  [./F_rate]
    type = ParsedMaterial
    f_name = F_rate
    material_property_names = 'YXe'
    function = '2.35e18/YXe' #2.35e-9*1e27 {unit conversion 1/nm3*sec to 1/m3*sec for D2 and D3 calculation in m-units}
  [../]

  #vacancy_diffusivity_heterogeneity_throughout_the_domain
  [./Dv_eff]
    type = ParsedMaterial
    f_name = Dv
    material_property_names = 'Dg'
    function = 'Dg'
    args = bubble
  [../]

  #Order-parameter-mobility,L, reference #20
  [./L]
    type = DerivativeParsedMaterial
    f_name = L
    material_property_names = 'GB_mobility int_width_mat'
    function = '1.33*GB_mobility/int_width_mat'
    derivative_order = 2
  [../]

  #Grain Boundary Mobility, reference #15,16,17
  [GB_mobility]
    type = DerivativeParsedMaterial
    f_name = GB_mobility
    material_property_names = 'T'
    function = '3.43e10*exp(-34.88e3/T)' #m4/J-s > nm4/ev-s
    derivative_order = 2
  [../]

  #reference #18
  [./kappa]
    type = DerivativeParsedMaterial
    f_name = kappa
    material_property_names = 'gmm int_width_mat energy_scale'
    function = '0.75*gmm*int_width_mat/energy_scale'
    derivative_order = 2
  [../]

  #reference #19
  [./mu]
    type = DerivativeParsedMaterial
    f_name = mu
    material_property_names = 'gmm int_width_mat energy_scale'
    function = '(6*gmm)/(int_width_mat*energy_scale)'
    derivative_order = 2
  [../]

  #GB_energy, reference #6
  [./gmm]
    type = DerivativeParsedMaterial
    f_name = gmm
    material_property_names = 'T'
    function = '(1.56-(5.87e-4*T))*6.242' #J_m2 > ev_nm2
    derivative_order = 2
  [../]

  #surface_energy, reference #7
  [./gmb]
    type = DerivativeParsedMaterial
    f_name = gmb
    material_property_names = 'gmm'
    function = '2*gmm'
    derivative_order = 2
  [../]

  #smooth transition of grain boundary energy and surface energy along interface
  [./gm_final]
    type = DerivativeParsedMaterial
    f_name = gm_final
    material_property_names = 'gmb gmm H_trans'
    function = 'gmm*(1-H_trans)+gmb*H_trans'
    derivative_order = 2
  [../]

  #Interpolating_function_between_bubble_surface_energy_to_grain_boundary_energy_transition
  [./H_trans]
    type = DerivativeParsedMaterial
    f_name = H_trans
    args = 'bubble'
    # function = '1+1/sinh(-20*bubble-0.881371)'
    function = 'if(bubble < 0.3, 6*(bubble/0.3)^5-15*(bubble/0.3)^4+10*(bubble/0.3)^3,1)'
    derivative_order = 2
  [../]

  #vacancy_formation_energy, reference #10
  [./cvmatrixeq]
    type = ParsedMaterial
    f_name = cvmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efv'  # in eV/atom
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
  [../]

  #gas_formation_energy, reference #11
  [./cgmatrixeq]
    type = ParsedMaterial
    f_name = cgmatrixeq
    material_property_names = 'T'
    constant_names        = 'kB           Efg'  # in eV/atom
    constant_expressions  = '8.6173324e-5 3.0'
    function = 'exp(-Efg/(kB*T))'
  [../]

  #curvature_of_parabola, reference #13
  [./kvmatrix_parabola]
    type = ParsedMaterial
    f_name = kvmatrix
    function = '0.11'
  [../]
  [./kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgmatrix
    material_property_names = 'kvmatrix'
    function = 'kvmatrix'
  [../]

  #curvature_of_parabola, reference #14
  [./kgbub_parabola]
    type = ParsedMaterial
    f_name = kgbub
    function = '1.4' #'0.5625e3/625' # in eV/nm^3 [30um*30um/1.2um*1.2um = 625]
  [../]
  [./kvbub_parabola]
    type = ParsedMaterial
    f_name = kvbub
    material_property_names = 'kgbub'
    function = 'kgbub'
  [../]

  #gas_generation, reference #5
  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hm'
    constant_names = 's0'
    constant_expressions = '2.35e-9'  # in atoms/(nm^3 * s)
    function = 's0 * hm'
  [../]
  [./XeRate]
    type = ParsedMaterial
    f_name = XeRate
    material_property_names = 'hm'
    args = 'XolotlXeRate'  # XolotlXeRate is in Xe/(nm^3 * s) & Va is in Xe/nm^3
    function = 'XolotlXeRate'
  [../]

  #gas_generation, reference #4, considering fission yield, YXe
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate'
    function = 'XeRate / YXe'
  [../]

  #vacancy mobility
  [./Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchiv
    material_property_names = 'Dv chiv'
    function = 'Dv*chiv'
    derivative_order = 2
  [../]

  #gas_mobility
  [./Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'Dg chig'
    function = 'Dg*chig'
    derivative_order = 2
  [../]

  #susceptibilities
  [./chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    material_property_names = 'Va hb kvbub hm kvmatrix '
    function = '(hm/kvmatrix + hb/kvbub) / Va^2'
    derivative_order = 2
  [../]
  [./chig]
    type = DerivativeParsedMaterial
    f_name = chig
    material_property_names = 'Va hb kgbub hm kgmatrix '
    function = '(hm/kgmatrix + hb/kgbub) / Va^2'
    derivative_order = 2
  [../]

  #gas_concentration
  [./cg]
    type = ParsedMaterial
    f_name = cg_from_rhog
    material_property_names = 'Va rhogbub rhogmatrix hm hb'
    function = 'hb*Va*rhogbub + hm*Va*rhogmatrix'
  [../]
  [./gas_conc]
    type = ParsedMaterial
    f_name = gas_conc
    args = 'cg'
    function = 'cg'
  [../]

  #vacancy_concentration
  [./cv]
    type = ParsedMaterial
    f_name = cv_from_rhov
    material_property_names = 'Va rhovbub rhovmatrix hm hb'
    function = 'hb*Va*rhovbub + hm*Va*rhovmatrix'
  [../]
  [./vac_conc]
    type = ParsedMaterial
    f_name = vac_conc
    args = 'cv'
    function = 'cv'
  [../]
  # Chemical contribution to grand potential of bubble
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq'
    function = '-0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq'
    derivative_order = 2
  [../]
  # Chemical contribution to grand potential of matrix
  [./omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegam
    material_property_names = 'Va kvmatrix cvmatrixeq kgmatrix cgmatrixeq'
    function = '-0.5*wv^2/Va^2/kvmatrix-wv/Va*cvmatrixeq-0.5*wg^2/Va^2/kgmatrix-wg/Va*cgmatrixeq'
    derivative_order = 2
  [../]

  # Densities
  [./rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
  [../]
  [./rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va kvmatrix cvmatrixeq'
    function = 'wv/Va^2/kvmatrix + cvmatrixeq/Va'
    derivative_order = 2
  [../]
  [./rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
  [../]
  [./rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va kgmatrix cgmatrixeq'
    function = 'wg/Va^2/kgmatrix + cgmatrixeq/Va'
    derivative_order = 2
  [../]
[]

[Postprocessors]
  [./num_DOF]
    type = NumDOFs
    system = NL
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
  [../]  
  [./gas_concentration]
    type = ElementIntegralMaterialProperty
    mat_prop = gas_conc
  [../]
  [./gas_total_flux]
    type = SideFluxIntegral
    diffusivity = Dchig
    boundary = left
    variable = wg
  [../]
  [./vacancy_concentration]
    type = ElementIntegralMaterialProperty
    mat_prop = vac_conc
  [../]
  [./num_bubbles]
    type = FeatureFloodCount
    variable = bubble
    threshold = 0.3
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
  l_max_its = 150
  l_tol = 1.0e-5
  # nl_max_its = 20
  # l_max_its = 40
  # l_tol = 1e-04
  nl_rel_tol = 1.0e-8
  end_time = 1e8
  num_steps = 50
  nl_abs_tol = 1e-9
  [./TimeStepper]
#    type = IterationAdaptiveDT
#    optimal_iterations = 5
#    growth_factor = 1.2
#    cutback_factor = 0.8
#    dt = 1
    type = ConstantDT
    dt = 5.0
  [../]
[]

[MultiApps]
  [./sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'xolotl_3D_CR.i'
    app_type = coupling_xolotlApp
    execute_on = TIMESTEP_END
    library_path = 'lib'
  [../]
[]

[Transfers]
  [./fromsubrate]
    type = MultiAppMeshFunctionTransfer
    direction = from_multiapp
    multi_app = sub_app
    source_variable = Auxv
    variable = XolotlXeRate
    execute_on = SAME_AS_MULTIAPP
  [../]
  [./tosub]
    type = MultiAppMeshFunctionTransfer
    direction = to_multiapp
    multi_app = sub_app
    source_variable = bnds
    variable = AuxGB
    execute_on = SAME_AS_MULTIAPP
  [../]
[]

[Outputs]
  [./nemesis]
    type = Nemesis
#    interval = 10
  [../]
  perf_graph = true
  csv = true
[]

