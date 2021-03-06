# 一键部署springboot + dubbo + zookeeper + seata-searver整合server环境
**注意:** 支持 Mac 与 Linux两种系统


由于不少公司的项目环境是 springboot + dubbo + zookeeper，以zookeeper而非nacos作为注册中心和配置中心，本人近期针对这种应用场景整理了《一键部署springboot + dubbo + zookeeper + seata-searver整合server docker环境》的项目，链接如下：

https://github.com/nyl1001/onekey-zk-seata-server-docker

同时提供了示例项目《spring boot + dubbo + zookeeper + seata 整合示例》，链接如下：

https://github.com/nyl1001/springboot-dubbo-seata-zk

上述两个项目搭配使用比官网样例好用很多，官网样例不仅陈旧，而且没有详细部署操作文档，整个操作会相当复杂。通过一键部署docker + 专用示例项目和盘托出，所见即所得，让你直达主题和核心要害，少走弯路。


## 1 安装与启动

### 1.1 首次安装

首次安装需要配置环境变量ONEKEY_ZK_ENV_PATH

对于linux/mac os系统可以在本项目根目录下执行下列脚本:
```
cd到当前项目根目录下执行如下脚本
./init.sh
```

用户也可通过如下方式手动设置该环境变量
```
linux环境配置方法如下：
cd onekey-zk-springcloud-docker项目根目录
echo export ONEKEY_ZK_ENV_PATH=$(pwd) >> ~/.profile && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.profile && source ~/.profile

mac os环境配置方法如下：
cd onekey-zk-springcloud-docker项目根目录
echo export ONEKEY_ZK_ENV_PATH=$(pwd) >> ~/.zshrc && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.zshrc && source ~/.zshrc
或者
cd onekey-zk-springcloud-docker项目根目录
echo export ONEKEY_ZK_ENV_PATH=$(pwd) >> ~/.bashrc && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.bashrc && source ~/.bashrc
或者
cd onekey-zk-springcloud-docker项目根目录
echo export ONEKEY_ZK_ENV_PATH=$(pwd) >> ~/.zshrc.pre-oh-my-zsh && echo 'export PATH="$PATH:$ONEKEY_ZK_ENV_PATH/bin"' >> ~/.zshrc.pre-oh-my-zsh && source ~/.zshrc

```

### 1.2 依赖环境准备
- docker

docker的安装指南请移步官网：
https://www.docker.com/get-started

- docker compose

docker-compose的安装指南请移步官网：
https://docs.docker.com/compose/install/

### 1.3 启动
当环境变量设置和docker-compose执行环境安装完毕后，可以通过如下方式启动容器：
- 方式1：任意目录下执行 onekey-zk start 命令
- 方式2：直接执行当前项目目录下的 one-key-start.sh 脚本

### 1.4 启动健康状态查看

检查docker list状态，发现下述5个容器状态正常则表示启动正常。
<img width="1788" alt="image" src="https://user-images.githubusercontent.com/5603342/153039414-daf75c5d-a85b-414e-874b-88caec6bc52f.png">


seata在zookeeper上的注册信息:
```
onekey-zk login custom-zookeeper-onekey-zk-standalone
cd /apache-zookeeper-3.7.0-bin/bin
./zkCli.sh
ls /registry/zk/default![image](https://user-images.githubusercontent.com/5603342/153039168-767fcdb6-a7ec-44ab-bf22-9c3966619eac.png)
```
<img width="484" alt="image" src="https://user-images.githubusercontent.com/5603342/153038895-6e76a1c8-5dce-4aca-b42f-b40e6c0aac2c.png">


seata在zookeeper上的配置信息
```
onekey-zk login custom-zookeeper-onekey-zk-standalone
cd /apache-zookeeper-3.7.0-bin/bin
./zkCli.sh
ls /seata
```
<img width="1736" alt="image" src="https://user-images.githubusercontent.com/5603342/153038719-7aa0a709-5537-4cf4-bf51-23a87af2bc8f.png">



### 1.5 onekey-zk 命令行参数说明

```
// docker简单命令列表
onekey-zk build       重置配置信息和docker镜像，文件.env、seata/conf/registry.conf、docker-compose.yml均会被重置
onekey-zk list        显示当前onekey-zk的容器列表
onekey-zk start       重建镜像后启动容器，启动后即可正常容器
onekey-zk restart     重新启动容器；如果没有启动，则会直接启动容器，注意此过程不会重建容器镜像
onekey-zk stop        停止运行所有相关容器
onekey-zk login       进入容器内部，需要指定容器名称
onekey-zk destroy     停止并删除所有相关容器
onekey-zk rmi         删除所有相关容器镜像，谨慎操作
onekey-zk logs        查看容器运行日志，需要指定容器名称
onekey-zk help        显示所有的命令列表

```

## 2 配置注意事项

- 原则上配置文件.env-default和seata/conf/registry-default.conf不要做任何修改。

- 如果在本docker启动时，发生端口冲突，请尽量修改原冲突服务的端口。

- 当执行onekey-zk build命令时，文件.env、seata/conf/registry.conf、docker-compose.yml均会被重置。

- .env文件会在每次执行onekey-zk start时被重置，主要是为了及时刷新HOST_IP配置，防止因主机换一个环境后ip地址发生变更导致容器启动失败。

- 不要修改被大括号{}标记的变量。

## 3 端口占用情况
运行命令 docker ps | grep onekey-zk 即可查看
- 0.0.0.0:8091->8091/tcp                                 seata-server-onekey-zk-standalone
- 33060/tcp, 0.0.0.0:3308->3306/tcp                      mysql-for-seata-onekey-zk-standalone
- 33060/tcp, 0.0.0.0:3309->3306/tcp                      mysql-for-business-onekey-zk-standalone
- 0.0.0.0:6380->6379/tcp                                 redis-onekey-zk-standalone
- 2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp, 8080/tcp   custom-zookeeper-onekey-zk-standalone


如果特殊情况下确实不可避免需要修改上述端口信息，请同步修改下列配置文件的如下位置:
- .env-default:3
- seata/conf/registry-default.conf:7
- seata/conf/registry-default.conf:21
- docker-compose.yml.bak

## 4 部分实现细节说明
1. zookeeper和seata容器镜像均进行了一定程度的自定义改造。其进行自定义的主要原因是：
    - seata采用了zookeeper和seata容器镜像均进行了一定程度的自定义改造方式进行服务注册和服务发现，并且seata的配置参数也是通过zookeeper进行配置和获取，这样在zookeeper启动之后需要立即导入seata的配置信息。
    - zookeeper的启动过程较长，而seata的启动依赖zookeeper和seata容器镜像均进行了一定程度的自定义改造，因此需要在检查确认zookeeper启动成功并且seata的配置信息全部同步到zookeeper后seata才能启动。

2. 脚本seata/init.data/import.data.zk.sh用于在zookeeper启动后往zookeeper中写入seata的配置信息。

3. 脚本seata/entry-point.sh用于等待配置信息同步zookeeper完成后启动seata server。

4. seata 镜像基于seata-server 1.4.2构建。

5. mysql-for-seata容器为seata提供数据持久化，mysql-for-seata容器在启动时会初始化seata所依赖的数据表结构并生成默认的seata访问账号。

6. mysql-for-business容器为业务测试数据库，用户可选。


