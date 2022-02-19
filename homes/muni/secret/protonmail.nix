# will require hydroxide or other protonmail bridge
let
  # change these
  realName = "municorn";
  userName = "municorn";
in
{
  address = "${userName}@protonmail.com";
  flavor = "plain";
  maildir.path = "protonmail";
  passwordCommand = "pass protonmail/hydroxide";
  realName = realName;
  userName = userName;

  imap = {
    host = "127.0.0.1";
    port = 1143;
    tls.enable = false;
  };
  smtp = {
    host = "127.0.0.1";
    port = 1025;
    tls.enable = false;
  };

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
