# enables sshd on devices
{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    forwardX11 = true;
    startWhenNeeded = true;
    extraConfig = ''
      ClientAliveInterval 30
      ClientAliveCountMax 20
    '';
  };
}
