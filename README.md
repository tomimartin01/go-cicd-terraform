# go-cicd-terraform

A Go application demonstrating CI/CD best practices with structured logging, graceful shutdown, and unit testing.

## Features

- **Structured Logging**: Uses [Zap](https://github.com/uber-go/zap) for fast, structured JSON logging
- **Environment Configuration**: Supports multiple environments (development, production, testing)
- **Graceful Shutdown**: Proper signal handling for clean application termination
- **Unit Testing**: Comprehensive test coverage with example calculator package
- **Calculator Package**: Simple arithmetic operations with full test coverage

## Project Structure

```
.
├── cmd/
│   └── main.go              # Application entrypoint
├── internal/
│   ├── app/                 # App lifecycle management
│   ├── calculator/          # Business logic example with tests
│   └── config/              # Configuration and logger setup
├── go.mod
├── go.sum
├── terraform/              # Infra as code (AWS)
├── .covignore              # Coverage ignore patterns
└── README.md
```

## Getting Started

### Prerequisites

- Go 1.24.2 or later

### Installation

```bash
git clone https://github.com/tomimartin01/go-cicd-terraform.git
cd go-cicd-terraform
go mod tidy
```

### Running the Application

```bash
# Development mode (default)
go run cmd/main.go

# Production mode
APP_ENV=production go run cmd/main.go

# Testing mode (no logs)
APP_ENV=testing go run cmd/main.go
```

The application will start, log initialization details, and wait for a shutdown signal (`Ctrl+C` or `SIGTERM`).

### Running Tests

```bash
# Run all tests in internal packages
go test -cover ./internal/...

# Run calculator tests with verbose output
go test -v ./internal/calculator

# Run with coverage report
go test -cover -coverprofile=coverage.out ./internal/calculator
view coverage.out
```

## Terraform (Infra)

This repository includes Terraform configuration in `terraform/` to provision AWS resources for the migration to ECS.

Current Terraform scope includes:

- **ECR Repository** for container images
- **ECR Lifecycle Policy** to expire old images automatically
- **ECS Cluster** for running services/tasks
- **CloudWatch Log Group** for ECS logs
- Existing Lambda/API Gateway resources (still present during migration)

### Terraform Prerequisites

- Terraform `>= 1.5`
- AWS credentials configured locally (for example with profile `dev-profile`)
- S3 backend bucket already created (as configured in `terraform/providers.tf`)

### Terraform Commands

```bash
cd terraform

# Format files
terraform fmt

# Initialize backend/providers
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show outputs (for example API endpoint / ECR URL)
terraform output

# Destroy resources (careful)
terraform destroy
```

### Optional: one-command local deploy script

You can also use:

```bash
cd terraform
./deploy.sh
```

The script compiles the Go binary for Lambda and then runs Terraform apply.

## Environment Variables

- **`APP_ENV`**: Sets the application environment
  - `development` (default): Verbose console logs
  - `production`: JSON structured logs
  - `testing`: No logs (uses Zap no-op logger)

## Logging

The application uses Zap for structured logging. Examples:

```go
config.Logger.Infow("application started", "service", "go-cicd-terra", "env", appEnv)
config.Logger.Errorw("application error", "error", err)
config.Logger.Debugw("example debug log", "workers", 2)
```

In testing, logs are automatically disabled via `APP_ENV=testing` to keep test output clean.

## License

MIT
