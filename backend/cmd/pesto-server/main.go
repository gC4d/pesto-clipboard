package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"example/pesto-backend/internal/config"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/internal/repositories"
	"example/pesto-backend/internal/services"
)

func main() {

	db, err := config.NewDB()
	if err != nil {
		log.Fatalf("❌ Failed to setup database: %v", err)
	}

	db.AutoMigrate(&models.ClipboardItem{})

	clipboardItemRepository := repositories.NewClipboardItemRepository(db)
	services.NewClipboardItemService(clipboardItemRepository)

	engine := gin.Default()
	engine.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello, World!")
	})
	engine.Run(":8080")
}
