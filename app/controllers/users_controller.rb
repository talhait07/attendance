class UsersController < ApplicationController

  before_filter :check_permission, :only => [:index, :show, :new, :create, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index

    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def login
   redirect_to root_url, :notice => 'You are logged in already!' if session[:user].present?
  end

  def verify_login
    email = params[:login][:email]
    password = params[:login][:password]
    if  @user = User.find_by_email(email)
       user_id = @user.id
      roles_mask = @user.roles_mask
    end

    date_check =  Time.now.strftime("%Y-%m-%d")
    if roles_mask == 1
      is_logged_in = login_by_email(email, password)
    else
      @attdance_logs = AttendanceLog.where("user_id=? AND logged_in_at LIKE '%#{date_check}%'  ", user_id ).presence
      if @attdance_logs == nil
        is_logged_in = login_by_email(email, password)
      else
        redirect_to login_path,:notice => "you have already logged in there is no need to login again for today" and return
      end

    end

    #raise is_logged_in.inspect

    if is_logged_in
      user = User.find_by_email(email)

      if user
        session[:user] = user
        AttendanceLog::create_attendance_log(user)
      else
        user = User.create(:email => email)
        AttendanceLog::create_attendance_log(user)
        session[:user] = user
      end
      flash[:notice] = "You are logged in successfully"
      redirect_to root_url
    else
      flash[:notice] = "Login error.Please check your email and password"
      redirect_to login_path
    end

  end


def login_by_email(email='', password)
  is_logged_in = false
  if (email.match(/.+\b@akhoni.com$\b/i))
    require 'net/imap'
    require 'openssl'
    client = Net::IMAP.new("imap.gmail.com", 993, true, nil, false)
    begin
      client.login(email, password)
      client.logout
      is_logged_in = true
    rescue Exception => error
      logger.error "Error to login staging server :: #{error.message}"
    end
    client.disconnect
  else
    logger.error "Unknown domain to try login :: #{email}"
  end
  return is_logged_in
end

def forgot_password

end


def password_check
  if session[:user] == nil
    email = params[:email]
    @user = User.find_by_email(params[:email])
    pass = @user.password
    #raise password.inspect
    if @user.email != email
      flash[:notice] = "invalid email"
      redirect_to users_path


    else

      PasswordRecoveryMail.recovery_email(email, pass).deliver
      flash[:notice] = "we sent a email to your email number"
      redirect_to login_path
    end
  else
    flash[:notice] = "please logout first "
  end
end

 def logout
  id = session[:user].id
  attendance_log = AttendanceLog.where("user_id=?",id).order("id DESC").first
  attendance_log.logged_out_at = Time.now
  ch = attendance_log.save
  #raise ch.inspect
  session[:user] = nil
  redirect_to login_path, :notice => 'You are logged out now!'
 end
end
