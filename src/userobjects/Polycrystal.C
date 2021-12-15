//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Polycrystal.h"
#include "IndirectSort.h"
#include "MooseRandom.h"
#include "MooseMesh.h"
#include "MooseVariable.h"
#include "NonlinearSystemBase.h"
#include "DelimitedFileReader.h"

registerMooseObject("coupling_xolotlApp", Polycrystal);

InputParameters Polycrystal::validParams() {
	InputParameters params = PolycrystalVoronoi::validParams();
	params.addRequiredParam < VariableName > ("bnds_var", "bnds variable name");
	params.addRequiredParam<int>("num_bub", "the number of bubbles to create");
	params.addRequiredParam < Real > ("radius_bub", "radius of the bubbles");
	params.addParam<unsigned int>("rand_seed", 0, "The random seed");
	params.addClassDescription(
			"Creates list of bubbles along grain boundary of polycrystal structure");
	return params;
}

Polycrystal::Polycrystal(const InputParameters &parameters) :
		PolycrystalVoronoi(parameters), _bndsvar_name(
				getParam < VariableName > ("bnds_var")), _num_bub(
				getParam<int>("num_bub")), _radius_bub(
				getParam < Real > ("radius_bub")), _rand_seed(
				getParam<unsigned int>("rand_seed")) {
}

void Polycrystal::execute() {
	if (!_executed) {
		// Create a list of GB
		std::vector<double> localGBList;

//		auto &sys = _fe_problem.getSystem(_bndsvar_name);
		auto &bnds = _fe_problem.getVariable(0, _bndsvar_name,
				Moose::VarKindType::VAR_ANY,
				Moose::VarFieldType::VAR_FIELD_STANDARD);
		for (const auto &node : as_range(_mesh.localNodesBegin(),
				_mesh.localNodesEnd())) {

			dof_id_type dof_bnds = node->dof_number(bnds.sys().number(),
					bnds.number(), 0);
			// Get the value
			Real value = bnds.sys().solution()(dof_bnds);
			// Test if it is a GB
			if (value < 0.9) {
				localGBList.push_back((*node)(0));
				localGBList.push_back((*node)(1));
				localGBList.push_back((*node)(2));
			}
		}
		bnds.sys().solution().close();

		// Share the vector
		int procId;
		MPI_Comm_rank(comm().get(), &procId);
		int worldSize;
		MPI_Comm_size(comm().get(), &worldSize);

		// Need to create an array of size worldSize where each entry
		// is the number of element on the given procId
		int toSend = localGBList.size();

		std::cout << toSend << std::endl;

		// Receiving array for number of elements
		int counts[worldSize];
		MPI_Allgather(&toSend, 1, MPI_INT, counts, 1, MPI_INT, comm().get());

		// Define the displacements
		int displacements[worldSize];
		int totalSize = 0;
		for (auto i = 0; i < worldSize; i++) {
			totalSize += counts[i];
			if (i == 0)
				displacements[i] = 0;
			else
				displacements[i] = displacements[i - 1] + counts[i - 1];
		}

		// Receiving array
		double broadcastedGB[totalSize];
		MPI_Allgatherv(localGBList.data(), toSend, MPI_DOUBLE, &broadcastedGB,
				counts, displacements, MPI_DOUBLE, comm().get());

		MooseRandom::seed (_rand_seed);

		// We want num_bub bubbles
		while (_bubble_loc.size() < _num_bub) {
			// Get a random number
			auto nPick = int(MooseRandom::rand() * (totalSize / 3));
			auto xPick = broadcastedGB[3 * nPick], yPick = broadcastedGB[3
					* nPick + 1], zPick = broadcastedGB[3 * nPick + 2];

			// Add the bubble
			Point bubble = Point(xPick, yPick, zPick);
			_bubble_loc.push_back(bubble);
		}
	}

	_executed = true;
}
