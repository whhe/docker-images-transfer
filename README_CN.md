# Docker 镜像转发器

[English](README.md) | 简体中文

一个用于将已发布的 Docker 镜像转到其他 Docker Registry 的 GitHub Action。

## 说明

fork 并 clone 本仓库，并根据需要配置好以下环境变量:

`Settings` -> `Secrets and variables` -> `Actions` -> `Repository secrets`
- `USERNAME`：发布使用的用户名。
- `PASSWORD`：发布使用的密码或 token。

`Settings` -> `Secrets and variables` -> `Actions` -> `Repository variables`
- `REGISTRY`：要发布的 Docker Registry，如 `quay.io`，为空时表示为 Docker Hub。
- `REPO_BASE`：目的仓库的前缀，本发布任务默认使用相同的 Repo 名，因此这里应该填目的仓库名中最后一个斜线（不含）之前的部分，如 `quay.io/whhe`。

上述配置完成后，你可以根据要转发的镜像名称创建 git tag，GitHub Action 将对应的镜像发布到指定的仓库。

注意：

- 因为 git tag 中不能有 `:`，因此你需要使用 `--` 来代替镜像名称中的 `:`。
- 默认情况下，GitHub Action 在 fork 仓库里是未启用的，因此你可能需要手动启用它。请参阅[文档](https://docs.github.com/en/actions/using-workflows/disabling-and-enabling-a-workflow?tool=webui#enabling-a-workflow)。

## 示例

假设你已经 fork 本仓库，并且开启了 GitHub Action。现在你要将 Docker Hub 上的镜像 `langgenius/dify-plugin-daemon:0.0.5-local` 转发到 `quay.io/oceanbase-devhub/dify-plugin-daemon:0.0.5-local`，那么你应该进行如下配置：

- `USERNAME` 和 `PASSWORD`：填你在 quay.io 上的用户名和密码，并且保证该用户有 `quay.io/oceanbase-devhub` 这个组织的权限。
- `REGISTRY`：填 `quay.io`。
- `REPO_BASE`：填 `quay.io/oceanbase-devhub`。

之后，创建 tag `langgenius/dify-plugin-daemon--0.0.5-local`。

```shell
# 'langgenius/dify-plugin-daemon--0.0.5-local' 代表镜像 'langgenius/dify-plugin-daemon:0.0.5-local'
git tag langgenius/dify-plugin-daemon--0.0.5-local
git push origin --tags
```

tag 推送后将自动触发 GitHub Action，你可以进入你的 fork 仓库的 [actions](https://github.com/whhe/docker-images-transfer/actions) 页面，在最新的 workflow 页面查看执行详情。

GitHub Action 的 workflow 完成后，如果没有错误发生，则镜像应当已经发布到了目的仓库。

## 许可证

请参阅 [LICENSE](LICENSE)。