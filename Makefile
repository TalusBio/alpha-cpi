.PHONY: .venv format test pre-commit clean conda

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROFILE = default
PROJECT_NAME = alpha-cpi

.venv:
	pre-commit install

kernel: .venv
	python -m ipykernel install --user --name ${PROJECT_NAME}

format: .venv
	isort .
	black .
	flake8 .

test: .venv
	python -m pytest --durations=0 -s $(FILTER)

pre-commit: .venv
	pre-commit run --all-files

# Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

# Install Dependencies
conda: environment.yml
ifeq ($(conda env list | grep "${PROJECT_NAME})",)
	conda env create -f environment.yml
	@echo ">>> New conda env created. Activate with:\nconda activate $(PROJECT_NAME)"
else
	conda env update -n ${PROJECT_NAME} -f environment.yml --prune
	@echo ">>> Updated conda env. Activate with:\nconda activate $(PROJECT_NAME)"
endif

#################################################################################
# Terraform Commands                                                            #
#################################################################################

# Initialize terraform
tf-init:
	cd infrastructure && rm -rf .terraform/
	cd infrastructure && terraform init -backend=true -backend-config=backend.tfvars

# Format terraform code
tf-format:
	terraform fmt -recursive

# Check whether terraform code is valid
tf-check-terraform:
	terraform fmt -check -recursive
	terraform validate

# Validate terraform code
tf-validate:
	cd infrastructure && terraform validate

# Plan terraform configuration (doesn't apply)
tf-plan:
	cd infrastructure && terraform plan

# Applyterraform configuration
tf-apply:
	cd infrastructure && terraform apply $(APPROVE)

# Destroy terraform configuration
tf-destroy:
	cd infrastructure && terraform destroy


#################################################################################
# Docker Commands                                                               #
#################################################################################

docker-build:
	docker build -t alpha-cpi . -f docker/Dockerfile

docker-run: docker-build
	docker run -it --rm -p 8888:8888 -v "${PWD}/data/:/app/data/" alpha-cpi

docker-tag:
	docker tag alpha-cpi:latest rmeinl/alpha-cpi:latest

docker-push: docker-build docker-tag
	docker push rmeinl/alpha-cpi:latest

# Cuda
docker-cuda-build:
	docker build -t alpha-cpi-cuda . -f docker-cuda/Dockerfile

docker-cuda-run: docker-cuda-build
	docker run --rm --gpus all -p 8888:8888 -v "${PWD}/:/app/alpha-cpi/" -v "${PWD}/alphafold/data/params/:/app/alphafold/alphafold/data/params/" alpha-cpi-cuda

docker-cuda-tag:
	docker tag alpha-cpi-cuda:latest rmeinl/alpha-cpi-cuda:latest

docker-cuda-push: docker-cuda-build docker-cuda-tag
	docker push rmeinl/alpha-cpi-cuda:latest
