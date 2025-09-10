package config

import (
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

// AppConfig holds the application configuration.
type AppConfig struct {
	DBHost     string
	DBPort     int
	DBUser     string
	DBPassword string
	DBName     string
	DBSSLMode  string
}

// LoadConfig loads configuration from environment variables.
func LoadConfig() (*AppConfig, error) {
	// Load .env file if it exists
	godotenv.Load()

	dbPort, err := strconv.Atoi(os.Getenv("DB_PORT"))
	if err != nil {
		dbPort = 5432 // default port
	}

	return &AppConfig{
		DBHost:     os.Getenv("DB_HOST"),
		DBPort:     dbPort,
		DBUser:     os.Getenv("DB_USER"),
		DBPassword: os.Getenv("DB_PASSWORD"),
		DBName:     os.Getenv("DB_NAME"),
		DBSSLMode:  os.Getenv("DB_SSLMODE"),
	}, nil
}
