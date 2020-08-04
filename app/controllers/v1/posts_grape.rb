module V1
  class PostsGrape < SignGrape
    desc 'POST 列表页'
    get '/' do
      @posts = Post.enabled.page(params.page).per(page_per)
      data_paginate!(@posts, Entities::Post::List)
    end

    desc '创建 POST'
    params do
      requires :post, type: Hash do
        requires :title, type: String
        optional :desc, type: String
      end
    end
    post '/' do
      @post = Post.create!(declared_params.post.to_h)
      data_record!(@post, Entities::Post::List)
    end

    route_param :id, requirements: { id: /[0-9]+/ } do
      desc 'POST 详情'
      get '/' do
        data_record!(current_record, Entities::Post::Detail)
      end

      desc '删除 POST'
      delete '/' do
        current_record.disabled!
        data!('删除成功')
      end

      desc '修改 POST'
      params do
        requires :post, type: Hash do
          optional :title, type: String
          optional :desc, type: String
        end
      end
      put '/' do
        current_record.update!(declared_params.post.to_h)
        data_record!(current_record, Entities::Post::List)
      end
    end
  end
end
