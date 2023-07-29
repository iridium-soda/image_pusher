# image_pusher
Upload signed image to Dockerhub via API V2.

See https://github.com/Razikus/dockerregistrypusher

## Format

See https://iridium-soda.github.io/2023/07/1c85f5f8cd37.html

## Usage

**Add your info to the script before executing**

Upload layers

```shell
source regv2cdn.sh
```

Get manifest
```shell
source get_manifest.sh
```

Generate and sign manifest **(Not finished yet)**
```shell
python manifest_generator.py
```

## Notes

https://forums.docker.com/t/401-unauthorized-when-pushing-an-image-layer-to-dockerhub/34832

http://web.archive.org/web/20180926062602/https://gist.github.com/jlhawn/8f218e7c0b14c941c41f

https://gist.github.com/alex-bender/55fefa42f47ca4e3013a8c51afa8f3d2

https://zhuanlan.zhihu.com/p/597602077

https://sysdig.com/blog/analysis-of-supply-chain-attacks-through-public-docker-images/