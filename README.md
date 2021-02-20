# naboo-server

The Naboo Server project houses a Phoenix-based REST API that serves a NuxtJS/VueJS-based front-end ([naboo-pwa](https://github.com/DaveMuirhead/naboo-pwa)).

## Stack

<img src="https://phoenixframework.org/images/phoenix-78c0fd3233522383ea9093ef877c8851.png?vsn=d" />

with:
* [Ueberauth](https://github.com/ueberauth/ueberauth) + [Guardian](https://github.com/ueberauth/guardian) for auth
* [Bamboo](https://github.com/thoughtbot/bamboo) for email
* [Arc](https://github.com/stavro/arc) for file upload

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
