{...}: {
    config = {
        programs.ssh = {
            startAgent = true;
            enableAskPassword = true;
        };

        environment.variables = {
            SSH_ASKPASS_REQUIRE = "prefer";
        };
    };
}
