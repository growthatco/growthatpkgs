{ dir, pkgs }:

{ implementation, libPrefix, executable, sourceVersion, pythonVersion
, packageOverrides, sitePackages, hasDistutilsCxxPatch, pythonOnBuildForBuild
, pythonOnBuildForHost, pythonOnBuildForTarget, pythonOnHostForHost
, pythonOnTargetForTarget, self # is pythonOnHostForTarget
}:
let
  packageFile = path: dir + "/${path}";
	rootFile = 

  pythonPackages = callPackage ({ pkgs, stdenv, python, overrides }:
    let
      pythonPackagesFun = import ../../../top-level/python-packages.nix {
        inherit stdenv pkgs lib;
        python = self;
      };
      otherSplices = {
        selfBuildBuild = pythonOnBuildForBuild.pkgs;
        selfBuildHost = pythonOnBuildForHost.pkgs;
        selfBuildTarget = pythonOnBuildForTarget.pkgs;
        selfHostHost = pythonOnHostForHost.pkgs;
        selfTargetTarget =
          pythonOnTargetForTarget.pkgs or { }; # There is no Python TargetTarget.
      };
      keep = self: {
        # TODO maybe only define these here so nothing is needed to be kept in sync.
        inherit (self)
          isPy27 isPy35 isPy36 isPy37 isPy38 isPy39 isPy3k isPyPy pythonAtLeast
          pythonOlder python bootstrapped-pip buildPythonPackage
          buildPythonApplication fetchPypi hasPythonModule requiredPythonModules
          makePythonPath disabledIf toPythonModule toPythonApplication
          buildSetupcfg

          condaInstallHook condaUnpackHook eggUnpackHook eggBuildHook
          eggInstallHook flitBuildHook pipBuildHook pipInstallHook
          pytestCheckHook pythonCatchConflictsHook pythonImportsCheckHook
          pythonNamespacesHook pythonRecompileBytecodeHook
          pythonRemoveBinBytecodeHook pythonRemoveTestsDirHook
          setuptoolsBuildHook setuptoolsCheckHook venvShellHook wheelUnpackHook

          wrapPython

          pythonPackages

          recursivePthLoader;
      };
      extra = _: { };
      optionalExtensions = cond: as: if cond then as else [ ];
      python2Extension = import ../../../top-level/python2-packages.nix;
      extensions = lib.composeManyExtensions
        ((optionalExtensions (!self.isPy3k) [ python2Extension ])
          ++ [ overrides ]);
      aliases = self: super:
        lib.optionalAttrs (config.allowAliases or true)
        (import ../../../top-level/python-aliases.nix lib self super);
    in lib.makeScopeWithSplicing pkgs.splicePackages pkgs.newScope otherSplices
    keep extra (lib.extends (lib.composeExtensions aliases extensions)
      pythonPackagesFun)) { overrides = packageOverrides; };
in rec {
  isPy27 = pythonVersion == "2.7";
  isPy35 = pythonVersion == "3.5";
  isPy36 = pythonVersion == "3.6";
  isPy37 = pythonVersion == "3.7";
  isPy38 = pythonVersion == "3.8";
  isPy39 = pythonVersion == "3.9";
  isPy310 = pythonVersion == "3.10";
  isPy2 = lib.strings.substring 0 1 pythonVersion == "2";
  isPy3 = lib.strings.substring 0 1 pythonVersion == "3";
  isPy3k = isPy3;
  isPyPy = lib.hasInfix "pypy" interpreter;

  buildEnv = callPackage (packageFile "wrapper.nix") {
    python = self;
    inherit (pythonPackages) requiredPythonModules;
  };
  withPackages = import (packageFile "with-packages.nix") {
    inherit buildEnv pythonPackages;
  };
  pkgs = pythonPackages;
  interpreter = "${self}/bin/${executable}";
  inherit executable implementation libPrefix pythonVersion sitePackages;
  inherit sourceVersion;
  pythonAtLeast = lib.versionAtLeast pythonVersion;
  pythonOlder = lib.versionOlder pythonVersion;
  inherit hasDistutilsCxxPatch;
  # TODO: rename to pythonOnBuild
  # Not done immediately because its likely used outside Nixpkgs.
  pythonForBuild = pythonOnBuildForHost.override {
    inherit packageOverrides;
    self = pythonForBuild;
  };

  tests = callPackage (packageFile "tests.nix") { python = self; };
}
