{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, google-cloud-testutils
, grpc-google-iam-v1
, grpcio-status
, libcst
, mock
, proto-plus
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "2.13.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1ksbqghjKwh0IvL3SsNcwVrQtJJ82ZHJDp/u35sorSg=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    grpcio-status
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests in pubsub_v1 attempt to contact pubsub.googleapis.com
    "tests/unit/pubsub_v1"
  ];

  pythonImportsCheck = [
    "google.cloud.pubsub"
  ];

  meta = with lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://pypi.org/project/google-cloud-pubsub";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
