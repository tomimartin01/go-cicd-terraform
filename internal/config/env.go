package config

import (
	"os"

	"github.com/joho/godotenv"
)

const (
	EnvDevelopment = "development"
	EnvProduction  = "production"
	EnvLocal       = "local"
	EnvTesting     = "testing"
)

func InitEnv() error {
	return godotenv.Load("local.env")
}

func GetValue(key string) string {
	return os.Getenv(key)
}
