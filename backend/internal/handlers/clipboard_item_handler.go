package handlers

import (
	"net/http"
	"strconv"
	"example/pesto-backend/internal/dto"
	"example/pesto-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type ClipboardItemHandler struct {
	service *services.ClipboardItemService
}

func NewClipboardItemHandler(service *services.ClipboardItemService) *ClipboardItemHandler {
	return &ClipboardItemHandler{service: service}
}

func (h *ClipboardItemHandler) GetAll(c *gin.Context) {
	items, err := h.service.GetAll(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

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

func (h *ClipboardItemHandler) GetByContentType(c *gin.Context) {
	contentType := c.Param("content_type")
	items, err := h.service.GetByContentType(c.Request.Context(), contentType)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

func (h *ClipboardItemHandler) GetCurrent(c *gin.Context) {
	item, err := h.service.GetCurrent(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, item)
}

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

func (h *ClipboardItemHandler) Create(c *gin.Context) {
	var item dto.ClipboardItemInputDto
	if err := c.ShouldBindJSON(&item); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := h.service.Create(c.Request.Context(), item.ToModel())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, item)
}
