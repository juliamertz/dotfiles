{
  picom,
  wrapPackage,
  ...
}:
wrapPackage {
  package = picom;
  appendFlags = "--config ${./picom.conf}";
}
