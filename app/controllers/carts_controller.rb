class CartsController < ApplicationController
  def order_complete
    @cart = Cart.find(params[:cart_id])
    @amount = (@cart.subtotal.to_f.round(2) * 100).to_i
    customer = Stripe::Customer.create(
    :email => current_user.email,
    :card => params[:stripeToken]
    )
    charge = Stripe::Charge.create(
    :customer => customer.id,
    :amount => @amount,
    :description => 'Rails Stripe Customer',
    :currency => 'usd'
    )
    @cart.destroy
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end

  def show
    @cart = Cart.find(params[:id])
    unless current_user.id == @cart.user_id
      flash[:notice] = "You don't have access to that order."
      redirect_to root_path
    end
  end

  def new
    @cart = Cart.new
  end

  def edit
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.new(cart_params)
    respond_to do |format|
      if @cart.save
        format.html {redirect_to @cart, notice: "Cart was successfully created"}
      else
        format.html {render :new}
      end
    end
  end

  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy if @cart.id == session[:cart_id]
      session[:cart_id] = nil
      respond_to do |format|
      format.html {redirect_to products_path, notice: "Your Cart was removed."}
    end
  end

  def update
    @cart = Cart.find(params[:id])
    respond_to do |format|
      if @cart.update(cart_params)
        format.html {redirect_to @cart, notice: "Cart was successfully created"}
      else
        format.html {render :edit}
      end
    end
  end

  private
  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
