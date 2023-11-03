{ fetchFromSourcehut, buildGo119Module, pkg-config, libxkbcommon }:
buildGo119Module rec {
  pname = "dotool";
  version = "1.4";
  src = fetchFromSourcehut {
    owner = "~geb";
    repo = pname;
    rev = version;
    hash = "sha256-bRp5Zmo71efjqJsoaQwu09SRJ3pgHpCq9kcgawT81SI=";
  };
  vendorSha256 = "sha256-obdCAEoaqLfrES3CVyC5CBErwJSev7UpMLSAHmjJZ4A=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxkbcommon ];
  postInstall = ''
    install -D $src/80-dotool.rules $out/lib/udev/rules.d/80-dotool.rules
  '';
}
