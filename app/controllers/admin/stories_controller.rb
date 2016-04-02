class Admin::StoriesController < ApplicationController
  before_filter :user_story_object

  def index
    @users = User.search(params[:search]).order(:created_at).paginate(:per_page => 1, :page => params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @story.update(story_params)
      flash[:notice] = 'Saved.'
      redirect_to edit_admin_story_path(params[:id])
    else
      flash[:error] = 'Not saved.'
      render :edit
    end
  end

  def publish
    # Update the publish document status
    @story.update(publish: true)
    @story.in_design_doc.set_publish_status_to_generate_pdf

    publication_id = SecureRandom.urlsafe_base64
    @story.update(publication_id: publication_id) unless Story.find_by_publication_id(publication_id)

    # Bakground job to publish story
    # PublishStoryJob.set(wait_until: 60.seconds).perform_later(story.id)
    PublishStoryJob.perform_later(@story.id)

    # flash and exit controller
    flash[:notice] = "Published."
    redirect_to edit_admin_story_path(params[:id])
  end

  def unpublish
    # Update the publish and document status
    @story.update(publish: false)
    @story.in_design_doc.set_publish_status_to_invalid

    # flash and exit controller
    flash[:notice] = "Unpublished."
    redirect_to edit_admin_story_path(params[:id])
  end

  def user_story_object
    if User.try(:find_by_username, params[:id])
      @user = User.find_by_username(params[:id])
      @story = @user.story
    end
  end

  private

  def story_params
    params.require(:story).permit(:id, :authors_name, :text, :publish, :publication_id)
  end
end
