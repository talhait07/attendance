class User < ActiveRecord::Base
  ROLES = %w[admin user]

  attr_accessible :email, :first_name, :last_name, :password ,:password_confirmation, :roles,:attendance_logs
  has_many :attendance_logs, :dependent => :destroy
  validates :email, :uniqueness => true
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end


end
