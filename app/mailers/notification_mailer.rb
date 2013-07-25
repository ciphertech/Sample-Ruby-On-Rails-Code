class NotificationMailer < ActionMailer::Base

  add_template_helper(Manager::NotificationsHelper)

  default from: "manager@cipher-tech.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.notice.subject
  #
  def notice(notification)
    @notification = notification

    mail to: @notification.user_email, :subject => "Cipher-tech wants you to know: #{@notification.notifier_type} #{@notification.message}"
  end

  def import_complete(to, status, vendor)
    @to = to
    @status = status
    @vendor = vendor
    mail to: @to.email, :subject => "Your inventory job has been completed."
  end

end
