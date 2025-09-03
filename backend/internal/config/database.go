package config

import (
	"fmt"
	"example/pesto-backend/pkg/utils"
	"gorm.io/driver/sqlite"
    "gorm.io/gorm"
    "gorm.io/gorm/logger"
)

const DATABASE_PATH = "../../Clipboard.db"

func NewDB() (*gorm.DB, error) {
	
    err := CreateDatabaseIfNotExists()
    if err != nil {
        return nil, fmt.Errorf("failed to create database: %w", err)
    }

	db, err := gorm.Open(sqlite.Open(DATABASE_PATH), &gorm.Config{
        Logger: logger.Default.LogMode(logger.Info),
    })
    if err != nil {
        return nil, fmt.Errorf("failed to connect to database: %w", err)
    }

    return db, nil
}

func CreateDatabaseIfNotExists() error {
	return utils.CreateFileIfNotExists(DATABASE_PATH)
}
