class CategoriesController < ApplicationController
  def index
  end

  def show
    @category  = Category.find(params[:id])
    @children = Category.find(params[:id]).children
    @parent = Category.find(params[:id])
  end
end
