namespace :my_tasks do
  desc 'remove old files from user folder'
  task :user_folder_clean_up => :environment do
    usernames = User.select(:username).map(&:username)

    usernames.each do |username|
      uploader = Upload.new
      files = {}
      s3_files = uploader.list_folder_contents("users/#{username}/")
      s3_files.each { |k, v| files.merge!(k => v) }

      if files.count > 1
        unix_times = files.values.each { |time| Time.parse(time.to_s).to_i }
        most_recent_time = Time.at(unix_times.sort.reverse[0]).gmtime.to_s
        last_modified_file = files.delete_if { |k, v| v != most_recent_time }

        s3_files.each do |k, v|
          if k != last_modified_file.keys.first
            uploader.delete_file(full_remote_path: k)
          end
        end
      end
    end
  end
end
