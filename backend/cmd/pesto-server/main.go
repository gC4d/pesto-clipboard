package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	ginSwagger "github.com/swaggo/gin-swagger"
	swaggerFiles "github.com/swaggo/files"

	"example/pesto-backend/internal/config"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/internal/repositories"
	"example/pesto-backend/internal/services"
	"example/pesto-backend/internal/handlers"
)

func main() {

	db, err := config.NewDB()
	if err != nil {
		log.Fatalf("❌ Failed to setup database: %v", err)
	}

	db.AutoMigrate(&models.ClipboardItem{})

	clipboardItemRepository := repositories.NewClipboardItemRepository(db)
	clipboardItemService := services.NewClipboardItemService(clipboardItemRepository)
	clipboardItemHandler := handlers.NewClipboardItemHandler(clipboardItemService)

	engine := gin.Default()
	engine.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello, World!")
	})

	engine.GET("/clipboard-items", clipboardItemHandler.GetAll)
	engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	engine.Run(":8080")
}
