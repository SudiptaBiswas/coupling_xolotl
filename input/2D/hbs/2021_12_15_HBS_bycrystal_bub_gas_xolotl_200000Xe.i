[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  xmin = 0
  xmax = 250
  ymin = 0
  ymax = 250
  uniform_refine = 2
[]

[GlobalParams]
  op_num = 2
  grain_num = 2
  var_name_base = eta
  bubspac = 1
  numbub = 1
  radius = 25.0
  int_width = 10.0
  contact_angle = 90
[]

[Variables]
  [PolycrystalVariables]
  []
  [w]
  []
  [wg]
  []
  [etab]
  []
[]

[ICs]
  [PolycrystalICs]
    [PolycrystalVoronoiVoidIC]
      invalue = 1.0
      outvalue = 0.0
      polycrystal_ic_uo = voronoi
      rand_seed = 0
    []
  []
  [bubble_IC]
    variable = etab
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 1.0
    outvalue = 0.0
    polycrystal_ic_uo = voronoi
    rand_seed = 0
  []
  # [wIC]
  #   type = BubblesBicrystalIC
  #   feature_type = bubble
  #   variable = w
  #   c_invalue = 3.97
  #   c_outvalue = 2.02
  # []
  # [wgIC]
  #   type = BubblesBicrystalIC
  #   feature_type = bubble
  #   variable = wg
  #   c_invalue = -3.97
  #   c_outvalue = 2.59
  # []
  [bnds]
    type = BndsCalcIC
    variable = bnds
    op_num = 2
  []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
  [./XolotlXeRate]
    order = FIRST
    family = LAGRANGE
  [../]
  [./XolotlXeMono]
    order = FIRST
    family = LAGRANGE
  [../]
  [./XolotlVolumeFraction]
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
[]

[Kernels]
  [ACb_bulk]
    type = ACGrGrMulti
    variable = etab
    v = 'eta0 eta1 '
    gamma_names = 'gmb  gmb '
    mob_name = Lv
  []
  [ACb_sw]
    type = ACSwitching
    variable = etab
    Fj_names = 'omegab  omegam'
    hj_names = 'hb      hm'
    args = 'w wg eta0 eta1 '
    mob_name = Lv
  []
  [ACb_int]
    type = ACInterface
    variable = etab
    kappa_name = kappa
    mob_name = Lv
  []
  [eb_dot]
    type = TimeDerivative
    variable = etab
  []
  # Order parameter eta_m0 for matrix grain 0
  [ACm0_bulk]
    type = ACGrGrMulti
    variable = eta0
    v = 'etab eta1 '
    gamma_names = 'gmb  gmm '
  []
  [ACm0_sw]
    type = ACSwitching
    variable = eta0
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 '
  []
  [ACm0_int]
    type = ACInterface
    variable = eta0
    kappa_name = kappa
  []
  [em0_dot]
    type = TimeDerivative
    variable = eta0
  []
  # Order parameter eta_m1 for matrix grain 1
  [ACm1_bulk]
    type = ACGrGrMulti
    variable = eta1
    v = 'etab eta0 '
    gamma_names = 'gmb  gmm  '
  []
  [ACm1_sw]
    type = ACSwitching
    variable = eta1
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta0 '
  []
  [ACm1_int]
    type = ACInterface
    variable = eta1
    kappa_name = kappa
  []
  [em1_dot]
    type = TimeDerivative
    variable = eta1
  []
  #Chemical potential for vacancies
  [wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
  []
  [Diffusion_wg]
    type = MatDiffusion
    variable = wg
    diffusivity = Dgchi
    args = 'etab eta0 eta1 '
  []
  [source_wg]
    type = MaskedBodyForce
    variable = wg
    value = 1.0 #2.35e-9
    mask = XeRate
    args = 'etab eta0 eta1 '
  []
  [coupled_wg_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  []
  [coupled_wg_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  []
  [coupled_wg_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  []

  [wv_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
  []
  [Diffusion_wv]
    type = MatDiffusion
    variable = w
    diffusivity = Dvchi
    args = 'etab eta0 eta1 '
  []
  [source_wv]
    type = MaskedBodyForce
    variable = w
    value = 1.0 #4.7e-8
    mask = VacRate
    args = 'etab eta0 eta1 '
  []
  # [sink_wv]
  #   type = GrandPotentialSink
  #   variable = w
  #   value = 1.0
  #   sink_strength = 1.92e-7 # sv*Va/cv0/Dv, obtained equating the residuals for MaskedBodyForce for w and GrandPotentialSink kernels
  #   rho = rho
  #   rho_s = 1
  #   D = 1
  #   mask = hm
  #   args = 'etab eta0 eta1 '
  # []

  [coupled_w_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  []
  [coupled_w_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  []
  [coupled_w_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  []
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    op_num = 2
    # v = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 etab'
    execute_on = 'timestep_end'
  []
  [./cg]
    type = MaterialRealAux
    variable = cg
    property = cg_mat
  [../]
  [./cv]
    type = MaterialRealAux
    variable = cv
    property = cv_mat
  [../]
[]

[Materials]
  [hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1  etab'
    phase_etas = 'eta0 eta1 '
    outputs = exodus
    output_properties = 'hm'
  []
  [hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'eta0 eta1  etab'
    phase_etas = 'etab'
    outputs = exodus
    output_properties = 'hb'
  []

  [omegab]
    type = DerivativeParsedMaterial
    f_name = omegab
    args = 'w wg'
    material_property_names = 'Va kb cb_eq cgb_eq f0'
    function = '-0.5*w^2/Va^2/kb - w/Va*cb_eq - 0.5*wg^2/Va^2/kb - wg/Va*cgb_eq + f0'
    derivative_order = 2
    outputs = exodus
  []
  [omegam]
    type = DerivativeParsedMaterial
    f_name = omegam
    args = 'w wg'
    material_property_names = 'Va km kgm cm_eq'
    function = '-0.5*w^2/Va^2/km - w/Va*cm_eq -0.5*wg^2/Va^2/kgm - wg/Va*cm_eq'
    derivative_order = 2
    outputs = exodus
  []

  [chi]
    type = DerivativeParsedMaterial
    f_name = chi
    args = 'w'
    material_property_names = 'Va hb hm kb km'
    function = '(hm/km + hb/kb)/Va^2'
    derivative_order = 2
    outputs = exodus
  []
  [chig]
    type = DerivativeParsedMaterial
    f_name = chig
    args = 'w'
    material_property_names = 'Va hb hm kb kgm'
    function = '(hm/kgm + hb/kb)/Va^2'
    derivative_order = 2
    outputs = exodus
  []
  [rhob]
    type = DerivativeParsedMaterial
    f_name = rhob
    args = 'w'
    material_property_names = 'Va kb cb_eq'
    function = 'w/Va^2/kb + cb_eq/Va'
    derivative_order = 1
    outputs = exodus
    output_properties = 'rhob'
  []
  [rhom]
    type = DerivativeParsedMaterial
    f_name = rhom
    args = 'w'
    material_property_names = 'Va km cm_eq'
    function = 'w/Va^2/km + cm_eq/Va'
    derivative_order = 1
    output_properties = 'rhom'
    outputs = exodus
  []
  [rhogb]
    type = DerivativeParsedMaterial
    f_name = rhogb
    args = 'wg'
    material_property_names = 'Va kb cgb_eq'
    function = 'wg/Va^2/kb + cgb_eq/Va'
    derivative_order = 1
    outputs = exodus
    output_properties = 'rhogb'
  []
  [rhogm]
    type = DerivativeParsedMaterial
    f_name = rhogm
    args = 'wg'
    material_property_names = 'Va kgm cm_eq'
    function = 'wg/Va^2/kgm + cm_eq/Va'
    derivative_order = 1
    output_properties = 'rhogm'
    outputs = exodus
  []
  [rhov]
    type = ParsedMaterial
    f_name = rho
    material_property_names = 'rhom hm rhob hb'
    function = '(hm*rhom + hb*rhob)'
    outputs = exodus
  []
  [rhog]
    type = ParsedMaterial
    f_name = rhog
    material_property_names = 'rhogm hm rhogb hb'
    function = '(hm*rhogm + hb*rhogb)'
    outputs = exodus
  []
  [cv_mat]
    type = ParsedMaterial
    f_name = cv_mat
    material_property_names = 'rhom hm rhob hb Va'
    function = 'Va*(hm*rhom + hb*rhob)'
    outputs = exodus
  []
  [cg_mat]
    type = ParsedMaterial
    f_name = cg_mat
    material_property_names = 'rhogm hm rhogb hb Va'
    function = 'Va*(hm*rhogm + hb*rhogb)'
    outputs = exodus
  []
  [Diff_v]
    type = PolycrystalDiffusivity
    c = etab
    v = 'eta0 eta1 '
    diffusivity = Dv
    Dbulk = 16.65271
    Dsurf = 16.65271
    Dvoid = 16.65271
    surf_weight = 10.0
    gb_weight = 10.0
    bulk_weight = 1.0
    void_weight = 10.0
    Dgb = 16.65271
    outputs = exodus
    output_properties = 'Dv'
  []
  [Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dvchi
    material_property_names = 'Dv chi'
    function = 'Dv*chi'
    args = 'etab eta0 eta1 '
    derivative_order = 2
    outputs = exodus
    output_properties = 'Dvchi'
  []
  [Diff_g]
    type = PolycrystalDiffusivity
    c = etab
    v = 'eta0 eta1 '
    diffusivity = Dg
    Dbulk = 0.0175
    Dsurf = 0.0175
    Dvoid = 0.0175
    surf_weight = 10.0
    gb_weight = 10.0
    bulk_weight = 1.0
    void_weight = 10.0
    Dgb = 0.0175
    outputs = exodus
    output_properties = 'Dg'
  []

  [Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dgchi
    material_property_names = 'Dg chig'
    function = 'Dg*chig'
    args = 'etab eta0 eta1 '
    derivative_order = 2
    outputs = exodus
    output_properties = 'Dgchi'
  []
  [gb_loc]
    type = ParsedMaterial
    f_name = gb
    function = '9*eta0*eta1*eta0*eta1'
    args = 'eta0 eta1 '
    outputs = exodus
    output_properties = 'gb'
  []
  [surf_loc]
    type = ParsedMaterial
    f_name = surf
    function = '30*etab*etab*(1-etab)*(1-etab)'
    args = 'etab'
    outputs = exodus
    output_properties = 'surf'
  []
  [constants]
    type = GenericConstantMaterial
    prop_names = 'kappa   mu       L   Lv      Va       cb_eq  cgb_eq    kb        gmb    gmm    T    f0        '
                 '  kB      burg_vec  G_mod YXe'
    prop_values = '70.2   5.62    4.58e-5 4.58e-4 0.04092   0.562  0.438    321.15     1.5	  1.5  1200  5.316 '
                  '8.6173324e-5   0.5      400.0 0.25'
  []

  [cm_eq] #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
    type = ParsedMaterial
    f_name = cm_eq
    material_property_names = 'T'
    constant_names = 'kB           Efv'
    constant_expressions = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
    outputs = exodus
  []

  [kvmatrix_parabola]
    type = ParsedMaterial
    f_name = km
    material_property_names = 'T  cm_eq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.008 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cm_eq)'
    outputs = exodus
  []

  [kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgm
    material_property_names = 'T  cm_eq kB Va'
    constant_names = 'c0g  Efg     al'
    constant_expressions = '0.02 3.0 log(c0g)-log(1-c0g)'
    function = '(kB*T/Va*al+Efg/Va)/(c0g-cm_eq)'
    outputs = exodus
  []


  [pg_vdw]
    type = ParsedMaterial
    f_name = pg_vdw
    args = 'cg'
    material_property_names = 'T Va'
    constant_names = 'kb b'
    constant_expressions = '8.6173324e-5 0.085'
    function = 'cg*kb*T/(Va-cg*b)'
    outputs = exodus
  []

  [./XeRate]
    type = ParsedMaterial
    f_name = XeRate
    material_property_names = 'hm'
    args = 'XolotlXeRate'  # XolotlXeRate is in Xe/(nm^3 * s) & Va is in Xe/nm^3
    # function = 'if(time < 0, 0, XolotlXeRate * hm)'
    function = 'XolotlXeRate'
    outputs = exodus
  [../]

  [./VacRate]
    type = ParsedMaterial
    f_name = VacRate
    material_property_names = 'XeRate YXe'
    function = 'XeRate / YXe'
    outputs = exodus
  [../]

  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hm'
    constant_names = 's0'
    constant_expressions = '2.35e-9'  # in atoms/(nm^3 * s)
    function = ' s0 * hm'
    outputs = exodus
  [../]
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate0'
    function = 'XeRate0 / YXe'
    outputs = exodus
  [../]
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'xolotl_subapp_200000Xe_small.i'
    app_type = coupling_xolotlApp
    execute_on = TIMESTEP_END
    library_path = 'lib'
  []
[]

[Transfers]
  [fromsubrate]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = sub_app
    source_variable = Auxv
    variable = XolotlXeRate
  []
  [fromsubmono]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = sub_app
    source_variable = AuxMono
    variable = XolotlXeMono
  []
  [fromsubfrac]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = sub_app
    source_variable = AuxFrac
    variable = XolotlVolumeFraction
  []
  [tosub]
    type = MultiAppInterpolationTransfer
    direction = to_multiapp
    multi_app = sub_app
    source_variable = bnds
    variable = AuxGB
  []
[]


[Postprocessors]
  [DOFs]
    type = NumDOFs
    execute_on = 'initial timestep_end'
    system = NL
  []
  [dt]
    type = TimestepSize
  []
  [Volume]
    type = VolumePostprocessor
    execute_on = 'initial'
  []
  [etab_total]
    type = ElementIntegralVariablePostprocessor
    variable = etab
  []
  [cg_total]
    type = ElementIntegralVariablePostprocessor
    variable = cg
  []
  [cv_total]
    type = ElementIntegralVariablePostprocessor
    variable = cv
  []
  [cv_mat_total]
    type = ElementIntegralMaterialProperty
    mat_prop = cv_mat
  []
  [cg_mat_total]
    type = ElementIntegralMaterialProperty
    mat_prop = cg_mat
  []
  [etab_avg]
    type = ElementAverageValue
    variable = etab
  []
  [bnds_avg]
    type = ElementAverageValue
    variable = bnds
  []
  [Ds_total]
    type = ElementAverageMaterialProperty
    mat_prop = Dg
  []
  [Dgb_total]
    type = ElementAverageMaterialProperty
    mat_prop = Dv
  []
  [surf_total]
    type = ElementIntegralMaterialProperty
    mat_prop = surf
  []
  [gb_total]
    type = ElementIntegralMaterialProperty
    mat_prop = gb
  []
  # [avg_grain_volumes]
  #   type = AverageGrainVolume
  #   feature_counter = grain_tracker
  #   execute_on = 'timestep_end'
  # []
  [ngrains]
    type = FeatureFloodCount
    variable = bnds
    threshold = 0.7
  []
  # [num_grains]
  #   type = FeatureFloodCount
  #   variable = unique_grains
  # []
  [area]
    type = GrainBoundaryArea
    grains_per_side = 2
  []
  [area_bubble]
    type = GrainBoundaryArea
    grains_per_side = 1
  []
  [nbub]
    type = FeatureFloodCount
    variable = etab
    threshold = 0.5
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_end'
  []
  # [porosity]
  #   type = Porosity
  #   variable = etab
  # []
[]

[UserObjects]
  [voronoi]
    type = FauxPolycrystalVoronoi
    rand_seed = 56
  []
  [grain_tracker]
    type = FauxGrainTracker
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    halo_level = 3
    remap_grains = true
  []
[]

# [BCs]
#   [Periodic]
#     [all]
#       auto_direction = 'x y'
#     []
#   []
# []

# [VectorPostprocessors]
#   [int]
#     type = LineMaterialRealSampler
#     start = '2.0 30.0 0'
#     end = '240.0 30.0 0'
#     sort_by = x
#     property = surf
#   []
#   [gb]
#     type = LineMaterialRealSampler
#     start = '2.0 30.0 0'
#     end = '240.0 30.0 0'
#     sort_by = x
#     property = gb
#   []
# []

[Adaptivity]
  initial_steps = 2
  max_h_level = 2
  marker = err
  # cycles_per_step = 1
  [Markers]
    [err_bnds]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_bnds
    []
    [err_b]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_b
    []
    [err_w]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_w
    []
    [err]
      type = ComboMarker
      markers = 'err_bnds err_b err_w'
    []
  []
  [Indicators]
    [ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
    []
    [ind_b]
      type = GradientJumpIndicator
      variable = etab
    []
    [ind_w]
      type = GradientJumpIndicator
      variable = w
    []
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    # coupled_groups = 'c,w'
  []
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  solve_type = PJFNK
  # line_search = basic
  # petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap '
  # petsc_options_value = 'asm ilu 1'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap  '
                        '-pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'asm         31   preonly   ilu      1  NONZERO 1e-8'
  petsc_options = '-ksp_converged_reason -snes_converged_reason' # -ksp_error_if_not_converged -snes_error_if_not_converged -snes_view'
  automatic_scaling = true
  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 12
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8
  # num_steps = 2

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 10.0 #s
    cutback_factor = 0.85
    growth_factor = 1.2
    optimal_iterations = 6
    iteration_window = 1
  []

  dtmax = 800000 #86400
  end_time = 1e8
  #num_steps = 80
  # end_time = 241920000 #2.4192e8
[]

[Outputs]
  csv = true
  perf_graph = true
  # file_base = 2021_08_17_HBS_bycrystal_bub_gas_sink_test
  #  sync_times = '50000 100000 150000 200000 250000 300000 350000 400000 450000 500000'
  # checkpoint = true

  [console]
    type = Console
    max_rows = 10
    interval = 1
  []
  [exodus]
    type = Exodus
    # interval = 5
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
[]

# [Debug]
# show_var_residual_norms = true
# []
