(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� b�Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq!QA���F~���Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�q��xM��)����!JT�/o����;����GI��_.����^q��:.�?�V������>[ǩ��@�\�$M�����5|��/��t9��{Lĝ��^u�=��K��I�y�;��q��Y��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ث�s�!������?N���?����������:��Zy�j=]6�!�ڢuʃ���Me�w٤�0	���
V�ׂ���ikA�*̄Բ�O�4q��W��B���f<�-�x�X��I�	ܑ�㹉�S�z�B4�Y��|��,=�N�R7��@��4}������@�e����E/�P׾}�N�U����;�7�/�ۋ�K�O�?w/��(����J�G��.����:��xE��D��?��8U��R�@��nȒ�j�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe��7�@�9��aRf�[7"��
��򸝢0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�H����>-�������7Me'��k~�N��"r����;i�<��"o�5�H�X��`a�}� ď�������E�I>�{o-�+����g��x�P����P�ȀS}U���ÛC����F�v#a����+6F�L��~�A�ڀv�,g%�U.܎Pޕ��e��(nugJ7s-j6:p����{B.rp��G�'3�;�A�_�� \�_�[ix⹰� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy`2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l���3����Ϧ���=�����������6����>������k�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�#F��P�1��	���#;� � WS�.�
�{e�ާ)����u��e��i(��C�ل��<��.G�މE�r	��b�֐�ek�Dj�b��.:7��,��ty�H�\̭�m�.�}
@s�e�Rw���=s�mu�4@.�'���	s�0��ax�@����4���Y�@��"�9�W ������k��k��Aȁ3_�A7��}���|Ƿ4�צ����4���A#�9�u �-�5�.��̶��	�4���qG�"j>ob��bM�CAn�{�I���sn
��L�k�t���mfՇJ&�����)~I�����]��!�*��|����y��_�*�/��_�����������x9�(�W�_~I���S�������~}��>Ex1	/�l��:N�l��0M���H@�.���Ca��(����U�?ʐ�+�ߏ�(���2pA�����IA+G�	�2�x���
� 4.�7�|x1�g-[�m[����r�45~��Ko�R��d3D��/9��g�A�ۑ���s���W����v+�j� �n���iX����4�?3����/%����*�_���j��Z����ޥ�?3����R�A���!�?��W
��3����̡�H�>BaJo�vZ��?������|��,a��Y�c�gb>4����m����T8.Wy �Ȥ���L꽩4��s�m��{�;�9TD:FwE�z�ӹ��6֛ɼa�]c~��@�t��ʝ��1v���k̑��#�r68F$�{�����[�i��1K �L�0$�@ ��6PĖ �!/X��k�N8a7E�j�de:�� �n��;���GӞ=4�*���TQ��w{�χf=�/��$d�����f�u��LiYZw4�C^nvL5QBډI�H�,E�vC2�	\��d�Ѓ������%����?8]���F�O������+�����\{���ߵ�}���_���\"�Wh�E\���b�����+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pgX%a	�gQ�%Iʮ��~?�!����'*��\��2aW�W���X�plNl����{���6[�A�z�^��C	��yܩ�JJ�E�Il/��j����hc7�1c���������<D i�l0h�C���<�甒S�ݬ��{7��8���Ï����Gi�Z�/o����w���JU������2�p��q���)x��$޾|Y9\.G�J�e�#���vЋ口T�/����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v�w�Q���w��P�xj�Q^�e������K��*��2��������o� ���+�����_����΁X�qе
�%,�!?;�y<���%�������a�Ui��U��n�/���CwA�����h�� ���=hZ�a��-
'���N����B�N{Ġ�o�վml�8O`���L�z��"<c8x&'8�d�ub�ysD�������⢹���l�LT0�:����=�m�(����1��&1`[���&�0�BK<��9ޭ�+�F��5a��7�STY�M9�S�Kw*�vg<6� n-�y��<�K�In{.���}�?�� �'�)gSs��wu��{
mE6��l�q�s�2�)a�l�i��@�=��a�Sb3�=)�h���g�O�֪�Ys�P��ϋ�H���v�w��8Z���෰�)����&|���An���(C������(Q��^
޶����c��_��n�$��T�wx��#�����2?yf(?��G�t���@�O��@�q[z-PS �]��'n��c��<�������nJJ�Xڢ��#[����m�5����Ԕh�;ķf*Ǯ�	C:�͘$s�Z��������%��/�I_M��==���A��}�R{���Ț���	�H�6k��y�^wӾ�R󬑬�R��S2���k�g�`�r����߃�N�Ѱ	#$�{Da�6������H���q���MT��෰��g�������Z�����g���������������j��Z����)0���U��\.��������QY�����+��������b������T��V
.��#l�>Zh(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_H�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O��%q�_�������ŏ����_�����l�4+����_�_���v���W�Vsm�x�զ��_k�}�����N:u�\�뎡n(�
�F��+{�L��g��v����_�ϕ�jW5	p������U�o��v��zul���>���:�^ǿh�$����V��^z_k٤v���zZG�(�u��H�>�VӅ_{��O�C���q�h��/��NΫ]9������I�W��;u�6^l"�A]×�����Oq��˵=]���Ҏ�Q��7w�AE�[[�v�<-|��ʰ�-v���ꂨ��MCTEtn:r�U ���C�O?/�>^�r_�fW�v��kE%��|��^�q������\;�BϾ��.:J�'ߺ�o^--���DYrg��X����}�u��Y�E���K�2iA���^ܛ������Ӻ8�?��n���6��5x���ߟWe���?��ǒ߿���4����NM��t>]�7�4�Z��d�qb�'p��p8]O6�u��~0�I�^�=L|�	�!�#%pVϧ�� }T�#����Gdq�S7�X=��^��2)���7|�*��q$�C4dE��o��y\VGƷu��'�J1g�^WV�o��t���I��᭝��f	�-����D?}���][���y�7���l��H���kE���N�I](�uLQ���(��K���P)�9��F '���H��oҢ	�`4ڧ6hZ4yI��64���uP �C�CJ�H#iF3�]�g���υ�����?�sN6�����-_��fry�`j����rK(!c�q,�ҙ4��g�Bb=<X�@�d�g��d�^&O�(hm��1�铄�m.�e,��RNם�i30-�@,���-=	D�y-:%�
�,�!��1aV�/zz��ih��!8xL�׳�Z���h�V����h];�	�) ��ӕz�x���ȑQz=݄�	��|n����|t�V���w4C��>�|a�C�
�L����ڬ�^]j}���n笛�t�>��k֙����ZЈU$ĖU
� �3�&lt���e#~��y�-���%c�Q�t�[7�Aݹ9ǋ��)�M�6��Ð�-�n�E8�.�3�p�����4����8����OL�4`w��������&��_����X6�~�����%}��y�g�sj��^�,
��Z����t��f,X�����N�9�x��.��h�t�Ьa�����Qԩέ\�׬���e~��D]2E��[UX���.�0v� E��zPpV� [�a�$�yk�1K
�aGr�����B���e���ڸ,4{��}�Ϸ"�����$�"39�W�ĵ�}���o�V�eC!�8a��λ&ϧN�{i�!��ᓴ��?V��u$���l\���!�vY1A;��"f�yoڐ����+�R�~���R��Q@�ސ�X�_�:�����ܮ��l��t^ѐ갪&���٧<��7�"z7W�������lx�7z��8��NX��,�������?�~�K��Ay��޵�o����!�#�J�y�k�!���c0�����P#"p�0 HDX�����
d����&�EB���W-�����[O�����}��F�O������_��{��맑��uW��E�;/xxG�ҋ��i ����O���-�!���[��B�xk���_=���M�s�M��⾼B`dZܼ����)9�&1��!�J�B{��&�����s-���OQ�0�~緥��X2?�+� ht"�"�ُ��(�L�p�?�/�	z�gp\����an��)c�QM�d0'�J�h Z1�)U&%�̷J���>盹%9�j��h���9��-R�1tIh�G`YR�r41$S�����U."Ps�u�����:9���#=���Vd�V�5�U(Y9ծ��&�l�+'���	�D�yP5��RT
����L ЪFY*�j���}�W��LX�	�2a�a�"_9a�²�"llaSO��Φ����ZX�R3J)C�쩹�4�"J�B3�k�8NE hP�T&�Ϩ�=:|X[)�),��	>BK!�B��P�L�����1�6+�U`<}>de�I��a�Z�h���x^ �~)�� �	�%���d���}���A��b���}����a�Y���L(�w�i�f�z��sb��I��@l�:�H�;L�ʴVVy��[�`���n���+K쒔e��K�r�����1#3�j*x$�&��n�h�/Md���D%ċ�D��ӓC���R��d�J���S����`�-��qt��)ū\ɬ�l�����r�KT��fW����FeI~*���\p���@Jrݲ���&I��~<���T�S(�V��Q)�:1�`��ě!���k�a����ɴ2:M�ﭲ$�)�h���NW��ʒ �C�g1�.���C�Ӭ2ƈ������)�� �s�ԥ��1JOT���b/=��B�-xK�m"�4~>e�)���ǩ a�k��|֗��D[Q��K����I�����qrՐQn8.p�J�٦Z.
i�+bp�/��U�(HgFf�{�Z
��-�D�2�P�c�4��T�m�4e�>�볹>�v>��5�
��^<\6�=�0�_Bn�<��!;�5����{7�/�J;��`v��A<P��yv��yv\�*'	�sU��	���+Į�{�����!<�똎�3�mH�砬�6�1��8x�EI�Q�:=��4x���r��3��W�Y��Q���f�,�u	�E�����j��<b�&ߜH�G��;`��W���|��s�^�sn"7v>�����+���XĢ ��Y�[�|y
?�<���nsdf'e�OqS9��n�딮þ�V��m仈X�#�ȷ�=
tEE3��g&�En �#黯������������w���"��{\��R�l�R�ڙC�t����� �eh����r�����������|�:�H+���֢���tаLDTg8��+`��'�;��[lOc�Y*ó�{��A��t���X�O�}�=�0�/�u2.����c�ʁ�n�&t7�%�X���a�r:"*-2]�Z"Jйʹ��)V���$R�(���ѩ=X8�[TL�=��9gS��17���!{���Nƒ�j�F��H��#��ku���E�o'�<�sR�ttJ(�꩐>	tuB�(!�Ǻ�O�Z-38)��'��9!�ai��r���%��Z�_&M��1	�b�M�q�iV�����j^�8\�p��?�w�%=�|:�]p.�[���1Y�1���́9�ݳ�SP�Ʌ�"ם�>��������ݟ�0?&v���~_<,7�����m;���#B��g�Z�2��h�aL�(��ʗ9,�Py��[���PKA�yL\4(2o�E��`Y���0�vyg�ፎ�&��~�R�LDG�,�)��)]_�cGz�@#Y����XR��>`�v�dq�Ҵ�$6��	4Wͪ��c��b0�d,�7r�˃�

��H��P�H���HD����X.z!�#b�����a����dK�F@�֩��EʵI܇�4Ǝ
���A��h����4��J�E �F2k�j1>�2��٪2�K;o�a�����7�8���/G��r��s;eK9�}m��"̶w<i���BOH�������{}Î��L�-���"�T�nH�)����.�y��`wV(����� ���OPx x���z噕8��$�<�"W�7�.p�]����>�~������ћ_~�??�7�����*��`w���{�ws�rZ;Q���8��IN���]��}I�����W��o^�o���_㷐ǯ��z��?|������������W�?K�/����@<���;_����{�9�NԬ#{���>��'���n�������6Ho������-���p���/��2���.�ӥv��N�&��\j������H�i���R;]j�볹>����yn��}��9�rhܤ���24-t$��:B�<�%C/-�z���y#�|�������	o .��u�\���)�����\�p��=�\�#y��� 38��[�l6yZ�7��Ιq����93�q��q��\`����܏�9w.;w��ڶ��w�<z�d���:���s����&7�o��{���  