use Mix.Config

config :arc,
  asset_host: "http://localhost:4500/"

#Arc (https://github.com/stavro/arc) file uploader configuration
#config :arc,
#  storage: Arc.Storage.S3, # or Arc.Storage.Local
#  bucket: "naboo-data" # if using Amazon S3

#config :ex_aws,
#  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
#  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]