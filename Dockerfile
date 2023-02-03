FROM wiremock/wiremock:2.32.0

WORKDIR /home/wiremock

EXPOSE 8080

COPY . .
