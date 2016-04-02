class StaticPagesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout false

  def homepage
  end
end
