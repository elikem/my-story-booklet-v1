class StoriesController < ApplicationController
  before_filter :story

  def show
    redirect_if_username_invalid
  end

  def edit
    redirect_if_username_invalid
  end

  def update
    if story.update(story_params)
      # Flash story count
      count = Validator.story_count(story.text).to_s
      flash[:notice] = "Saved. Your story length is #{count} characters."

      redirect_to edit_story_path(current_user.username)
    else
      flash[:error] = 'Not saved.'
      render :edit
    end
  end

  def publish
    # Update the publish document status
    story.update(publish: true)
    story.in_design_doc.set_publish_status_to_generate_pdf

    publication_id = SecureRandom.urlsafe_base64
    story.update(publication_id: publication_id) unless Story.find_by_publication_id(publication_id)

    # Bakground job to publish story
    PublishStoryJob.perform_later(story.id)

    # Flash and exit controller
    flash[:notice] = 'Published.'
    redirect_to edit_story_path(current_user.username)

    # Slack notification
    notify_slack
  end

  def unpublish
    # Update the publish and document status
    story.update(publish: false)
    story.in_design_doc.set_publish_status_to_invalid

    # flash and exit controller
    flash[:notice] = 'Unpublished.'
    redirect_to edit_story_path(current_user.username)
  end

  def training_worksheet
  end

  def example
  end

  private

  def story_params
    params.require(:story).permit(:id, :authors_name, :text, :publish, :publication_id)
  end

  def story
    @story = user.story
  end

  def user
    user = User.find(current_user.id)
  end

  def redirect_if_username_invalid
    if params[:id] != current_user.username
      if params[:action] == "edit"
        redirect_to edit_story_path(current_user.username) and return
      else
        redirect_to story_path(current_user.username) and return
      end
    end
  end

  def notify_slack
    SLACK_NOTIFIER.ping "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Published story for #{story.user.username}"
  end
end
