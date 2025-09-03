package dto

import (
	"time"
	"example/pesto-backend/internal/models"
)

type ClipboardItemDTO struct {
	ID          uint   `json:"id"`
	ContentType string `json:"content_type" binding:"required"`
	Content     string `json:"content" binding:"required"`
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string `json:"updated_at"`
}

func (dto *ClipboardItemDTO) ToModel() *models.ClipboardItem {
	createdAt, _ := time.Parse(time.RFC3339, dto.CreatedAt)
	updatedAt, _ := time.Parse(time.RFC3339, dto.UpdatedAt)
	
	return &models.ClipboardItem{
		ID:          dto.ID,
		ContentType: dto.ContentType,
		Content:     dto.Content,
		CreatedAt:   createdAt,
		UpdatedAt:   updatedAt,
	}
}

func FromModel(model *models.ClipboardItem) *ClipboardItemDTO {
	return &ClipboardItemDTO{
		ID:          model.ID,
		ContentType: model.ContentType,
		Content:     model.Content,
		CreatedAt:   model.CreatedAt.Format(time.RFC3339),
		UpdatedAt:   model.UpdatedAt.Format(time.RFC3339),
	}
}
	