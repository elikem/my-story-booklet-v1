require 'fog/aws'

# p Upload.new.to_s3(filename: 'IMG_3910.JPG', remote_path: 'users/username')
# p Upload.new.get_url(remote_path: 'users/username', filename: 'IMG_3910.JPG')

# remote_path -- the folder on S3
# local_path -- the file path including the filename of the file
# filename -- just the filename of the file
# key -- the S3 API for the file path and file name
# body -- the S3 API for the file's path

class Upload
  def connection
    Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    )
  end

  def bucket
    connection.directories.get('my-story-booklet')
  end

  def to_s3(options = {})
    filename = options.fetch(:filename)
    local_path = options.fetch(:local_path, false)
    remote_path = options.fetch(:remote_path, false)

    if remote_path
      key = "#{remote_path}/#{filename}"
    end

    if local_path
      body = "#{local_path}"
    end

    bucket.files.create(
        key: key,
        body: File.open(body),
        public: true
    )
  end

  def get_file(options = {})
    full_remote_path = options.fetch(:full_remote_path, false)
    remote_path = options.fetch(:remote_path, false)
    filename = options.fetch(:filename)

    if remote_path
      file = "#{remote_path}/#{filename}"
    end

    if full_remote_path
      file = full_remote_path
    end

    bucket.files.get(file)
  end

  def delete_file(options = {})
    get_file(options).destroy
  end

  def get_url(options = {})
    get_file(options).public_url
  end

  def list_folder_contents(path)
    files = connection.directories.get('my-story-booklet', prefix: path).files

    filename_and_dates = {}
    files.map do |file|
      filename_and_dates.merge!({file.key => file.last_modified})
    end

    filename_and_dates.delete_if { |k, v| k == "users/test/" }
  end
end