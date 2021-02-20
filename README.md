# naboo-server

The Naboo Server project houses a Phoenix-based REST API that serves a NuxtJS/VueJS-based front-end ([naboo-pwa](https://github.com/DaveMuirhead/naboo-pwa)).

## API

### Accounts Context

#### Register User Command - POST /api/users
Request:
```json
Content-Type 'application/json'
{
  "user": {
    "email" : "kylo@ren.com",
    "password": "plain_text_password"
  }
}
```
Response:
```json
HTTP 201 Status Code
{
  "user": {
    "email" : "kylo@ren.com",
    "token": "token",
    "first_name": "Kylo",
    "last_name": "Ren"
  }
}
```
Error:
```json
HTTP 422 Status Code
{
  "errors": {
      "body": ["can't be empty"]
  }
}
```

*  
