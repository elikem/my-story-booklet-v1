# == Schema Information
#
# Table name: in_design_docs
#
#  id         :integer          not null, primary key
#  story_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#  idml       :string
#  epub       :string
#  pdf        :string
#

class InDesignDoc < ActiveRecord::Base
  require 'erb'
  require 'fileutils'

  belongs_to :story

  def create_idml
    create_user_folder_and_archive
    build_xml_files_into_archive
    create_idml_file
  end

  def text
    TextCleaner.clean_story(story.text)
  end

  def get_publication_id
    self.story.publication_id
  end

  def get_user_name
    self.story.user.username
  end

  def get_authors_name
    self.story.authors_name
  end

  def get_page_one_first_letter
    text[0]
  end

  def get_page_one_to_three
    text[1..-1]
  end

  def set_publish_status_to_generate_pdf
    self.status = 'generate_pdf_ebook'
    self.save
  end

  def set_publish_status_to_invalid
    # The status here really doesn't matter for generating the IDML file.
    # We only care about the status for the API where we might query to see what documents are ready to download
    # and convert to other formats.
    self.status = 'invalid'
    self.save
  end

  def user_folder
    "#{Rails.root}/storage/users/#{get_user_name}"
  end

  def user_story_folder
    "#{user_folder}/Soaring"
  end

  def idml_file_path
    "#{user_folder}/#{get_publication_id}.idml"
  end

  private

  def create_user_folder_and_archive
    if Dir.exists? user_folder
      if Dir.exists? user_story_folder
        # delete the idml file if the user folder and soaring folder exists
        %x( cd "#{user_folder}" && rm -rf Soaring ) if File.file? "#{user_story_folder}/#{get_publication_id}.idml"
      end
    else
      # since the user folder does not exist create it
      FileUtils.mkdir_p user_folder
    end

    %x( cp -R "#{Rails.root}/lib/assets/Soaring" "#{user_folder}" )
  end

  def template_to_file(template, file_path)
    File.open(file_path, 'w+') do |f|
      f.write(template)
    end
  end

  def fix_br_tags_for_imdl(template)
    template.gsub!('<br>', '</Content><Br /><Content>')
  end

  def build_xml_files_into_archive
    template_builder_authors_name
    template_builder_page_one_first_letter
    template_builder_page_one_to_three
  end

  def create_idml_file
    %x( cd "#{user_story_folder}" && zip -X0 "#{get_user_name}.idml" mimetype )
    %x( cd "#{user_story_folder}" && zip -rDX9 "#{get_publication_id}.idml" * -x '*.DS_Store' -x mimetype )

    %x( cd "#{user_folder}" && mv Soaring/"#{get_publication_id}".idml ./ && rm -rf Soaring )
  end

  def template_builder(template)
    template = template.to_sym

    templates = {
        authors_name: {
            file_path: "#{user_story_folder}/Stories/Story_u2fc1.xml",
            template_path: "#{Rails.root}/lib/idml_templates/Story_u2fc1.xml.erb"
        },
        page_one_first_letter: {
            file_path: "#{user_story_folder}/Stories/Story_u32b4.xml",
            template_path: "#{Rails.root}/lib/idml_templates/Story_u32b4.xml.erb"
        },
        page_one: {
            file_path: "#{user_story_folder}/Stories/Story_u326e.xml",
            template_path: "#{Rails.root}/lib/idml_templates/Story_u326e.xml.erb"
        }
    }

    erb = ERB.new(File.read(templates[template][:template_path])).result(binding)
    template_to_file(erb, templates[template][:file_path])
  end

  def template_builder_authors_name
    template_builder('authors_name')
  end

  def template_builder_page_one_first_letter
    template_builder('page_one_first_letter')
  end

  def template_builder_page_one_to_three
    template_builder('page_one')
  end
end
