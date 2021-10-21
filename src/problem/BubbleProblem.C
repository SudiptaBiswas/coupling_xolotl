//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "BubbleProblem.h"
#include "SystemBase.h"
#include "MooseRandom.h"

registerMooseObject("coupling_xolotlApp", BubbleProblem);

template<>
InputParameters validParams<BubbleProblem>() {
	InputParameters params = validParams<ExternalProblem>();
	params.addRequiredParam < VariableName > ("bnds_var", "bnds variable name");
	params.addRequiredParam<int>("num_bub", "the number of bubbles to create");
	params.addRequiredParam < Real > ("radius_bub", "radius of the bubbles");
	params.addParam<unsigned int>("rand_seed", 0, "The random seed");
	params.addClassDescription(
			"Creates list of bubbles along grain boundary of polycrystal structure");
	return params;
}

BubbleProblem::BubbleProblem(const InputParameters &params) :
		ExternalProblem(params), _bndsvar_name(
				getParam < VariableName > ("bnds_var")), _num_bub(
				getParam<int>("num_bub")), _radius_bub(
				getParam < Real > ("radius_bub")), _rand_seed(
				getParam<unsigned int>("rand_seed")) {
}

void BubbleProblem::externalSolve() {
	MeshBase &to_mesh = mesh().getMesh();
	auto &bnds = getVariable(0, _bndsvar_name, Moose::VarKindType::VAR_ANY,
			Moose::VarFieldType::VAR_FIELD_STANDARD);

	// Create a list of GB
	std::vector<double> localGBList;

	for (const auto &node : as_range(to_mesh.local_nodes_begin(),
			to_mesh.local_nodes_end())) {
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
	MPI_Comm_rank(MPI_COMM_WORLD, &procId);
	int worldSize;
	MPI_Comm_size(MPI_COMM_WORLD, &worldSize);

	// Need to create an array of size worldSize where each entry
	// is the number of element on the given procId
	int toSend = localGBList.size();

	// Receiving array for number of elements
	int counts[worldSize];
	MPI_Allgather(&toSend, 1, MPI_INT, counts, 1, MPI_INT, MPI_COMM_WORLD);

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
	MPI_Gatherv(localGBList.data(), toSend, MPI_DOUBLE, &broadcastedGB, counts,
			displacements, MPI_DOUBLE, 0, MPI_COMM_WORLD);

	// Only work on one task now
	if (procId != 0)
		return;

	MooseRandom::seed (_rand_seed);

	// We want num_bub bubbles
	std::vector < std::vector<double> > bubbleLoc;
	while (bubbleLoc.size() < _num_bub) {
		// Get a random number
		auto nPick = int(MooseRandom::rand() * (totalSize / 3));
		auto xPick = broadcastedGB[3 * nPick], yPick = broadcastedGB[3 * nPick
				+ 1], zPick = broadcastedGB[3 * nPick + 2];

		// Check the location with regard to the other selected bubbles
		bool tooClose = false;
		for (auto bubble : bubbleLoc) {
			if (interdist(xPick, yPick, zPick, bubble[0], bubble[1], bubble[2])
					<= 2.0 * _radius_bub) {
				tooClose = true;
				break;
			}
		}

		if (tooClose)
			continue;

		// Add the bubble
		std::vector<double> bubble = { xPick, yPick, zPick };
		bubbleLoc.push_back(bubble);
	}

	// Print in a file
	std::ofstream outputFile;
	outputFile.open("bub_coords.txt");
	for (auto bubble : bubbleLoc) {
		outputFile << bubble[0] << " " << bubble[1] << " " << bubble[2] << " "
				<< _radius_bub << std::endl;
	}
	outputFile.close();
}

bool BubbleProblem::converged() {
	return true;
}

void BubbleProblem::syncSolutions(Direction direction) {
}

Real BubbleProblem::interdist(Real xto, Real yto, Real zto, Real xfrom,
		Real yfrom, Real zfrom) {
	return sqrt(pow(xfrom - xto, 2) + pow(yfrom - yto, 2) + pow(zfrom - zto, 2));
}
