package handlers

import "github.com/gin-gonic/gin"

type Handlers struct {
	PingHandler *PingHandler
	AuthHandler *AuthHandler
}

func (h *Handlers) MapHandlers(router *gin.Engine) {
	router.GET("/ping", h.PingHandler.Ping)
	router.GET("/auth/info", h.AuthHandler.GetAuthInfo)
}
