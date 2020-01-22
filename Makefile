help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

stub: ## Stub proto
	protoc -I proto proto/calculator.proto --go_out=plugins=grpc:server/pkg/calculatorpb --dart_out=grpc:client/lib/services/src/generated