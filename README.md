# naboo-server

The Naboo Server project houses a Phoenix-based API and Commanded-based CQRS/ES implementation.

## The Name

Much like, chronologically speaking, the Star Wars saga begins on Naboo, this project and naboo-pwa are hopefullly the beginning of a long and prosperous software product business saga.

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