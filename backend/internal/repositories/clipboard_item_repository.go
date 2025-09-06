package repositories

import (
	"context"
	"example/pesto-backend/internal/models"
	"gorm.io/gorm"
)

// ClipboardItemRepository defines the interface for clipboard item operations
type ClipboardItemRepository interface {
	Create(ctx context.Context, item *models.ClipboardItem) error
	GetAll(ctx context.Context) ([]*models.ClipboardItem, error)
	GetByID(ctx context.Context, id uint) (*models.ClipboardItem, error)
	GetByContentType(ctx context.Context, contentType string) ([]*models.ClipboardItem, error)
	GetCurrent(ctx context.Context) (*models.ClipboardItem, error)
	Update(ctx context.Context, item *models.ClipboardItem) error
	Delete(ctx context.Context, id uint) error
}

// gormClipboardItemRepository implements ClipboardItemRepository
var _ ClipboardItemRepository = (*gormClipboardItemRepository)(nil)

type gormClipboardItemRepository struct {
	db *gorm.DB
}

// Update implements ClipboardItemRepository.
func (r *gormClipboardItemRepository) Update(ctx context.Context, item *models.ClipboardItem) error {
	return r.db.WithContext(ctx).Save(item).Error
}

// NewClipboardItemRepository creates a new clipboard item repository
func NewClipboardItemRepository(db *gorm.DB) ClipboardItemRepository {
	return &gormClipboardItemRepository{db: db}
}

// Create creates a new clipboard item
func (r *gormClipboardItemRepository) Create(ctx context.Context, item *models.ClipboardItem) error {
	return r.db.WithContext(ctx).Create(item).Error
}

// GetAll retrieves all clipboard items
func (r *gormClipboardItemRepository) GetAll(ctx context.Context) ([]*models.ClipboardItem, error) {
	var items []*models.ClipboardItem
	err := r.db.WithContext(ctx).Order("created_at DESC").Find(&items).Error
	return items, err
}

// GetByID retrieves a clipboard item by ID
func (r *gormClipboardItemRepository) GetByID(ctx context.Context, id uint) (*models.ClipboardItem, error) {
	var item models.ClipboardItem
	err := r.db.WithContext(ctx).First(&item, id).Error
	return &item, err
}

// Delete deletes a clipboard item by ID
func (r *gormClipboardItemRepository) Delete(ctx context.Context, id uint) error {
	return r.db.WithContext(ctx).Delete(&models.ClipboardItem{}, id).Error
}

// GetByContentType retrieves all clipboard items by content type
func (r *gormClipboardItemRepository) GetByContentType(ctx context.Context, contentType string) ([]*models.ClipboardItem, error) {
	var items []*models.ClipboardItem
	err := r.db.WithContext(ctx).Where("content_type = ?", contentType).Find(&items).Error
	return items, err
}

// GetCurrent retrieves the current clipboard item
func (r *gormClipboardItemRepository) GetCurrent(ctx context.Context) (*models.ClipboardItem, error) {
	var item models.ClipboardItem
	err := r.db.WithContext(ctx).Where("is_current = ?", true).First(&item).Error
	return &item, err
}
