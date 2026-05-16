package config

type AppError struct {
	sentinel string
	err      error
}

const (
	InternalError = "INTERNAL_ERROR"
)

func NewAppError(sentinel string, err error) AppError {
	return AppError{
		sentinel: sentinel,
		err:      err,
	}
}

func (e AppError) Error() string {
	Logger.Errorw("eror", "sentinel", e.sentinel, "error", e.err)
	return e.sentinel
}
