package main

import (
	"github.com/tomimartin01/go-cicd-terra/internal/app"
	cfg "github.com/tomimartin01/go-cicd-terra/internal/config"
)

func main() {
	app, dep, err := app.Init()
	if err != nil {
		panic(err)
	}
	defer app.Close()

	if err := app.Run(dep); err != nil {
		appErr := cfg.NewAppError(cfg.InternalError, err)
		cfg.Logger.Errorw("application error", "error", appErr.Error())
	}
}
