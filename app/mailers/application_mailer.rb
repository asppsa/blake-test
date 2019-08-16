# The ApplicationMailer class is the base class inherited by all mailers in the
# app.  It provides the default mail settings.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
