Rails.application.routes.draw do
  root :to=>"homes#index"
  get "sign_in" => "authentications#sign_in"
  post "sign_in" => "authentications#login"
  get "signed_out" => "authentications#signed_out"
  
  get "new_user" => "authentications#new_user"
  post "new_user" => "authentications#register"

  get "change_password" => "authentications#change_password"
  
  get "account_settings" => "authentications#account_settings"
  put "account_settings" => "authentications#set_account_info"
  
  get "password_sent" => "authentications#password_sent"
  
  #for the page of forgot password and request link to email
  get "forgot_password" => "authentications#forgot_password"
  put "forgot_password" => "authentications#send_password_reset_instructions"

  
  get "password_reset" => "authentications#password_reset"
  put "password_reset" => "authentications#new_password"
end
