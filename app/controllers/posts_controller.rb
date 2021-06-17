class PostsController < ApplicationController
    before_action :decode_token, only: [:create]
    # Get Posts
    # /posts?title=TITULO
    # /posts?category=CATEGORIA
    # /posts?titulo=TITULO&category=CATEGORY

    def index 

        @posts = Post.all.order("created_at DESC")

        # Get Params
        params_title = params[:title]
        params_category = params[:category]
 
        # Retorna el post dependiendo el filtro
        return category_title_filter if params_category && params_title
        return title_filter if params_title  
        return category_filter if params_category 
            
        # Si no se hay parametros retorna todos los posts
        render json: @posts, status: :ok, each_serializer: PostListSerializer
    end

    def show

        @post = Post.find_by_id(params[:id])

        if !@post.nil?
            render json: @post, status: :ok
        else
            render json: { 
                status: false,
                message: "Post not found"
            }
        end
         
    end

    def create 

        # Recibo el Id del User por medio del before_action
        user = User.find(@user_id)
        @category = Category.find_by_id(params[:category]) 
        @post = Post.new(params_post)
     
        @post.user = user 
        @post.category = @category
 
        if @post.save
            render json: @post, status: :ok
        end
    end

    def update 
        #user = User.find(@user_id)
        #@category = Category.find()
    end

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
    
        filter_cat_title =  @posts.joins(:category).where(string_cate + " and " + string_title)

        render json: { 
            message: "Filter to Category and Post title",
            object: filter_cat_title 
        }
    end

end

 
