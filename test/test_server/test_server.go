package main

import (
	"fmt"
	"net/http"
	"log"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "OK")
		log.Println("Request received")
	})
	http.HandleFunc("/api/vacuum/start", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "vacuum activated")
		log.Println("Start Request received")
	})
	http.HandleFunc("/api/vacuum/pause", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "vacuum paused")
		log.Println("Pause Request received")
	})
	http.HandleFunc("/api/vacuum/return", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "vacuum returning to dock")
		log.Println("Return Request received")
	})
	http.HandleFunc("/api/vacuum/status", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "vacuum status: cleaning")
		log.Println("Status Request received")
	})

	port := "8080"
	fmt.Printf("Starting server on port %s\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}