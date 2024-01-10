//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef XOLOTLPROBLEM_H
#define XOLOTLPROBLEM_H

#include "ExternalProblem.h"
#include "coupling_xolotlApp.h"

/**
 * This is an interface to call an external solver
 */
class XolotlProblem : public ExternalProblem
{
public:
  static InputParameters validParams();

  XolotlProblem(const InputParameters & params);
  ~XolotlProblem() { _interface->finalizeXolotl(); }

  virtual void externalSolve() override;
  virtual void syncSolutions(Direction /*direction*/) override;

  virtual bool converged();

  // Methods for restart
  void saveState();
  void setState();

private:
  /// The name of the variable to transfer to
  const VariableName & _sync_rate;
  const VariableName & _sync_gb;
  const VariableName & _sync_mono;
  const VariableName & _sync_frac;
  bool _free_surface;
  std::shared_ptr<XolotlInterface> _interface;
  Real _dt_for_derivative;
  std::vector<std::vector<std::vector<Real>>> & _old_rate;
  std::vector<int> _gb_list;
  Real & _current_time;
  bool _xolotl_has_run;

  // Variables for restart
  Real & _current_dt;
  Real & _previous_time;
  Real & _n_xenon;
  std::vector<std::vector<std::vector<std::array<Real, 4>>>> & _local_NE;
  std::vector<std::vector<std::vector<std::vector<std::pair<xolotl::IdType, Real>>>>> &
      _conc_vector;
};

#endif /* XOLOTLPROBLEM_H */
