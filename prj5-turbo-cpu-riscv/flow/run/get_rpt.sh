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
��u�`get_rpt.sh ͕_O�0ş�Oq1����-�$�)�:Z�2U)� (u�qIcc;-lc�}N�����4�(�����'����L����A�����fq`4:��;����=�q��$t�q�R����7T��h�+���T�w���D8���u�@h����#(怈'��hx�����A�A�����+�pO)�Zp$���Q�ܠ���7�ٜm�C�Smh�@��-c���� ��1x�|,\۰���B�	Pi �!5���x)�ܭ�sʕ����g7��6|d�{�TJ�����-��ǉ��L�g�Q�),l�Vb��1R�)#A��v�s���A��m4��JNoI��-���J����58��/1��7�xj{�s_�1ZՓCU��K��A��'L�A��~�k�R���&�����5�(t[�țSm*�h\�<��K>T5����k�}6ԃu��@$�4|2aT���듽�"����R��Cs��31�~��>��pbyt[2�K:e�ncmە[�a��'����K����w�%�HJk#(���x�nY���=�~�k�����a���ރ��2��>�6��w�c3+'��fW�y2�b�&��E<�7z�GdFf�����25������0BYj7p�#�\��{#��FH��Q��*v�-ϧ�SI�H�b#y
����dD�x�k>/\���cb��%b��%��
�T1��
ߚLl�M�+Y]>��Ե�O���~�  