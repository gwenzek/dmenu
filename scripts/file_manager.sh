# https://github.com/jukil/dmenu-scripts-collection/blob/master/dmenu_fm/dmenu_fm

DMENU=/usr/local/bin/dmenu
LS_OPTIONS="--group-directories-first --classify"
DMENU_OPTIONS="-i -l 20"

current_folder=$HOME
file=$current_folder

function header() {
  echo "$(basename $1)/"
}

while [ "$file" ]; do
  echo "Current: $current_folder"
  file=$(ls -a $LS_OPTIONS $current_folder | $DMENU $DMENU_OPTIONS -p $(header $current_folder))
  echo "Selected: $file"

  if [ "$file" == "" ]; then
    exit
  fi
  # strip classifier chars
  file=${file%[*/]}

  if [ "$file" == "." ]; then
    nautilus $current_folder &
    exit
  fi

  # compute absolute path to selected file
  file=$(readlink -f "$current_folder/$file")

  if [ -e "$file" ]; then
    if [ -d "$file" ]; then
      current_folder=$file
    else [ -f "$file" ]
      if which xdg-open &> /dev/null; then
        exec xdg-open "$file" &
        unset file
      fi
    fi
  fi
done

