## POST /api/v1/locations
Locationデータを新たに登録できる.

### Example

#### Request
```
POST /api/v1/locations HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 263
Content-Type: application/json, Accept-Version:v1
Host: www.example.com

{
  "ssid": "LILO5056161616",
  "bssid": "1616:1616:1616:1616:1616",
  "capabilities": "aaaaaaaaaa",
  "level": "418",
  "frequency": "118",
  "accuracy": "18",
  "latitude": 35.3929,
  "longitude": 139.4155,
  "provider": "network",
  "device_id": "Likef923r02",
  "way_id": "1",
  "speed": "16",
  "floor": "14"
}
```

#### Response
```
HTTP/1.1 201
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 3
Content-Type: application/json
ETag: "757b505cfd34c64c85ca5b5690ee5293"
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: e6d11275-7186-4e18-a858-82a32ac8c143
X-Runtime: 0.003849
X-XSS-Protection: 1; mode=block
```

## POST /api/v1/locations
Locationsデータが１増える.

### Example

#### Request
```
POST /api/v1/locations HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 263
Content-Type: application/json, Accept-Version:v1
Host: www.example.com

{
  "ssid": "LILO5056171717",
  "bssid": "1717:1717:1717:1717:1717",
  "capabilities": "aaaaaaaaaa",
  "level": "419",
  "frequency": "119",
  "accuracy": "19",
  "latitude": 35.3929,
  "longitude": 139.4155,
  "provider": "network",
  "device_id": "Likef923r02",
  "way_id": "1",
  "speed": "17",
  "floor": "15"
}
```

#### Response
```
HTTP/1.1 201
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 3
Content-Type: application/json
ETag: "757b505cfd34c64c85ca5b5690ee5293"
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: a1219b3e-803b-4e28-b743-f095e097587c
X-Runtime: 0.004776
X-XSS-Protection: 1; mode=block
```

## GET /api/v1/locations
登録されている情報を取得できる.

### Example

#### Request
```
GET /api/v1/locations HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 0
Content-Type: application/x-www-form-urlencoded
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 2
Content-Type: application/json
ETag: "d751713988987e9331980363e24189ce"
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: c28f5d09-5695-40eb-97ae-9f7f6c877b80
X-Runtime: 0.003887
X-XSS-Protection: 1; mode=block

[

]
```
