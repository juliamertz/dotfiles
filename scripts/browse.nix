{
  mkScript,
  packages,
  lib,
  urlencode,
  ...
}:
mkScript [
  "browse"
  "duck"
]
<|
  # sh
  ''
    query=$(${lib.getExe urlencode} "$*")

    case $(basename $0) in
      "duck") url="https://lite.duckduckgo.com/lite?kd=-1&kp=-1&q=$query";;
      "google") url="https://google.com/search?q=$query";;
      *) url="$1";;
    esac

    ${lib.getExe packages.w3m} "$url"
  ''
