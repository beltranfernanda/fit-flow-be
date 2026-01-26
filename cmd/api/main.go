package main

import (
	"fit-flow-be/internal/app"
	"log"
)

func main() {
	router := app.InitializeRouter()

	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}

	log.Println("Server running on http://localhost:8080")
}