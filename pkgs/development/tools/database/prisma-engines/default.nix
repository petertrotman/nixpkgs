{ fetchFromGitHub
, lib
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
}:

let
  node-api-lib = (if stdenv.isDarwin then "libquery_engine.dylib" else "libquery_engine.so");
in rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = "2.30.2";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    sha256 = "sha256-39+pEjve7evxcjcBK1JLTRNNjfUMoCgSgtYcdJ3zIKE=";
  };

  cargoPatches = [
    # Remove test from compilation targets:
    # they add time to an already long compilation and some fail out-of-the-box.
    ./no_tests.patch
  ];

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "sha256-BldEj8+tzY0dIA/fdrPLsFn3ZdfoGq6GsomCUhQBoLM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl protobuf ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${openssl.out}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000
  '';

  postInstall = ''
    mv $out/lib/${node-api-lib} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "A collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pamplemousse pimeys ];
  };
}
