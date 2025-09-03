// @title Pesto Clipboard API
// @version 1.0
// @description A clipboard manager API with automatic monitoring
// @host localhost:8080
// @BasePath /api/v1
package main

import (
	"log"

	"github.com/gin-gonic/gin"
	_ "example/pesto-backend/internal/docs"
	ginSwagger "github.com/swaggo/gin-swagger"
	swaggerFiles "github.com/swaggo/files"

	"example/pesto-backend/internal/config"
	"example/pesto-backend/internal/routes"
	"example/pesto-backend/internal/models"
)

func main() {

	db, err := config.NewDB()
	if err != nil {
		log.Fatalf("❌ Failed to setup database: %v", err)
	}

	db.AutoMigrate(&models.ClipboardItem{})

	engine := gin.Default()

	routes.SetupRoutes(engine, db)
	engine.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	engine.Run(":8080")
}
