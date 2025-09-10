package user

import "time"

// User defines the structure for a user in the system.
type User struct {
	ID          string    `json:"id" db:"id"`
	Email       *string   `json:"email" db:"email"`
	PhoneNumber *string   `json:"phone_number" db:"phone_number"`
	Password    *string   `json:"-" db:"password_hash"` // Omit from JSON responses
	GoogleID    *string   `json:"-" db:"google_id"`
	AppleID     *string   `json:"-" db:"apple_id"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}
