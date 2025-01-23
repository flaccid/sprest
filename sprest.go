package sprest

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"strings"

	"github.com/gorilla/handlers"
	log "github.com/sirupsen/logrus"
)

func queryHandler(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query().Get("q")
	if len(q) < 1 {
		w.WriteHeader(400)
		fmt.Fprintf(w, "%s", "{\"error\": \"missing query string parameter\"}")
		return
	}
	log.Debugf("query (GET ?q=)=%s", q)

	log.Debug("checking if steampipe executable is in path")
	steampipePath, err := exec.LookPath("steampipe")
	log.Debugf("steampipePath: %s", steampipePath)
	if err != nil {
		log.Error("steampipe executable not found in PATH")
		fmt.Fprintf(w, "steampipe executable not found in PATH")
	}
	log.Debugf("steampipe binary found in PATH: %s", steampipePath)

	cmdArgs := []string{"query", q, "--output", "json"}
	if log.IsLevelEnabled(log.DebugLevel) {
		os.Setenv("STEAMPIPE_LOG_LEVEL", "DEBUG")
	}
	log.Debugf("cmdArgs: %s", cmdArgs)
	out, err := exec.Command(steampipePath, cmdArgs...).CombinedOutput()
	if err != nil {
		log.Errorf("%s: %s", err, string(out))
		s := strings.Replace(string(out), `"`, `\"`, -1)
		s = strings.TrimSpace(s)
		w.WriteHeader(400)
		fmt.Fprintf(w, "{\"error\": \"%s\"}", s)
		return
	}
	fmt.Fprintf(w, "%s", string(out))
}

func Serve(listenPort int, accessLog bool) {
	log.Debug("debug logging enabled")
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
