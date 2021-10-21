//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "MultiSmoothCircleIC.h"
#include "MooseRandom.h"
#include "PolycrystalICTools.h"
#include "Polycrystal.h"

// Forward Declarationsc
class GrainTrackerInterface;

/**
 * PolycrystalVoronoiVoidIC initializes either grain or void values for a
 * voronoi tesselation with voids distributed along the grain boundaries.
 */
class PolycrystalGBBubbleIC: public MultiSmoothCircleIC {
public:
	static InputParameters validParams();

	PolycrystalGBBubbleIC(const InputParameters &parameters);

	virtual void initialSetup() override;

	static InputParameters actionParameters();

protected:

	const Polycrystal &_poly_ic_uo;

	virtual void computeCircleRadii() override;
	virtual void computeCircleCenters() override;

	virtual Real value(const Point &p) override;
	virtual RealGradient gradient(const Point &p) override;
};
