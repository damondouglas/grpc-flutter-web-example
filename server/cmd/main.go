package main

import (
	"calculator/pkg/calculatorpb"
	"context"
	"fmt"
	"google.golang.org/grpc"
	"log"
	"net"
	"os"
)

const (
	portKey = "PORT"
)

var (
	address = fmt.Sprintf(":%s", os.Getenv(portKey))
)

func init() {
	if os.Getenv(portKey) == "" {
		log.Fatalf("%s empty but expected from environment variables", portKey)
	}
}

type server struct {}

func main() {
	log.Printf("Listening on %s\n", address)
	lis, err := net.Listen("tcp", address)
	if err != nil {
		log.Fatal(err)
	}
	s := grpc.NewServer()
	calculatorpb.RegisterCalculatorServer(s, &server{})
	err = s.Serve(lis)
	if err != nil {
		log.Fatal(err)
	}
}

func (*server) Add(ctx context.Context, in *calculatorpb.Input) (result *calculatorpb.Answer, err error) {
	result = new(calculatorpb.Answer)
	for _, k := range in.Values {
		result.Value += k
	}
	return
}
