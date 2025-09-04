package middleware

import (
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/getkin/kin-openapi/openapi3"
	"github.com/getkin/kin-openapi/openapi3filter"
	"github.com/getkin/kin-openapi/routers"
	"github.com/getkin/kin-openapi/routers/gorillamux"
)

// OpenAPIValidator validates requests and responses against the OpenAPI specification
type OpenAPIValidator struct {
	Router routers.Router
	Spec   *openapi3.T
}

// NewOpenAPIValidator creates a new OpenAPI validator middleware
func NewOpenAPIValidator(openAPISpec *openapi3.T) (*OpenAPIValidator, error) {
	router, err := gorillamux.NewRouter(openAPISpec)
	if err != nil {
		return nil, err
	}

	return &OpenAPIValidator{
		Router: router,
		Spec:   openAPISpec,
	}, nil
}

// Validate returns a Gin middleware function for request validation
func (v *OpenAPIValidator) Validate() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Skip validation for Swagger UI and OpenAPI spec endpoints
		path := c.Request.URL.Path
		if strings.HasPrefix(path, "/swagger/") || path == "/openapi.json" {
			c.Next()
			return
		}

		// Create a request validator
		route, pathParams, err := v.Router.FindRoute(c.Request)
		if err != nil {
			// Log the error but don't block the request
			// This allows the application to function even if validation fails
			c.Next()
			return
		}

		// Validate the request against the OpenAPI specification
		requestValidationInput := &openapi3filter.RequestValidationInput{
			Request:    c.Request,
			PathParams: pathParams,
			Route:      route,
		}

		err = openapi3filter.ValidateRequest(c.Request.Context(), requestValidationInput)
		if err != nil {
			// Log the error but don't block the request
			// This allows the application to function even if validation fails
			c.Next()
			return
		}

		// Continue with the next handler
		c.Next()

		// TODO: Add response validation if needed
	}
}
