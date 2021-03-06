class User < ActiveRecord::Base
  # attr_accessible :email, :username, :password, :password_confirmation
  attr_accessor :password, :previous_email, :previous_username, :new_password, :new_password_confirmation
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :username, :on => :create
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_presence_of :email, :if => Proc.new {|user| 
  user.previous_email.nil? || user.email != user.previous_email}
  validates_presence_of :username, :if => Proc.new {|user| 
  user.previous_username.nil? || user.username != user.previous_username}


  def self.authenticate_by_email(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def self.authenticate_by_username(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.from_omniauth(auth)
    a = auth.slice(:provider, :uid)
    #!!!!as twitter doesnt send email we create user with uid for twitter!!!
    auth[:provider] == "facebook" ? user = User.where("email = ?", auth.info.email).first || User.where("provider = ? or uid =?",a.provider,a.uid).first_or_initialize  : user = User.where(:provider => auth.provider, :uid => auth.uid).first_or_initialize
    user.username = auth.info.name
    user.oauth_token = auth.credentials.token
    # auth[:provider] == "facebook" ? user.oauth_expires_at = Time.at(auth.credentials.expires_at) : user.oauth_expires_at =Time.at(auth[:extra][:access_token].params[:x_auth_expires])

    #for twitter we are generating random email bcz twitter doesnt send email
    auth[:provider] == "facebook" ? user.email = auth.info.email : user.email = auth.info.name.parameterize + Time.now.to_i.to_s + "@ruturaj.com"
    #as password is must we generate random password if anyone login with fb or twitter !!!!
    user.password = (0...20).map { ('a'..'z').to_a[rand(26)] }.join
    user.save!
    user
  end
end
