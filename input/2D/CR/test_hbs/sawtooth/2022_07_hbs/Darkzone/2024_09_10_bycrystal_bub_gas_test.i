# This is an input file for the HBS with explicit nucleation and dislocation energy only.

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  xmin = 0
  xmax = 1250 #25000 #50000
  ymin = 0
  ymax = 1250 #25000 #50000

 uniform_refine = 2
[]

[GlobalParams]
  op_num = 2
  # grain_num = 250
  var_name_base = eta
  # numbub = 2
  nbub = 1
  # bubspac = 600
  radius = 100.0
  int_width = 20.0
  contact_angle = 90
  # polycrystal_ic_uo = voronoi
[]

[Variables]
  [./PolycrystalVariables]
  [../]
  [./w]
  [../]
  [./wg]
  [../]
  [./etab]
  [../]
[]

[ICs]
  [./gr0IC]
    type = BubblesBicrystalIC
    feature_type = left_grain
    variable = eta0
  [../]
  [./gr1IC]
    type = BubblesBicrystalIC
    feature_type = right_grain
    variable = eta1
  [../]
  [./bubblesIC]
    type = BubblesBicrystalIC
    feature_type = bubble
    variable = etab
  [../]
  # [./wIC]
  #   type = BubblesBicrystalIC
  #   feature_type = bubble
  #   variable = w
  #   c_outvalue = 2.92
  #   c_invalue = 0
  # [../]
  # [./wgIC]
  #   type = BubblesBicrystalIC
  #   feature_type = bubble
  #   variable = wg
  #   c_outvalue = 2.92
  #   c_invalue = 0
  # [../]
  [IC_wv]
    type = ConstantIC
    variable = w
    value = 6.995147964479171e-05
  []
  [IC_wg]
    type = ConstantIC
    variable = wg
    value = -0.0038098539401999997
  []
  # [./PolycrystalICs]
  #   [./PolycrystalVoronoiVoidIC]
  #     invalue = 1.0
  #     outvalue = 0.0
  #     op_num = 15
  #   [../]
  # [../]
  # [./bubble_IC]
  #   variable = etab
  #   type = PolycrystalVoronoiVoidIC
  #   structure_type = voids
  #   invalue = 1.0
  #   outvalue = 0.0
  # [../]
  # [./IC_w]
  #   variable = w
  #   type = PolycrystalVoronoiVoidIC
  #   structure_type = voids
  #   invalue = 0.0
  #   outvalue = 0.0
  # [../]
  [./bnds]
    type = BndsCalcIC
    variable = bnds
    op_num = 2
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  # [./unique_grains]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./var_indices]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
  # [./halos]
  #   order = CONSTANT
  #   family = MONOMIAL
  # [../]
[]

[Kernels]
  [./ACb_bulk]
    type = ACGrGrMulti
    variable = etab
    v =           'eta0 eta1'
    gamma_names = 'gmb  gmb'
  [../]
  [./ACb_sw]
    type = ACSwitching
    variable = etab
    Fj_names  = 'omegab  omegam'
    hj_names  = 'hb      hm'
    args = 'w wg eta0 eta1 '
  [../]
  [./ACb_int]
    type = ACInterface
    variable = etab
    kappa_name = kappa
  [../]
  [./eb_dot]
    type = TimeDerivative
    variable = etab
  [../]
  # Order parameter eta_m0 for matrix grain 0
  [./ACm0_bulk]
    type = ACGrGrMulti
    variable = eta0
    v =           'etab eta1 '
    gamma_names = 'gmb  gmm '
  [../]
  [./ACm0_sw]
    type = ACSwitching
    variable = eta0
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'w wg etab eta1 '
  [../]
  [./ACm0_int]
    type = ACInterface
    variable = eta0
    kappa_name = kappa
  [../]
  [./em0_dot]
    type = TimeDerivative
    variable = eta0
  [../]
  # [./em0_dd]
  #   type = ACPolycrystalDislocationEnergy
  #   variable = eta0
  #   grain_tracker = grain_tracker
  #   op_index = 0
  #   v =  'etab eta1 '
  # [../]
  # Order parameter eta_m1 for matrix grain 1
  [./ACm1_bulk]
    type = ACGrGrMulti
    variable = eta1
    v =           'etab eta0 '
    gamma_names = 'gmb  gmm  '
  [../]
  [./ACm1_sw]
    type = ACSwitching
    variable = eta1
    Fj_names  = 'omegab   omegam'
    hj_names  = 'hb       hm'
    args = 'w wg etab eta0 '
  [../]
  [./ACm1_int]
    type = ACInterface
    variable = eta1
    kappa_name = kappa
  [../]
  [./em1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  # [./em1_dd]
  #   type = ACPolycrystalDislocationEnergy
  #   variable = eta1
  #   grain_tracker = grain_tracker
  #   op_index = 1
  #   v =  'etab eta0 '
  # [../]

  #Chemical potential for vacancies
  [./wv_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_wv]
    type = MatDiffusion
    variable = w
    D_name = Dchi
    args = 'etab eta0 eta1 '
  [../]
  [./source_wv]
    type = MaskedBodyForce
    variable = w
    value = 4.46e-6
    mask = hm
    args = 'etab eta0 eta1 '
  [../]
  # [./sink]
  #   type = GrandPotentialSink
  #   variable = w
  #   D = 0.246
  #   rho = rho   # In the Grand Potential Model, rho is the number density.
  #   mask = 1.0
  #   sink_strength = 5.58e-4
  # [../]
  [./coupled_w_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  [../]
  [./coupled_w_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  [../]
  [./coupled_w_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 '
  [../]

  [./wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chi
    args = '' # in this case chi (the susceptibility) is simply a constant
  [../]
  [./Diffusion_wg]
    type = MatDiffusion
    variable = wg
    D_name = Dchi
    args = 'etab eta0 eta1 '
  [../]
  [./source_wg]
    type = MaskedBodyForce
    variable = wg
    value = 9.62e-11
    mask = hm
    args = 'etab eta0 eta1 '
  [../]
  [./coupled_wg_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  [../]
  [./coupled_wg_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  [../]
  [./coupled_wg_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 '
  [../]

  # [./nucleation]
  #   type = DiscreteNucleationForce
  #   variable = eta15
  #   map = map
  #   nucleus_value = 1
  # [../]
  # [./reaction]
  #   type = Reaction
  #   variable = eta15
  # [../]
[]


[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    op_num = 2
    # v = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 etab'
    execute_on = 'timestep_end'
  [../]
  # [./unique_grains_calc]
  #   type = FeatureFloodCountAux
  #   variable = unique_grains
  #   flood_counter = grain_tracker
  #   field_display = UNIQUE_REGION
  #   execute_on = 'initial timestep_end'
  # [../]
  # [./var_indices_calc]
  #   type = FeatureFloodCountAux
  #   variable = var_indices
  #   flood_counter = grain_tracker
  #   field_display = VARIABLE_COLORING
  #   execute_on = 'initial timestep_end'
  # [../]
  # [./halos]
  #   type = FeatureFloodCountAux
  #   variable = halos
  #   flood_counter = grain_tracker
  #   field_display = HALOS
  #   execute_on = 'initial timestep_end'
  # [../]
[]

[Materials]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1 etab'
    phase_etas = 'eta0 eta1 '
    outputs = exodus
    output_properties = 'hm'
  [../]
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'eta0 eta1 etab'
    phase_etas = 'etab'
    outputs = exodus
    output_properties = 'hb'
  [../]
  [./omegab]
    type = DerivativeParsedMaterial
    f_name = omegab
    args = 'w wg'
    material_property_names = 'Va kb cb_eq cgb_eq f0'
    function = '-0.5*w^2/Va^2/kb - w/Va*cb_eq - 0.5*wg^2/Va^2/kb - wg/Va*cgb_eq + f0'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./omegam]
    type = DerivativeParsedMaterial
    f_name = omegam
    args = 'w wg'
    material_property_names = 'Va km cm_eq'
    function = '-0.5*w^2/Va^2/km - w/Va*cm_eq -0.5*wg^2/Va^2/km - wg/Va*cm_eq'
    derivative_order = 2
    # outputs = exodus
  [../]
  [./chi]
    type = DerivativeParsedMaterial
    f_name = chi
    args = 'w'
    material_property_names = 'Va hb hm kb km'
    function = '(hm/km + hb/kb)/Va^2'
    derivative_order = 2
    outputs = exodus
  [../]

  [./rhob]
    type = DerivativeParsedMaterial
    f_name = rhob
    args = 'w'
    material_property_names = 'Va kb cb_eq'
    function = 'w/Va^2/kb + cb_eq/Va'
    derivative_order = 1
    outputs = exodus
    output_properties = 'rhob'
  [../]
  [./rhom]
    type = DerivativeParsedMaterial
    f_name = rhom
    args = 'w'
    material_property_names = 'Va km cm_eq'
    function = 'w/Va^2/km + cm_eq/Va'
    derivative_order = 1
    output_properties = 'rhom'
    outputs = exodus
  [../]
  [./rhogb]
    type = DerivativeParsedMaterial
    f_name = rhogb
    args = 'wg'
    material_property_names = 'Va kb cgb_eq'
    function = 'wg/Va^2/kb + cgb_eq/Va'
    derivative_order = 1
    outputs = exodus
    output_properties = 'rhogb'
  [../]
  [./rhogm]
    type = DerivativeParsedMaterial
    f_name = rhogm
    args = 'wg'
    material_property_names = 'Va km cm_eq'
    function = 'wg/Va^2/km + cm_eq/Va'
    derivative_order = 1
    output_properties = 'rhogm'
    outputs = exodus
  [../]
  [./rhov]
    type = ParsedMaterial
    f_name = rho
    material_property_names = 'rhom hm rhob hb'
    function = '(hm*rhom + hb*rhob)'
    outputs = exodus
  [../]
  [./rhog]
    type = ParsedMaterial
    f_name = rhog
    material_property_names = 'rhogm hm rhogb hb'
    function = '(hm*rhogm + hb*rhogb)'
    outputs = exodus
  [../]
  [./cv]
    type = ParsedMaterial
    f_name = cv
    material_property_names = 'rhom hm rhob hb Va'
    function = 'Va*(hm*rhom + hb*rhob)'
    outputs = exodus
  [../]
  [./cg]
    type = ParsedMaterial
    f_name = cg
    material_property_names = 'rhogm hm rhogb hb Va'
    function = 'Va*(hm*rhogm + hb*rhogb)'
    outputs = exodus
  [../]
  # [./Diff_v]
  #   type = GrandPotentialDiffusionMaterial
  #   c = etab
  #   v = 'eta0 eta1'
  #   # Dbulk = 5.86e-1
  #   Dbulk = 0.246
  #   Dsurf = 2.46e2
  #   surfindex = 1.0
  #   gbindex = 100.0
  #   bulkindex = 10.0
  #   Dgb = 2.46
  #   outputs = exodus
  # [../]
  [./Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    args = 'etab eta0 eta1 '
    derivative_order = 2
    outputs = exodus
  [../]
   [./constants]
     type = GenericConstantMaterial
     # prop_names =  'Va      cb_eq cm_eq kb   km   mu   gmm  gmb  L     D    kappa  kB            burgers_vector shear_modulus'
     # prop_values = '0.04092 1.0   1e-5  1.41 1.41 0.59 1.5  1.5  4e-6 0.01  740    8.6173324e-5  0.5            456'
     prop_names =  'kappa   mu       L      Va     D  cb_eq  cgb_eq  kb       gmb   gmm  T     f0          kB      burgers_vector shear_modulus'
     prop_values = '70.2   5.62    4.01e-5 0.04092 0.01   1.0   1.0037  39.51   1.5	  1.5 1000  -19.36 8.6173324e-5   0.5            400.0'
   [../]


   [./cm_eq]    #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
     type = ParsedMaterial
     f_name = cm_eq
     material_property_names = 'T'
     constant_names        = 'kB           Efv'
     constant_expressions  = '8.6173324e-5 3.0'
     function = 'exp(-Efv/(kB*T))'
     outputs = exodus
   [../]

   # [./kvmatrix_parabola]
   #   type = ParsedMaterial
   #   f_name = km
   #   material_property_names = 'T  cm_eq'
   #   constant_names        = 'c0v  c0g  a1                                               a2'
   #   constant_expressions  = '0.01 0.01 0.178605-0.0030782*log(1-c0v)+0.0030782*log(c0v) 0.178605-0.00923461*log(1-c0v)+0.00923461*log(c0v)'
   #   function = '((-a2+3*a1)/(4*(c0v-cm_eq))+(a2-a1)/(2400*(c0v-cm_eq))*T)'
   #   outputs = exodus
   # [../]

   [./kvmatrix_parabola]
     type = ParsedMaterial
     f_name = km
     material_property_names = 'T  cm_eq kB Va'
     constant_names        = 'c0v  Efv     al'
     constant_expressions  = '0.01 3.0 log(c0v)-log(1-c0v)'
     function = '(kB*T/Va*al+Efv/Va)/(c0v-cm_eq)'
     outputs = exodus
   [../]

   # [./dislocation_density]
   #   type = PolycrystalDislocationDensity
   #   grain_tracker = grain_tracker
   #   burnup_constant = 4.2654e-5
   #   outputs = exodus
   #   burgers_vector = 0.5 #maybe it's a little smaller per Nogita and Une...
   #   shear_modulus = 400 # eV/nm^3 =  64.1 GPa
   #   op_num = 15
   #   time_scale = 1 #s
   #   length_scale = 1e-9 #nm
   # [../]
   # [./nucleation_rate]
   #   type = GrGrDislocNucRate
   #   k0 = 1e-3
   #   bounds = bnds
   #   outputs = exodus
   #   critical_density = 0.000586138 # dislocation density at 44 GWd/t, nm/nm^3
   # [../]
[]

[Postprocessors]
  [./DOFs]
    type = NumDOFs
    execute_on = 'initial timestep_end'
    system = NL
  [../]
  [./dt]
    type = TimestepSize
  [../]
  # [./nnuc]
  #   type = DiscreteNucleationData
  #   inserter = inserter
  # [../]
  [./etab]
    type = ElementIntegralVariablePostprocessor
    variable = etab
  [../]
  [./cv]
    type = ElementIntegralMaterialProperty
    mat_prop = cv
  [../]
  [./cg]
    type = ElementIntegralMaterialProperty
    mat_prop = cg
  [../]
  [./etab_avg]
    type = ElementAverageValue
    variable = etab
  [../]
[]

[UserObjects]
  # [./voronoi]
  #   type = PolycrystalVoronoi
  #   rand_seed = 123
  #   # rand_seed = 1
  #   grain_num = 2
  #   # op_num = 6
  # [../]
  # [./inserter]
  #   # The inserter runs at the end of each time step to add nucleation events
  #   # that happend during the timestep (if it converged) to the list of nuclei
  #   type = DiscreteNucleationInserterDislocations
  #   hold_time = 0
  #   probability = nucleation_rate
  # [../]
  # [./map]
  #   # The map UO runs at the beginning of a timestep and generates a per-element/qp
  #   # map of nucleus locations. The map is only regenerated if the mesh changed or
  #   # the list of nuclei was modified.
  #   # The map converts the nucleation points into finite area objects with a given radius.
  #   type = DiscreteNucleationMap
  #   radius = 20
  #   int_width = 20
  #   periodic = eta0
  #   inserter = inserter
  # [../]
  # [./dislocation_density_file]
  #   type = DislocationDensityFileReader
  #   # file_name = dislocNuc.txt
  # [../]
  # [./grain_tracker]
  #   type = GrainTrackerDislocations
  #   compute_var_to_feature_map = true
  #   execute_on = 'initial timestep_begin'
  #   # dislocation_density_reader = dislocation_density_file
  #   prefactor = 1e-2
  #   deformed_grain_num = 3
  #   #compute_halo_maps = true # Only necessary for displaying HALOS
  #   halo_level = 3
  #   rand_seed = 198756
  #   #threshold = 0.2
  #   #connecting_threshold = 0.15
  #   reserve_op = 1
  #   reserve_op_threshold = 0.05
  #
  #   # add_zero_density_grains = true
  #   # add_default_density_grains = true
  #   default_density = 1e-5
  #   remap_grains =  true
  #   # polycrystal_ic_uo = voronoi
  #
  #   tolerate_failure = true
  # [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'y'
    [../]
  [../]
[]

[Adaptivity]
  initial_steps = 2
  max_h_level = 2
  marker = err
  # cycles_per_step = 1
 [./Markers]
    [./err_bnds]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_bnds
    [../]
    [./err_b]
      type = ErrorFractionMarker
      coarsen = 0.01
      refine = 0.8
      indicator = ind_b
    [../]
    [./err]
      type = ComboMarker
      markers = 'err_bnds err_b'
    [../]
  [../]
  [./Indicators]
     [./ind_bnds]
       type = GradientJumpIndicator
       variable = bnds
    [../]
    [./ind_b]
      type = GradientJumpIndicator
      variable = etab
   [../]
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    # coupled_groups = 'c,w'
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'

  solve_type = PJFNK
  # line_search = basic
  # petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap '
  # petsc_options_value = 'asm ilu 1'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap  -pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'asm         31   preonly   ilu      1  NONZERO 1e-8'
  petsc_options = '-ksp_converged_reason -snes_converged_reason' # -ksp_error_if_not_converged -snes_error_if_not_converged -snes_view'

  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 12
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 10.0 #s
    cutback_factor = 0.85
    growth_factor = 1.05
    optimal_iterations = 6
    iteration_window = 1
  [../]

  dtmax = 800000 #86400
  end_time = 241920000
  #num_steps = 80
  # end_time = 241920000 #2.4192e8
[]

[Outputs]
  csv = true
  perf_graph = true
  # file_base = HBS_bub_test_poly2
#  sync_times = '50000 100000 150000 200000 250000 300000 350000 400000 450000 500000'
  checkpoint = true

 [./console]
    type = Console
    max_rows = 10
    interval = 1
  [../]
  [./exodus]
    type = Exodus
    # interval = 5
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  [../]
[]

# [Debug]
# show_var_residual_norms = true
# []
