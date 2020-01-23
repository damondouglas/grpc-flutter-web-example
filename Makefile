export TAG=1.0
export GRPCHOST=$$(kubectl get svc calculator -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export GRPCPORT=$$(kubectl get svc calculator -o jsonpath='{.spec.ports[?(@.name=="grpc-web")].port}')
export WEBHOST=$$(kubectl get svc client -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export WEBPORT=$$(kubectl get svc client -o jsonpath='{.spec.ports[?(@.name=="http")].port}')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

stub: ## Stub proto
	protoc -I proto proto/calculator.proto --go_out=plugins=grpc:server/pkg/calculatorpb --dart_out=grpc:client/lib/services/src/generated

build: ## Build via skaffold with TAG
	skaffold build

dev: ## Run skaffold dev with TAG
	skaffold dev

deploy: ## Deploy skaffold with TAG
	skaffold run

curl: ## Test endpoint
	grpcurl -d '{"values": [1,2,3]}' -plaintext -proto proto/calculator.proto -v ${GRPCHOST}:${GRPCPORT} calculatorpb.Calculator.Add

open: ## Open front end
	open http://${WEBHOST}:${WEBPORT}
