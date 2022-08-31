class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def index 
    get_data_for_this_user
    if params[:category_name].present? || params[:buy_at].present?  
       filter_purchases            
    else         
       @purchases = @user_purchases      
    end     
    total_cost_for_user_purchase 
  end


  def filter_purchases
    if  params[:category_name] == "all" ||  params[:buy_at] == "all" 
      @purchases = @user_purchases
    elsif params[:category_name].present? 
      filter_by_category_name      
      params[:buy_at] == nil    
    elsif  params[:buy_at].present? 
      filter_by_buy_at 
      params[:category_name] == nil 
    else  
      @purchases = @user_purchases
    end   
  end
 
  def last_month
    params[:category_name] == nil 
    params[:buy_at] == nil 
    @purchases = current_user.purchases.where('buy_at BETWEEN ? AND ?', Date.today.beginning_of_month, Date.today)       
  end

  def last_year    
    params[:category_name] == nil 
    params[:buy_at] == nil 
    @purchases = current_user.purchases.where('buy_at BETWEEN ? AND ?', Date.today.beginning_of_year, Date.today)           
  end

  def  filter_by_buy_at 
    @purchases = @user_purchases.where(buy_at: params[:buy_at]) 
  end

  def filter_by_category_name
    @purchases = @user_purchases.where(category_name: params[:category_name]) 
  end

 
  def  get_data_for_this_user
    @user_purchases = current_user.purchases  
    @date_list =["all"]+@user_purchases.distinct.pluck(:buy_at)
    @category_list = ["all"]+@user_purchases.distinct.pluck(:category_name)    
  end

  def total_cost_for_user_purchase
    @total_cost =  @purchases.sum(:price)
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def new
    @purchase = Purchase.new(user: current_user)
  end    

  def edit
    @purchase = Purchase.find(params[:id])
  end

  def create
    @purchase = current_user.purchases.build(filtered_params)
    if @purchase.valid?
      @purchase.save
       flash[:messages] = "Successfully created"
       redirect_to purchases_path 
    else
      flash[:notice] = @purchase.errors.full_messages
      redirect_to new_purchase_path    
    end   
  end

  def update   
    @purchase = Purchase.find(params[:id]) 
    if @purchase.update(filtered_params)
      redirect_to purchases_path 
    else
      render :edit
    end
  end

  def destroy   
    @purchase = Purchase.find(params[:id])
    @purchase.destroy
    redirect_to purchases_path 
  end

  def remove_all
    Purchase.delete_all
    flash[:notice] = "You have removed all results!"
    redirect_to purchases_path 
  end

  private
  def filtered_params
   params.require(:purchase).permit(:category_name, :user_id, :price, :buy_at)
  end
 end
