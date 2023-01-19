# makeR
R docker images for CI/CD style workflows

## Usage

This repo builds the base docker image for my CI/CD style R workflows. 

In order to build the base image, clone this repo, cd into the repo and then run `make docker-build`.

If you want to use this for your own purposes, you should change the docker repo at the top of the Makefile to your own repo. Then you can run `make run` to build, test and push the image.

