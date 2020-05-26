use Mix.Config

config :ueberauth, Ueberauth,
  base_path: "/api/oauth",
  providers: [
   #   facebook: {Ueberauth.Strategy.Facebook, []},
   #   github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]},
   google:
     {Ueberauth.Strategy.Google,
     [
       default_scope: "email profile",
       callbak_methods: ["POST"]
     ]},
   identity:
     {Ueberauth.Strategy.Identity,
     [
       uid_field: :email,
       callback_methods: ["POST"]
     ]},
   #  slack: {Ueberauth.Strategy.Slack, []},
   #  twitter: {Ueberauth.Strategy.Twitter, []}
  ]

#config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
#  client_id: System.get_env("FACEBOOK_APP_ID"),
#  client_secret: System.get_env("FACEBOOK_APP_SECRET"),
#  redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

#config :ueberauth, Ueberauth.Strategy.Github.OAuth,
#  client_id: System.get_env("GITHUB_CLIENT_ID"),
#  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
#  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

#config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
#  client_id: System.get_env("SLACK_CLIENT_ID"),
#  client_secret: System.get_env("SLACK_CLIENT_SECRET")

#config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
#  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
#  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

config :naboo, Naboo.Auth.Guardian,
  allowed_algos: ["HS512"],
  issuer: "Naboo",
  ttl: {2, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "bbOSDNSPINjOJWQNgt3fA9ny3RxLdyd12aaPM202vyjNZ7Rl2zlBtHmGqyHSHReM",
  serializer: Naboo.Auth.Guardian
