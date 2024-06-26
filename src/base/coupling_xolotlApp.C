#include "coupling_xolotlApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "XolotlProblem.h"
#include "Executioner.h"
#include "ModulesApp.h"

InputParameters coupling_xolotlApp::validParams() {
	InputParameters params = MooseApp::validParams();

	// By default, use preset BCs
	params.set<bool>("use_legacy_dirichlet_bc") = false;
	params.set<bool>("use_legacy_material_output") = false;

	return params;
}

coupling_xolotlApp::coupling_xolotlApp(InputParameters parameters) :
		MooseApp(parameters), _interface(std::make_shared<XolotlInterface>()), _is_xolotl_app(
				false) {
	coupling_xolotlApp::registerAll(_factory, _action_factory, _syntax);
}

coupling_xolotlApp::~coupling_xolotlApp() {
}

void coupling_xolotlApp::createInterface(FileName paramName) {
	int argc = 2;
	const char* argv[argc + 1];
	std::string fakeAppName = "bla";
	argv[0] = fakeAppName.c_str();
	argv[1] = paramName.c_str();

	_interface->initializeXolotl(argc, argv, _comm->get());

	_is_xolotl_app = true;
}

void coupling_xolotlApp::registerAll(Factory &f, ActionFactory &af, Syntax &s) {
	ModulesApp::registerAll(f, af, s);
	Registry::registerObjectsTo(f, { "coupling_xolotlApp" });
	Registry::registerActionsTo(af, { "coupling_xolotlApp" });

	/* register custom execute flags, action syntax, etc. here */
}

void coupling_xolotlApp::registerApps() {
	registerApp (coupling_xolotlApp);
}

void coupling_xolotlApp::preBackup() {
	if (_is_xolotl_app) {
		// Get the state from Xolotl
		mooseAssert(_executioner, "Executioner is nullptr");
		XolotlProblem &xolotl_problem =
				(XolotlProblem&) _executioner->feProblem();
		xolotl_problem.saveState();
	}
}

void coupling_xolotlApp::postRestore(bool /*for_restart*/) {
	if (_is_xolotl_app) {
		// Set it in Xolotl
		mooseAssert(_executioner, "Executioner is nullptr");
		XolotlProblem &xolotl_problem =
				(XolotlProblem&) _executioner->feProblem();
		xolotl_problem.setState();
	}
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void coupling_xolotlApp__registerAll(Factory &f, ActionFactory &af,
		Syntax &s) {
	coupling_xolotlApp::registerAll(f, af, s);
}

extern "C" void coupling_xolotlApp__registerApps() {
	coupling_xolotlApp::registerApps();
}
