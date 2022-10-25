package main

import (
	"errors"
	"fmt"
	"os"
	"strings"

	log "github.com/sirupsen/logrus"
)

func echo(args []string) error {
	if len(args) < 2 {
		return errors.New("no argument to echo")
	}
	_, err := fmt.Println(strings.Join(args[1:], " "))
	return err
}

func main() {
	if err := echo(os.Args); err != nil {
		log.Error(err)
		os.Exit(1)
	}
}
