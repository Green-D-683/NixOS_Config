{pkgs, ...}:

with pkgs; [
  openlp
  # openlpFull.override({
  #   sqlalchemy-migrate = sqlalchemy-migrate.override({
  #     sqlalchemy = sqlalchemy_1_4;
  #   });
  #   sqlalchemy = pkgs.python3Packages.sqlalchemy_1_4;
  #   pdfSupport = true;
  #   presentationSupport = true;
  #   vlcSupport = true;
  #   gstreamerSupport = true;
  # })# 
  (pkgs.libsForQt5.callPackage ../derivations/openlp {
    pdfSupport = true;
    presentationSupport = true;
    vlcSupport = true;
    gstreamerSupport = true;})
]