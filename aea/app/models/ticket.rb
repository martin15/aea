class Ticket < ActiveRecord::Base
  mount_uploader :filename, TicketUploader
  belongs_to :user

  def ticket_exist
    return false if self.filename.current_path.nil?
    self.filename.file.exists?
  end
end
