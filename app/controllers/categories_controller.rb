class CategoriesController < ApplicationController

    def index 
        @category = Category.all 

        if @category 
            render json: @category, status: :ok
        end
         
    end

    def show

         
    end

    def create 
        @category = Category.new(name: params[:name])

        if @category.save
            render json: @category, status: :ok
        end
    end


 

end
