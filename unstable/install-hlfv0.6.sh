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
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� b�Y �[o�0�yx�� �21�BJ��EI`�
��ɹ�l�w��2HHXW��4�?�\���9>��ؾ�E�n�n����s�ʻ)�N��ū6���$��(��-6��
[�S��C)��I �D�Lpx^���?%A$ľ'�j�z"�`�� .rW�G���]s�d���8�^#"<�+��zF�t�YvZu��4�z@P��c::�I�L@Ԯ`�%�K-�!/���\�EG�X�(��-��~o٣?eһQ�A7"1Je�m]ӳ�L�Ԟ��ț��,ZX��Df�&�5�6�٤߬�?Ք�LQ�eo0�]�͍�@1��q\�A��Df�����~�AHL"���t;7Bz�R���h2\��BQ��f>,��hХ�+q�>��
�����T�����x�^��l�����ȸ/�C�D��*]W��hYX܉��j��?���}������m3��L�P�@-t
@�#`]<�F�2�K$��(3[Y��3ݟ��l���ܭ�{viK_�k(�K�l��<�,������l��*�����P�� ~� �Z��!+��͌��AaU�)�f��Ђ��<�E�~�\�*lZ�LxwL�M�����⸈
�3�[�[���$��E�<�C�-�l�l:aq�}78����\S�tkXt�4|q�K�!�cPQ��]�*�Kei��đ��KD�K�-ʉr�����e��ļ���ⴐ_c�(�����S=�Ջ�ӿ�_�p8���p8���p8���p8�o���u4 (  