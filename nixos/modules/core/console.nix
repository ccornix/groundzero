{ pkgs, ... }:

{
  console = {
    font = "ter-v22n";
    keyMap = "us";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
  };
}
