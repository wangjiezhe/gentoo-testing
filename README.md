# gentoo testing image

Dockerfile 参考: https://gitlab.com/grauwoelfchen/portolan/-/tree/master/gentoo

Action 参考: https://printempw.github.io/ghcr-io-with-github-actions/

# starting command

```bash
docker run -it --gpus=all --name gentoo -p 1084:1084 ghcr.nju.edu.cn/wangjiezhe/gentoo-testing:master
```
