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
�}�^fpga_run.sh �Xks�J��~EGW�|Y�G�u���ء�c(CU�-y�е�h������̌^��[w]���~�>ݭ�^��0v�,[Yևч�˱7�oN�z�ѻ|s=p��u7ϼ��t��r`���[��tx�M���+�v6I��O������p�{���N;��N׈|��ϼ�������w�D}�ů�/�>u9:�i�J��M8O3W�L⚎>oY7��O�<V�M.�7�[�'�C�)o+�^��nn�ǥA��6̑��,��h�]�n�ZS��I��̡
ѫ�:w��%����'f�w�Ù{n��E��Y�-�jr}�]\]�gP���2w�,��f1[�T��m}�p���}@��I_6���o���2(�$\�$��l���mI�������^9̗�#?�����*��Eq
3J9�_ȕ�+Y(E�d�����9U1��[r�c���� {��"=�[AP��'�������v_Bi-BeJ��b��!�1�D&3Z���lER��)�K+]S{A�u;x���>%�o�@�T�zg4�K��b�K��FbA��,������4 ۏDؕ�e��c���Ө0�7ey �=%c��Ui��H�L��S&CQ$qR���R[Z��L$OTV.��~���d��\���� L��3��k���:�&UX-}�0�U$@�c@��E��Rݥ�b��8�������V�+��[�%�`�Ծ"�O6��W��1d��yu]�����'�S+V�i�!��e�ህ$E��J�>F4�L�k�I�Y���p�I䀧��g&�"�q��Qbd�[-r�%�9NqĝE*6_g[.rE���U�H��I?����ױ�lW��q|�y�?���1!= L�9ؘ���X|����<|�N�G����8�#V��"�}�i;,X���8��|�ߏ�̩w�s�ۧ�}��Jd�r[<�T�4tG��aՈ��
H�D��w�lf'K/�6NS�\�V��8ɥ����J�C���*؄��YDk��� ��@*��Я2iϴ��Z���N[������j�EuB�n�վ�!��>��Ы���+�F���qꙁ2)���k��Tq�qTEBU,�
��7�3��]�G\���l�N���s�J��+y`�&��7�4��.�$�s�|S&
2�{��5�Vb_%����]P��b��CKJ�}�DG��Ѩ�a�a�Mc�[����l�&��paR�Y���oԑ
%��U����މ��jzUi����r�1�J���赹T��hk���&Z�ki�������vٲx�5}(�z��C���ҖK�x�F�)�`��3.���Mq<�֠��0V��3M*�,�x;~7�N�eM�o�Qx�|��:���b�j-�N��a�W7���-0���/�bl��?](`��A,����t�+@�~^�`���\("4`3=�4yR� ��5&0�R��*���{%j���x,���,"���S����Y`�m���<My,�'�c�A/d���b���Q�Q2`1פ��FX-�ȋ��2�p�AC��Uݞ(��YX��
�:��t�����q��ܯ�b��B�U%�(ј����Z�?+��$vX��u�B��ۻ�ݤ3�3&�F����3g{��Y;����r��l]W�B9�~˨����`���u�ڻ��d��A�Fb��s�c���jc��ئ��dl���(�u����qYіG�ad�єK������o���R����D�FMb�b�� ��5�<��Q^WA
Zp�Z��3xj}P���y[������M�]�U��V�<�hް�W���QD/��G���чp��W��{bqP�c�
l�x�U�X��,�0>��V���yH�O0�8�jK?�w�6������xi����֟N�U9#���r�gq��ݰ<ƒ�%�! �)C�/���c��!V�:р������4��i���i�q뚥BB�5[��o/���z�0*�<��������N�&�Uͩ�\hw{��S�����=��)u_S�g����^�z}�Z���s�g�CY�a�σ=��G���bݤ�1�r�R��wl�?=�a�o<m��YG�X�ۜأ��T' �������z��i�/�^�:Q$�l�z�T	L�_����QU������h7*Ԯ�4���U���RYi�煢	���XO�@�BQ�Ec�0o3��jТ6�9Ě�R�è���X�AY��eK7�˗�k�=�m+�>k@4���-�@��~�P�S8P����ҧ�7��A�~���s�,���?�_���  