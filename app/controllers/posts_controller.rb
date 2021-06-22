class PostsController < ApplicationController
    #before_action :authorized
    before_action :decode_token 



    # GET FILTER POST
    # /posts?title=TITULO
    # /posts?category=CATEGORIA
    # /posts?titulo=TITULO&category=CATEGORY

    def index 

        @posts = Post.find(@user_id)

        # Get Params
        params_title = params[:title]
        params_category = params[:category] #ADASDSA
 
        # Retorna el post dependiendo el filtro
        return category_title_filter if params_category && params_title
        return title_filter if params_title  
        return category_filter if params_category 
            
        # Si no se hay parametros para filtrar retorna todos los posts
        render json: @posts, status: :ok, each_serializer: PostListSerializer
    end


    # GET POST ID
    def show

        params_title_id = params[:id]
 

        @post = Post.find_by(id: params_title_id, status: true, user_id: @user_id)

        if !@post.nil?
            render json: @post, status: :ok
        else
            render json: { 
                error: "Post not found in User ID #{@user_id || 'XX'}",
                status: false
            }, status: 404
        end
         
    end

  

    # CREATE POST AND ASSOCIATION
  def create 

        user = User.find(@user_id)
        post = user.posts.build(params_post)
        
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

        param_post_id = params[:id]
        param_category_id = params[:category]
         
        # Obtengo los parametros y los busco en mi base
        post = Post.find_by(id: param_post_id, user_id: @user_id, status: true) 

        category = Category.find_by_id(param_category_id)
        
        # Si post y category no existen en mi base retorno errores 
        return render json: { error: "Post not found in User ID #{@user_id}"}, status: 404 if post.nil?
        return render json: { error: "Category not found"}, status: 404 if category.nil?

        # Asigno la relacion con categoria
        post.category = category 

        # Realizo el update
        if  post.update(params_post)
            render json: { 
                message: "Post ID #{post.id} updated",
                object: post
            }
        else 
            render json: category.errors, status: :unprocessable_entity
        end

    end


    # DELETE FIRST ITERATION
    def destroy 

        param_post_id = params[:id]

        post = Post.find_by(id: param_post_id, user_id: @user_id, status: true)

        return render json: { error: "Post not found in User ID #{@user_id}"}, status: 404 if post.nil?

        if post.destroy
            render json: { status: "deleted"}
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def soft_delete
        
        param_post_id = params[:id]

        post = Post.find_by(id: param_post_id, status: true, user_id: @user_id)

        return render json: { error: "Post not found in User ID #{@user_id}" }, status: 404 if post.nil?

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
                                  .joins(:category).select(:id,:title,:image,:content)
                                  .where(string_title)
                                
                                   
                                  

        render json: { 
            message: "Filter to Category and Post title",
            object: filter_cat_title 
        }
    end

end

 
