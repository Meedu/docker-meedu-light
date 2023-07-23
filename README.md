# Docker 运行 MeEdu 的轻量级方案

### 本套方案集成了以下服务

- API 程序
- 后台管理界面程
- PC 前台界面程序
- H5 界面程序
- 定时任务
- 消费者队列进程

### TODO

- [ ] `php-fpm` 的配置覆盖
- [ ] `ssl` 证书配置

## 构建镜像并运行

### 第一步、下载本仓库：

```
git clone https://github.com/Meedu/docker-meedu-light.git docker-meedu-light
```

### 第二步、编译生成静态资源

接下来分别编译 PC 端口、H5 端口、后台管理端口程序，并将它们编译后的 `dist` 目录复制到 `docker-meedu-light/dist` 下面，如下：

```
docker-meedu-light
|-dist
|--pc
|--h5
|--backend
```

其中 `pc` 目录就是 `PC` 端口编译出来的 `dist` 目录；`h5` 目录就是 `H5` 端口编译出来的 `dist` 目录；`backend` 就是后台管理界面编译出来的 `dist` 。需要注意的是，这三个端口编译配置的 `APP_URL` 均为 `/api/` 。

### 第三步、编译生成镜像

```
docker build -t meeduxyz/light:4.9.2 .
```

### 第四步、运行镜像

```
docker run -d -p 80:80 -p 9800:9800 -p 9801:9801 -p 9900:9900 --name meedu-light \
  -e DB_HOST=mysql的host \
  -e DB_PORT=mysql的端口 \
  -e DB_DATABASE=mysql数据库名 \
  -e DB_USERNAME=mysql的用户名 \
  -e DB_PASSWORD=mysql的密码 \
  -e CACHE_DRIVER=redis \
  -e SESSION_DRIVER=redis \
  -e QUEUE_DRIVER=redis \
  -e REDIS_HOST=redis的host \
  -e REDIS_PASSWORD=null \
  -e REDIS_PORT=6379 \
  -e APP_KEY=base64:s9M5EmBWLWerXU/udZ8biH8GYGKBAEtatGNI2XnzEVM= \
  -e JWT_SECRET=26tpIiNHtYE0YsXeDge837qfIXVmlOES8l9M2u9OTrCZ9NASZcqJdYXBaOSPeLsh \
  meeduxyz/light:4.9.2
```

> 请注意修上上述命令中的参数。为了安全起见，请务必修改 `APP_KEY` 和 `JWT_SECRET` 的值。

## 镜像附带信息

### 端口地址

| 应用         | 端口      |
| ------------ | --------- |
| API 服务     | `ip:80`   |
| PC 端口      | `ip:9800` |
| H5 端口      | `ip:9801` |
| 后台管理端口 | `ip:9900` |