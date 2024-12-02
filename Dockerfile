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

# Add GOPATH/bin to PATH persistently
ENV PATH=$PATH:$(go env GOPATH)/bin

# Verify PATH in a subsequent step
RUN echo $PATH

# Build the Go binary
RUN orchestrion go build -o app .

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./app"]
