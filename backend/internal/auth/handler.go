package auth

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// Handler holds the dependencies for the authentication handlers.
type Handler struct {
	authService *Service
}

// NewHandler creates a new authentication handler.
func NewHandler(authService *Service) *Handler {
	return &Handler{authService: authService}
}

// RegisterRoutes sets up the routes for authentication.
func (h *Handler) RegisterRoutes(router *gin.Engine) {
	authGroup := router.Group("/auth")
	{
		authGroup.POST("/signup", h.SignUp)
	}
}

// SignUp handles the user registration endpoint.
func (h *Handler) SignUp(c *gin.Context) {
	var req SignUpRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.authService.SignUp(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	c.JSON(http.StatusCreated, user)
}
