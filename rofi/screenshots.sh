# depends on: rofi, scrot and imagemagick

dir=$(dirname "$0")

timeout=2
echo You have $timeout seconds to switch to an empty workspace! && sleep $timeout;

generate() {
  variant=$1

  rofi -show drun -theme "$HOME/dotfiles/rofi/themes/rose-pine-$variant.rasi" &
  pid=$!

  scrot temp.png --monitor 0 --delay 1 && \
  kill $pid

  magick temp.png -gravity center -crop 1300x420+0+0 +repage "$dir/$variant.png" 
  rm temp.png
}

generate main
generate moon
generate dawn
