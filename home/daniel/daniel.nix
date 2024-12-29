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
      ];
      initialHashedPassword = "$y$j9T$JcyQRA1bfYBw2j/a3D75A.$OQfpPyw2RNuj7G6C8oY6sQKY2X/ttB77VZgQu6./bg8";
    };
  };
}