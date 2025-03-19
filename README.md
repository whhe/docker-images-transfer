# Docker Images Transfer

English | [简体中文](README_CN.md)

A GitHub Action used to transfer Docker images to other Docker Registries.

## Usage

Fork and clone this repository, and configure the following environment variables:

`Settings` -> `Secrets and variables` -> `Actions` -> `Repository secrets`
- `USERNAME`: Username for publishing.
- `PASSWORD`: Password or token for publishing.

`Settings` -> `Secrets and variables` -> `Actions` -> `Repository variables`
- `REGISTRY`: Docker Registry to publish, such as `quay.io`, or Docker Hub if empty.
- `REPO_BASE`: The prefix of the target repository. This workflow uses the same repository name by default, so the part before the last slash (not included) in the target repository name should be filled in here, such as `quay.io/whhe`.

Then you can create a git tag according to the image name you want to transfer, and GitHub Action will publish it to the target repository.

Note:
- There must not be `:` in git tag, so you should use `--` to represent `:` in the tag name.
- Workflows are not being run on forked repository by default, so you should enable it manually. See [docs](https://docs.github.com/en/actions/using-workflows/disabling-and-enabling-a-workflow?tool=webui#enabling-a-workflow).

## Example

Assume that you have forked this repository and enabled GitHub Action. Now you want to transfer image `langgenius/dify-plugin-daemon:0.0.5-local` on Docker Hub to `quay.io/oceanbase-devhub/dify-plugin-daemon:0.0.5-local`, then you should configure environment variables as follows:

- `USERNAME` and `PASSWORD`: fill in your username and password on quay.io, and make sure that the user has the permissions of the `quay.io/oceanbase-devhub` organization.
- `REGISTRY`: fill in `quay.io`.
- `REPO_BASE`: fill in `quay.io/oceanbase-devhub`.

After that, create the tag `langgenius/dify-plugin-daemon--0.0.5-local`.

```shell
# 'langgenius/dify-plugin-daemon--0.0.5-local' represents image 'langgenius/dify-plugin-daemon:0.0.5-local'
git tag langgenius/dify-plugin-daemon--0.0.5-local
git push origin --tags
```

A GitHub Action will be automatically triggered after the tag is pushed up. You can go to the [actions](https://github.com/whhe/docker-images-transfer/actions) page of your repository and check the execution details at the latest workflow page.

After the GitHub Action workflow is complete, if no errors occur, the image should have been published to the target repository.

## License

See [LICENSE](LICENSE).