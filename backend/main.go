// @title Pesto Clipboard API
// @version 1.0
// @description A clipboard manager API with automatic monitoring
// @host localhost:8080
// @BasePath /api/v1
package main

import (
	"log"

	"github.com/gin-gonic/gin"
	_ "example/pesto-backend/docs"
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


	engine.GET("/api/v1/clipboard-items", clipboardItemHandler.GetAll)
	engine.GET("/api/v1/clipboard-items/:id", clipboardItemHandler.GetByID)
	engine.GET("/api/v1/clipboard-items/content/:content_type", clipboardItemHandler.GetByContentType)
	engine.GET("/api/v1/clipboard-items/current", clipboardItemHandler.GetCurrent)
	engine.DELETE("/api/v1/clipboard-items/:id", clipboardItemHandler.Delete)
	engine.POST("/api/v1/clipboard-items", clipboardItemHandler.Create)
	engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	engine.Run(":8080")
}
