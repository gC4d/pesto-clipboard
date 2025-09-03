package config

import (
	"fmt"

	"gorm.io/driver/sqlite"
    "gorm.io/gorm"
    "gorm.io/gorm/logger"
)

func NewDB() (*gorm.DB, error) {
	
	db, err := gorm.Open(sqlite.Open("Clipboard.db"), &gorm.Config{
        Logger: logger.Default.LogMode(logger.Info),
    })
    if err != nil {
        return nil, fmt.Errorf("failed to connect to database: %w", err)
    }

    return db, nil
}

