{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, hspec, mtl, stdenv, stm, time
      , transformers
      }:
      mkDerivation {
        pname = "hspec-slow";
        version = "0.1.0.0";
        src = ./.;
        libraryHaskellDepends = [ base hspec mtl stm time transformers ];
        testHaskellDepends = [ base hspec mtl stm ];
        homepage = "https://github.com/bobjflong/hspec-slow#readme";
        description = "Find slow test cases";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
