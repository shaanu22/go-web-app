# #build stage
# FROM golang:alpine AS builder
# RUN apk add --no-cache git
# WORKDIR /go/src/app
# COPY . .
# RUN go get -d -v ./...
# RUN go build -o /go/bin/app -v ./...

# #final stage
# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# COPY --from=builder /go/bin/app /app
# ENTRYPOINT /app
# LABEL Name=gowebapp Version=0.0.1
# EXPOSE 8080



FROM golang:1.21 AS base

WORKDIR /app

COPY go.mod ./

RUN go mod download 

COPY . .

RUN go build -o main .

#Final Stage - Distroless Image
FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static 

EXPOSE 8080 

CMD [ "./main" ]
