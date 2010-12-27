# https://github.com/rails/exception_notification 
#
# Add EXCEPTION_RECIPIENTS environment variable to your deployment
# environment

recipients = ENV['EXCEPTION_RECIPIENTS'] || ''

Nodewise::Application.config.middleware.use(
  ExceptionNotifier,
  :email_prefix => "[nodewise-#{ Rails.env }] ",
  :sender_address => %{"nodewise exception" <no-reply@baltimorenode.org>},
  :exception_recipients => recipients.split(",")
)
