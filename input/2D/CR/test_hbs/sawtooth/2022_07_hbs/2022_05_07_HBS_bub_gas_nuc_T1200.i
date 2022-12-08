
# input file for bubble groeth and pressure build up in HbS structure
# For model parameterization, time scale = 1 sec, length scale  = 1 nm, energy density scale = 1 eV/nm^3, int_width = 10 nm
# domain size is scaled for reducing computational cost
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 25
  ny = 25
  xmin = 0
  xmax = 1250
  ymin = 0
  ymax = 1250
  uniform_refine = 1
[]

[GlobalParams]
  op_num = 16
  # grain_num = 15
  var_name_base = eta
  numbub = 1
  bubspac = 600
  radius = 120.0
  int_width = 20.0
  polycrystal_ic_uo = voronoi
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
      op_num = 15
      rand_seed = 18765
    []
  []
  [bubble_IC]
    variable = etab
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    rand_seed = 18765
    invalue = 1.0
    outvalue = 0.0
  []
  [IC_w]
    variable = w
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    rand_seed = 18765
    invalue = 0.0 #this corresponds to concentration 0.85
    outvalue = 0.0
  []
  [IC_wg]
    variable = wg
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    rand_seed = 18765
    invalue = 0.0 #concentration 0.15
    outvalue = 0.0
  []
  [bnds]
    type = BndsCalcIC
    variable = bnds
    op_num = 15
  []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
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

  [./time]
  [../]
  [./cg]
    order = FIRST
    family = MONOMIAL
  [../]
  [./cv]
    order = FIRST
    family = MONOMIAL
  [../]
  [proc_id]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  #order parameter etab for bubbles
  [ACb_bulk]
    type = ACGrGrMulti
    variable = etab
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    gamma_names = 'gmb  gmb  gmb  gmb   gmb gmb  gmb  gmb  gmb  gmb  gmb    gmb   gmb  gmb   gmb '
    mob_name = Lv
  []
  [ACb_sw]
    type = ACSwitching
    variable = etab
    Fj_names = 'omegab  omegam'
    hj_names = 'hb      hm'
    args = 'w wg eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
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
  # Order parameter eta0 for matrix grain 0
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
  # Order parameter eta1 for matrix grain 1
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
  # Order parameter eta2 for matrix grain 2
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
  # Order parameter eta3 for matrix grain 3
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
  # Order parameter eta4 for matrix grain 4
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
  # Order parameter eta5 for matrix grain 5
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
  # Order parameter eta6 for matrix grain 6
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
  # Order parameter eta7 for matrix grain 7
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
  # Order parameter eta8 for matrix grain 8
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
  # Order parameter eta9 for matrix grain 9
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
  # Order parameter eta10 for matrix grain 10
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
  # Order parameter eta11 for matrix grain 11
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
  # Order parameter eta12 for matrix grain 12
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
  # Order parameter eta13 for matrix grain 13
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
  # Order parameter eta14 for matrix grain 14
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

  #Chemical potential for gas atoms
  [wg_dot]
    type = SusceptibilityTimeDerivative
    variable = wg
    f_name = chig
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [Diffusion_wg]
    type = MatDiffusion
    variable = wg
    diffusivity = Dgchi
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [source_wg]
    type = MaskedBodyForce
    variable = wg
    value = 1 #fission rate * Xe yield = 1.09e19*0.2156 fission/m^3/s
    mask = XeRate
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_etabdot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = etab
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta0dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta0
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta1dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta1
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta2dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta2
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta3dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta3
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta4dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta4
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta5dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta5
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta6dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta6
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta7dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta7
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta8dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta8
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta9dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta9
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta10dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta10
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta11dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta11
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta12dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta12
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta13dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta13
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [coupled_wg_eta14dot]
    type = CoupledSwitchingTimeDerivative
    variable = wg
    v = eta14
    Fj_names = 'rhogb   rhogm'
    hj_names = 'hb      hm'
    args = 'w etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [wv_dot]
    type = SusceptibilityTimeDerivative
    variable = w
    f_name = chiv
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [Diffusion_wv]
    type = MatDiffusion
    variable = w
    diffusivity = Dvchi
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  [source_wv]
    type = MaskedBodyForce
    variable = w
    value = 1.0 # 20 times of the gas source
    mask = VacRate
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  []
  # [sink_wv]
  #   type = GrandPotentialSink
  #   variable = w
  #   value = 1.0
  #   sink_strength = 1.9223e-7 # sv*Va/cv0/Dv, obtained equating the residuals for MaskedBodyForce for w and GrandPotentialSink kernels
  #   rho = rho
  #   rho_s = 1
  #   D = 1
  #   mask = hm
  #   args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  # []
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
  [nucleation]
    type = DiscreteNucleationForce
    variable = eta15
    map = map
    nucleus_value = 1
  []
  [reaction]
    type = Reaction
    variable = eta15
  []
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    op_num = 15
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
  [./time]
    type = FunctionAux
    variable = time
    function = 't'
  [../]
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
  [./proc_id]
    type = ProcessorIDAux
    variable = proc_id
  [../]
[]

[Materials]
  [hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
    phase_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    outputs = exodus
    output_properties = 'hm'
  []
  [hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14 etab'
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
    output_properties = 'omegab'
  []
  [omegam]
    type = DerivativeParsedMaterial
    f_name = omegam
    args = 'w wg'
    material_property_names = 'Va kmv kmg cm_eq'
    function = '-0.5*w^2/Va^2/kmv - w/Va*cm_eq -0.5*wg^2/Va^2/kmg - wg/Va*cm_eq'
    derivative_order = 2
    outputs = exodus
    output_properties = 'omegam'
  []

  [chiv]
    type = DerivativeParsedMaterial
    f_name = chiv
    args = 'w'
    material_property_names = 'Va hb hm kb kmv'
    function = '(hm/kmv + hb/kb)/Va^2'
    derivative_order = 2
    outputs = exodus
  []
  [chig]
    type = DerivativeParsedMaterial
    f_name = chig
    args = 'wg'
    material_property_names = 'Va hb hm kb kmg'
    function = '(hm/kmg + hb/kb)/Va^2'
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
    material_property_names = 'Va kmv cm_eq'
    function = 'w/Va^2/kmv + cm_eq/Va'
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
    material_property_names = 'Va kmg cm_eq'
    function = 'wg/Va^2/kmg + cm_eq/Va'
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
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    diffusivity = Dv
    Dbulk = 16.65271 # this value is obatined from Matzke 1987, cluster dynamics value is in the order of 1e-7
    Dsurf = 16.65271
    surf_weight = 100.0 # 30 is the ptefactor for normalizing the function
    gb_weight = 1000.0 # 9 is the ptefactor for normalizing the function
    bulk_weight = 1.0
    void_weight = 1000.0
    Dgb = 16.65271
    Dvoid = 16.65271
    outputs = exodus
    output_properties = 'Dv'
  []
  [Mobility_v]
    type = DerivativeParsedMaterial
    f_name = Dvchi
    material_property_names = 'Dv chiv'
    function = 'Dv*chiv'
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    derivative_order = 2
    outputs = exodus
    output_properties = 'Dvchi'
  []
  [Diff_gm]
    type = PolycrystalDiffusivity
    c = etab
    v = 'eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    diffusivity = Dg
    Dbulk = 0.0175 # cluster dynamics data from Mathews 2019, Turnbull value is 0.0215 nm^2/s
    Dsurf = 0.0175
    surf_weight = 100000.0 # 30 is the ptefactor for normalizing the function
    gb_weight = 1000000.0 # 9 is the ptefactor for normalizing the function
    bulk_weight = 1.0
    void_weight = 1000000.0
    Dgb = 0.0175
    Dvoid = 0.0175
    outputs = exodus
    output_properties = 'Dg'
  []

  # [Diff_g]
  #   type = DerivativeParsedMaterial
  #   f_name = Dg
  #   args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
  #   material_property_names = 'Dgm hm hb'
  #   function = 'hm*Dgm+10*Dgm*hb'
  #   outputs = exodus
  #   output_properties = 'Dg'
  # []

  [Mobility_g]
    type = DerivativeParsedMaterial
    f_name = Dgchi
    material_property_names = 'Dg chig'
    function = 'Dg*chig'
    args = 'etab eta0 eta1 eta2 eta3 eta4 eta5 eta6 eta7 eta8 eta9 eta10 eta11 eta12 eta13 eta14'
    derivative_order = 2
    outputs = exodus
    output_properties = 'Dgchi'
  []

  [constants]
    type = GenericConstantMaterial
    prop_names = 'kappa   mu       L  Lv     Va             cb_eq  cgb_eq    kb        gmb    gmm    T  f0   '
                 '  kB      burg_vec  G_mod YXe'
    prop_values = '70.2   5.62     4.58e-5 4.58e-4 0.04092   0.562  0.438    245.0     1.5	  1.5   1200  5.31579 '
                  '8.6173324e-5   0.5      400.0 0.25'
  []

  [f0_test]
    type = ParsedMaterial
    f_name = f0_test
    material_property_names = 'T'
    function = '0.0049*T-0.5799'
    outputs = exodus
  []

  [cm_eq]
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
    f_name = kmv
    material_property_names = 'T  cm_eq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.008 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cm_eq)'
    outputs = exodus
  []
  [kgmatrix_parabola]
    type = ParsedMaterial
    f_name = kmg
    material_property_names = 'T  cm_eq kB Va'
    constant_names = 'c0v  Efv     al'
    constant_expressions = '0.008 3.0 log(c0v)-log(1-c0v)'
    function = '(kB*T/Va*al+Efv/Va)/(c0v-cm_eq)'
    outputs = exodus
  []

  [pg_vdw]
    type = ParsedMaterial
    f_name = pg_vdw
    material_property_names = 'T Va'
    args = 'cg'
    constant_names = 'kb b'
    constant_expressions = '8.6173324e-5 0.085'
    function = 'cg*kb*T/(Va-cg*b)'
    outputs = exodus
  []

  [./XeRate]
    type = ParsedMaterial
    f_name = XeRate
    material_property_names = 'hm'
    args = 'time XolotlXeRate'  # XolotlXeRate is in Xe/(nm^3 * s) & Va is in Xe/nm^3
    # function = 'if(time < 0, 0, XolotlXeRate * hm)'
    function = 'if(time < 0, 0, XolotlXeRate)'
    outputs = exodus
  [../]

  # [./VacRate]
  #   type = ParsedMaterial
  #   f_name = VacRate
  #   material_property_names = 'XeRate'
  #   function = '1.2*XeRate'
  #   outputs = exodus
  # [../]
  [./VacRate]
    type = ParsedMaterial
    f_name = VacRate
    material_property_names = 'XeRate'
    function = '4.0*XeRate'
    outputs = exodus
  [../]

  [./XeRate_ref]
    type = ParsedMaterial
    f_name = XeRate0
    material_property_names = 'Va hm'
    constant_names = 's0'
    constant_expressions = '2.35e-9'  # in atoms/(nm^3 * s)
    args = 'time'
    function = 'if(time < 0, 0, s0 * hm)'
    outputs = exodus
  [../]
  [./VacRate_ref]
    type = ParsedMaterial
    f_name = VacRate0
    material_property_names = 'YXe XeRate0'
    args = 'time'
    function = 'if(time < 0, 0, XeRate0 / YXe)'
    outputs = exodus
  [../]
  [dislocation_density]
    type = PolycrystalDislocationDensityMaterial
    grain_tracker = grain_tracker
    burnup_constant = 4.2654e-5
    outputs = exodus
    burgers_vector = 0.5
    shear_modulus = 400 # eV/nm^3 =  64.1 GPa
    op_num = 15
    time_scale = 1 #s
    length_scale = 1e-9 #nm
  []
  [nucleation_rate]
    type = GrGrDislocNucRate
    k0 = 3e-4
    bounds = bnds
    outputs = exodus
    critical_density = 0.000586138 # dislocation density at 44 GWd/t, nm/nm^3
  []
[]

[MultiApps]
  [./sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = 'xolotl_subapp.i'
    app_type = coupling_xolotlApp
    execute_on = TIMESTEP_END
    library_path = 'lib'
  [../]
[]

[Transfers]
[./fromsubrate]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = Auxv
variable = XolotlXeRate
[../]
[./fromsubmono]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = AuxMono
variable = XolotlXeMono
[../]
[./fromsubfrac]
type = MultiAppInterpolationTransfer
direction = from_multiapp
multi_app = sub_app
source_variable = AuxFrac
variable = XolotlVolumeFraction
[../]
[./tosub]
type = MultiAppInterpolationTransfer
direction = to_multiapp
multi_app = sub_app
source_variable = bnds
variable = AuxGB
[../]
[]


[Postprocessors]
  [DOFs_NL]
    type = NumDOFs
    execute_on = 'initial timestep_end'
    system = NL
  []
  [DOFs_total]
    type = NumDOFs
    execute_on = 'initial timestep_end'
  []
  [dt]
    type = TimestepSize
  []
  [memory]
    type = MemoryUsage
  []
  [nnuc]
    type = DiscreteNucleationData
    inserter = inserter
  []
  [total_time]
    type = PerfGraphData
    execute_on = 'INITIAL TIMESTEP_END'
    data_type = 'TOTAL'
    section_name = 'Root'
  []
  [run_time]
    type = ChangeOverTimePostprocessor
    postprocessor = total_time
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [etab_total_abs]
    type = ElementIntegralVariablePostprocessor
    variable = etab
    use_absolute_value = true
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
  [etab_abs_avg]
    type = ElementAverageValue
    variable = etab
    use_absolute_value = true
  []
  [bnds_avg]
    type = ElementAverageValue
    variable = bnds
  []
  [ngrains]
    type = FeatureFloodCount
    variable = bnds
    threshold = 0.7
  []
  [num_grains]
    type = FeatureFloodCount
    variable = unique_grains
    #thresold = 0.3
  []
  [area]
    type = GrainBoundaryArea
    grains_per_side = 2
  []
  [area_bubble]
    type = GrainBoundaryArea
    grains_per_side = 1
  []
  [feature_counter]
    type = FeatureFloodCount
    variable = etab
    threshold = 0.5
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_end'
  []
  [porosity]
    type = Porosity
    variable = etab
  []
  [max_cg]
    type = ElementExtremeMaterialProperty
    mat_prop = cg_mat
    value_type = max
  []
  [max_pressure]
    type = ElementExtremeMaterialProperty
    mat_prop = pg_vdw
    value_type = max
  []
  [min_pressure]
    type = ElementExtremeMaterialProperty
    mat_prop = pg_vdw
    value_type = min
  []
  [Xe_mono_total]
    type = ElementIntegralVariablePostprocessor
    variable = XolotlXeMono
  []
  [Xe_frac_total]
    type = ElementIntegralVariablePostprocessor
    variable = XolotlVolumeFraction
  []
  [Xe_frac_max]
    type = ElementExtremeValue
    variable = XolotlVolumeFraction
  []
  [Xe_rate_total]
    type = ElementIntegralVariablePostprocessor
    variable = XolotlXeRate
  []
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 123
    grain_num = 4
    # file_name = grains100.txt
  []
  [inserter]
    # The inserter runs at the end of each time step to add nucleation events
    # that happend during the timestep (if it converged) to the list of nuclei
    type = DiscreteNucleationInserter
    hold_time = 0
    time_dependent_statistics = false
    probability = nucleation_rate
    radius = 20
  []
  [map]
    # The map UO runs at the beginning of a timestep and generates a per-element/qp
    # map of nucleus locations. The map is only regenerated if the mesh changed or
    # the list of nuclei was modified.
    # The map converts the nucleation points into finite area objects with a given radius.
    type = DiscreteNucleationMap
    # radius = 20
    int_width = 20
    periodic = eta0
    inserter = inserter
  []
  # [grain_tracker]
  #   type = GrainTracker
  #   compute_var_to_feature_map = true
  #   execute_on = 'initial timestep_begin'
  #   thresold = 0.7
  #   connecting_thresold = 0.01
  #   halo_level = 3
  #   remap_grains = false
  #   compute_halo_maps = true
  # []
  [grain_tracker]
    type = GrainTrackerDislocations
    compute_var_to_feature_map = true
    execute_on = 'initial timestep_begin'
    # dislocation_density_reader = dislocation_density_file
    prefactor = 1e-2
    deformed_grain_num = 4
    compute_halo_maps = true # Only necessary for displaying HALOS
    halo_level = 3
    rand_seed = 198756
    #threshold = 0.2
    #connecting_threshold = 0.15
    reserve_op = 1
    reserve_op_threshold = 0.05
    # thresold = 0.7
    # connecting_thresold = 0.01
    # add_zero_density_grains = true
    # add_default_density_grains = true
    default_density = 1e-5
    remap_grains = true
    # polycrystal_ic_uo = voronoi
    tolerate_failure = true
  []
[]

[BCs]
  [Periodic]
    [all]
      auto_direction = 'x y'
    []
  []
[]

[Adaptivity]
  initial_steps = 3
  max_h_level = 3
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
      variable = etab
    []
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  scheme = 'BDF2'
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap  '
                        '-pc_factor_shift_type -pc_factor_shift_amount'
  petsc_options_value = 'asm         31   preonly   ilu      1  NONZERO 1e-8'
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_factor_shift_type'
  # petsc_options_value = 'hypre    boomeramg      31 nonzero'
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = 'bjacobi  gmres     30'
  petsc_options = '-ksp_converged_reason -snes_converged_reason'
  automatic_scaling = true
  l_tol = 1.0e-3
  l_max_its = 20
  nl_max_its = 12
  nl_rel_tol = 1.0e-6
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

  dtmax = 800000
  end_time = 1e8
[]

[Outputs]
  csv = true
  perf_graph = true
  checkpoint = true

  [console]
    type = Console
    max_rows = 10
    interval = 1
  []
  [exodus]
    type = Exodus
    interval = 100
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
[]

[Debug]
  show_var_residual_norms = true
[]
