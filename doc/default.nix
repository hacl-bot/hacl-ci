{
  mdbook,
  stdenv,
}:
stdenv.mkDerivation {
  name = "hacl-ci-doc";
  src = ./.;
  nativeBuildInputs = [mdbook];
  buildPhase = "mdbook build";
  installPhase = "cp -r book $out";
}
