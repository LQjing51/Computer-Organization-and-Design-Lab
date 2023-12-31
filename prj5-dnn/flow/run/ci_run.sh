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
�m�`ci_run.sh �U]s�6}F�b���N
�O�q;�8	S2�mڎ��2h"[�$�0m�{�2�@roʄ	�v��9��t)r�dfC��}y"V�rv�A�-�l�0RY��l�5�M�0�J���r=^ķ�(��Ǔ���zKa�wA�G7�q!������Xgw�"����J�����3Ӝ�����>_�<��ЄoŊw��*�N��qv�؉]*B�97kTj+0ʊ��L&�2��b	R!at��Ûp��?����_�R�ԫ�n��')4�!��0�9Kv�+
�
e�UzG��w� ]I�O����W^���W0Q��L��5Ȝe��:��>If���4�п��ǻ!Ԛ��Y����z�7R�U`�^sK�tBV������h�����:����6�2MPW݃>:K�>�md��;#�Bc��E�^=��9����PH~jv��$3��Ś��q�{���dkSws���^gp�`���l��Br���.��~�W�2_m�o�,����KD�r�s����'0��1�2�u8��7�Y5%7��]W�x���n���ܧ��+[hD�1�d\~�^۳���n�I�8��Û�.����$��5�jb�֍$�A���3.��9P� ����q��������	���}��ǿ-P%���τt�$[\Ƕbک��Dõ`r�	�oS�K߃?H�Qrf8���v��`
���v�	�Kk�ɫ���w�ҮsQ�A�}k�Vw8M�Z�#���� �|�A�4���C�����/��qx�nRfřܪ�Ei�YF57��=�b�xG���8���I(��]���A�Y8�-���U˯q9��X( W��B���Z+��լ��š��o�K�ek�;��&\~�d-j^�컴��&C�%��	��T�{��ֻ�[ 6�Z��է�/��C��)�sJTΛ�R��:�E����^������W�������}7ʏ�yK2)�64Peϓ������p�r������0����  