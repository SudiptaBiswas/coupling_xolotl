//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "coupling_xolotlTestApp.h"
#include "MooseMain.h"

// Begin the main program.
int main(int argc, char *argv[]) {
	Moose::main<coupling_xolotlTestApp>(argc, argv);	

	return 0;
}
