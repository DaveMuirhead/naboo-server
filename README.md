# naboo-server

The Naboo Server project houses a Phoenix-based REST API that serves a NuxtJS/VueJS-based front-end ([naboo-pwa](https://github.com/DaveMuirhead/naboo-pwa)).

This project is no longer active and was used as a means to try out various approaches with Elixir / Phoenix / NuxtJS.

## Stack

Elixir

<img src="https://elixir-lang.org/images/logo/logo.png" height="60" />

Phoenix Framework

<img src="https://hexdocs.pm/phoenix/assets/logo.png" height="60" />

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

## Consulting or Partnership

If you need help with your Elixir projects, contact <info@brsg.io> or visit <https://brsg.io>.

## License and Copyright

Copyright 2021 - Dave Muirhead - All Rights Reeserved

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
