{
  pkgs,
  variables,
  ...
}:
{
  programs.git = {
    package = pkgs.gitFull;
    config.credential.helper = "manager";
    config.credential."https://github.com".username = "d3ltaaa";
    config.credential.credentialstore = "cache";
  };
}
