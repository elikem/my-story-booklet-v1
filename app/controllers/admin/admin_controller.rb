class Admin::AdminController < ApplicationController
  before_filter :authenticate_admin_user

  def index
    redirect_to admin_stories_path
  end

  def api_key
    @api_keys = ApiKey.all.order(updated_at: :desc)
  end

  def create_api_key
    @api_key = ApiKey.create_key(params[:name])

    if @api_key.save
      flash[:info] = 'API Key created.'
      redirect_to admin_api_key_path
    else
      flash[:error] = 'API Key was not created.'
      redirect_to admin_api_key_path
    end
  end

  def regenerate_api_key
    @api_key = ApiKey.generate_key(params[:name])

    if @api_key
      flash[:info] = 'API Key regenerated.'
      redirect_to admin_api_key_path
    else
      flash[:error] = 'API Key was not regenerated.'
      redirect_to admin_api_key_path
    end
  end

  def deactivate_api_key
    @api_key = ApiKey.deactivate_key(params[:name])

    if @api_key
      flash[:info] = 'API Key deactivated.'
      redirect_to admin_api_key_path
    else
      flash[:error] = 'API Key not deactivated.'
      redirect_to admin_api_key_path
    end
  end

  def activate_api_key
    @api_key = ApiKey.activate_key(params[:name])

    if @api_key
      flash[:info] = 'API Key activated.'
      redirect_to admin_api_key_path
    else
      flash[:error] = 'API Key not activated.'
      redirect_to admin_api_key_path
    end
  end

  def destroy_api_key
    @api_key = ApiKey.delete_key(params[:name])

    if @api_key
      flash[:info] = 'API Key destroyed.'
      redirect_to admin_api_key_path
    else
      flash[:error] = 'API Key not destroyed.'
      redirect_to admin_api_key_path
    end
  end
end
