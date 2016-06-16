class UploadIdmlToS3Job < ActiveJob::Base
  queue_as :upload_to_s3

  def perform(filename, local_path, remote_path)
    Upload.new.to_s3(filename: filename, local_path: local_path, remote_path: remote_path)
  end
end
