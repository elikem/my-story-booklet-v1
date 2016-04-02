class PublishStoryJob < ActiveJob::Base
  queue_as :create_and_publish_story

  def perform(story_id)
    story = Story.find(story_id)

    # Create and email the IDML document
    story.in_design_doc.create_idml
    SendIdmlFileToTswJob.new.perform(story.user_id, story.in_design_doc.idml_file_path)
  end
end
