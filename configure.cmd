extproc sh

gccver=$(gcc -dumpversion)
gccver_major=${gccver%%.*}
gccver_minor=${gccver#*.}
gccver_minor=${gccver_minor%.*}

ac_cv_vars=
if test $gccver_major -eq 4 -a $gccver_minor -ge 8; then
  # gcc v4.8+ has a regression. XMM compilation fails. Disable it
  # gcc 5.x fixed this
  ac_cv_vars="$ac_cv_vars ac_cv_header_xmmintrin_h=no"
fi

./configure. --enable-shared=no --enable-static --enable-nasm $ac_cv_vars "$@"
