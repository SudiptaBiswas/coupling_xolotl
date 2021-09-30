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
  op_num = 11
  var_name_base = etam

  # SolutionUserObject parameters
  mesh = step2_exodus.e
  system_variables = 'etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10 bubble'
  timestep = 71
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
  [./IC_bubble]
    type = FunctionIC
    variable = bubble
    function = sol_func_bubble
  [../]
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
  [./sol_func_bubble]
    type = SolutionFunction
    from_variable = bubble
    solution = soln_uo
  [../]
[]

[BCs]
  [./Periodic]
    [./y_direction_periodic]
      auto_direction = 'x y'
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
    mask = XolotlXeRate
  [../]
[]

[Materials]
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
    # material_property_names = 'D_gb D_grain D_bubble g_GB g_grain hb(bubble)'
    # function = '(D_grain*(g_grain - hb - g_GB) + D_gb*g_GB+ D_bubble*hb)'
    # args = bubble
    outputs = exodus
  [../]
  #diffusivity_along_the_bulk_of_fuel_matrix
  [./D_grain]
    type = DerivativeParsedMaterial
    f_name = D_grain
    material_property_names = 'D1 D2 D3'
    function = '(D1+D2+D3)*1e18' #unit conversion from m2/sec to nm2/sec
    derivative_order = 2
    # outputs = exodus
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
    # material_property_names = 'D_gb D_grain D_surf g_GB g_grain g_surf(bubble)'
    # function = '20*(D_grain*(g_grain - g_surf - g_GB) + D_gb*g_GB + D_surf*g_surf)'
    args = bubble
    outputs = exodus
  [../]

  #Order-parameter-mobility,L, reference #20
  [./L]
    type = DerivativeParsedMaterial
    f_name = L
    material_property_names = 'GB_mobility int_width_mat'
    function = '1.33*GB_mobility/int_width_mat'
    derivative_order = 2
    # outputs = exodus
  [../]

  #Grain Boundary Mobility, reference #15,16,17
  [GB_mobility]
    type = DerivativeParsedMaterial
    f_name = GB_mobility
    material_property_names = 'T'
    function = '3.43e10*exp(-34.88e3/T)' #m4/J-s > nm4/ev-s
    derivative_order = 2
    # outputs = exodus
  [../]

  #reference #18
  [./kappa]
    type = DerivativeParsedMaterial
    f_name = kappa
    material_property_names = 'gmm int_width_mat energy_scale'
    function = '0.75*gmm*int_width_mat/energy_scale'
    derivative_order = 2
    # outputs = exodus
  [../]

  #reference #19
  [./mu]
    type = DerivativeParsedMaterial
    f_name = mu
    material_property_names = 'gmm int_width_mat energy_scale'
    function = '(6*gmm)/(int_width_mat*energy_scale)'
    derivative_order = 2
    # outputs = exodus
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
    # outputs = exodus
  [../]

  #Interpolating_function_between_bubble_surface_energy_to_grain_boundary_energy_transition
  [./H_trans]
    type = DerivativeParsedMaterial
    f_name = H_trans
    args = 'bubble'
    # function = '1+1/sinh(-20*bubble-0.881371)'
    function = 'if(bubble < 0.3, 6*(bubble/0.3)^5-15*(bubble/0.3)^4+10*(bubble/0.3)^3,1)'
    derivative_order = 2
    # outputs = exodus
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

  #gas_generation, reference #4, considering fission yield, YXe
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XolotlXeRate'
    function = 'XolotlXeRate / YXe'
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

  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10'    
    phase_etas = 'bubble'
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm    
    all_etas = 'bubble etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10'
    phase_etas = 'etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10'
  [../]
  # Chemical contribution to grand potential of bubble
  [./omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq'
    function = '-0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq'
    derivative_order = 2
    # outputs = exodus
  [../]
  # Chemical contribution to grand potential of matrix
  [./omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegam
    material_property_names = 'Va kvmatrix cvmatrixeq kgmatrix cgmatrixeq'
    function = '-0.5*wv^2/Va^2/kvmatrix-wv/Va*cvmatrixeq-0.5*wg^2/Va^2/kgmatrix-wg/Va*cgmatrixeq'
    derivative_order = 2
    # outputs = exodus
  [../]

  # Densities
  [./rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va kvmatrix cvmatrixeq'
    function = 'wv/Va^2/kvmatrix + cvmatrixeq/Va'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va kgmatrix cgmatrixeq'
    function = 'wg/Va^2/kgmatrix + cgmatrixeq/Va'
    derivative_order = 2
    # outputs = exodus
  [../]
[]

[Postprocessors]
  [./gas_concentration]
    type = ElementIntegralMaterialProperty
    mat_prop = gas_conc
    # outputs = csv
  [../]
  [./gas_total_flux]
    type = SideFluxIntegral
    diffusivity = Dchig
    boundary = left
    variable = wg
    # outputs = csv
  [../]
  [./vacancy_concentration]
    type = ElementIntegralMaterialProperty
    mat_prop = vac_conc
    # outputs = csv
  [../]
  [./bubble_fraction_new]
    type = ElementAverageValue
    variable = bubble
    # outputs = csv
  [../]
  [./num_bubbles]
    type = FeatureFloodCount
    variable = bubble
    threshold = 0.3
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
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = 'bjacobi  gmres     30'  # default is 30, the higher the higher resolution but the slower
  nl_max_its = 15
  l_max_its = 150
  # l_max_its = 15
  l_tol = 1e-05
  nl_rel_tol = 1.0e-8
  end_time = 1e8
  num_steps = 1000
  nl_abs_tol = 1e-10
  [./Adaptivity]
    initial_adaptivity = 1
    max_h_level = 3
    refine_fraction = 0.9
    coarsen_fraction = 0.10
    weight_names = 'bubble etam0 etam1 etam2 etam3 etam4 etam5 etam6 etam7 etam8 etam9 etam10  wv  wg'
    weight_values = '1.0    0.7   0.7   0.7   0.7   0.7   0.7   0.7   0.7   0.7   0.7   0.7   1.0 1.0'
  [../]
  [./TimeStepper]
    type = IterationAdaptiveDT
    linear_iteration_ratio = 100
    optimal_iterations = 6
    # growth_factor = 1.2
    growth_factor = 2
    cutback_factor = 0.5
    dt = 0.5
  #  dt = 1000
    # adapt_log = true
  [../]
[]

[Outputs]
  [./exodus]
    interval = 10
    type = Exodus
  [../]
  perf_graph = true
  csv = true
[]

[MultiApps]
  [./sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'xolotl_2D_noCnoR.i'
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
