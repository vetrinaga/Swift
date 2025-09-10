package auth

import (
	"car-hire-app/backend/internal/user"

	"golang.org/x/crypto/bcrypt"
)

// Service provides authentication business logic.
type Service struct {
	userRepo *user.Repository
}

// NewService creates a new authentication service.
func NewService(userRepo *user.Repository) *Service {
	return &Service{userRepo: userRepo}
}

// SignUpRequest defines the request payload for signing up a new user.
type SignUpRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`
}

// SignUp handles the business logic for user registration.
func (s *Service) SignUp(req SignUpRequest) (*user.User, error) {
	// Hash the password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	// Create the user object
	hashedPasswordStr := string(hashedPassword)
	newUser := &user.User{
		Email:    &req.Email,
		Password: &hashedPasswordStr,
	}

	// Save the user to the database
	if err := s.userRepo.Create(newUser); err != nil {
		return nil, err
	}

	// Clear password before returning the user object
	newUser.Password = nil

	return newUser, nil
}
