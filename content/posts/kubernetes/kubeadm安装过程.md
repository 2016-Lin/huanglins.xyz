---
title: "kubeadm安装单master kubernetes集群"
date: 2020-08-01T17:00:05+08:00
draft: false
tags: ["云原生","kubernetes","go"]
categories: [ "kubernetes教程" ]
series: ["kubernets教程"]
toc: true
---

## kubeadm 安装单节点过程

通过kuboard.cn提供的脚本按照，具体可以到[官网](https://kuboard.cn)进行教程学习

### 要求 cpu大于2核，内存大于4G

```shell
# 设置 hostname 解析
echo "127.0.0.1   $(hostname)" >> /etc/hosts
```

# 安装docker和kubelete 所有节点都必须执行

> 出现网络问题，无法访问可以访问[备份](/kubernetes/install_kubelet.sh)

``` shell
# 阿里云 docker hub 镜像
export REGISTRY_MIRROR=https://registry.cn-hangzhou.aliyuncs.com
# 如果网络出现问题可以使用本目录下的备份脚本
curl -sSL https://kuboard.cn/install-script/v1.18.x/install_kubelet.sh | sh -s 1.18.5
```

# 只在 master 节点执行



> 关于初始化时用到的环境变量
>
>- **APISERVER_NAME** 不能是 master 的 hostname
>- **APISERVER_NAME** 必须全为小写字母、数字、小数点，不能包含减号
>- **POD_SUBNET** 所使用的网段不能与 ***master节点/worker节点*** 所在的网段重叠。该字段的取值为一个 [CIDR](https://www.kuboard.cn/glossary/cidr.html) 值，如果您对 CIDR 这个概念还不熟悉，请仍然执行 export POD_SUBNET=10.100.0.1/16 命令，不做修改


> 出现网络问题，可以访问[备份地址](/kubernetes/init_master.sh)
```shell
# 替换 x.x.x.x 为 master 节点实际 IP（请使用内网 IP）
# export 命令只在当前 shell 会话中有效，开启新的 shell 窗口后，如果要继续安装过程，请重新执行此处的 export 命令
export MASTER_IP=x.x.x.x
# 替换 apiserver.demo 为 您想要的 dnsName
export APISERVER_NAME=apiserver.demo

## Kubernetes 容器组所在的网段，该网段安装完成后，由 kubernetes 创建，事先并不存在于您的物理网络中
export POD_SUBNET=10.100.0.1/16

echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts
# 如果网络出现问题，也可使用该目录下的备份脚本
curl -sSL https://kuboard.cn/install-script/v1.18.x/init_master.sh | sh -s 1.18.5

# 如果只是单节点的话，可以设置mater节点为可调度,因为默认情况下K8s的master节点是不能运行Pod
kubectl taint nodes --all node-role.kubernetes.io/master-
```
> 有效时间
>
> 该 token 的有效时间为 2 个小时，2小时内，您可以使用此 token 初始化任意数量的 worker 节点。

检查master初始化状态
```shell
# 只在 master 节点执行

# 执行如下命令，等待 3-10 分钟，直到所有的容器组处于 Running 状态
watch kubectl get pod -n kube-system -o wide

# 查看 master 节点初始化结果
kubectl get nodes -o wide
```

# 安装worker节点

## 获取join信息
```shell
# 只在 master 节点执行 获取join信息
kubeadm token create --print-join-command

# 数据示例
# kubeadm token create 命令的输出
kubeadm join apiserver.demo:6443 --token mpfjma.4vjjg8flqihor4vt     --discovery-token-ca-cert-hash sha256:6f7a8e40a810323672de5eee6f4d19aa2dbdb38411845a1bf5dd63485c43d303
```
# 初始化worker节点
```shell
# 只在 worker 节点执行
# 替换 x.x.x.x 为 master 节点的内网 IP
export MASTER_IP=x.x.x.x
# 替换 apiserver.demo 为初始化 master 节点时所使用的 APISERVER_NAME
export APISERVER_NAME=apiserver.demo
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts

# 替换为 master 节点上 kubeadm token create 命令的输出
kubeadm join apiserver.demo:6443 --token mpfjma.4vjjg8flqihor4vt     --discovery-token-ca-cert-hash sha256:6f7a8e40a810323672de5eee6f4d19aa2dbdb38411845a1bf5dd63485c43d303

```

# 安装dashboard并获取获取dashboard 的token
```shell
# 下载dashboardyaml文件
> wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# 如果需要通过本地端口进行访问的话可以通过修改文件中service部分，具体如下
> vim recommended.yaml 
...
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort # 新增
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30443 # 新增
  selector:
    k8s-app: kubernetes-dashboard

# 安装dashboard
kubectl apply -f recommended.yaml

# 创建serviceaccount和clusterrolebinding资源YAML文件
> vim adminuser.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

# 创建admin-user并且赋予admin-user集权管理员权限
> kubectl apply -f adminuser.yaml

# 通过本机ip+端口进行访问,需要的toke信息通过下面的命令获取

# 获取登陆时，需要的token
> kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```