class Mailer < ApplicationMailer
  # Send IDML file to tsw after file has being created
  def send_idml_file_to_tsw(user_id, file)
    @user = User.find(user_id)
    @file = file

    attachments['Soaring.idml'] = { mime_type: 'application/x-gzip', content: File.read(@file)  }

    mail(to: 'tsw@cru.org', subject: "IDML file for #{@user.email}")
  end
end
