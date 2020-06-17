use Mix.Config

# Bamboo Mailer configuration
config :naboo, NabooWeb.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "mail.brsg.io",
  hostname: "brsg.io",
  port: 465,
  username: {:system, "APPS_SMTP_USERNAME"},
  password: {:system, "APPS_SMTP_PASSWORD"},
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 1,
  no_mx_lookups: false,
  auth: :always
