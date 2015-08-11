Rails.application.routes.draw do
  root 'sendmail#show'
  post '/send_emails', to: 'sendmail#do_send'
end
