package handlers

import (
	"net/http"
	"strconv"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type ClipboardItemHandler struct {
	service *services.ClipboardItemService
}

func NewClipboardItemHandler(service *services.ClipboardItemService) *ClipboardItemHandler {
	return &ClipboardItemHandler{service: service}
}

// GetAll godoc
// @Summary Get all clipboard items
// @Description Get all clipboard items ordered by creation time
// @Tags clipboard
// @Accept json
// @Produce json
// @Success 200 {array} models.ClipboardItem
// @Failure 500 {object} map[string]string
// @Router /clipboard-items [get]
func (h *ClipboardItemHandler) GetAll(c *gin.Context) {
	items, err := h.service.GetAll(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

// GetByID godoc
// @Summary Get a clipboard item by ID
// @Description Get a specific clipboard item by its ID
// @Tags clipboard
// @Accept json
// @Produce json
// @Param id path int true "Clipboard Item ID"
// @Success 200 {object} models.ClipboardItem
// @Failure 400 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /clipboard-items/{id} [get]
func (h *ClipboardItemHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID format"})
		return
	}
	item, err := h.service.GetByID(c.Request.Context(), uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, item)
}

// GetByContentType godoc
// @Summary Get clipboard items by content type
// @Description Get all clipboard items with a specific content type
// @Tags clipboard
// @Accept json
// @Produce json
// @Param content_type path string true "Content Type"
// @Success 200 {array} models.ClipboardItem
// @Failure 500 {object} map[string]string
// @Router /clipboard-items/content/{content_type} [get]
func (h *ClipboardItemHandler) GetByContentType(c *gin.Context) {
	contentType := c.Param("content_type")
	items, err := h.service.GetByContentType(c.Request.Context(), contentType)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

// GetCurrent godoc
// @Summary Get the current clipboard item
// @Description Get the current clipboard item (the most recently copied item)
// @Tags clipboard
// @Accept json
// @Produce json
// @Success 200 {object} models.ClipboardItem
// @Failure 500 {object} map[string]string
// @Router /clipboard-items/current [get]
func (h *ClipboardItemHandler) GetCurrent(c *gin.Context) {
	item, err := h.service.GetCurrent(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, item)
}

// Delete godoc
// @Summary Delete a clipboard item
// @Description Delete a clipboard item by its ID
// @Tags clipboard
// @Accept json
// @Produce json
// @Param id path int true "Clipboard Item ID"
// @Success 200 {object} map[string]string
// @Failure 400 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /clipboard-items/{id} [delete]
func (h *ClipboardItemHandler) Delete(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID format"})
		return
	}
	err = h.service.Delete(c.Request.Context(), uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Clipboard item deleted successfully"})
}

// Create godoc
// @Summary Create a new clipboard item
// @Description Create a new clipboard item
// @Tags clipboard
// @Accept json
// @Produce json
// @Param item body models.ClipboardItem true "Clipboard Item"
// @Success 200 {object} models.ClipboardItem
// @Failure 400 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /clipboard-items [post]
func (h *ClipboardItemHandler) Create(c *gin.Context) {
	var item models.ClipboardItem
	if err := c.ShouldBindJSON(&item); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := h.service.Create(c.Request.Context(), &item)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, item)
}
