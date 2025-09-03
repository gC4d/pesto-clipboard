package models

import (
	"gorm.io/gorm"
)

type ClipboardItem struct {
	gorm.Model
	Content     string
	ContentType string
	IsCurrent   bool
}
