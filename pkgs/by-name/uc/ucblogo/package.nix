{ gettext, libtool, wxGTK32
, lib
, autoreconfHook
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ucblogo";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "jrincayc";
    repo = "ucblogo-code";
    rev = "version_${version}";
    hash = "sha256-7cJhWirtXAl8h1pmJ6b0/kj4JSvFSTNZTks3qc15KxA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    libtool
    wxGTK32
  ];

  buildInputs = [
  ];

  meta =  {
    homepage = "https://people.eecs.berkeley.edu/~bh/logo.html";
    description = "This is a free (both senses) interpreter for the Logo programming language";
    longDescription = ''
      UCBLogo, also termed Berkeley Logo, is a programming language, a dialect of Logo, which derived from Lisp.
      It is a dialect of Logo intended to be a "minimum Logo standard".
      It can be used to teach most computer science concepts, as University of California, Berkeley lecturer
      Brian Harvey did in his Computer Science Logo Style trilogy.
    '';
    license = lib.licenses.gpl3;
    mainProgram = "ucblogo";
    maintainers = [ lib.maintainers.petertrotman ];
  };
}
