class ReportController < ApplicationController

  before_filter :check_permission

  def search_by_date

    #raise start_datefield.inspect
    @attendance_logs = []
    if params[:commit] == 'Search'
      email = params[:search][:email]

      if !params[:search][:email].present?
          redirect_to search_by_date_url,  :notice => "Please enter the email number" and return
      end

      month_from = params[:search][:from_date]

      month_to = params[:search][:to_date]
      start_datefield = "#{month_from} 08:00:00 +0600"

      #end_datefield = "#{params[:search]["to(1i)"]}-#{month_to}-#{params[:search]["to(3i)"]} #{params[:search]["to(4i)"]}:#{params[:search]["to(5i)"]}:00 +0600"

      start_date = DateTime.parse(start_datefield)

      end_date = Time.now.strftime("%I:%M")
      to_date = "#{month_to} #{end_date}:00 +600"
      check_date = DateTime.parse(to_date)
      if @user = User.find_by_email(params[:search][:email])
        user_id = @user.id

      else
        redirect_to search_by_date_url, :notice => "email number is wrong"
      end
      if check_date < start_date
         redirect_to search_by_date_path, :notice => "Please select appropriate date"
      else
       @attendance_logs = AttendanceLog.where("user_id=? AND logged_in_at >= ? AND  logged_in_at <= ?", user_id,start_date,to_date  )
      end


      #raise @attendance_logs.inspect
      #@attendance_logs = @attendance_logs.where("#{logged_in} >= #{start_datefield} AND #{logged_in} <= #{end_datefield}")

      #@attendance_logs = @attendance_logs.where("logged_in_at BETWEEN #{start_datefield} AND #{end_datefield}")

    end
  end

  def show_history
    if !session[:user] || (session[:user] && !session[:user].is?(:admin))
      redirect_to root_url, :notice => 'You have not enough permission to access' and return
    else
      @attendance_logs = AttendanceLog.all
    end
    #@attendance_logs = AttendanceLog.all
  end

  def find_user_email
    #redirect_to find_user_by_email_path
  end

  def show_user_history

    email = params[:find_user_email][:email]
    if @user = User.find_by_email(email)
      user_id = @user.id
      @attendance_logs = AttendanceLog.find_all_by_user_id(user_id)

    else
      flash[:notice] =  "there is no user with such name"
      redirect_to find_user_email_path
    end
  end

  # @return [Object]

end
