{ lib
, buildPythonPackage
, cmake
, cvxopt
, fetchPypi
, future
, numpy
, oldest-supported-numpy
, pytestCheckHook
, pythonOlder
, qdldl
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A+Rg5oPsLOD4OTU936PEyP+lCauM9qKyr7tYb6RT4YA=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    oldest-supported-numpy
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
    numpy
    qdldl
    scipy
  ];

  nativeCheckInputs = [
    cvxopt
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "osqp"
  ];

  disabledTests = [
    # Need an unfree license package - mkl
    "test_issue14"
  ]
  # disable tests failing after scipy 1.12 update
  # https://github.com/osqp/osqp-python/issues/121
  # re-enable once unit tests fixed
  ++ [
    "feasibility_tests"
    "polish_tests"
    "update_matrices_tests"
  ];

  meta = with lib; {
    description = "The Operator Splitting QP Solver";
    longDescription = ''
      Numerical optimization package for solving problems in the form
        minimize        0.5 x' P x + q' x
        subject to      l <= A x <= u

      where x in R^n is the optimization variable
    '';
    homepage = "https://osqp.org/";
    downloadPage = "https://github.com/oxfordcontrol/osqp-python/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
