#!/bin/bash
# from https://gist.github.com/alex-bender/55fefa42f47ca4e3013a8c51afa8f3d2
# Shell scripts for push/pull to v2 registry
#
# - Get a token.
# - Push a blob.
# - Pull that blob repeatedly.
#
# Tested on OS X 10.10.3, curl 7.38.0, jq-1.4
#

reponame="" # the repo you want to push
UNAME="" # Your username
UPASS="" # Your password
TARPATH="test/85e601059a16cdd58f9b02de2c34b30f19464bc60e848da43b7daf5b1b1c2a8c/layer.tar" # Path of layer's tar will be uploaded
reference="latest" # the tag you want to push


getToken() {
    local reponame=$1
    local actions=$2
    local headers
    local response

    if [ -n "$UNAME" ]; then
        headers="Authorization: Basic $(echo -n "${UNAME}:${UPASS}" | base64)"
    fi

    response=$(curl -s -H "$headers" "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$reponame:$actions")
    
    echo $response | jq '.token' | xargs echo
    
}

uploadBlob() {
    local reponame=$1
    local token=$(getToken $reponame "push,pull")
    local uploadURL
    local numBytes=100000000 # 10 Megabytes
    echo "Get token" $token
    uploadURL=$(curl -siL -H "Authorization: Bearer $token" -X POST "https://registry-1.docker.io/v2/$reponame/blobs/uploads/" | grep 'location:' | cut -d ' ' -f 2 | tr -d '[:space:]')
    echo "Upload URL is"$uploadURL
    #echo "Raw is" $(curl -siL -H "Authorization: Bearer $token" -X POST "https://registry-1.docker.io/v2/$reponame/blobs/uploads/")
    #curl -X PUT -H "Content-Type: application/octet-stream,Authorization: Bearer ${token}" -I --upload-file ./test/83cb78f77b90249ffac6eee25f37091931addccb562cb11d264671ad7a749dc0/layer.tar $uploadURL
    #blobDigest="sha256:$(head -c $numBytes /dev/urandom | tee upload.tmp | shasum -a 256 | cut -d ' ' -f 1)"
    blobDigest="sha256:$(shasum -a 256 ${TARPATH}| cut -d ' ' -f 1)"
    echo "Blob ${TARPATH} digest256 is"$blobDigest
    echo "Uploading Blob "$TARPATH
    curl -T ${TARPATH} --progress-bar -w '%{http_code}\n' -H "Authorization: Bearer $token" "$uploadURL&digest=$blobDigest"  >output.log

}

downloadBlob() {
    local reponame=$1
    local blobDigest=$2
    local token=$(getToken $reponame "pull")

    echo "Downloading Blob"
    time curl -L --progress-bar -H "Authorization: Bearer $token" "https://registry-1.docker.io/v2/$reponame/blobs/$blobDigest" > download.tmp
}


uploadBlob $reponame

#for i in {1..10}; do
#    downloadBlob $reponame $blobDigest
#done
