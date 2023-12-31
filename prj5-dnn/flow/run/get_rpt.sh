#!/bin/sh
skip=44

tab='	'
nl='
'
IFS=" $tab$nl"

umask=`umask`
umask 77

gztmpdir=
trap 'res=$?
  test -n "$gztmpdir" && rm -fr "$gztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

if type mktemp >/dev/null 2>&1; then
  gztmpdir=`mktemp -dt`
else
  gztmpdir=/tmp/gztmp$$; mkdir $gztmpdir
fi || { (exit 127); exit 127; }

gztmp=$gztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$gztmp" && rm -r "$gztmp";;
*/*) gztmp=$gztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `echo X | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | gzip -cd > "$gztmp"; then
  umask $umask
  chmod 700 "$gztmp"
  (sleep 5; rm -fr "$gztmpdir") 2>/dev/null &
  "$gztmp" ${1+"$@"}; res=$?
else
  echo >&2 "Cannot decompress $0"
  (exit 127); res=127
fi; exit $res
�O�`get_rpt.sh ͕_o�0ş�Oq�2��PmR�!V�F��}h�`�CL��:�ۺ�>'$�V���n����}~��{w�L� �Dz���o��m��F���Ή�=�x?�;�&���k&Pk0��PmxH�&q�r�Pp�)=�B �ӈM����σ��x�������ʃ\!Y�WlI���n��|nlG�r�B�ִ�xJ��j��+C�����*��(�|���&ꏅ+[��wH�@�3��*���y/d���rF�V�߼���&Wޅ���O�t���3�nY.pp����4���{�u���Fa%��!E������d��3w*��Z�P���-�T�%�߀[*�[����%�P��4�W{�U�u=TI��b1D��0��ݾr��1+-������+6ˤ�H���ނ&桲�ڕ˃���Cec������gC�ߔ(�2�P1�	+���.9h?8!|��ؖR�[���	t����_�D��I��i_���kۮ�"3�8�f�.�N��܉K����VP�����ݢ�߹{d��V>��g���/-^�E�e��}bm��m��f�N8��0���d��JĒy<6�5z�G�F���͖�25f���l�0B��	8�Q �K�:#��DH/�����2v�jϧ�UJe�H�� y
;��i�d�h�'|�;���Ė��a,W$�:XQ�Ȓ/i }k2��6��Uye����k��:�1�  