# This is an input file for the HBS with explicit nucleation and dislocation energy only.
[Mesh]
  #MOOSE supports reading field data from ExodusII, XDA/XDR, and mesh checkpoint files (.e, .xda, .xdr, .cp)
  # file = 2020_10_12_HBS_bub_gas_Gr100_exodus.e
  #This method of restart is only supported on serial meshes
  # distribution = serial
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  xmin = 70
  xmax = 1220 #25000 #50000
  ymin = 70
  ymax = 1220 #25000 #50000

 uniform_refine = 3
[]

# [Problem]
#   restart_file_base = 2020_10_12_HBS_bub_gas_Gr100_out_cp/LATEST
# []

# [Variables]
#   [PolycrystalVariables]
#     initial_from_file = true
#   []
#   [etab]
#     initial_from_file_var = etab
#     initial_from_file_timestep = LATEST
#   []
#   [w]
#     initial_from_file_var = w
#     initial_from_file_timestep = LATEST
#   []
#   [wg]
#     initial_from_file_var = wg
#     initial_from_file_timestep = LATEST
#   []
# []

[Functions]
  [etab]
    type = SolutionFunction
    solution = sol
    from_variable = etab
  []
  [eta0]
    type = SolutionFunction
    solution = sol
    from_variable = eta0
  []
  [eta1]
    type = SolutionFunction
    solution = sol
    from_variable = eta1
  []
  [eta2]
    type = SolutionFunction
    solution = sol
    from_variable = eta2
  []
  [eta3]
    type = SolutionFunction
    solution = sol
    from_variable = eta3
  []
  [eta4]
    type = SolutionFunction
    solution = sol
    from_variable = eta4
  []
  [eta5]
    type = SolutionFunction
    solution = sol
    from_variable = eta5
  []
  [eta6]
    type = SolutionFunction
    solution = sol
    from_variable = eta6
  []
  [eta7]
    type = SolutionFunction
    solution = sol
    from_variable = eta7
  []

  [eta8]
    type = SolutionFunction
    solution = sol
    from_variable = eta8
  []
  [eta9]
    type = SolutionFunction
    solution = sol
    from_variable = eta9
  []
  [eta10]
    type = SolutionFunction
    solution = sol
    from_variable = eta10
  []
  [eta11]
    type = SolutionFunction
    solution = sol
    from_variable = eta11
  []
  [eta12]
    type = SolutionFunction
    solution = sol
    from_variable = eta12
  []
  [eta13]
    type = SolutionFunction
    solution = sol
    from_variable = eta13
  []
  [eta14]
    type = SolutionFunction
    solution = sol
    from_variable = eta14
  []
  [w]
    type = SolutionFunction
    solution = sol
    from_variable = w
  []
  [wg]
    type = SolutionFunction
    solution = sol
    from_variable = wg
  []
[]

[GlobalParams]
  op_num = 15
  var_name_base = eta
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
  [etab]
    type = FunctionIC
    variable = etab
    function = etab
  []

  [eta0]
    type = FunctionIC
    variable = eta0
    function = eta0
  []
  [eta1]
    type = FunctionIC
    variable = eta1
    function = eta1
  []

  [eta2]
    type = FunctionIC
    variable = eta2
    function = eta2
  []
  [eta3]
    type = FunctionIC
    variable = eta3
    function = eta3
  []
  [eta4]
    type = FunctionIC
    variable = eta4
    function = eta4
  []
  [eta5]
    type = FunctionIC
    variable = eta5
    function = eta5
  []
  [eta6]
    type = FunctionIC
    variable = eta6
    function = eta6
  []
  [eta7]
    type = FunctionIC
    variable = eta7
    function = eta7
  []
  [eta8]
    type = FunctionIC
    variable = eta8
    function = eta8
  []
  [eta9]
    type = FunctionIC
    variable = eta9
    function = eta9
  []
  [eta10]
    type = FunctionIC
    variable = eta10
    function = eta10
  []
  [eta11]
    type = FunctionIC
    variable = eta11
    function = eta11
  []
  [eta12]
    type = FunctionIC
    variable = eta12
    function = eta12
  []
  [eta13]
    type = FunctionIC
    variable = eta13
    function = eta13
  []
  [eta14]
    type = FunctionIC
    variable = eta14
    function = eta14
  []

  [w]
    type = FunctionIC
    variable = w
    function = w
  []
  [wg]
    type = FunctionIC
    variable = wg
    function = wg
  []
[]


[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
    # initial_from_file_var = bnds
    # initial_from_file_timestep = LATEST
  []
  [unique_grains]
    order = CONSTANT
    family = MONOMIAL
  []
  [var_indices]
    order = CONSTANT
    family = MONOMIAL
  []
  [halos]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [ACb_bulk]
    type = ACGrGrMulti
    variable = etab
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmb  gmb  gmb   gmb gmb  gmb  gmb  gmb  gmb  gmb    gmb   gmb  gmb   gmb '
  []
  [ACb_bulk1]
    type = AllenCahn
    variable = etab
    f_name = fetab0
  []
  [ACb_sw]
    type = ACSwitching
    variable = etab
    Fj_names = 'omegab  omegam'
    hj_names = 'hb      hm'
    args = 'w wg eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACb_int]
    type = ACInterface
    variable = etab
    kappa_name = kappa
  []
  [eb_dot]
    type = TimeDerivative
    variable = etab
  []
  # Order parameter eta_m0 for matrix grain 0
  [ACm0_bulk]
    type = ACGrGrMulti
    variable = eta0
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm    gmm'
  []
  [ACm0_sw]
    type = ACSwitching
    variable = eta0
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
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
  [em0_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta0
    grain_tracker = grain_tracker
    op_index = 0
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  # Order parameter eta_m1 for matrix grain 1
  [ACm1_bulk]
    type = ACGrGrMulti
    variable = eta1
    v = 'etab eta0 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm   gmm '
  []
  [ACm1_sw]
    type = ACSwitching
    variable = eta1
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta0 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
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
  [em1_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta1
    grain_tracker = grain_tracker
    op_index = 1
    v = 'etab eta0 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  # Order parameter eta_m2 for matrix grain 2
  [ACm2_bulk]
    type = ACGrGrMulti
    variable = eta2
    v = 'etab eta1 eta0 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm  gmm   gmm'
  []
  [ACm2_sw]
    type = ACSwitching
    variable = eta2
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta0 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm2_int]
    type = ACInterface
    variable = eta2
    kappa_name = kappa
  []
  [em2_dot]
    type = TimeDerivative
    variable = eta2
  []
  [em2_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta2
    grain_tracker = grain_tracker
    v = 'etab eta1 eta0 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 2
  []
  # Order parameter eta_m3 for matrix grain 3
  [ACm3_bulk]
    type = ACGrGrMulti
    variable = eta3
    v = 'etab eta1 eta2 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm    gmm gmm'
  []
  [ACm3_sw]
    type = ACSwitching
    variable = eta3
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm3_int]
    type = ACInterface
    variable = eta3
    kappa_name = kappa
  []
  [em3_dot]
    type = TimeDerivative
    variable = eta3
  []
  [em3_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta3
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 3
  []
  [ACm4_bulk]
    type = ACGrGrMulti
    variable = eta4
    v = 'etab eta1 eta2 eta3 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm'
  []
  [ACm4_sw]
    type = ACSwitching
    variable = eta4
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm4_int]
    type = ACInterface
    variable = eta4
    kappa_name = kappa
  []
  [em4_dot]
    type = TimeDerivative
    variable = eta4
  []
  [em4_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta4
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta0 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 4
  []
  [ACm5_bulk]
    type = ACGrGrMulti
    variable = eta5
    v = 'etab eta1 eta2 eta3 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm  gmm   gmm '
  []
  [ACm5_sw]
    type = ACSwitching
    variable = eta5
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm5_int]
    type = ACInterface
    variable = eta5
    kappa_name = kappa
  []
  [em5_dot]
    type = TimeDerivative
    variable = eta5
  []
  [em5_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta5
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta0 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 5
  []
  [ACm6_bulk]
    type = ACGrGrMulti
    variable = eta6
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta0 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm '
  []
  [ACm6_sw]
    type = ACSwitching
    variable = eta6
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta0 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm6_int]
    type = ACInterface
    variable = eta6
    kappa_name = kappa
  []
  [em6_dot]
    type = TimeDerivative
    variable = eta6
  []
  [em6_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta6
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta0 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 6
  []
  [ACm7_bulk]
    type = ACGrGrMulti
    variable = eta7
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta0 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm   gmm   gmm'
  []
  [ACm7_sw]
    type = ACSwitching
    variable = eta7
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta0 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm7_int]
    type = ACInterface
    variable = eta7
    kappa_name = kappa
  []
  [em7_dot]
    type = TimeDerivative
    variable = eta7
  []
  [em7_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta7
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta0 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 7
  []
  [ACm8_bulk]
    type = ACGrGrMulti
    variable = eta8
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta0 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm    gmm  gmm   gmm'
  []
  [ACm8_sw]
    type = ACSwitching
    variable = eta8
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta0 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm8_int]
    type = ACInterface
    variable = eta8
    kappa_name = kappa
  []
  [em8_dot]
    type = TimeDerivative
    variable = eta8
  []
  [em8_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta8
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta0 eta9 eta10 eta11 eta12 eta13 eta14'
    op_index = 8
  []
  [ACm9_bulk]
    type = ACGrGrMulti
    variable = eta9
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta0 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm   gmm   gmm    gmm'
  []
  [ACm9_sw]
    type = ACSwitching
    variable = eta9
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta0 eta10 eta11 eta12 eta13 eta14'
  []
  [ACm9_int]
    type = ACInterface
    variable = eta9
    kappa_name = kappa
  []
  [em9_dot]
    type = TimeDerivative
    variable = eta9
  []
  [em9_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta9
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta0 eta10 eta11 eta12 eta13 eta14'
    op_index = 9
  []
  [ACm10_bulk]
    type = ACGrGrMulti
    variable = eta10
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta0 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm '
  []
  [ACm10_sw]
    type = ACSwitching
    variable = eta10
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta0 eta11 eta12 eta13 eta14'
  []
  [ACm10_int]
    type = ACInterface
    variable = eta10
    kappa_name = kappa
  []
  [em10_dot]
    type = TimeDerivative
    variable = eta10
  []
  [em10_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta10
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta0 eta11 eta12 eta13 eta14'
    op_index = 10
  []
  [ACm11_bulk]
    type = ACGrGrMulti
    variable = eta11
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  [ACm11_sw]
    type = ACSwitching
    variable = eta11
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
  []
  [ACm11_int]
    type = ACInterface
    variable = eta11
    kappa_name = kappa
  []
  [em11_dot]
    type = TimeDerivative
    variable = eta11
  []
  [em11_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta11
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
    op_index = 11
  []

  [ACm12_bulk]
    type = ACGrGrMulti
    variable = eta12
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta0 eta12 eta13 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  [ACm12_sw]
    type = ACSwitching
    variable = eta12
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta0 eta13 eta14'
  []
  [ACm12_int]
    type = ACInterface
    variable = eta12
    kappa_name = kappa
  []
  [em12_dot]
    type = TimeDerivative
    variable = eta12
  []
  [em12_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta12
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta0 eta13 eta14'
    op_index = 12
  []
  [ACm13_bulk]
    type = ACGrGrMulti
    variable = eta13
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta0 eta14'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  [ACm13_sw]
    type = ACSwitching
    variable = eta13
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta0 eta14'
  []
  [ACm13_int]
    type = ACInterface
    variable = eta13
    kappa_name = kappa
  []
  [em13_dot]
    type = TimeDerivative
    variable = eta13
  []
  [em13_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta13
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta0 eta14'
    op_index = 13
  []
  [ACm14_bulk]
    type = ACGrGrMulti
    variable = eta14
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta0'
    gamma_names = 'gmb  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm  gmm   gmm  gmm   gmm    gmm'
  []
  [ACm14_sw]
    type = ACSwitching
    variable = eta14
    Fj_names = 'omegab   omegam'
    hj_names = 'hb       hm'
    args = 'w wg etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta0'
  []
  [ACm14_int]
    type = ACInterface
    variable = eta14
    kappa_name = kappa
  []
  [em14_dot]
    type = TimeDerivative
    variable = eta14
  []
  [em14_dd]
    type = ACPolycrystalDislocationEnergy
    variable = eta14
    grain_tracker = grain_tracker
    v = 'etab eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta0'
    op_index = 14
  []
  #Chemical potential for vacancies
  [wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chi
  []
  [Diffusion_wg]
    type = MatDiffusion
    variable = wg
    diffusivity = Dchi
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [source_wg]
    type = MaskedBodyForce
    variable = wg
    value = 2.35e-9
    # value = 5.0e-6
    mask = hm
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta2dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta2
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta3dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta3
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta4dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta4
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta5dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta5
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta6dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta6
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta7dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta7
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta8dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta8
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta9dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta9
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta10dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta10
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta11dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta11
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta12dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta12
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta13dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta13
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta14dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta14
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []

  [wv_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chi
  []
  [Diffusion_wv]
    type = MatDiffusion
    variable = w
    diffusivity = Dchi
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [source_wv]
    type = MaskedBodyForce
    variable = w
    value = 4.7e-8
    # value = 5.0e-7
    mask = hm
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = etab
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta0
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta1
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta2dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta2
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta3dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta3
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta4dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta4
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta5dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta5
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta6dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta6
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta7dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta7
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta8dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta8
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta9dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta9
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta10dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta10
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta11dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta11
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta12dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta12
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta13dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta13
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_w_eta14dot]
    type = CoupledSwitchingTimeDerivative
    variable = w
    v = eta14
    Fj_names = 'rhob   rhom'
    hj_names = 'hb      hm'
    args = 'wg etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []

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
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    op_num = 15
    # v = 'eta1 eta2 eta3 eta0 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 etab'
    execute_on = 'timestep_end'
  []
  [unique_grains_calc]
    type = FeatureFloodCountAux
    variable = unique_grains
    flood_counter = grain_tracker
    field_display = UNIQUE_REGION
    execute_on = 'initial timestep_end'
  []
  [var_indices_calc]
    type = FeatureFloodCountAux
    variable = var_indices
    flood_counter = grain_tracker
    field_display = VARIABLE_COLORING
    execute_on = 'initial timestep_end'
  []
  [halos]
    type = FeatureFloodCountAux
    variable = halos
    flood_counter = grain_tracker
    field_display = HALOS
    execute_on = 'initial timestep_end'
  []
[]

[Materials]
  [fetab0]
    type = DerivativeParsedMaterial
    f_name = fetab0
    args = 'etab'
    function = '(1-etab)^4/4-(1-etab)^2/2'
    derivative_order = 2
    # outputs = exodus
  []
  [hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
    phase_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    # outputs = exodus
    # output_properties = 'hm'
  []
  [hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
    phase_etas = 'etab'
    # outputs = exodus
    # output_properties = 'hb'
  []

  [omegab]
    type = DerivativeParsedMaterial
    f_name = omegab
    args = 'w wg'
    material_property_names = 'Va kb cb_eq cgb_eq f0'
    function = '-0.5*w^2/Va^2/kb - w/Va*cb_eq - 0.5*wg^2/Va^2/kb - wg/Va*cgb_eq + f0'
    # derivative_order = 2
    # outputs = exodus
  []
  [omegam]
    type = DerivativeParsedMaterial
    f_name = omegam
    args = 'w wg'
    material_property_names = 'Va km cm_eq'
    function = '-0.5*w^2/Va^2/km - w/Va*cm_eq -0.5*wg^2/Va^2/km - wg/Va*cm_eq'
    # derivative_order = 2
    # outputs = exodus
  []

  [chi]
    type = DerivativeParsedMaterial
    f_name = chi
    args = 'w'
    material_property_names = 'Va hb hm kb km'
    function = '(hm/km + hb/kb)/Va^2'
    # derivative_order = 2
    # outputs = exodus
  []

  [rhob]
    type = DerivativeParsedMaterial
    f_name = rhob
    args = 'w'
    material_property_names = 'Va kb cb_eq'
    function = 'w/Va^2/kb + cb_eq/Va'
    derivative_order = 1
    # outputs = exodus
    # output_properties = 'rhob'
  []
  [rhom]
    type = DerivativeParsedMaterial
    f_name = rhom
    args = 'w'
    material_property_names = 'Va km cm_eq'
    function = 'w/Va^2/km + cm_eq/Va'
    derivative_order = 1
    # output_properties = 'rhom'
    # outputs = exodus
  []
  [rhogb]
    type = DerivativeParsedMaterial
    f_name = rhogb
    args = 'wg'
    material_property_names = 'Va kb cgb_eq'
    function = 'wg/Va^2/kb + cgb_eq/Va'
    derivative_order = 1
    # outputs = exodus
    # output_properties = 'rhogb'
  []
  [rhogm]
    type = DerivativeParsedMaterial
    f_name = rhogm
    args = 'wg'
    material_property_names = 'Va km cm_eq'
    function = 'wg/Va^2/km + cm_eq/Va'
    derivative_order = 1
    # output_properties = 'rhogm'
    # outputs = exodus
  []
  [rhov]
    type = ParsedMaterial
    f_name = rho
    material_property_names = 'rhom hm rhob hb'
    function = '(hm*rhom + hb*rhob)'
    # outputs = exodus
  []
  [rhog]
    type = ParsedMaterial
    f_name = rhog
    material_property_names = 'rhogm hm rhogb hb'
    function = '(hm*rhogm + hb*rhogb)'
    # outputs = exodus
  []
  [cv]
    type = ParsedMaterial
    f_name = cv
    material_property_names = 'rhom hm rhob hb Va'
    function = 'Va*(hm*rhom + hb*rhob)'
    # outputs = exodus
  []
  [cg]
    type = ParsedMaterial
    f_name = cg
    material_property_names = 'rhogm hm rhogb hb Va'
    function = 'Va*(hm*rhogm + hb*rhogb)'
    # outputs = exodus
  []
  [Diff_v]
    type = GrandPotentialDiffusionMaterial
    c = etab
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    # Dbulk = 5.86e-1
    Dbulk = 0.246
    Dsurf = 2.46e2
    surfindex = 1.0
    gbindex = 100.0
    bulkindex = 10.0
    Dgb = 2.46
    # outputs = exodus
  []
  [Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dchi
    material_property_names = 'D chi'
    function = 'D*chi'
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    derivative_order = 2
    # outputs = exodus
  []
  [constants]
    type = GenericConstantMaterial
    # prop_names =  'Va      cb_eq cm_eq kb   km   mu   gmm  gmb  L     D    kappa  kB            burgers_vector shear_modulus'
    # prop_values = '0.04092 1.0   1e-5  1.41 1.41 0.59 1.5  1.5  4e-6 0.01  740    8.6173324e-5  0.5            456'
    prop_names = 'kappa   mu       L      Va       cb_eq  cgb_eq kb        gmb   gmm  T    f0        '
                 '  kB      burg_vec  G_mod'
    prop_values = '70.2   5.62    4.01e-5 0.04092   0.56  0.44    321.15     1.5	  1.5 1100 4.814 '
                  '8.6173324e-5   0.5      400.0'
  []

  [cm_eq] #For values, see Li et al., Nuc. Inst. Methods in Phys. Res. B, 303, 62-27 (2013).
    type = ParsedMaterial
    f_name = cm_eq
    material_property_names = 'T'
    constant_names = 'kB           Efv'
    constant_expressions = '8.6173324e-5 3.0'
    function = 'exp(-Efv/(kB*T))'
    # outputs = exodus
  []

  # [./kvmatrix_parabola]
  #   type = ParsedMaterial
  #   f_name = km
  #   material_property_names = 'T  cm_eq'
  #   constant_names        = 'c0v  c0g  a1                                               a2'
  #   constant_expressions  = '0.01 0.01 0.178605-0.0030782*log(1-c0v)+0.0030782*log(c0v) 0.178605-0.00923461*log(1-c0v)+0.00923461*log(c0v)'
  #   function = '((-a2+3*a1)/(4*(c0v-cm_eq))+(a2-a1)/(2400*(c0v-cm_eq))*T)'
  #   outputs = exodus
  # [../]

  [kvmatrix_parabola]
    type = ParsedMaterial
    f_name = km
    material_property_names = 'T  cm_eq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.01 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cm_eq)'
    # outputs = exodus
  []

  [dislocation_density]
    type = PolycrystalDislocationDensity
    grain_tracker = grain_tracker
    burnup_constant = 4.2654e-5
    # outputs = exodus
    burgers_vector = 0.5 #maybe it's a little smaller per Nogita and Une...
    shear_modulus = 400 # eV/nm^3 =  64.1 GPa
    op_num = 15
    time_scale = 1 #s
    length_scale = 1e-9 #nm
  []
  # [./nucleation_rate]
  #   type = GrGrDislocNucRate
  #   k0 = 1e-3
  #   bounds = bnds
  #   outputs = exodus
  #   critical_density = 0.000586138 # dislocation density at 44 GWd/t, nm/nm^3
  # [../]
[]

[UserObjects]
  [grain_tracker]
    type = GrainTrackerDislocations
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    # dislocation_density_reader = dislocation_density_file
    prefactor = 1e-5
    deformed_grain_num = 100
    #compute_halo_maps = true # Only necessary for displaying HALOS
    halo_level = 3
    rand_seed = 198756
    #threshold = 0.2
    #connecting_threshold = 0.15
    reserve_op = 1
    reserve_op_threshold = 0.05

    # add_zero_density_grains = true
    # add_default_density_grains = true
    default_density = 1e-7
    remap_grains = true
    # polycrystal_ic_uo = voronoi

    tolerate_failure = true
  []
  [./sol]
    type = SolutionUserObject
    mesh = 2020_10_22_HBS_bub_gas_Gr100_recover_exodus.e
  [../]
[]

# [VectorPostprocessors]
#   [./features]
#     type = FeatureVolumeVectorPostprocessor
#     flood_counter = grain_tracker
#
#     # Turn on centroid output
#     output_centroids = false
#     execute_on = 'timestep_end'
#   [../]
# []

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
  line_search = basic
  # petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap '
  # petsc_options_value = 'asm ilu 1'
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap  '
                        '-pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'asm         31   preonly   ilu      1  NONZERO 1e-8'
  petsc_options = '-ksp_converged_reason -snes_converged_reason' # -ksp_error_if_not_converged -snes_error_if_not_converged -snes_view'

  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 12
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1 #s
    cutback_factor = 0.85
    growth_factor = 1.2
    optimal_iterations = 6
    iteration_window = 1
  []

  dtmax = 800000 #86400
  # end_time = 1.0
  num_steps = 10
  # end_time = 241920000 #2.4192e8
[]

[Outputs]
  csv = true
  perf_graph = true
  # file_base = HBS_bub_test_poly2
  #  sync_times = '50000 100000 150000 200000 250000 300000 350000 400000 450000 500000'
  checkpoint = true

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
