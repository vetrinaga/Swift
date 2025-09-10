package user

import (
	"database/sql"
	"time"

	"github.com/google/uuid"
)

// Repository provides access to the user storage.
type Repository struct {
	db *sql.DB
}

// NewRepository creates a new user repository.
func NewRepository(db *sql.DB) *Repository {
	return &Repository{db: db}
}

// Create inserts a new user into the database.
func (r *Repository) Create(user *User) error {
	user.ID = uuid.NewString()
	user.CreatedAt = time.Now()
	user.UpdatedAt = time.Now()

	query := `
		INSERT INTO users (id, email, phone_number, password_hash, google_id, apple_id, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`
	_, err := r.db.Exec(query, user.ID, user.Email, user.PhoneNumber, user.Password, user.GoogleID, user.AppleID, user.CreatedAt, user.UpdatedAt)
	return err
}
