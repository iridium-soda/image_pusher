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

getManifest(){
    local reponame=$1
    local reference=$2
    local token=$(getToken $reponame "push,pull")
    #echo "Get token" $token
    manifest=$(curl -siL -H "Authorization: Bearer $token" -X GET "https://registry-1.docker.io/v2/$reponame/manifests/$reference" )
    echo Manifest is ${manifest}
}

getManifest $reponame $reference > sample_manifest.json