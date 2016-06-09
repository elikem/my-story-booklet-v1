require 'fog/aws'

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
    else
      key = filename
    end

    if local_path
      body = "#{local_path}/#{filename}"
    else
      body = filename
    end

    bucket.files.create(
        key: key,
        body: File.open(body),
        public: true
    )
  end

  def get_url(options = {})
    remote_path = options.fetch(:remote_path, false)
    filename = options.fetch(:filename)

    if remote_path
      file = "#{remote_path}/#{filename}"
    else
      file = filename
    end

    bucket.files.get(file).public_url
  end
end