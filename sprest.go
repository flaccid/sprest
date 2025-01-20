package sprest

import (
	"fmt"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
	log "github.com/sirupsen/logrus"
)

func queryHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, world!")
}

func Serve(listenPort int, accessLog bool) {
	log.Info("initialize sprest server")
	log.WithFields(log.Fields{
		"port": listenPort,
	}).Info("listening for requests")

	http.HandleFunc("/", queryHandler)
	http.HandleFunc("/health", healthCheckHandler)

	if err := http.ListenAndServe(":"+fmt.Sprintf("%v", listenPort), handlers.LoggingHandler(os.Stdout, http.DefaultServeMux)); err != nil {
		log.Fatalf("fatality: %v", err)
	}
}
