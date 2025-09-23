{config, lib, ...}:

{
  config = lib.mkIf (builtins.elem "daniel" config.userConfig.users) {
    users.users.daniel = {
      isNormalUser = true;
      description = "Daniel";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "gamemode"
        "vboxusers"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCMkac5FvL0j9jMZ61ccNyXw6+9ENeEg7yajjPX0p8hAqCKhyWv/bpIcFKx6CZIqXDvLsW3QYc6+xFEePnaCjEoUTxlncctqLUDxT+TeCimsyfSONhJJGRHYRcIxOxoluyGjsjlhv5PX2kDAguqXy3vNoZ1l6utRlWJ9hYYCuE74vGEXZWtu0vo6c0db96iXORB6RxphPXmrP295QGapn+RQM/t+3rIkhqOktG2idUC33dRbCPpO3WfzZhqwQ2hHLsJuiKBJYpfeaGXgCcM2j1dgYhoM3aM+SgDnYRex/EOFYYzP7O5lCZ4UOnZyH7rMVLTBIbWBRpTfvGxG75wNzBk3Z/rtXrrgrwlVI50VbwSBtic4Ougk0GrV5/7GuzzBdLU7bN2HB7n+YMJw+WnYLIfp9bGnDsJ1DBNqGFFgbeLA60/D57yRPQog1rH0PWwELOfwr7VM0hvEsxhxkm0GYTYJ3oacRkY0OklxdLuR8LdVbS5afTuMacu34T1jiMBWqjMbJljx4eP2Oi1q5bLHvqJjmA6vNIG4uuFbJYZT9vuIqM+j23C5eCJ3tsZjq1TmZr3qBrVdAk3LcfddGUG/MSZIcBPjgA6iO9BbU3Ef54zzykHt1hCFsJS3BDnfx+YH7Y7Ta5nBND3oyrklBUOfN/Fjxd6kjAHIHag1AOvqluuhw== daniel"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCw6Ywsa3FPVYDWpjEVuaAitvaAnZH4nyJ9Mc+p1e1bhmkEhAN1cDHnF2iY84ZWNNKHOYkKDQckcDRv+jLTozUdU+c8Y8SNhIYrK0T/Ue+Yrvqs30i9LP2J0NKM1hRiKVkWLTOWhBBlz99H6r5u+biQW4XoQPtwgdAPG3gB6zb6V2jaby4PnlStgdk9E7PYhEGq8MsqadzNGwNcLSel5bagYjtZjcn0RSSI+agSKc+FasRkGdozRheD+Kay3+ISFuFXGaSm+gHHEDrdNyAlEb64hQgr8MYbeWDn/gEmB8yJqcllsX+DCt+cL8+Ph8B/pV5VZZCsZoPNI1UgpwTj4XeL0CwICR/G/xNzvWDt/C96vTmy5yxJX9hfkau5aputc3fvHe2Juj9rGj0KrnOh6JenVQ9YsDTo2xhTOeugZ9+FUD07UTArNVXk7UG1rh5Z6w/ZCj5UQGwRWkgdByx7jLVm89HMFAQD/ilOErGSFwmrIOEKBxMhSIzDvqDS6vRAddk= daniel@AnotherUnknownDevice"
      ];
      initialHashedPassword = "$y$j9T$CywaUT3szkkGZi0yBAtQU1$DLV40sBOH2l1eYO2mTDIfc8wSoh56QkmIS5sk6ZVuO7";
    };
  };
}
