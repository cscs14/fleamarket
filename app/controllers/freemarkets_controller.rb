class FreemarketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :buy]

  def index
    @freemarkets = Freemarket.where(status: "1").limit(10).order('created_at DESC')
  end

  def show
    @freemarket = Freemarket.includes(:user).find(params[:id])
    prefecture = Prefecture.all
  end

  def new
    @freemarket = Freemarket.new
    @freemarket.item_images.build
  end

  def create
    @freemarket = Freemarket.new(freemarket_params)
    if @freemarket.item_images.blank?
      @freemarket.errors.add(:image_url, "画像を選択してください")
      @freemarket.item_images.build
      render "new"
      return
    end
    if @freemarket.save
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit
    @freemarket = Freemarket.find(params[:id])
  end

  def update
    @freemarket = Freemarket.find(params[:id])
      if @freemarket.user_id == current_user.id
        @freemarket.update(freemarket_edit_params)
        redirect_to freemarket_path
      end
  end

  def destroy
    @item = find_freemarket_by_id
    @item.destroy
    redirect_to list_users_path
    flash[:notice] = '削除しました'
  end

  def buy
    @user = User.find_by(id: current_user.id)
    @deliver = DeliverAddress.find_by(user_id: current_user.id)
    @item = find_freemarket_by_id
    @card = find_card_by_id
    if user_signed_in? && current_user.id == @item.user_id
      redirect_to freemarket_path(@item)
    elsif @card.present?
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_info = customer.cards.retrieve(@card.card_id)
    end
  end

  def pay
    @deliver = DeliverAddress.find_by(user_id: current_user.id)
    @item = find_freemarket_by_id
    @card = find_card_by_id
    begin
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
      Payjp::Charge.create(
      amount: @item.price,
      customer: @card.customer_id,
      currency: 'jpy',
      )
      @item.update(status: 2)
      Order.create(
        user_id: current_user.id,
        freemarket_id: @item.id, 
        deliver_address_id: @deliver.id,
      )
      redirect_to purchased_users_path
      flash[:notice] = '購入が完了しました'
    rescue Payjp::PayjpError => e
      redirect_to buy_freemarket_path(@item)
      flash[:alert] = 'このカードはご利用になれません。ご利用のクレジットカード会社へお問い合わせください。'
    end
  end

  private

  def freemarket_params
    params.require(:freemarket).permit(:item, :description, :price, :condition, :ship_charge, :ship_from, :ship_day, item_images_attributes: [:image_url]).merge(user_id: current_user.id)
  end

  def freemarket_edit_params
    params.require(:freemarket).permit(:item, :description, :price, :condition, :ship_charge, :ship_from, :ship_day, item_images_attributes: [:id, :image_url, :_destroy]).merge(user_id: current_user.id)
  end

  def find_card_by_id
    Card.find_by(user_id: current_user.id)
  end

  def find_freemarket_by_id
    Freemarket.find(params[:id])
  end

end
