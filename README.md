## Description

HTTP server used for mocking Multi CD APIs.

It can be used for development and for stress testing.

Implemented using [WireMock](https://wiremock.org/).

## Running locally

```bash
docker run -it --rm -p 3001:8080 --name wiremock -v $PWD:/home/wiremock wiremock/wiremock:2.35.0 -v --global-response-templating
```

## Usage

### Fulfillment Orders API

```bash
curl --request GET --url http://localhost:3001/v1/123/orders/456/fulfillment-orders/ -H "Authentication: Bearer ABC"
curl --request GET --url http://localhost:3001/v1/123/orders/456/fulfillment-orders/123/ -H "Authentication: Bearer ABC"
curl --request DELETE --url http://localhost:3001/v1/123/orders/456/fulfillment-orders/123/ -H "Authentication: Bearer ABC"
curl --request POST --url http://localhost:3001/v1/123/orders/456/fulfillment-orders/ -H "Authentication: Bearer ABC" -H "Content-Type: application/json" -d '
{
  "location": {
    "id": 01GRKDFX9QMNRBE3X5DAV21MGA
  },
  "order": {
    "id": 456
  },
  "line_items": [
    {}
  ],
  "recipient": {
    "name": "Recipient name"
  },
  "shipping": {
    "type": "ship"
  },
  "destination": {
    "zipcode": "12910802"
  }
}
'
curl --request PATCH --url http://localhost:3001/v1/123/orders/123/fulfillment-orders/01GRKDJKZ5RH81593CVGXWN2W5/ -H "Authentication: Bearer ABC" -H "Content-Type: application/json" -d '
{
  "status": "FULFILLED"
}
```

### Orders API

```bash
curl --request GET --url http://localhost:3001/v1/123/orders/456/ -H "Authentication: Bearer ABC"
curl --request GET --url http://localhost:3001/v1/123/orders/456/\?aggregates\=fulfillments -H "Authentication: Bearer ABC"
```


To replicate real world performance it's possible to add delays to every call. For example, we could simulate a 250ms average response time using:
```bash
curl --request POST \
  --url http://localhost:3001/__admin/settings \
  --header 'Content-Type: application/json' \
  --data '{    
	"delayDistribution": {
  	"type": "lognormal",
    "median": 250,
    "sigma": 0.1
	}
}'
```

## Development

Add new mocks in `mappings` folder. To avoid URL conflicts between different services, please include a prefix (i.e: `/dLocal/`) in every URL.

## Build

```bash
docker build . -t multicd-mocks
docker run --rm -p 3001:8080 multicd-mocks
```
