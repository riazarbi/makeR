# makeR
R docker images for CI/CD style workflows

## Usage

This repo builds the base docker image for my CI/CD style R workflows. The file structure follows [binder](https://mybinder.org/) conventions, so that downstream Dockerfiles can add Jupyterlab or RStudio interactivity if they wish.

In order to build the base image, clone this repo, `cd` into the repo and then run `make docker-build`.

If you want to use this for your own purposes, you should change the docker repo at the top of the Makefile to your own repo. Then you can run `make run` to build, test and push the image.

## Developing

The basic idea behind this Dockerfile is that you just include what is strictly necessary in the Dockerfile to run R. If you would like to add additional R packages for convenience, they should be kept in the `install.R` file. Some R package need additional system packages. Put them in the `apt.txt` folder.

## Github Actions

If you clone this repo to run it in GitHub Actions, note that you will only be able to push to Docker Hub with a Docker Access Key, and you will only be able to write file canges and commit them to the repo once you've changed the Workflow Permissions in the GitHub Repo Settings > Actions > General dialog to 'read and write'.

