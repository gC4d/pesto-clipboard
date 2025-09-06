package services

import (
	"context"
	"example/pesto-backend/internal/models"
	"example/pesto-backend/internal/repositories"
	"gorm.io/gorm"
)

type ClipboardItemService struct {
	repository repositories.ClipboardItemRepository
}

func NewClipboardItemService(repository repositories.ClipboardItemRepository) *ClipboardItemService {
	return &ClipboardItemService{repository: repository}
}

func (s *ClipboardItemService) Create(ctx context.Context, item *models.ClipboardItem) error {
	currentItem, err := s.repository.GetCurrent(ctx)
	if err != nil && err != gorm.ErrRecordNotFound {
		return err
	}
	if currentItem != nil {
		currentItem.IsCurrent = false
		s.repository.Update(ctx, currentItem)
	}
	item.IsCurrent = true
	return s.repository.Create(ctx, item)
}

func (s *ClipboardItemService) GetAll(ctx context.Context) ([]*models.ClipboardItem, error) {
	return s.repository.GetAll(ctx)
}

func (s *ClipboardItemService) GetByID(ctx context.Context, id uint) (*models.ClipboardItem, error) {
	return s.repository.GetByID(ctx, id)
}

func (s *ClipboardItemService) GetByContentType(ctx context.Context, contentType string) ([]*models.ClipboardItem, error) {
	return s.repository.GetByContentType(ctx, contentType)
}

func (s *ClipboardItemService) GetCurrent(ctx context.Context) (*models.ClipboardItem, error) {
	return s.repository.GetCurrent(ctx)
}

func (s *ClipboardItemService) Delete(ctx context.Context, id uint) error {
	return s.repository.Delete(ctx, id)
}
	