## POST /api/v1/locations
Locationデータを新たに登録できる.

### Example

#### Request
```
POST /api/v1/locations HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 185
Content-Type: application/json, Accept-Version:v1
Host: www.example.com

{
  "ssid": "LILO5056444",
  "bssid": "44:44:44:44:44",
  "capabilities": "aaaaaaaaaa",
  "level": "46",
  "frequency": "16",
  "accuracy": "6",
  "latitude": "35.3929",
  "longitude": "139.4155",
  "provider": "network"
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
X-Request-Id: b3c178e5-41f9-46e7-8168-b50713364898
X-Runtime: 0.006442
X-XSS-Protection: 1; mode=block
```

## POST /api/v1/locations
Locationsデータが１増える.

### Example

#### Request
```
POST /api/v1/locations HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 185
Content-Type: application/json, Accept-Version:v1
Host: www.example.com

{
  "ssid": "LILO5056555",
  "bssid": "55:55:55:55:55",
  "capabilities": "aaaaaaaaaa",
  "level": "47",
  "frequency": "17",
  "accuracy": "7",
  "latitude": "35.3929",
  "longitude": "139.4155",
  "provider": "network"
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
X-Request-Id: ccf5161b-ef2f-49f5-9446-7769057945d8
X-Runtime: 0.002982onn
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
X-Request-Id: 5b8b90cc-e97c-434e-8a07-54169f23351d
X-Runtime: 0.003475
X-XSS-Protection: 1; mode=block

[

]
```
