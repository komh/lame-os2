extproc sh

n=configure
test -f "./$n." || { echo "\`./$n' not found !!!"; exit 1; }

"./$n" --disable-shared --enable-static --enable-nasm "$@" 2>&1 | tee "$n.log"
