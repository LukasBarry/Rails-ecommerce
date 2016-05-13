class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    respond_to do |format|
      if @line_item.save
        format.html {redirect_to cart_path(@line_item.cart_id), notice: "You added #{product.name} to your Cart"}
      else
        format.html {redirect_to root_path}
      end
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_to cart_path(line_items.cart_id)
  end

  private
  def line_items_params
    params.require(:line_items).permit(:product_id, :cart_id, :quantity)
  end
end
