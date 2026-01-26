package app

import (
    "github.com/gin-gonic/gin"
	"fit-flow-be/internal/adapters/http/handlers"
)

func InitializeRouter() *gin.Engine {
	router := gin.Default()

	pingHandler := handlers.NewPingHandler()

	routes := &handlers.Handlers{
		PingHandler: pingHandler,
	}

	routes.MapHandlers(router)
	
	return router
}