package utils

import "os"

func Getenv(key, defaultValue string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return defaultValue
}

func FileExists(path string) bool {
    _, err := os.Stat(path)
    return err == nil
}