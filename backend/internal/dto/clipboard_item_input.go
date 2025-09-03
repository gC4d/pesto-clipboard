package dto

import "example/pesto-backend/internal/models"

type ClipboardItemInputDto struct {
	ContentType string `json:"content_type" binding:"required"`
	Content     string `json:"content" binding:"required"`
}

func (dto *ClipboardItemInputDto) ToModel() *models.ClipboardItem {
	return &models.ClipboardItem{
		ContentType: dto.ContentType,
		Content:     dto.Content,
	}
}
