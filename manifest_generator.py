"""
Only for generate manifest for uploading. Be sure your input is legal, signed.
"""
import sys
import os
import json

usage="""
python3 manifest_generator.py [Path to untar directories]
"""

def main():
    if not os.path.isdir(sys.argv[1]):
        print("[ERROR] Not a vaild path")
    
    # Starting generating manifest
    res={}
    res["schemaVersion"]=2
    res["mediaType"] = "application/vnd.docker.distribution.manifest.v2+json"

    # Reading existed data 
    manifest_path=os.path.join(sys.argv[1], "manifest.json")
    with open(manifest_path, "r") as f:
        manifest=json.load(f)[0]
    repo,repotag=manifest["RepoTags"].split(":")
    res["name"],res["tag"]= repo.split("/")[-1],repotag
    # Get config's path and read
    config_path=manifest["Config"]
    with open(os.path.join(sys.argv[1],config_path),"r") as f:
        config=json.load(f)
    res["architecture"]=config["architecture"]
    
    # Get history with v1Compatibility
    # History is in each directory
    

    






if __name__=="__main__":
    if len(sys.argv)!=2:
        print(usage)
    else:
        main()