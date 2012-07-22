class AttendanceLog < ActiveRecord::Base
  belongs_to :user

  def self.create_attendance_log(user)

    attendance = AttendanceLog.new
    attendance.user_id = user.id
    attendance.logged_in_at = Time.now
    attendance.save
  end
end
