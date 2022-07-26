class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[new create]
  before_action :find_category, only: %i[edit update destroy]
  before_action :get_categories, only: %i[index create update destroy]
  
  def index    

  end

  def new
    
  end

  def create
    respond_to do |format|
      if @category.save
        format.turbo_stream do
          flash.now[:notice] = I18n.t('views.common.messages.successful_creation')                   
        end                
      else
        flash.now[:alert] = @category.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }        
      end    
    end
  end

  def edit;end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.turbo_stream do 
          render turbo_stream: turbo_stream.replace(@category, partial: "categories/category", locals: {category: @category})        
        end
                       
      else
        flash.now[:alert] = @category.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }        
      end    
    end
  end

  def destroy
    respond_to do |format|
      if @category.update(active: false)
        format.turbo_stream                        
      else
        flash.now[:alert] = @category.errors.full_messages
        format.html { render :index, status: :unprocessable_entity }        
      end    
    end    
  end



  private

  def category_params
    params.require(:category).permit(:name, :color, :to_analyze)    
  end

  def find_category
    @category = current_user.categories.find params[:id]    
  end

  def set_category
    @category = params[:action] == "new" ? current_user.categories.new : current_user.categories.new(category_params)    
  end

  def get_categories
    @categories = current_user.categories.to_a    
  end


end
