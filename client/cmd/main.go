package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

const (
	portKey = "PORT"
	endpointKey = "ENDPOINT"
	configPath = "build/web/assets/assets/config.yaml"
	web = "build/web"
)

var (
	address = fmt.Sprintf(":%s", os.Getenv(portKey))
	config = []byte(fmt.Sprintf("endpoint: %s", os.Getenv(endpointKey)))
	required = map[string]struct{}{
		portKey: {},
		endpointKey: {},
	}
)

func init() {
	for k := range required {
		if os.Getenv(k) == "" {
			log.Fatalf("%s empty but expected from environment variables", k)
		}
	}
}

func main() {
	log.Printf("Listening on %s", address)
	err := ioutil.WriteFile(configPath, config, os.ModePerm)
	if err != nil {
		log.Fatal(err)
	}
	fs := http.FileServer(http.Dir(web))
	err = http.ListenAndServe(address, fs)
	if err != nil {
		log.Fatal(err)
	}
}