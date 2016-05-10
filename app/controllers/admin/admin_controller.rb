class Admin::AdminController < ApplicationController
  before_filter :authenticate_admin_user

  def index
    redirect_to admin_stories_path
  end

  def api_key
    @api_keys = ApiKey.all.order(updated_at: :desc)
  end

  def create_api_key
    api_key_action(:create_key, 'created')
  end

  def regenerate_api_key
    api_key_action(:generate_key, 'regenerated')
  end

  def deactivate_api_key
    api_key_action(:deactivate_key, 'deactivated')
  end

  def activate_api_key
    api_key_action(:activate_key, 'activated')
  end

  def destroy_api_key
    api_key_action(:delete_key, 'deleted')
  end

  def api_key_action(method, message_verb)
    @api_key = ApiKey.send(method, params[:name])

    if @api_key
      flash[:info] = "API Key #{message_verb}."
    else
      flash[:error] = "API Key not #{message_verb}."
    end

    redirect_to admin_api_key_path
  end
end
