use Mix.Config

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  s3: [
    scheme: "https://",
    host: "naboo-data.s3.amazonaws.com",
    region: "us-east-1"
  ]
