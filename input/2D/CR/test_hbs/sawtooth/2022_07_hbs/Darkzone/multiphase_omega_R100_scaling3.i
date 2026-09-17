[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  xmin = 0
  xmax = 1000
  ymin = 0
  ymax = 1000
  uniform_refine = 2
[]

[Adaptivity]
  initial_steps = 2
  max_h_level = 2
  marker = err
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
    [err]
      type = ComboMarker
      markers = 'err_bnds err_b'
    []
  []
  [Indicators]
    [ind_bnds]
      type = GradientJumpIndicator
      variable = bnds
    []
    [ind_b]
      type = GradientJumpIndicator
      variable = etab0
    []
  []
[]


[GlobalParams]
  #int_width = 3.0
  #block = 0
  op_num = 2
  var_name_base = etam
[]

[Variables]
  [wv]
  []
  [wg]
  []
  [etab0]
  []
  [etam0]
  []
  [etam1]
  []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
[]

[ICs]
  [IC_etab0]
    type = FunctionIC
    variable = etab0
    function = ic_func_etab0
  []
  [IC_etam0]
    type = FunctionIC
    variable = etam0
    function = ic_func_etam0
  []
  [IC_etam1]
    type = FunctionIC
    variable = etam1
    function = ic_func_etam1
  []
  [IC_wv]
    type = ConstantIC
    variable = wv
    value = 6.995147964479171e-05
  []
  [IC_wg]
    type = ConstantIC
    variable = wg
    value = -0.0038098539401999997
  []
[]

[Functions]
  [ic_func_etab0]
    type = ParsedFunction
    vars = 'kappa  mu'
    vals = '0.5273 0.004688'
    value = 'r:=sqrt((x-500)^2+(y-500)^2);0.5*(1.0-tanh((r-100)*sqrt(mu/2.0/kappa)))'
  []
  [ic_func_etam0]
    type = ParsedFunction
    vars = 'kappa  mu'
    vals = '0.5273 0.004688'
    value = 'r:=sqrt((x-500)^2+(y-500)^2);0.5*(1.0+tanh((r-100)*sqrt(mu/2.0/kappa)))*0.5*(1.0+tanh((y-500)*sqrt(mu/2.0/kappa)))'
  []
  [ic_func_etam1]
    type = ParsedFunction
    vars = 'kappa  mu'
    vals = '0.5273 0.004688'
    value = 'r:=sqrt((x-500)^2+(y-500)^2);0.5*(1.0+tanh((r-100)*sqrt(mu/2.0/kappa)))*0.5*(1.0-tanh((y-500)*sqrt(mu/2.0/kappa)))'
  []
[]

#[Functions]
#  [./ic_func_etab0]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0-tanh((r-10.0)/sqrt(2.0)))'
#  [../]
#  [./ic_func_etam0]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0+tanh((r-10)/sqrt(2.0)))*(1.0+tanh((y)/sqrt(2.0)))' #TODO put in another factor of 0.5
#  [../]
#  [./ic_func_etam1]
#    type = ParsedFunction
#    value = 'r:=sqrt(x^2+y^2);0.5*(1.0+tanh((r-10)/sqrt(2.0)))*(1.0-tanh((y)/sqrt(2.0)))' #TODO put in another factor of 0.5
#  [../]
#[]

[BCs]
[]

[Kernels]
  # Order parameter eta_b0 for bubble phase
  [ACb0_bulk]
    type = ACGrGrMulti
    variable = etab0
    v = 'etam0 etam1'
    gamma_names = 'gmb   gmb'
  []
  [ACb0_sw]
    type = ACSwitching
    variable = etab0
    Fj_names = 'omegab omegam'
    hj_names = 'hb     hm'
    args = 'etam0 etam1 wv wg'
  []
  [ACb0_int]
    type = ACInterface
    variable = etab0
    kappa_name = kappa
  []
  [eb0_dot]
    type = TimeDerivative
    variable = etab0
  []
  # Order parameter eta_m0 for matrix grain 1
  [ACm0_bulk]
    type = ACGrGrMulti
    variable = etam0
    v = 'etab0 etam1'
    gamma_names = 'gmb   gmm'
  []
  [ACm0_sw]
    type = ACSwitching
    variable = etam0
    Fj_names = 'omegab omegam'
    hj_names = 'hb     hm'
    args = 'etab0 etam1 wv wg'
  []
  [ACm0_int]
    type = ACInterface
    variable = etam0
    kappa_name = kappa
  []
  [em0_dot]
    type = TimeDerivative
    variable = etam0
  []
  # Order parameter eta_m1 for matrix grain 2
  [ACm1_bulk]
    type = ACGrGrMulti
    variable = etam1
    v = 'etab0 etam0'
    gamma_names = 'gmb   gmm'
  []
  [ACm1_sw]
    type = ACSwitching
    variable = etam1
    Fj_names = 'omegab omegam'
    hj_names = 'hb     hm'
    args = 'etab0 etam0 wv wg'
  []
  [ACm1_int]
    type = ACInterface
    variable = etam1
    kappa_name = kappa
  []
  [em1_dot]
    type = TimeDerivative
    variable = etam1
  []
  #Chemical potential for vacancies
  [wv_dot]
    type = SusceptibilityTimeDerivative
    variable = wv
    f_name = chiv
    args = '' # in this case chi (the susceptibility) is simply a constant
  []
  [Diffusion_v]
    type = MatDiffusion
    variable = wv
    D_name = Dchiv
    args = ''
  []
  [Source_v]
    type = MaskedBodyForce
    variable = wv
    value = 2.35e-9
    mask = hm
    args = 'etab0 etam0 etam1'
  []
  [coupled_v_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etab0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
  [coupled_v_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam0
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
  [coupled_v_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wv
    v = etam1
    Fj_names = 'rhovbub rhovmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
  #Chemical potential for gas atoms
  [wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
    args = '' # in this case chi (the susceptibility) is simply a constant
  []
  [Diffusion_g]
    type = MatDiffusion
    variable = wg
    D_name = Dchig
    args = ''
  []
  [Source_g]
    type = MaskedBodyForce
    variable = wg
    value = 2.35e-10
    mask = hm
    args = 'etab0 etam0 etam1'
  []
  [coupled_g_etab0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
  [coupled_g_etam0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam0
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
  [coupled_g_etam1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etam1
    Fj_names = 'rhogbub rhogmatrix'
    hj_names = 'hb      hm'
    args = 'etab0 etam0 etam1'
  []
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  []
[]

[Materials]
  [hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'etab0 etam0 etam1'
    phase_etas = 'etab0'
    #outputs = exodus
  []
  [hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'etab0 etam0 etam1'
    phase_etas = 'etam0 etam1'
    #outputs = exodus
  []
  [omegab]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegab
    material_property_names = 'Va kvbub cvbubeq kgbub cgbubeq f0'
    function = '-0.5*wv^2/Va^2/kvbub-wv/Va*cvbubeq-0.5*wg^2/Va^2/kgbub-wg/Va*cgbubeq + f0'
    derivative_order = 2
    #outputs = exodus
  []
  [omegam]
    type = DerivativeParsedMaterial
    args = 'wv wg'
    f_name = omegam
    material_property_names = 'Va kvmatrix cvmatrixeq kgmatrix cgmatrixeq'
    function = '-0.5*wv^2/Va^2/kvmatrix-wv/Va*cvmatrixeq-0.5*wg^2/Va^2/kgmatrix-wg/Va*cgmatrixeq'
    derivative_order = 2
    #outputs = exodus
  []
  [rhovbub]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovbub
    material_property_names = 'Va kvbub cvbubeq'
    function = 'wv/Va^2/kvbub + cvbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  []
  [rhovmatrix]
    type = DerivativeParsedMaterial
    args = 'wv'
    f_name = rhovmatrix
    material_property_names = 'Va kvmatrix cvmatrixeq'
    function = 'wv/Va^2/kvmatrix + cvmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  []
  [rhogbub]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogbub
    material_property_names = 'Va kgbub cgbubeq'
    function = 'wg/Va^2/kgbub + cgbubeq/Va'
    derivative_order = 2
    #outputs = exodus
  []
  [rhogmatrix]
    type = DerivativeParsedMaterial
    args = 'wg'
    f_name = rhogmatrix
    material_property_names = 'Va kgmatrix cgmatrixeq'
    function = 'wg/Va^2/kgmatrix + cgmatrixeq/Va'
    derivative_order = 2
    #outputs = exodus
  []
  [cv]
    type = ParsedMaterial
    f_name = cv
    material_property_names = 'Va hm hb rhovmatrix rhovbub'
    function = 'Va * (hm * rhovmatrix + hb * rhovbub)'
    outputs = exodus
  []
  [cg]
    type = ParsedMaterial
    f_name = cg
    material_property_names = 'Va hm hb rhogmatrix rhogbub'
    function = 'Va * (hm * rhogmatrix + hb * rhogbub)'
    outputs = exodus
  []

  [const]
    type = GenericConstantMaterial
    prop_names = ' kappa   mu       L     Lv      D        Dv    Va     cvbubeq cgbubeq  kgbub   kvbub    gmb gmm    T    f0        kB tgrad_corr_mult'
    # prop_values = '0.5273 0.004688  1.0 0.01 0.04092 1       1.0037   0.09889 10    1.5 0.9218 1000 -4.847e-2  0.0'
    prop_values = '70.2    5.62   2.16e-6 2.16e-5 9.351e-3 1.67 0.04092 1       1.0037   39.51 3994.88    1.5 0.9218 1000 -4.847e-2 8.6173324e-5 0.0'
  []
  [cvmatrixeq] #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
    type = ParsedMaterial
    f_name = cvmatrixeq
    material_property_names = 'T'
    constant_names = 'kB           Efv'
    constant_expressions = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
  []
  [cgmatrixeq]
    type = ParsedMaterial
    f_name = cgmatrixeq
    material_property_names = 'T'
    constant_names = 'kB           Efg'
    constant_expressions = '8.6173324e-5 3.0'
    function = 'exp(-Efg/(kB*T))'
  []
  [kvmatrix_parabola]
    # type = ParsedMaterial
    # f_name = kvmatrix
    # material_property_names = 'T  cvmatrixeq'
    # constant_names = 'c0v  c0g  a1                                               a2'
    # constant_expressions = '0.01 0.01 0.178605-0.0030782*log(1-c0v)+0.0030782*log(c0v) 0.178605-0.00923461*log(1-c0v)+0.00923461*log(c0v)'
    # function = '((-a2+3*a1)/(4*(c0v-cvmatrixeq))+(a2-a1)/(2400*(c0v-cvmatrixeq))*T)'
    # #outputs = exodus
    type = ParsedMaterial
    f_name = kvmatrix
    material_property_names = 'T  cvmatrixeq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.008 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cvmatrixeq)'
    outputs = exodus
  []
  [kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kgmatrix
    material_property_names = 'T  cgmatrixeq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.008 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cgmatrixeq)'
    outputs = exodus
  []
  # [kgmatrix_parabola]
  #   type = ParsedMaterial
  #   f_name = kgmatrix
  #   material_property_names = 'kvmatrix'
  #   function = 'kvmatrix'
  # []

  [Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchiv
    material_property_names = 'Dv chiv'
    function = 'Dv*chiv'
    derivative_order = 2
    #outputs = exodus
  []
  [Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dchig
    material_property_names = 'D chig'
    function = 'D*chig'
    derivative_order = 2
    #outputs = exodus
  []
  [chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    args = 'wv'
    material_property_names = 'Va hb kvbub hm kvmatrix '
    function = '(hm/kvmatrix + hb/kvbub) / Va^2'
    derivative_order = 2
    # outputs = exodus
  []
  [chig]
    type = DerivativeParsedMaterial
    f_name = chig
    args = 'wg'
    material_property_names = 'Va hb kgbub hm kgmatrix '
    function = '(hm/kgmatrix + hb/kgbub) / Va^2'
    derivative_order = 2
    # outputs = exodus
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  nl_max_its = 15
  scheme = bdf2
  #solve_type = NEWTON
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type'
  petsc_options_value = 'asm      1               lu'
  l_max_its = 45
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1e-9
  start_time = 0.0
  end_time = 1e9
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    optimal_iterations = 8
    iteration_window = 2
  []
[]

[Outputs]
  exodus = true
  checkpoint = true
[]
