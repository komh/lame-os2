#! /bin/sh

config() {
  n=configure

  target=i686-pc-os2-emx

  export CFLAGS=-Wno-error=incompatible-pointer-types
  export LDFLAGS=-Zhigh-mem

  opts="
    --prefix=/@unixroot/usr/local
    --disable-shared
    --enable-static
    --enable-nasm
"

  crossopts="
    --host=$target
"
}

# convert $2 to the relative path to $1
getrelpath() {
  dir1="$1"
  [ ${#dir1} -gt 1 ] && dir1=${dir1%/}
  dir2="$2"
  [ ${#dir2} -gt 1 ] && dir2=${dir2%/}

  while [ -n "$dir1" ] && [ -n "$dir2" ]; do
    d1="${dir1%%/*}"
    dir1="${dir1#$d1}"
    dir1="${dir1#/}"

    d2="${dir2%%/*}"
    dir2="${dir2#$d2}"
    dir2="${dir2#/}"

    if [ "$(echo "$d1" | tr [:upper:] [:lower])" != \
         "$(echo "$d2" | tr [:upper:] [:lower])" ]; then
      dir1="$d1/$dir1"
      dir1="${dir1%/}"

      dir2="$d2/$dir2"
      dir2="${dir2%/}"

      break
    fi
  done

  while [ -n "$dir1" ]; do
    d1="${dir1%%/*}"
    dir1="${dir1#$d1}"
    dir1="${dir1#/}"
    [ -z "$d1" ] && continue

    dir2="../$dir2"
  done

  getrelpath_result="${dir2%/}"
  getrelpath_result="${getrelpath_result:-.}"
}

run() {
  d="$(dirname "$0")"
  test -f "$d/$n" || { echo "\`$d/$n' not found !!!"; exit 1; }

  if [ -n "$1" ] && [ "${1#-}" = "$1" ]; then
    # $1 is a build dir
    [ -f "$1/configure" ] \
      && { echo "BUILD dir should be different from SOURCE dir!!!"; exit 1; }

    blddir="$1"
    shift
  else
    # $1 is empty or an option. Determine the build dir with configure
    [ -f configure ] && blddir=build || blddir=.
  fi

  # get the absolute path of configure
  srcdir="$(cd "$d"; pwd)"

  [ -f "$d/$n" ] || { echo "\`$d/$n' not found!!!"; exit 1; }

  [ -z "$OS2_SHELL" ] && opts="$opts $crossopts"

  mkdir -p "$blddir" && cd "$blddir" || exit 1

  # convrt the path of configure to the relative path to the build dir
  getrelpath "$(pwd)" "$srcdir"

  eval '"$getrelpath_result/$n"' $opts '"$@"'
}

config
run "$@"
