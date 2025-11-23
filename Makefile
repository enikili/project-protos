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

.PHONY: generate clean deps check

# Check if proto files exist
check:
	@echo "Checking proto files..."
	@if [ -z "$(PROTOS)" ]; then \
		echo "❌ Error: No proto files found. Run 'make create-proto' first"; \
		exit 1; \
	else \
		echo "✅ Found: $(PROTOS)"; \
	fi

# Generate Go code from protobuf
generate: check
	@echo "Generating Go code from protobuf..."
	$(GO_OUT) $(PROTOS)
	@echo "✅ Generation completed!"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	find . -name "*.pb.go" -delete
	find . -name "*.pb.gw.go" -delete
	@echo "✅ Clean completed!"

# Install dependencies
deps:
	@echo "Installing protoc plugins..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "✅ Dependencies installed"

# Help
help:
	@echo "Available targets:"
	@echo "  generate - Generate Go code from protobuf"
	@echo "  clean    - Remove generated files"
	@echo "  deps     - Install dependencies"
	@echo "  check    - Check if proto files exist"
	@echo "  help     - Show this help message"
