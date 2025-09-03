package routers

import (
	"github.com/gin-gonic/gin"
	"example/pesto-backend/pkg/swagger"
)

type RouteInfo struct {
    Method      string
    Path        string
    InputType   any
    OutputType  any
    Summary     string
    Description string
    StatusCode  int
}


func RegisterRoute(router *gin.Engine, r RouteInfo, handler gin.HandlerFunc) {
    switch r.Method {
    case "POST":
        router.POST(r.Path, handler)
    case "GET":
        router.GET(r.Path, handler)
	case "PUT":
		router.PUT(r.Path, handler)
	case "DELETE":
		router.DELETE(r.Path, handler)
	case "PATCH":
		router.PATCH(r.Path, handler)
	default:
		router.Any(r.Path, handler)
    }

    
    swagger.GenerateSwaggerDoc(
		r.Path, r.Method, r.InputType, 
		r.OutputType, r.Summary, r.Description, 
		r.StatusCode,
	)
}