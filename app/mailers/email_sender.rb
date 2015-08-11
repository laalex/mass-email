class EmailSender < ApplicationMailer
  default from: "no-reply@icmla-conference.org"

  def send_email(data, mail)
    @firstName = data[:firstName]
    @lastName = data[:lastName]
    @email = data[:email]
    @subject = mail[:subject]
    @message = mail[:message]
    mail(to: @email, subject: @subject)
  end
end
