export TAG=1.0
export HOST=$$(kubectl get svc calculator -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export PORT=$$(kubectl get svc calculator -o jsonpath='{.spec.ports[?(@.name=="grpc-web")].port}')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

stub: ## Stub proto
	protoc -I proto proto/calculator.proto --go_out=plugins=grpc:server/pkg/calculatorpb --dart_out=grpc:client/lib/services/src/generated

build: ## Build via skaffold with TAG
	skaffold build

dev: ## Run skaffold dev with TAG
	skaffold dev

certificates: ## Generate mock certificates
	openssl req -nodes -x509 -newkey rsa:4096 -keyout certs/cert.key -out certs/cert.crt -days 365 -subj "/C=US/ST=WA/L=Seattle/O=Company/OU=Enterprise/CN=localhost"

curl: ## Test endpoint
	grpcurl -d '{"values": [1,2,3]}' -proto proto/calculator.proto -insecure -v ${HOST}:${PORT} calculatorpb.Calculator.Add