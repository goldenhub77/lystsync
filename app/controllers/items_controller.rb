class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_item, only: [:show, :edit, :update, :destroy]
  before_action :find_user, only: [:new, :create, :edit, :show, :update, :destroy]
  before_action :find_list, except: [:index]

  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(post_item_params)
    if @item.valid?
      flash[:notice] = "Created Item Successfully."
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @item.update(post_item_params)
    @item.completed.present? ? nil : @item.date_completed = nil
    if @item.save
      flash[:notice] = "Updated Item Successfully."
      redirect_to list_path(@list)
    else
      flash.now[:error] = @item.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "Deleted Item Successfully."
      redirect_to list_path(@list)
    else
      redirect_to list_item_path(@list, @item)
    end
  end

  protected

  def find_item
    @item = Item.find(get_item_params[:id])
  end

  def find_list
    @list = List.find(get_item_params[:list_id])
  end

  def find_user
    if get_item_params[:user_id].present?
      @user = User.find(get_item_params[:user_id])
    else
      @user = current_user
    end
  end

  def get_item_params
    params.permit(:id, :list_id, :user_id)
  end

  def post_item_params
    params.require(:item).permit(:title, :list_id, :completed, :date_completed, :user_id)
  end
end
