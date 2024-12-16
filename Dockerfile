# Start with a base image
FROM golang:1.23 AS builder

# Set the working directory
WORKDIR /app

# Copy Go modules manifests
COPY go.mod go.sum ./

# Download Go modules
RUN go mod download

# Copy the source code
COPY . .

RUN mkdir -p /usr/local/bin 

RUN GOBIN=/usr/local/bin go install github.com/DataDog/orchestrion@latest

# Build the Go binary
ENV GOFLAGS="${GOFLAGS} '-toolexec=/usr/local/bin/orchestrion toolexec'"

RUN go build -o app .

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./app"]