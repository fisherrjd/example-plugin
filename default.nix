{ pkgs ? import
    (fetchTarball {
      name = "jpetrucciani-2025-09-01";
      url = "https://github.com/jpetrucciani/nix/archive/8ba3bd2fda347249f924039d7bca882265424cda.tar.gz";
      sha256 = "14cm30pfs2jgbrmdvzvy87gdr1p4dgxx8g3x62qar6j0aw2p5r5n";
    })
    { }
}:
let
  name = "example-plugin";

  tools = with pkgs; {
    cli = [
      jfmt
      nixup
    ];
    java = [
      gradle
      zulu11
    ];
    scripts = pkgs.lib.attrsets.attrValues scripts;
  };

  scripts = with pkgs; { };
  paths = pkgs.lib.flatten [ (builtins.attrValues tools) ];
  env = pkgs.buildEnv {
    inherit name paths; buildInputs = paths;
  };
in
(env.overrideAttrs (_: {
  inherit name;
  NIXUP = "0.0.9";
})) // { inherit scripts; }
