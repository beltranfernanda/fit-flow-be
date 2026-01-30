package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct{}

func NewAuthHandler() *AuthHandler {
	return &AuthHandler{}
}

func (h *AuthHandler) GetAuthInfo(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "this is auth service",
	})
}
