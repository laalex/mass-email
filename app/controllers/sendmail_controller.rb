class SendmailController < ApplicationController
  require 'csv'

  def show
  end


  def do_send
    send_mail(params[:csv_file].tempfile.path)
    flash[:notice] = "Your emails will be dispateched in background"
    redirect_to root_url
  end


  private
    def send_mail(path)
      CSV.foreach(path, :headers => true, :col_sep => ';') do |row|
        person = {firstName: row['FIRST_NAME'], lastName: row['LAST_NAME'], email: row['EMAIL']}
        if !person[:email].blank?
          mail = {message: params[:message]["{:cols=>40, :ckeditor=>{:uiColor=>%22#AADC6E%22}}"], subject: params[:subject]}
          EmailSender.delay.send_email(person, mail)
        end
      end
    end
end
