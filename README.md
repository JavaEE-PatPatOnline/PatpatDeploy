# Patpat Online Deployment

> Deployment environment for Patpat Online
>
> 有任何问题，请联系：[Lord Turmoil](https://github.com/Lord-Turmoil)。

---

## 环境配置

服务器的配置尽可能高一些，如 2 核 8 GB，投入使用时，也推荐有较大的硬盘存储学生的提交（以及镜像）。相关参考链接如下。

- [Docker](https://docs.docker.com/get-docker/)
- [K3S](https://k3s.io/)
- [MySQL](https://www.mysql.com/)
- [RabbitMQ](https://www.rabbitmq.com/)
- [Nginx](https://www.nginx.com/)

为了执行各种命令，可以以 root 身份访问服务器，如果使用其他用户，需要配置用户 sudo 权限，并且允许其不输入密码，可以参考 [Create Sudo-Enabled User on Linux](https://www.tonys-studio.top/posts/Create-sudo-enabled-User-on-Linux/)。


### 数据库配置

在服务器安装 MySQL，或使用现有的 MySQL 服务。在 [PatBoot](https://github.com/JavaEE-PatPatOnline/PatBoot) 项目的 resources 目录下，找到 `init.sql`  并运行，创建数据库表，注意更改其中 root 用户的密码。

### RabbitMQ 配置

在服务器安装 RabbitMQ，可以使用 Docker，或使用现有的 RabbitMQ 服务。

PatBoot 和 PatJudge 可以分开部署，只需要通过 RabbitMQ 将其联系起来就好。

### Nginx 配置

使用 `sudo apt install nginx` 安装 Nginx，其他安装方式需要确保 Nginx 配置文件在 `/etc/nginx/conf.d/`，否则部署脚本无法找到正确位置。

### Docker 与 K3s

部署使用 Docker 和 K3s，需要服务器支持 Docker 和 K3s 的运行环境。

K3s 依赖 `pause` 镜像，有可能无法下载，可以使用阿里云的镜像。

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/rancher/mirrored-pause:3.6
docker tag registry.cn-hangzhou.aliyuncs.com/rancher/mirrored-pause:3.6 rancher/mirrored-pause:3.6
```

此外，K3s 默认启用了很多插件，可能导致 Nginx 失效，具体可以参考 [Deployment-Practice-with-Kubernetes](https://www.tonys-studio.top/posts/Deployment-Practice-with-Kubernetes/#Unable-to-access-port-80) 的 Troubleshoot 部分。

---

## 目录结构

### 前端部署目录

前端项目均部署在 `app/` 目录下，由 Nginx 直接代理。Patpat Online 课程平台部署在 `app/patpat/` 下，教程部署在 `app/tutorial/` 下，由部署脚本生成。这两个目录是在 Nginx 配置中写死的。

课程的休闲小游戏直接写在这个仓库中，放置在 `app/game/` 下。此外，也有一个欢迎页，在 `app/welcome/`。

### 后端部署目录

PatBoot 部署目录为 `boot/`，PatJudge 部署目录为 `judge/`。

### Volume 目录

部署后，`volume` 下的各个目录会被挂载到容器中，具体含义如下。

- `/log/`: 日志目录。
- `/bucket/`: 私有文件目录（无法通过 URL 直接访问）
  - `${buaa-id}/`: 存放每个用户产生的文件。
  - `problem/${problem-id}/`: 编程题目录，为解压后的题目配置文件。
  - `lab/${lab-id}/${buaa-id}-${name}`: Lab 报告提交目录。
  - `iter/${iter-id}/${buaa-id}-${name}`: 迭代提交目录。
  - `proj/${course-id}/${group-id}`: 小组大作业提交目录。
  - `submission/${problem-id}/${buaa-id}`: 题目提交目录。
  - `temp/`: 临时目录，理论上为空，服务器会自动删除文件。
- `/wwwroot/`: 公有文件目录（可以直接通过 URL 访问。
  - `${buaa-id}/`: 用户上传的公开文件，如头像。
  - `course/${course-id}/`: 课程资料目录。

开始时，需要新建如下目录，由于题目和提交目录直接挂载在 PatJudge 里，所以需要提前创建，其他目录由后端自动创建。

- `volume/log/`
- `volume/wwwroot/`
- `volume/bucket/problem/`
- `volume/bucket/submission/`

---

## 项目部署

部署的容器依赖很多环境变量，通过 `env.yaml` 进行配置。因此在首次部署前，需要根据 `env.template.yaml` 手动创建 `env.yaml`，将其中的值改为实际的值。其中 `HTTP_URL` 为 `http://{IP}`，`WS_URL` 为 `ws://{IP}`，IP 即为服务器 IP。`PROFILE` 为 Spring Boot 项目启动的 Profile，生产环境选择 `prod`，测试选择 `stag`。

### 手动部署

#### 前端部署

对于课程平台，将 Vue 打包好的 `dist` 文件夹上传至 `app/` 目录下，在 `app/` 目录下执行下面的命令更新部署。

```bash
./deploy.sh dist patpat
```

对于课程教程，同理，将 Hexo 生成的 `public` 文件夹上传至 `app/` 目录下，执行下面的命令。

```bash
./deploy.sh public tutorial
```

游戏和欢迎页直接更新对应文件夹下的 HTML 即可。

#### 后端部署

后端 PatBoot 和 PatJudge 部署相同，以 PatBoot 为例。

在 IntelliJ IDEA 中（Windows 开发机上即可），打开 Maven 窗口中，执行 Lifecycle 中的 install，会在 target 目录下生成带版本号的 JAR 包，上传至 `boot/target/PatBoot-{version}.jar`（没有 `target` 的话新建），同时，将项目的 Dockerfile 上传至 `boot/Dockerfile`。然后在 `boot/` 目录下执行 `deploy.sh` 即可。PatJudge 除了在 `judge` 目录下操作，其余没有区别。

后端的部署脚本会自动选择 `target` 目录下版本号最高的 JAR 包部署，因此 JAR 包必须包含版本号，并且版本号回退时，需要删除更高版本的 JAR 包。

后端部署路径中有 K3s 使用的 Deployment YAML（.template.yaml），为模板，会在部署时自动生成最新版本的 YAML。

#### 部署管理

在根目录下有 `manage.sh`，用来快捷的执行各种部署操作，下面对常用功能进行介绍。

Nginx 的配置为 `patpat.conf`，更改后，执行 `manage.sh nginx` 更新 Nginx 配置。

如果想手动部署，可以直接执行下面的命令，`--all` 可以换成 `boot` 或 `judge`。

```bash
./manage.sh deploy --all
```

当需要扩容时（一般只有 PatJudge 需要），可以直接更改 `judge.env` 中的 `replicas`，然后运行下面的命令更新部署，即可实现不停机的扩容。

```bash
./manage.sh judge --apply
```

如果想监控当前 Deployment 的状态，可以执行下面的命令。

```bash
./manage.sh watch -d
```

如果想监控日志，可以执行如下命令，比如监控 PatBoot 的日志。

```bash
./manage.sh log boot
```

其他操作具体参考脚本中的 Usage。

### CI/CD

项目原生使用 GitHub Action 实现 CI/CD，Workflow 文件参考具体的项目。具体编写时，每个 Action 需要以下 4 个 Secrets：

- `HOST`: 部署服务器的 IP。
- `USERNAME`: 部署服务器的用户名。
- `SSH_PRIVATE_KEY`: SSH 私钥，在自己的 PC 上生成，具体参考：[SSH Configuration](https://www.tonys-studio.top/posts/Deployment-Practice-with-Kubernetes/#SSH-Configuration)。
- `DEPLOY_PATH`: 部署在服务器上的路径。

除了 `DEPLOY_PATH`，每个项目都是一样的。对于 `DEPLOY_PATH`，根据目录结构，前端在 `app/`，后端在 `boot/` 和 `judge`。

对于前端部署脚本，需要指定参数。课程平台部署至 `patpat`，教程部署至 `tutorial`，具体参考 [patpat-pro-frontend](https://github.com/JavaEE-PatPatOnline/patpat-pro-frontend) 的 Workflow 文件。
