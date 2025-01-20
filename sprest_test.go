package sprest

import (
	"os"
	"testing"

	log "github.com/sirupsen/logrus"
)

func TestServe(t *testing.T) {
	if os.Getenv("LOG_LEVEL") == "debug" {
		log.SetLevel(log.DebugLevel)
	}

	Serve(8080, true)
}
