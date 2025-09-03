package swagger

import (
	"fmt"
	"reflect"
)

func GenerateSwaggerDoc(
    path string,
    method string,
    inputType any,
    outputType any,
    summary string,
    description string,
    statusCode int,
) {
    inputType = reflect.TypeOf(inputType)
    outputType = reflect.TypeOf(outputType)
    fmt.Println("Registering Swagger route:", method, path)
    fmt.Println("Input type:", inputType)
    fmt.Println("Output type:", outputType)
    fmt.Println("Summary:", summary)
    fmt.Println("Description:", description)
    fmt.Println("Status code:", statusCode)
}