//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef BUBBLEPROBLEM_H
#define BUBBLEPROBLEM_H

#include "ExternalProblem.h"
#include "coupling_xolotlApp.h"

class BubbleProblem;

template<>
InputParameters validParams<BubbleProblem>();

/**
 * This is an interface to call an external solver
 */
class BubbleProblem: public ExternalProblem {
public:
	BubbleProblem(const InputParameters &params);
	~BubbleProblem() {
	}

	virtual void externalSolve() override;
	virtual void syncSolutions(Direction /*direction*/) override;

	virtual bool converged() override;

private:
	virtual Real interdist(Real xto, Real yto, Real zto, Real xfrom, Real yfrom,
			Real zfrom);
	const VariableName &_bndsvar_name;
	int _num_bub;
	Real _radius_bub;
	unsigned int _rand_seed;

};

#endif /* BUBBLEPROBLEM_H */
