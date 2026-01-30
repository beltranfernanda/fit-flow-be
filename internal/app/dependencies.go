package app

import (
	"fit-flow-be/internal/adapters/http/handlers"

	"github.com/gin-gonic/gin"
)

func InitializeRouter() *gin.Engine {
	router := gin.Default()

	pingHandler := handlers.NewPingHandler()
	authHandler := handlers.NewAuthHandler()

	routes := &handlers.Handlers{
		PingHandler: pingHandler,
		AuthHandler: authHandler,
	}

	routes.MapHandlers(router)

	return router
}
