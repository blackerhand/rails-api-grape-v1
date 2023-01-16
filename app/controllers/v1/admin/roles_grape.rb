# frozen_string_literal: true
module V1
  module Admin
    class RolesGrape < AdminGrape
      desc '角色列表' do
        summary '角色列表'
        detail '角色列表'
        tags ['admin_roles']
      end
      get '/' do
        @roles = Role.pure_roles
        data_paginate!(@roles, Entities::Role::List)
      end

      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '角色详情' do
          summary '角色详情'
          detail '角色详情'
          tags ['admin_roles']
        end
        get '/' do
          data_record!(current_record, Entities::Role::Detail)
        end

        desc '更新角色' do
          summary '更新角色'
          detail '更新角色'
          tags ['admin_roles']
        end
        params do
          requires :name, type: String, allow_blank: false, desc: '名称'
          requires :resource_ids, type: Array[Integer], desc: '权限id列表'
        end
        after_validation do
          valid_error!('权限 id 不正确, 请检查重试') unless Resource.where(id: params.resource_ids).count == params.resource_ids.count
        end
        post '/' do
          current_record.update(declared_params)
          data_record!(current_record, Entities::Role::Detail)
        end
      end
    end
  end
end
