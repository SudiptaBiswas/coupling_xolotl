[Problem]
  solve = false
[]

[GlobalParams]
  int_width = 8
  # nbub = 1
  radius = 20
  # contact_angle = 60
  # placement =
  bubspac = 1
  numbub = 1
  op_num = 4
  grain_num = 4
  var_name_base = gr
  # rand_seed = 123
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 200
  ymax = 200
  # xmin = -4
  # ymin = -4
  uniform_refine = 1
[]

[AuxVariables]
  [bnds]
  []
  [diff_s]
    order = FIRST
    family = MONOMIAL
  []
  [diff_gb]
    order = FIRST
    family = MONOMIAL
  []
  [diffb]
    order = FIRST
    family = MONOMIAL
  []
  [diff]
    order = FIRST
    family = MONOMIAL
  []
  [hb]
    order = CONSTANT
    family = MONOMIAL
  []
  [hm]
    order = CONSTANT
    family = MONOMIAL
  []
  [diff_mat]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [bnds]
    type = BndsCalcAux
    variable = bnds
    v = 'gr0 gr1 gr2 gr3'
    execute_on = 'INITIAL'
  []
  [diff_s]
    type = MaterialRealAux
    property = Ds
    variable = diff_s
    execute_on = 'INITIAL'
  []
  [diff_gb]
    type = MaterialRealAux
    property = Dgb
    variable = diff_gb
    execute_on = 'INITIAL'
  []
  [diffb]
    type = MaterialRealAux
    property = Db
    variable = diffb
    execute_on = 'INITIAL'
  []
  [diff]
    type = MaterialRealAux
    property = D
    variable = diff
    execute_on = 'INITIAL'
  []
  [diff_mat]
    type = MaterialRealAux
    property = diffusivity
    variable = diff_mat
    execute_on = 'INITIAL'
  []
  [hm]
    type = MaterialRealAux
    property = hm
    variable = hm
    execute_on = 'INITIAL'
  []
  [hb]
    type = MaterialRealAux
    property = hb
    variable = hb
    execute_on = 'INITIAL'
  []
[]

[Variables]
  [PolycrystalVariables]
  []
  [bubble]
  []
[]

[ICs]
  # [gr0IC]
  #   type = BubblesBicrystalIC
  #   feature_type = left_grain
  #   variable = gr0
  #   # profile = COS
  #   # profile = TANH
  # []
  # [gr1IC]
  #   type = BubblesBicrystalIC
  #   feature_type = right_grain
  #   variable = gr1
  #   # profile = TANH
  #   # profile = COS
  # []
  # [bubblesIC]
  #   type = BubblesBicrystalIC
  #   feature_type = bubble
  #   variable = bubble
  #   # profile = TANH
  #   # profile = COS
  # []
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      invalue = 1.0
      outvalue = 0.0
      polycrystal_ic_uo = voronoi
      rand_seed = 1586
    [../]
  [../]
  [./bubble_IC]
    variable = bubble
    type = PolycrystalVoronoiVoidIC
    structure_type = voids
    invalue = 1.0
    outvalue = 0.0
    polycrystal_ic_uo = voronoi
    rand_seed = 1586
  [../]
[]

[Materials]
  [Diff_v]
    type = PolycrystalDiffusionFunctionMaterial
    c = bubble
    v = 'gr0 gr1 gr2 gr3'
    diffusivity = diffusivity
    bub_switch = hb
    mat_switch = hm
    Dbulk = 1.0 # this value is obatined from Matzke 1987, cluster dynamics value is in the order of 1e-7
    Dsurf = 1.0
    surfindex = 1.0
    gbindex = 1.0
    bulkindex = 1.0
    bubbleindex = 10.0
    Dgb = 1.0
    outputs = exodus
    output_properties = 'diffusivity'
  []
  [./hb]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hb
    all_etas = 'bubble gr0 gr1 gr2 gr3'
    phase_etas = 'bubble'
    # outputs = exodus
  [../]
  [./hm]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = hm
    all_etas = 'bubble gr0 gr1 gr2 gr3'
    phase_etas = 'gr0 gr1 gr2 gr3'
    # outputs = exodus
  [../]
  [Ds]
    type = ParsedMaterial
    f_name = Ds
    args = 'bubble'
    function = '30*bubble*bubble*(1-bubble)*(1-bubble)'
    outputs = exodus
  []
  [Dgb]
    type = ParsedMaterial
    f_name = Dgb
    args = 'gr0 gr1 gr2 gr3'
    function = '9*2*(gr0*gr0*gr1*gr1+gr1*gr1*gr2*gr2+gr3*gr3*gr2*gr2+gr0*gr0*gr2*gr2+gr0*gr0*gr3*gr3+gr1*gr1*gr3*gr3)'
    outputs = exodus
  []
  [Db]
    type = ParsedMaterial
    f_name = Db
    args = 'gr0 gr1 gr2 gr3'
    material_property_names = 'hm hb'
    function = 'hm+10*hb'
    outputs = exodus
  []
  [D]
    type = ParsedMaterial
    f_name = D
    args = 'gr0 gr1 gr2 gr3'
    material_property_names = 'Dgb Ds hm hb'
    function = 'Ds+Dgb+hm+10*hb'
    outputs = exodus
  []
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    rand_seed = 1856
    int_width = 8
  []
[]

[Postprocessors]
  [Volume]
    type = VolumePostprocessor
    execute_on = 'initial'
  []
  [diffs_total]
    type = ElementIntegralVariablePostprocessor
    variable = diff_s
  []
  [diffs_avg]
    type = ElementAverageValue
    variable = diff_s
  []
  [difgb_total]
    type = ElementIntegralVariablePostprocessor
    variable = diff_gb
  []
  [diffgb_avg]
    type = ElementAverageValue
    variable = diff_gb
  []
[]

[Executioner]
  type = Steady
[]

[Outputs]
  execute_on = 'initial'
  exodus = true
  perf_graph = true
  # file_base = bicrystal_bubbles_poly
  # file_base = bicrystal_bubbles_cos
  # file_base = bicrystal_bubbles_tanh
[]
