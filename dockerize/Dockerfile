FROM golang:1.18-bullseye as base


WORKDIR /app

COPY . .
RUN go mod download
RUN go mod verify
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /webserver .

FROM gcr.io/distroless/static-debian11

COPY --from=base /webserver .

EXPOSE 80

CMD ["./webserver"]