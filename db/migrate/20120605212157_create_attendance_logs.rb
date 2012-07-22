class CreateAttendanceLogs < ActiveRecord::Migration
  def change
    create_table :attendance_logs do |t|
      t.integer :user_id
      t.datetime :logged_in_at
      t.datetime :logged_out_at
      t.text :comments

      t.timestamps
    end
  end
end
