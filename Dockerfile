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

# Build the Go binary
RUN go build -o app .

# Use a lightweight image for the final artifact
FROM alpine:latest

# Set up a working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/app .

# Expose the port
EXPOSE 8080

# Run the application
CMD ["./app"]
