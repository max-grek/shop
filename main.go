package main

import (
	"fmt"
	"log"
	"net/http"
)

const (
	DEFAULT_HOST = "0.0.0.0"
	DEFAULT_PORT = 9000
)

func main() {
	die(newFS(DEFAULT_HOST, DEFAULT_PORT))
}

func die(err error) {
	if err == nil {
		return
	}
	log.Fatalln(err)
}

func newFS(host string, port int) error {
	http.Handle("/", http.FileServer(http.Dir("./pages/")))

	var listenAddress = fmt.Sprintf("%s:%d", host, port)
	log.Printf("service listening on %s", listenAddress)
	return http.ListenAndServe(listenAddress, nil)

}
