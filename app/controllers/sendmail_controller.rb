class SendmailController < ApplicationController
  require 'csv'

  def show
  end


  def do_send
    if params[:csv_file].blank?
      flash[:notice] = "Please select a CSV file containing email addressess"
      redirect_to :back
    else
      # Upload the files first
      uploaded_files = do_upload!(params[:attachment])
      send_mail(params[:csv_file].tempfile.path, uploaded_files)
      flash[:notice] = "Your emails will be dispateched in background"
      redirect_to root_url
    end
  end


  private
    def do_upload!(files_array)
      return_array = []
      dir = 'public/data'
      if !files_array.blank?
        files_array.each do |upload_file|
          file_name = upload_file.original_filename
          path = File.join(dir, file_name)
          # write the file
          File.open(path, "wb") { |f| f.write(upload_file.read) }
          # Add the path into the return array
          return_array << {name: file_name, path: path}
        end
      end
      # Return array with uploaded files
      return_array
    end

    def send_mail(path, attachments)
      CSV.foreach(path, :headers => true, :col_sep => ';') do |row|
        person = {firstName: row['FIRST_NAME'], lastName: row['LAST_NAME'], email: row['EMAIL']}
        if !person[:email].blank?
          mail = {message: params[:message][:content], subject: params[:subject]}
          EmailSender.delay.send_email(person, mail, attachments)
        end
      end
    end
end
