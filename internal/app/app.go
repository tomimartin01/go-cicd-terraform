package app

import cfg "github.com/tomimartin01/go-cicd-terra/internal/config"

type App struct{}

func (a App) Run(dep Dependencies) error {
	cfg.Logger.Infow("application started", "service", "go-cicd-terra", "APP_ENV", cfg.GetValue("APP_ENV"))

	result := dep.Calculator.Add(2, 3)
	cfg.Logger.Infow("calculation result", "result", result)

	return nil
}

func (a App) Close() {
	cfg.Logger.Infow("shutting down app")
	cfg.Logger.Sync()
}
