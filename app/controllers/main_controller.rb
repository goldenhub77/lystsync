class MainController < ApplicationController
  before_action :force_json, only: :autocomplete
  before_action :initialize_empty_search_variables, only: :search

  def welcome
  end

  def autocomplete
    #Future refactor opportunity
    if current_user.admin?
      @lists = List.all.ransack(title_cont: params[:q]).result(distinct: true).limit(5)
    else
      user_lists = current_user.lists.ransack(title_cont: params[:q]).result(distinct: true).limit(5)
      collabs = current_user.list_collaborations.ransack(title_cont: params[:q]).result(distinct: true).limit(5)
      pubs = List.public.ransack(title_cont: params[:q]).result(distinct: true).limit(5)
      @lists = (user_lists + collabs + pubs).uniq
    end
    @users = User.all.ransack(name_cont: params[:q]).result(distinct: true).limit(5)
  end

  def search
    #Future refactor opportunity
    session[:q] = params['q'];
    if params['q'].present?
      if current_user.admin?
        @lists = List.all.ransack(title_cont: params[:q]).result(distinct: true)
      else
        user_lists = current_user.lists.ransack(title_cont: params[:q]).result(distinct: true)
        collabs = current_user.list_collaborations.ransack(title_cont: params[:q]).result(distinct: true)
        pubs = List.public.ransack(title_cont: params[:q]).result(distinct: true)
        @lists = (user_lists + collabs + pubs).uniq
      end
      @users = User.all.ransack(name_cont: params[:q]).result(distinct: true)
    else
      flash.now[:error] = "Please enter a search query."
    end
  end

  private

  def initialize_empty_search_variables
    @lists = []
    @users = []
  end

  def force_json
    request.format = :json
  end
end