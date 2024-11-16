# Variables
IMAGE_NAME := ollama
TAG := latest
CONTAINER_NAME := ollama_container

# Build the Podman image
build:
	podman build -t $(IMAGE_NAME):$(TAG) -f Containerfile .

# Run the Podman container
run:
	podman run -d --name $(CONTAINER_NAME) -p 11434:11434 $(IMAGE_NAME):$(TAG)

# Stop and remove the Podman container
stop:
	podman stop $(CONTAINER_NAME)
	podman rm $(CONTAINER_NAME)

# Remove the Podman image
clean:
	podman rmi $(IMAGE_NAME):$(TAG)

# Push the Podman image to a registry (assuming you have logged in)
push:
	podman push $(IMAGE_NAME):$(TAG)

# Pull the Podman image from a registry (assuming you have logged in)
pull:
	podman pull $(IMAGE_NAME):$(TAG)

# Display help
help:
	@echo "Available targets:"
	@echo "  build  - Build the Podman image"
	@echo "  run    - Run the Podman container"
	@echo "  stop   - Stop and remove the Podman container"
	@echo "  clean  - Remove the Podman image"
	@echo "  push   - Push the Podman image to a registry"
	@echo "  pull   - Pull the Podman image from a registry"
	@echo "  help   - Display this help message"

.PHONY: build run stop clean push pull help
