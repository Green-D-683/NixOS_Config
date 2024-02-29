{pkgs, nixpkgs-stable} :
let p = nixpkgs-stable; in
[
  (self: super: {
    self.python3Full = p.python3Full;

    self.python311Packages = super.python311Packages.overrideAttrs (oldAttrs: {
      overrides = self: super: {
        sqlalchemy = super.sqlalchemy_1_4;  
      };
    }); 
    #++ [
    #   (p.python311Packages.eventlet.overrideAttrs (oldAttrs: {
    #     disabledTests = [
    #       "TestGreenSocket::test_full_duplex"
    #       "TestGreenSocket::test_invalid_connection"
    #     ] ++ oldAttrs.disabledTests;
    #   }))



    #   (p.python311Packages.sqlalchemy-migrate.overrideAttrs (oldAttrs: {
    #     propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ ["sqlalchemy_1_4"];
    #   }))
    # ];

  
    #self.openlp = super.hello;
    self.openlp = super.openlp.override{
      sqlalchemy = super.sqlalchemy_1_4;
      sqlalchemy-migrate = super.sqlalchemy-migrate.override{
        sqlalchemy=super.sqlalchemy_1_4;
      };
    };
  
    self.openlpFull = self.openlp.override {
      pdfSupport = true;
      presentationSupport = true;
      vlcSupport = true;
      gstreamerSupport = true;
    };
      # sqlalchemy = super.sqlalchemy.overrideAttrs (oldAttrs: {
      #   version = "1.4.25";  # Replace with the specific compatible version
      # });

      # sqlalchemy-migrate = super.python3Packages.sqlalchemy-migrate.override {
      #   sqlalchemy = super.sqlalchemy.overrideAttrs (oldAttrs: {
      #     version = "1.4.25";  # Replace with the specific compatible version
      #   });
      # };

    # self.python3Packages = p.python3Packages;
  })
]