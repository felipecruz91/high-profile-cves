package main

import (
	"log"

	"golang.org/x/net/http/httpguts" // introduces CVE-2023-44487 (HTTP/2 rapid reset)
)

func main() {
	host, err := httpguts.PunycodeHostPort("host")
	if err != nil {
		log.Fatal(err)
	}
	log.Println(host)
}
