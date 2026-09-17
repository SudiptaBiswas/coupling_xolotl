# This script determines the equilibrium compositions of two co-existing phases in a ternary
# system, assuming that each phase has a parabolic dependence of free energy on composition
# and that that the composition of one species in one of the phases is known. The other compositions are
# determined by the common tangent plane construction between the two paraboloids. Numerically
# this is done by solving 3 equations for 3 unknowns. The three equations are equality of chemical
# potential of two solute species and equality of grand potentials between the two phases. The
# 3 unknowns (output at the end) are the 1 unknown solute composition in one phase (since one is specified
# as an input parameter) and two unknown solute compositions in the other phase. These equilibrium
# compositions are output at the end.

# 2/6/23 Parameters here for solid-gas bubble with interstitial Xenon, so cv_min = 1 in the bubble
# 7/31/24 Updating to use grand potential model, where mu = Va * df/dc and rho = c / Va

from scipy.optimize import fsolve

cgb = 3.32e-2
Va = 0.04092
#inital guesses as starting point for solver
cvb0 = 1
cgm0 = 0
cvm0 = 0

#Bubble phase parameters
kvb = 10
cvbmin = 1
kgb = 0.09889
cgbmin = 1.0037
f0 = -4.847e-2

#Matrix phase parameters
kvm = 7.7515
cvmmin = 0
kgm = 7.7515
cgmmin = 0


def equations(p):
    cvb, cgm, cvm = p
    #Chemical potentials
    muvm = Va * kvm * (cvm - cvmmin)
    muvb = Va * kvb * (cvb - cvbmin)
    mugm = Va * kgm * (cgm - cgmmin)
    mugb = Va * kgb * (cgb - cgbmin)

    #Free energies
    f_b = 0.5 * kvb * (cvb - cvbmin)**2 + 0.5 * kgb * (cgb - cgbmin)**2 + f0
    f_m = 0.5 * kvm * (cvm - cvmmin)**2 + 0.5 * kgm * (cgm - cgmmin)**2

    #Grand potentials
    omega_b = f_b - muvb * cvb / Va - mugb * cgb / Va
    omega_m = f_m - muvm * cvm / Va - mugm * cgm / Va


    return (muvm - muvb, mugm - mugb, omega_m - omega_b)

cvbeq, cgmeq, cvmeq =  fsolve(equations, (cvb0, cgm0, cgm0))

print('cgb entered = ', cgb)
print('Corresponding mugb = ', Va * kgb * (cgb - cgbmin))
print('Equilibrium cgm = ', cgmeq)
print('Equilibrium mugm = ', Va * kgm * (cgmeq - cgmmin))
print('Equilibrium cvb = ', cvbeq)
print('Equilibrium muvb = ', Va * kvb * (cvbeq - cvbmin))
print('Equilibrium cvm = ', cvmeq)
print('Equilibrium muvm = ', Va * kvm * (cvmeq - cvmmin))
