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
�wu�`get_wav.sh �U[o�0~�ũ���C�IS�X�]W�����$1��u�Ю�~��Ъ۞�!��|��{w�LyH�4
�|1>o�8�:B�^o4Ë�����Q�K�t|�=�8?�=�zA��7,D����?�Js��:��q�Pp�H5�`�XM����R<r�v��{܇��|��G�����v�bP���5ҁ�{��@ �(%TN�K�Yu�5�9ʙ;���j��D7�4],�������ǜ �418P
\ٲ�C{�!P�!�����xk���)�}~�����-䙾Yф�"|��q؅#f�DL�t��ٰ303ހ�e��L���Q����(ډZ˨AHK:3Y0�f5�ݰ�_��	��$�I����-�%�����_a��xh��X�	�E��J��K��!�0^N�B�n|z���q�J̙�+��x�wX1�EJQS1�Y�Ho�]֮m��~��nq����}q��k�B�/��{r�hĊ�=蒃��	��'FJ1|P�j�\L��FǽO��'R
'�OԔL�%�1g�����.�0SL��L���<���x$�/��Vf[��?V'k������8S��ի�4;�*�δ���)N���Z:aշc��N3��p!��e}���k{ׇ��hL��'Y��š9��Oy`��|Ѡ3r*M��,�o�)�aV`�q��r*Z%Tz���Ȏ�g�0��Nu��f��z��bO��2�v}a�%�����7UP孨b$�	���xOLeR�g'��h��h@  