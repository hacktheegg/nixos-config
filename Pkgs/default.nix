{ pkgs }:

{
  script = import ./script { inherit pkgs; };
}
