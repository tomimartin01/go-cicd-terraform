package app

import (
	"github.com/tomimartin01/go-cicd-terra/internal/calculator"
	"github.com/tomimartin01/go-cicd-terra/internal/config"
)

type Dependencies struct {
	Calculator calculator.Calculator
}

func Init() (App, Dependencies, error) {
	if err := config.InitEnv(); err != nil {
		return App{}, Dependencies{}, err
	}
	if err := config.InitLogger(); err != nil {
		return App{}, Dependencies{}, err
	}

	return App{}, Dependencies{Calculator: calculator.New()}, nil
}
