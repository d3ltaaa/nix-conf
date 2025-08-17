{ lib, ... }:
{
  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      port = 587;
      host = lib.strings.trim (builtins.readFile "/etc/credentials/mail/host");
      from = lib.strings.trim (builtins.readFile "/etc/credentials/mail/email");
      user = lib.strings.trim (builtins.readFile "/etc/credentials/mail/email");
      passwordeval = "cat /etc/credentials/mail/password";
    };
  };
}
