class Api::StoriesController < ApplicationController
  skip_before_filter :authenticate_user!

  before_filter :user_story_object
  before_filter :restrict_access_using_api_key

  def index
    @stories = Story.all
    render json: @stories
  end

  def show
    render json: @story
  end

  def published_stories
    stories_with_user_info = []
    beginning_of_week = Date.today.beginning_of_week(:monday)

    @stories = Story.where(('publish = true and updated_at > ?'), beginning_of_week).includes(:user)

    @stories.each do |story|
      stories_with_user_info << {
          "story_id" => story.id,
          "publication_id" => story.publication_id,
          "username" => story.user.username,
          "email" => story.user.email
      }
    end

    render json: stories_with_user_info
  end

  def user_story_object
    if User.try(:find_by_username, params[:id])
      @user = User.find_by_username(params[:id])
      @story = @user.story
    end
  end

  def restrict_access_using_api_key
    # authenticate_or_request_with_http_token do |token, options|
    #   ApiKey.exists?(key: token)
    # end

    #   curl http://localhost:3000/api/published_stories -H 'Authorization: Token token="P2v-6BU6sTiiMP6oAZ58XA"'
  end

  def idml
    if @story
      send_file("#{Rails.root}/storage/users/#{@user.username}/#{@user.username}.idml", type: 'application/x-indesign', disposition: 'attachment', stream: true, status: 200)
    else
      render json: {error: 'Bad Request'}, status: 400
    end
  end
end
