{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    cmake
    ninja
    git
    cacert
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    freetype
    libGL
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
  ];

  env = {
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-certificates.crt";
  };
}
