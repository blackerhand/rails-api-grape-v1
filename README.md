# 说明

rails api 最佳实践. 
这是使用 rails5 api + grape, 来实现前后端分离项目的一个基本脚手架. 用来帮助新手快速的搭建一个 rails 项目


## 相关技术

- rails 5.2.3
- grape 1.2
- grape entity 0.7
- swagger 
- kaminari
- jwt + bcrypt
- mysql2 


## JSON API 说明

### meta
记录请求的元数据, 主要有以下字段

- message: 描述请求的结果, 为一个字符串
- status: 状态吗, 目前状态码没有特殊的含义, 和 HTTP 状态码相同
- version: api 版本号
- payload(登录以后才有): jwt 加密信息
- menu(登录以后才有): 菜单栏列表
- pagination: 分页信息

### data
- data 请求成功时返回此字段, 代表要请求的数据. 部分 post 请求不需要要 data, 可能只会返回一个 meta[:message], data 值为 null
- 请求多个数据时, 为一个数组
- 请求一个数据时, 为一个哈希

### errors
- 代表错误的详细信息
- [{filed: 'email', message: '不能为空'}]

## swagger 
- 启动本地项目以后, 访问地址 localhost:3000/swagger

## 路径命名规范

'/v{版本号}/{resources}/{action}'

### HTTP METHOD

- POST: 创建
- GET: 获取数据
- PUT: 更新数据
- DELETE: 删除

### HTTP STATUS CODE 

- 401 验证错误
- 406 权限错误
- 422 验证错误
- 422 其他错误 

## changelog

创建项目 `rails new grape_api --api -d mysql -T --api`


# v0.1

搭建基本环境, 集成:

- rails-i18n
- rack-cors
- figaro
- grape
- hashie
- sawagger
- rubocop
- kaminari
