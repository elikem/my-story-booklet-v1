class SendIdmlFileToTswJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_id, file_path)
    Mailer.send_idml_file_to_tsw(user_id, file_path).deliver_now
  end
end
