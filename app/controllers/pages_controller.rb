class PagesController < ApplicationController
  skip_before_filter :authenticate_user!

  layout 'static'

  def welcome
  end
end
