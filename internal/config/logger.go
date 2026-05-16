package config

import (
	"os"
	"strings"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var Logger *zap.SugaredLogger

func InitLogger() error {
	envVal := strings.ToLower(strings.TrimSpace(os.Getenv("APP_ENV")))

	var cfg zap.Config
	switch envVal {
	case EnvTesting:
		Logger = zap.NewNop().Sugar()
		return nil
	case EnvDevelopment:
		cfg = zap.NewDevelopmentConfig()
		cfg.Encoding = "console"
	case EnvProduction:
		cfg = zap.NewProductionConfig()
		cfg.Encoding = "json"
	default:
		cfg = zap.NewDevelopmentConfig()
		cfg.Encoding = "console"
	}

	cfg.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	cfg.OutputPaths = []string{"stdout"}
	cfg.ErrorOutputPaths = []string{"stderr"}

	zl, err := cfg.Build(zap.AddCaller())
	if err != nil {
		return err
	}

	Logger = zl.Sugar()
	return nil
}

func Sync() error {
	if Logger == nil {
		return nil
	}
	return Logger.Sync()
}
