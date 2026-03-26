{ self, ... }:
let
  overlay-local = import "${self}/pkgs";
in
{
  nixpkgs = {
    overlays = [
      overlay-local
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pythonFinal: pythonPrev: {
            looptime = pythonPrev.looptime.overridePythonAttrs (old: {
              disabledTestPaths = [
                # Time-based tests that fail pretty predictably on darwin but pass on linux
                "tests/test_chronometers.py::test_duration_resets_on_reuse"
                "tests/test_chronometers.py::test_conversion_to_float"
                "tests/test_chronometers.py::test_sync_context_manager"
                "tests/test_chronometers.py::test_async_context_manager"
                "tests/test_plugin.py::test_fixture_chronometer"
                "tests/test_time_moves.py::test_real_time_is_ignored"
                "tests/test_time_on_executors.py::test_with_sleep"
                "tests/test_time_on_io_idle.py::test_end_of_time"
                "tests/test_time_on_io_idle.py::test_no_idle_configured"
                "tests/test_time_on_io_idle.py::test_stepping_with_no_limit"
              ];
            });
          })
        ];
      })
    ];
    config = {
      allowUnfree = true;
      # allowAliases = false;
      permittedInsecurePackages = [ ];
    };
  };

}
