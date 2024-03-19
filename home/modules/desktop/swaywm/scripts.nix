{ pkgs, ... }:

{
  my-sway-screenshot = pkgs.writeShellApplication {
    name = "my-sway-screenshot";
    text = builtins.readFile ../../../.local/bin/my-sway-screenshot;
    runtimeInputs = with pkgs; [ grim jq sway sway-contrib.grimshot ];
  };

  my-sway-windows = pkgs.writeShellApplication {
    name = "my-sway-windows";
    text = builtins.readFile ../../../.local/bin/my-sway-windows;
    runtimeInputs = with pkgs; [ jq sway ];
  };
}
