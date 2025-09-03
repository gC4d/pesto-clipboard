package models

import (
	"time"
)

// ClipboardItem represents a clipboard item
// @Description A clipboard item with its content and metadata
// @Success 200 {object} ClipboardItem
type ClipboardItem struct {
	// ID of the clipboard item
	ID uint `json:"id" gorm:"primaryKey" example:"1"`
	// Creation timestamp
	CreatedAt time.Time `json:"created_at" example:"2025-01-01T00:00:00Z"`
	// Last update timestamp
	UpdatedAt time.Time `json:"updated_at" example:"2025-01-01T00:00:00Z"`
	// Deletion timestamp (if deleted)
	DeletedAt *time.Time `json:"deleted_at" example:"null"`
	// Content of the clipboard item
	Content string `json:"content" example:"Hello, world!"`
	// Type of the content (e.g., text, image, url)
	ContentType string `json:"content_type" example:"text"`
	// Whether this is the current clipboard item
	IsCurrent bool `json:"is_current" example:"true"`
}
