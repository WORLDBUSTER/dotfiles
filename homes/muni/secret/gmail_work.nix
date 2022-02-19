let
  # change these
  domain = "unbanked.com";
  realName = "municorn";
  userName = "municorn";
in
{
  address = "${userName}@${domain}";
  flavor = "gmail.com";
  maildir.path = "work";
  passwordCommand = "pass work/email";
  realName = realName;
  primary = true;

  himalaya = {
    enable = true;
  };
  mbsync = {
    enable = true;
    create = "maildir";
  };
  msmtp.enable = true;
  neomutt = {
    enable = true;
  };
}
