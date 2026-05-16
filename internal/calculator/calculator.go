package calculator

type Calculator interface {
	Add(a, b int) int
}
type calculator struct{}

func New() Calculator {
	return &calculator{}
}

func (c calculator) Add(a, b int) int {
	return a + b
}
