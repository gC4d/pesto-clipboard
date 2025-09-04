// @title Pesto Clipboard API
// @version 1.0
// @description A clipboard manager API with automatic monitoring
// @host localhost:8080
// @BasePath /api/v1
package main

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"example/pesto-backend/internal/config"
	"example/pesto-backend/internal/routes"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/pkg/swagger"
	"example/pesto-backend/pkg/middleware"
)

func main() {
	db, err := config.NewDB()
	if err != nil {
		log.Fatalf("❌ Failed to setup database: %v", err)
	}

	db.AutoMigrate(&models.ClipboardItem{})

	// Validate the OpenAPI specification
	if err := swagger.Validate(); err != nil {
		log.Printf("Warning: OpenAPI spec validation failed: %v", err)
	}

	engine := gin.Default()

	// Create and use OpenAPI validation middleware
	validator, err := middleware.NewOpenAPIValidator(swagger.GetOpenAPISpec())
	if err != nil {
		log.Printf("Warning: Failed to create OpenAPI validator: %v", err)
	} else {
		engine.Use(validator.Validate())
	}

	routes.SetupRoutes(engine, db)

	// Serve the OpenAPI specification
	engine.GET("/openapi.json", func(c *gin.Context) {
		c.JSON(http.StatusOK, swagger.GetOpenAPISpec())
	})

	// Serve the Swagger UI
	engine.LoadHTMLGlob("pkg/swagger/ui/*")
	engine.GET("/swagger/*any", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{})
	})

	engine.Run(":8080")
}
