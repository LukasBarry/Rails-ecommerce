class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def items_by_category
    @category = Category.find(params[:cat_id])
    @products = Product.all
    @products_by_cat = []
    @products.each do |product|
      if product.category.id == params[:cat_id].to_i
        @products_by_cat.push(product)
      end
    end
  end

  def create
    @product = Product.create(product_params)
      if @product.save
        redirect_to @product
      else
        render :new
      end
  end

  def index
    @product = Product.near([current_user.latitude, current_user.longitude], 20)
  end

  def edit
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :description, :quantity, :latitude, :longitude, :address, :condition_id, :category_id, :user_id, :pic)
  end
end
