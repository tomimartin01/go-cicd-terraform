package app

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/tomimartin01/go-cicd-terra/internal/calculator"
	"github.com/tomimartin01/go-cicd-terra/internal/config"
	internalhttp "github.com/tomimartin01/go-cicd-terra/internal/http"
)

type Dependencies struct {
	Calculator calculator.Calculator
	Srv        *http.Server
}

func Init() (App, *Dependencies, error) {
	dep := &Dependencies{}
	if err := config.InitEnv(); err != nil {
		return App{}, dep, err
	}
	if err := config.InitLogger(); err != nil {
		return App{}, dep, err
	}

	mux := internalhttp.InitMux()
	if mux == nil {
		return App{}, dep, config.NewAppError(config.InternalError, errors.New("failed to initialize HTTP server"))
	}

	cal := calculator.New()
	dep.Calculator = cal

	srv := Route(dep, mux)
	dep.Srv = srv

	return App{}, dep, nil
}

func Route(dep *Dependencies, mux *http.ServeMux) *http.Server {
	mux.HandleFunc("/calculate", func(w http.ResponseWriter, r *http.Request) {

		result := dep.Calculator.Add(2, 3)
		config.Logger.Infow("calculation result", "result", result)

		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(fmt.Sprintf("calculator result: %d\n", result)))
	})

	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte("ok\n"))
	})

	return &http.Server{
		Addr:    ":80",
		Handler: mux,
	}
}
