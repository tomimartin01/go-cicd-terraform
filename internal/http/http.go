package http

import (
	"net/http"
)

func InitMux() *http.ServeMux {
	return http.NewServeMux()

}
