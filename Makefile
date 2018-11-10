IMAGENAME=k8s-tf-runner
RUNARGS=-v "${PWD}:/tf-project" -v "${HOME}/.config/gcloud:/root/.config/gcloud"
WHAT=plan

default: build

build:
	docker build -t $(IMAGENAME) image/.

run:
	docker run $(RUNARGS) $(IMAGENAME) $(WHAT)

run-interactive:
	docker run -it --rm -e TF_INPUT=1 $(RUNARGS) $(IMAGENAME) $(WHAT)

.PHONY: build run run-interactive
