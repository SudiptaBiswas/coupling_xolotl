//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "PolycrystalVoronoi.h"

// Forward Declarations
class Polycrystal;

class Polycrystal: public PolycrystalVoronoi {
public:
	static InputParameters validParams();

	Polycrystal(const InputParameters &parameters);

	/**
	 * We override all these functions to avoid calling FeatureFloodCount
	 * We know here is a one-to-one mapping between grain and variable
	 */
	virtual void execute() override;

	virtual std::vector < Point > getBubbleLocations() const {
		return _bubble_loc;
	}

private:
	bool _executed = false;
	const VariableName &_bndsvar_name;
	int _num_bub;
	Real _radius_bub;
	unsigned int _rand_seed;
	std::vector < Point > _bubble_loc;
};
