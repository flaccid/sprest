package main

import (
	"fmt"
	"os"

	"github.com/flaccid/sprest"
	"github.com/urfave/cli"

	log "github.com/sirupsen/logrus"
)

func beforeApp(c *cli.Context) error {
	fmt.Printf("sprest %s\n", "v0.0.1")

	switch c.GlobalString("log-level") {
	case "debug":
		log.SetLevel(log.DebugLevel)
	case "info":
		log.SetLevel(log.InfoLevel)
	case "warn":
		log.SetLevel(log.WarnLevel)
	case "error":
		log.SetLevel(log.ErrorLevel)
	case "":
		log.SetLevel(log.InfoLevel)
	default:
		log.Fatalf("%s is an invalid log level", c.GlobalString("log-level"))
	}

	log.Info("using log level " + log.GetLevel().String())

	return nil
}

func main() {
	app := cli.NewApp()
	app.Name = "sprest"
	app.Version = "v0.0.1"
	app.Usage = "rest interface for steampipe"
	app.Action = start
	app.Before = beforeApp
	app.Flags = []cli.Flag{
		cli.IntFlag{
			Name:  "port,p",
			Usage: "port the listen on",
			Value: 8080,
		},
		cli.BoolFlag{
			Name:  "access-log,a",
			Usage: "enable access logging of requests",
		},
		cli.StringFlag{
			Name:  "log-level,l",
			Usage: "log level to use (debug,warn,error,info); default: info",
		},
	}
	app.Run(os.Args)
}

func start(c *cli.Context) error {
	sprest.Serve(c.Int("port"),
		c.Bool("access-log"))

	return nil
}
