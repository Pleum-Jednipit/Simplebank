package api

type CustomError struct {
	message string
}

func (c *CustomError) Error() string {
	return c.message
}
