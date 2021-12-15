//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PolycrystalGBBubbleIC.h"

// MOOSE includes
#include "MooseMesh.h"
#include "MooseVariable.h"
#include "DelimitedFileReader.h"
#include "GrainTrackerInterface.h"

InputParameters PolycrystalGBBubbleIC::actionParameters() {
	InputParameters params = ::validParams<MultiSmoothCircleIC>();

	return params;
}

registerMooseObject("coupling_xolotlApp", PolycrystalGBBubbleIC);

InputParameters PolycrystalGBBubbleIC::validParams() {
	InputParameters params = PolycrystalGBBubbleIC::actionParameters();
	params.addRequiredParam < UserObjectName
			> ("poly_ic_uo", "UserObject for obtaining the polycrystal grain structure.");
	return params;
}

PolycrystalGBBubbleIC::PolycrystalGBBubbleIC(const InputParameters &parameters) :
		MultiSmoothCircleIC(parameters), _poly_ic_uo(
				getUserObject < Polycrystal > ("poly_ic_uo")) {
	if (_invalue < _outvalue)
		mooseError("PolycrystalGBBubbleIC requires that the voids be "
				"represented with invalue > outvalue");
}

void PolycrystalGBBubbleIC::initialSetup() {

	// Call initial setup from MultiSmoothCircleIC to create _centers and _radii
	// for voids
	MultiSmoothCircleIC::initialSetup();
}

void PolycrystalGBBubbleIC::computeCircleRadii() {
	MultiSmoothCircleIC::computeCircleRadii();
}

void PolycrystalGBBubbleIC::computeCircleCenters() {

	// Obtain the centers of the circles
	_centers = _poly_ic_uo.getBubbleLocations();
}

Real PolycrystalGBBubbleIC::value(const Point &p) {
	Real value = 0.0;

	// Determine value for voids
	Real void_value = MultiSmoothCircleIC::value(p);
	value = void_value;

	return value;
}

RealGradient PolycrystalGBBubbleIC::gradient(const Point &p) {
	RealGradient gradient;
	RealGradient void_gradient = MultiSmoothCircleIC::gradient(p);

	// Order parameter assignment assumes zero gradient (sharp interface)
	gradient = void_gradient;

	return gradient;
}
