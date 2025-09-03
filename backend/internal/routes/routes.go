package routes

import (
	"github.com/gin-gonic/gin"

	"example/pesto-backend/internal/handlers"
	"example/pesto-backend/internal/services"
	"example/pesto-backend/internal/repositories"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/pkg/routers"
	"gorm.io/gorm"
)

func SetupRoutes(router *gin.Engine, db *gorm.DB) {
	clipboardItemRepository := repositories.NewClipboardItemRepository(db)
	clipboardItemService := services.NewClipboardItemService(clipboardItemRepository)
	clipboardItemHandler := handlers.NewClipboardItemHandler(clipboardItemService)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "POST",
		Path:        "/clipboard-items",
		InputType:   models.ClipboardItem{},
		OutputType:  models.ClipboardItem{},
		Summary:     "Create a clipboard item",
		Description: "Creates a new clipboard item",
		StatusCode:  201,
	}, clipboardItemHandler.Create)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "GET",
		Path:        "/clipboard-items",
		InputType:   nil,
		OutputType:  models.ClipboardItem{},
		Summary:     "Get all clipboard items",
		Description: "Retrieves all clipboard items",
		StatusCode:  200,
	}, clipboardItemHandler.GetAll)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "GET",
		Path:        "/clipboard-items/:id",
		InputType:   nil,
		OutputType:  models.ClipboardItem{},
		Summary:     "Get a clipboard item by ID",
		Description: "Retrieves a specific clipboard item by its ID",
		StatusCode:  200,
	}, clipboardItemHandler.GetByID)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "GET",
		Path:        "/clipboard-items/content/:content_type",
		InputType:   nil,
		OutputType:  models.ClipboardItem{},
		Summary:     "Get clipboard items by content type",
		Description: "Retrieves all clipboard items with a specific content type",
		StatusCode:  200,
	}, clipboardItemHandler.GetByContentType)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "GET",
		Path:        "/clipboard-items/current",
		InputType:   nil,
		OutputType:  models.ClipboardItem{},
		Summary:     "Get the current clipboard item",
		Description: "Retrieves the most recently copied clipboard item",
		StatusCode:  200,
	}, clipboardItemHandler.GetCurrent)

	routers.RegisterRoute(router, routers.RouteInfo{
		Method:      "DELETE",
		Path:        "/clipboard-items/:id",
		InputType:   nil,
		OutputType:  nil,
		Summary:     "Delete a clipboard item",
		Description: "Deletes a specific clipboard item by its ID",
		StatusCode:  200,
	}, clipboardItemHandler.Delete)
}
