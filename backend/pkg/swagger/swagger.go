package swagger

import (
	"context"
	"fmt"
	"reflect"

	"github.com/getkin/kin-openapi/openapi3"
	"github.com/getkin/kin-openapi/openapi3gen"
)

var (
	OpenAPIDoc *openapi3.T
	generator   *openapi3gen.Generator
)

func init() {
	generator = openapi3gen.NewGenerator()
	OpenAPIDoc = &openapi3.T{
		OpenAPI: "3.0.3",
		Info: &openapi3.Info{
			Title:       "Pesto Clipboard API",
			Description: "A clipboard manager API with automatic monitoring",
			Version:     "1.0.0",
		},
		Servers: openapi3.Servers{
			&openapi3.Server{
				URL:         "http://localhost:8080",
				Description: "Local development server",
			},
		},
		Paths: &openapi3.Paths{},
	}
}

// GenerateSwaggerDoc adds a new route to OpenAPI doc
func GenerateSwaggerDoc(
	path string,
	method string,
	inputType any,
	outputType any,
	summary string,
	description string,
	statusCode int,
) {
	// Generate schemas using kin-openapi's generator
	var inSchema *openapi3.SchemaRef
	var outSchema *openapi3.SchemaRef
	var err error

	if inputType != nil && reflect.TypeOf(inputType) != nil {
		inSchema, err = generator.NewSchemaRefForValue(inputType, nil)
		if err != nil {
			// Fallback to basic schema
			inSchema = &openapi3.SchemaRef{
				Value: &openapi3.Schema{
					Type:       &openapi3.Types{"object"},
					Properties: map[string]*openapi3.SchemaRef{},
				},
			}
			addFieldsToSchema(reflect.TypeOf(inputType), inSchema)
		}
	} else {
		inSchema = &openapi3.SchemaRef{
			Value: &openapi3.Schema{
				Type: &openapi3.Types{"object"},
			},
		}
	}

	if outputType != nil && reflect.TypeOf(outputType) != nil {
		outSchema, err = generator.NewSchemaRefForValue(outputType, nil)
		if err != nil {
			// Fallback to basic schema
			outSchema = &openapi3.SchemaRef{
				Value: &openapi3.Schema{
					Type:       &openapi3.Types{"object"},
					Properties: map[string]*openapi3.SchemaRef{},
				},
			}
			addFieldsToSchema(reflect.TypeOf(outputType), outSchema)
		}
	} else {
		outSchema = &openapi3.SchemaRef{
			Value: &openapi3.Schema{
				Type: &openapi3.Types{"object"},
			},
		}
	}

	responses := openapi3.NewResponses()
	responses.Set(fmt.Sprintf("%d", statusCode), &openapi3.ResponseRef{
		Value: &openapi3.Response{
			Description: &description,
			Content: openapi3.Content{
				"application/json": &openapi3.MediaType{
					Schema: outSchema,
				},
			},
		},
	})

	operation := &openapi3.Operation{
		OperationID: method + " " + path,
		Summary:     summary,
		Description: description,
		Responses:   responses,
	}

	if method == "POST" || method == "PUT" || method == "PATCH" {
		operation.RequestBody = &openapi3.RequestBodyRef{
			Value: &openapi3.RequestBody{
				Content: openapi3.Content{
					"application/json": &openapi3.MediaType{
						Schema: inSchema,
					},
				},
			},
		}
	}

	pi := OpenAPIDoc.Paths.Find(path)
	if pi == nil {
		pi = &openapi3.PathItem{}
		OpenAPIDoc.Paths.Set(path, pi)
	}

	switch method {
	case "POST":
		pi.Post = operation
	case "GET":
		pi.Get = operation
	case "PUT":
		pi.Put = operation
	case "DELETE":
		pi.Delete = operation
	case "PATCH":
		pi.Patch = operation
	}
}

func addFieldsToSchema(t reflect.Type, schema *openapi3.SchemaRef) {
	if t == nil || t.Kind() != reflect.Struct {
		return
	}
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		jsonTag := f.Tag.Get("json")
		if jsonTag == "" {
			jsonTag = f.Name
		}
		// Handle omitempty and other json tag options
		if jsonTag != "-" {
			if idx := len(jsonTag); idx > 0 {
				if jsonTag[idx-1] == ',' {
					jsonTag = jsonTag[:idx-1]
				} else if idx > 9 && jsonTag[idx-9:] == ",omitempty" {
					jsonTag = jsonTag[:idx-9]
				}
			}
			schema.Value.Properties[jsonTag] = &openapi3.SchemaRef{
				Value: &openapi3.Schema{
					Type: &openapi3.Types{"string"},
				},
			}
		}
	}
}

// GetOpenAPISpec returns the OpenAPI specification
func GetOpenAPISpec() *openapi3.T {
	return OpenAPIDoc
}

// Validate validates the OpenAPI specification
func Validate() error {
	return OpenAPIDoc.Validate(context.Background())
}
