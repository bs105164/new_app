class StaticPagesController < ApplicationController
  def home
    @titre = "Home"
  end

  def help
    @titre = "Help"
  end

  def about
    @titre = "About"
  end
end
