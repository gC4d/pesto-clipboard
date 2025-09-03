package handlers

import (
	"net/http"
	"example/pesto-backend/internal/services"
	"github.com/gin-gonic/gin"
)

type ClipboardItemHandler struct {
	service services.ClipboardItemService
}

func NewClipboardItemHandler(service services.ClipboardItemService) *ClipboardItemHandler {
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