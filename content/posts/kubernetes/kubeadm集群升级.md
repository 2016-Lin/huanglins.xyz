---
title: "kubeadm升级kubernetes集群"
date: 2020-08-01T17:00:05+08:00
draft: false
tags: ["云原生","kubernetes","go"]
categories: [ "kubernetes" ]
series: ["kubernets教程"]
toc: true
---

# kubeadm集群升级

> 根据kuboard.cn的升级文档所写，同时备份。

随着kubernetes版本的不断发布，以及我们业务的需要，旧版本的k8s可能无法满足我们的需要，在新版本中，有新功能，可能是我们需要的，因此升级k8s版本是不可避免的。

## 预备工作

- 请确保您的kubernetes集群是通过kubeadm按照的，并且版本号不低于1.15.0
- sawp禁用（如果您是通过kuboard.cn教程按照的话，swap已经禁用）
- 集群使用静态Pod（apiserver、etcd）或者使用外部 etcd（如果您参考 www.kuboard.cn 上的文档安装，则您的集群符合此条件）
- 确保您备份了重要的信息，例如应用程序的数据库，部署配置信息等。`kubeadm upgrade` 在升级过程中并不涉及到部署在 Kubernetes 上应用程序，而是只升级 Kubernetes 的内部组件，尽管如此，备份始终是推荐的(一般需要备份etcd中的数据和kubeadm.conf文件)

>TIP
>
>- 升级后，所有的容器都会重启，因为升级改变了容器定义的 hash 值
>- 只能从一个小版本升级到下一个小版本，或者在小版本内部升级补丁版本，不能跳过小版本升级。例如，您可以从 1.15.0 升级到 1.15.4，也可以从 1.15.0 升级到 1.16.1，但是您不能从 1.14.9 升级到 1.16.0，官方建议每次升级不要跨越两个版本。

## 确定当前版本

```shell
yum list --showduplicates kubeadm --disableexcludes=kubernetes
# 例如我当前版本为1.15
# 我想要升级到的版本为1.16,则我要查找的版本应该为1.16,x-0，其中x是对应版本的罪行补丁
```

## master升级

### 升级第一个master节点

- 在第一个 master 节点上执行如下命令，升级 kubeadm

```shell
# 将 1.16.x-0 中的 x 替换为最新的补丁版本
# 你需要替换为你需要更新的版本号
# 注意升级版本不要超过两个版本
yum install -y kubeadm-1.16.x-0 --disableexcludes=kubernetes
```

- 在第一个 master 节点上执行命令 `kubeadm upgrade plan`，输出结果如下所示(以下是内容示例，请根据你的实际版本查看)：

```shell
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[preflight] Running pre-flight checks.
[upgrade] Making sure the cluster is healthy:
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.15.4
[upgrade/versions] kubeadm version: v1.16.0
W1002 21:49:38.572516   14315 version.go:101] could not fetch a Kubernetes version from the internet: unable to get URL "https://dl.k8s.io/release/stable.txt": Get https://dl.k8s.io/release/stable.txt: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
W1002 21:49:38.572555   14315 version.go:102] falling back to the local client version: v1.16.0
[upgrade/versions] Latest stable version: v1.16.0
W1002 21:49:48.655494   14315 version.go:101] could not fetch a Kubernetes version from the internet: unable to get URL "https://dl.k8s.io/release/stable-1.15.txt": Get https://dl.k8s.io/release/stable-1.15.txt: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
W1002 21:49:48.655532   14315 version.go:102] falling back to the local client version: v1.16.0
[upgrade/versions] Latest version in the v1.15 series: v1.16.0

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
Kubelet     1 x v1.15.3   v1.16.0
            3 x v1.15.4   v1.16.0

Upgrade to the latest version in the v1.15 series:

COMPONENT            CURRENT   AVAILABLE
API Server           v1.15.4   v1.16.0
Controller Manager   v1.15.4   v1.16.0
Scheduler            v1.15.4   v1.16.0
Kube Proxy           v1.15.4   v1.16.0
CoreDNS              1.3.1     1.6.2
Etcd                 3.3.10    3.3.15-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.16.0

_____________________________________________________________________

```

> TIP
>
> - 请忽略错误 `could not fetch a Kubernetes version from the internet: unable to get URL "https://dl.k8s.io/release/stable.txt"`，在不能获得最新 kubernetes 版本列表的情况下，将使用 kubeadm 的版本作为升级的目标版本（在前面的步骤中，已经从 yum 仓库找到了最新 kubeadm 的版本）

- 执行以下命令进行升级

```shell
# 替换 x 为最新补丁的版本号
kubeadm upgrade apply v1.16.x
```

> TIP
>
> - `kubeadm upgrade` 同时会自动更新节点上的证书。如果不想更新证书，请使用参数 `--certificate-renewal=false`

输出信息如下：

```shell
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[preflight] Running pre-flight checks.
[upgrade] Making sure the cluster is healthy:
[upgrade/version] You have chosen to change the cluster version to "v1.16.0"
[upgrade/versions] Cluster version: v1.15.4
[upgrade/versions] kubeadm version: v1.16.0
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Will prepull images for components [kube-apiserver kube-controller-manager kube-scheduler etcd]
...省略部分内容以节省篇幅...
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.16.0". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.

```

### 升级其他master节点

> 如果你只有单个master节点，不要执行下面的操作

- 在其他master节点上执行命令

```shell
kubeadm upgrade node
```

> TIP
>
> - 不需要执行 `kubeadm upgrade plan`
> - 第一个 master 节点上执行的是 `kubeadm upgrade apply v1.16.x`，此时执行的是 `kubeadm upgrade node`

### 升级kubelet和kubectl

- 在所有的 master 节点上执行如下命令以升级 kubelet 和 kubectl

```shell
# 替换 x 为最新补丁的版本号
yum install -y kubelet-1.16.x-0 kubectl-1.16.x-0 --disableexcludes=kubernetes
```

- 执行如下命令，以重启 kubelet

```shell
systemctl daemon-reload
systemctl restart kubelet
```

### 升级worker节点

建议逐个升级 worker 节点，或者同一时间点只升级少量的 worker 节点，以避免集群出现资源紧缺的状况。

#### 升级kubeadm

- 在所有的 worker 节点上执行如下命令，升级 kubeadm

```shell
# 将 1.16.x-0 中的 x 替换为最新的补丁版本
yum install -y kubeadm-1.16.x-0 --disableexcludes=kubernetes
```

#### 排空(drain)节点（在master节点执行）

- 执行以下命令，将节点标记为 `不可调度的` 并驱逐节点上所有的 Pod，

```shell
# 在可以执行 kubectl 命令的位置执行（通常是第一个 master节点）
# $NODE 代表一个变量，实际执行时，请用您的节点名替换
kubectl drain $NODE --ignore-daemonsets
```

- 输出结果:

```shell
node/ip-172-31-85-18 cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-dj7d7, kube-system/weave-net-z65qx
node/ip-172-31-85-18 drained
```

#### 升级kubelet的配置

- 执行命令

```shell
kubeadm upgrade node
```

#### 升级kubelet和kubectl

- 在所有的worker节点执行

```shell
# 替换 x 为最新补丁的版本号
yum install -y kubelet-1.16.x-0 kubectl-1.16.x-0 --disableexcludes=kubernetes
```

- 执行如下命令，以重启 kubelet

```shell
systemctl daemon-reload
systemctl restart kubelet
```

#### 恢复（uncordon）节点（在master节点执行）

- 执行如下命令，使节点重新接受调度并投入使用：

```shell
kubectl uncordon $NODE
```

### 检查集群的状态

在所有节点的kubelet升级以后，执行下面命令以验证所有节点都可用：

```shell
kubectl get nodes -o wide
```

`STATUS` 字段应该为 `Ready`，版本号也应该显示目标版本号。

###  从错误状态中恢复

如果 `kubeadm upgrade` 执行过程中出现错误且未曾回滚，例如执行过程中意外关机，您可以再次执行 `kubeadm upgrade`。该命令是 幂等的，并将最终保证您能够达到最终期望的升级结果。

从失败状态中恢复时，请执行 `kubeadm upgrade --force` 命令，注意要使用集群的当前版本号。

### 工作过程

在第一个 master 节点上，`kubeadm upgrade apply` 执行了如下操作：

- 检查集群是否处于可升级的状态：
  - API Server 可以调用
  - 所有的节点处于 `Ready` 装填
  - master 节点处于 `healthy` 状态
- 检验是否可以从当前版本升级到目标版本
- 确保 master 节点所需要的镜像可以被抓取到节点上
- 升级 master 节点的组件，（如果碰到问题，则回滚）
- 应用新的 `kube-dns` 和 `kube-proxy` 的 manifests 文件，并确保需要的 RBAC 规则被创建
- 如果证书在 180 天内将要过期，则为 API Server 创建新的证书文件，并备份旧的文件

在其他 master 节点上，`kubeadm upgrade node` 执行了如下操作：

- 从集群中抓取 kubeadm 的配置信息 `ClusterConfiguration`
- 备份 kube-apiserver 的证书
- 升级 master 节点上静态组件的 manifest 信息
- 升级 master 节点上 kubelet 的配置信息

在所有的 worker 节点上，`kubeadm upgrade node` 执行了如下操作：

- 从集群中抓取 kubeadm 的配置信息 `ClusterConfiguration`
- 升级 worker 节点上 kubelet 的配置信息