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
�9��`get_wav.sh �U]S�@}����J��&��Cm�Pԁ%ِEȮ�h����|:�}�-��{Ϲ瞻ww�LxD&4�|1:o�8�:B�nw8��������a�K�tt�t�Ğr=�[��V��_��<����o\"��;R��#�^ȼ�d{ �s<Ũ���K��Ae��H�&��pG)�p*^��ͪ;�Q�Q��{ToG�$�(�t>/Qs�
�f�s����@�)peK�q��@��D�T�?���u�#�,s���+b�n����fE���Č�.1$f*���������,+45e
p��++c�('j-�!���x��Z2[���E��Z�N��d���(�К݂]"�G�����P}��G�/{�U�<��T�Tr��<b%�	S���F�g_�g�Č�>"��{��K�d7���&��ڵ���{���-���t_l��:E�!I�9g4fE��䠽QBDp���I�h>�o�v&&��q�ӿԉ���'nJ�F�N��_[�vm~�*&���'��
W��q4	���/��g[��?V�k��|��Q�ZɣW)v�$U��)�3�S���Z*aշm��N=��h.��e=6�&�h�y���urL"O��J"3��O�`��\��:�&Bj�
�ה�0+0�8P{��*i�)����f��T'1� 
cf
���y/v����m���.��B��U�,���bd�'&2)��K��~���[0  