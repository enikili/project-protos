# Configuration
PROTOS_PATH := proto
OUT_DIR := .
PROTOS := $(wildcard $(PROTOS_PATH)/*.proto)

# Go modules
MODULE := github.com/enikili/project-protos

# Protoc commands
PROTOC := protoc
GO_OUT := $(PROTOC) \
	--go_out=$(OUT_DIR) --go_opt=module=$(MODULE) \
	--go-grpc_out=$(OUT_DIR) --go-grpc_opt=module=$(MODULE)

.PHONY: generate gen clean deps install

# Generate Go code from protobuf
generate:
	@echo "Generating Go code from protobuf..."
	$(GO_OUT) $(PROTOS)
	@echo "Generation completed!"

# Alias for generate
gen: generate

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	find . -name "*.pb.go" -delete
	find . -name "*.pb.gw.go" -delete
	@echo "Clean completed!"

# Install dependencies
deps:
	@echo "Installing protoc plugins..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Dependencies installed!"

# Alias for deps
install: deps

# Default target
all: deps generate

# Help
help:
	@echo "Available targets:"
	@echo "  generate, gen - Generate Go code from protobuf"
	@echo "  clean         - Remove generated files"
	@echo "  deps, install - Install dependencies"
	@echo "  all           - Install deps and generate code"
	@echo "  help          - Show this help message"