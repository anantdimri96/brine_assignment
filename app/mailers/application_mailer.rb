# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'assignment@brine.com'
  layout 'mailer'
end
