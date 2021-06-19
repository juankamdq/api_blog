class PostsController < ApplicationController
    before_action :authorized, except: [:index, :show]
    before_action :decode_token, only: [:create, :update]



    # GET FILTER POST
    # /posts?title=TITULO
    # /posts?category=CATEGORIA
    # /posts?titulo=TITULO&category=CATEGORY

    def index 

        @posts = Post.all 

        # Get Params
        params_title = params[:title]
        params_category = params[:category]
 
        # Retorna el post dependiendo el filtro
        return category_title_filter if params_category && params_title
        return title_filter if params_title  
        return category_filter if params_category 
            
        # Si no se hay parametros para filtrar retorna todos los posts
        render json: @posts, status: :ok, each_serializer: PostListSerializer
    end


    # GET POST ID
    def show

        @post = Post.find_by(id:params[:id], status: true)

        if !@post.nil?
            render json: @post, status: :ok
        else
            render json: { 
                message: "Post not found",
                status: false
                
            }
        end
         
    end

  

    # CREATE POST AND ASSOCIATION
    def create 

        post = Post.new(params_post)

        # Recibo el Id del User por medio del before_action
        user = User.find(@user_id)
        post.user = user
         
        category = Category.find_by_id(params[:category])
        return render json: { error: "Category not found"}, status: 404 if category.nil?
        post.category = category
        
     
        if post.save
            render json: post, status: :created
        else 
            render json: post.errors, status: :unprocessable_entity
        end
    end


    # UPDATE POST
    def update 

        # Obtengo los parametros y los busco en mi base
        post = Post.find_by(id:params[:id], status: true)
        category = Category.find_by_id(params[:category])
        

        # Si post y category no existen en mi base retorno errores 
        return render json: { error: "Post not found"}, status: 404 if post.nil?
        return render json: { error: "Category not found"}, status: 404 if category.nil?

        # Asigno la relacion con categoria
        post.category = category 

        # Realizo el update
        if  post.update(params_post)
            render json: { Status: "ok"}
        else 
            render json: category.errors, status: :unprocessable_entity
        end

    end


    # DELETE FIRST ITERATION
    def destroy 
        post = Post.find_by_id(params[:id])

        return render json: { error: "Post not found"}, status: 404 if post.nil?

        if post.destroy
            render json: { status: "deleted"}
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def soft_delete
        

        post = Post.find_by(id: 19, status: true)

        return render json: { error: "Post not found"}, status: 404 if post.nil?

        if post.update(status: false)
            render json: { 
                message: 'Data deleted, but persistent in the database',
                object_deleted: post
                }, status: :ok
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
        
    end




    ################################################# PRIVATE ############################################################

    private

    def params_post
        params.require(:post).permit(:title, :content, :image)
    end


    # FILTRADO POR TITULO
    def title_filter

        filter_title = @posts.where('title LIKE ?',"%#{params[:title]}%")

        render json: { 
            message: "Filter to Title",
            object: filter_title 
        }
    end

    # FILTRADO POR CATEGORIA
    def category_filter

        string_cate = "categories.name LIKE '#{params[:category]}'"

        filter_cat = @posts.joins(:category).where(string_cate)

        render json: { 
            message: "Filter to Category",
            object: filter_cat 
        }
    end

    # FILTRADO POR TITULO Y CATEGORIA
    def category_title_filter

        string_title = "posts.title LIKE '#{params[:title]}'"
        string_cate = "categories.name LIKE '#{params[:category]}'"
    
        filter_cat_title =  @posts.where(status: true)
                                  .where(string_cate)
                                  .joins(:category).select(:id,:title,:image,:content. )
                                  .where(string_title)
                                
                                   
                                  

        render json: { 
            message: "Filter to Category and Post title",
            object: filter_cat_title 
        }
    end

end

 
