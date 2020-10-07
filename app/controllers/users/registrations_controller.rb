class Users::RegistrationsController < Devise::RegistrationsController
  
  require "payjp"


  def registration
    @user = User.new
    session[:user] = @user

    
  end
  
  def phone
    params[:user][:birthday] = date_create
    session[:user] = user_params

    @user = User.new(user_params)
    if @user.valid?(:profile)
      
    else
      render :registration
      return
    end
  end  


  def adress

    session[:user][:user_phone]  = user_params[:user_phone]

    @user = User.new
    @user.build_deliver_address
    
    session[:deliver_address] = @user.deliver_address

    
    
  end
    
  def credit

    session[:user]["last_name"]        =   user_params[:last_name]
    session[:user]["first_name"]       =   user_params[:first_name]
    session[:user]["last_name_kana"]   =   user_params[:last_name_kana]
    session[:user]["first_name_kana"]  =   user_params[:first_name_kana]
    session[:user]["user_phone"]       =   user_params[:user_phone]
    session[:deliver_address] = user_params[:deliver_address_attributes]
    

    @user = User.new(session[:user])
    @user.build_deliver_address(session[:deliver_address])
    if @user.valid?(:deliver_address)
      if @user.deliver_address.valid?(:deliver_address)
      else
        render :adress
        return
      end
    elsif @user.deliver_address.valid?(:deliver_address)
      render :adress
      return
    else
      render :adress
      return
    end
  end
  
  
  def complete
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)

    if params[:payjp_token].present?
      @customer = Payjp::Customer.create(
        description: 'Fmarket',
        email: session[:user][:email],
        card: params[:payjp_token],
      )
    
    else
      render :credit
      return
    end
      
    
    @user = User.new(session[:user])
    @user.build_deliver_address(session[:deliver_address])
    @user.cards.build(
      user_id:        @user.id,
      customer_id:    @customer.id,
      card_id:        @customer.default_card,
    )
    

    
    if @user.save
      user = @user
      session.clear
      session[:id] = @user.id
      sign_in User.find(session[:id]) unless user_signed_in?
    else
      redirect_to action: 'registration'
    end
    
  end


  
private

def user_params
  params.require(:user).permit(
    :nickname,
    :email,
    :password,
    :first_name,
    :last_name,
    :first_name_kana,
    :last_name_kana,
    :birthday,
    :user_phone,
    deliver_address_attributes:[
      :postal_code,
      :prefecture_id,
      :city,
      :street_address,
    ]
  )
end


def date_create
  date = params[:birthday]
  if date["birthday(1i)"].empty? && date["birthday(2i)"].empty? && date["birthday(3i)"].empty?
    params[:user][:birthday] = ""
    return
  end

  Date.new date["birthday(1i)"].to_i,date["birthday(2i)"].to_i,date["birthday(3i)"].to_i

end




end