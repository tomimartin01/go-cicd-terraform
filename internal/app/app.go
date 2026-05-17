package app

import (
	"context"
	"errors"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	cfg "github.com/tomimartin01/go-cicd-terra/internal/config"
)

type App struct{}

func (a App) Run(dep *Dependencies) error {
	serverErr := make(chan error, 1)

	go func() {
		cfg.Logger.Infow("http server started", "addr", dep.Srv.Addr, "APP_ENV", cfg.GetValue("APP_ENV"))
		serverErr <- dep.Srv.ListenAndServe()
	}()

	shutdownSignals := make(chan os.Signal, 1)
	signal.Notify(shutdownSignals, syscall.SIGTERM, syscall.SIGINT)
	defer signal.Stop(shutdownSignals)

	select {
	case sig := <-shutdownSignals:
		cfg.Logger.Infow("shutdown signal received", "signal", sig.String())
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()

		if err := dep.Srv.Shutdown(ctx); err != nil {
			return err
		}
		return nil
	case err := <-serverErr:
		if err != nil && !errors.Is(err, http.ErrServerClosed) {
			return err
		}
		return nil
	}
}

func (a App) Close() {
	cfg.Logger.Infow("shutting down app")
	cfg.Logger.Sync()
}
