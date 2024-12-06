# Start with a base image
FROM golang:1.23 AS builder

# Set the working directory
WORKDIR /app

# COPY --from=datadog/serverless-init:1 /datadog-init /app/datadog-init

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
ENV ORCHESTRION_LOG_LEVEL=DEBUG

RUN go build -o app .

# Expose the port
EXPOSE 8080

# Run the application
# ENTRYPOINT ["/app/datadog-init"]

CMD ["./app"]
