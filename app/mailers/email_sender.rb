class EmailSender < ApplicationMailer
  default from: "no-reply@icmla-conference.org"

  def send_email(data, mail, files_attached)
    @firstName = data[:firstName]
    @lastName = data[:lastName]
    @email = data[:email]
    @subject = mail[:subject]
    @message = mail[:message]
    # Check if we have attachments
    if !files_attached.blank?
      files_attached.each do |file_attached|
        attachments[file_attached[:name]] = File.read(file_attached[:path])
      end
    end
    # Send the email
    mail(to: @email, subject: @subject)
  end
end
