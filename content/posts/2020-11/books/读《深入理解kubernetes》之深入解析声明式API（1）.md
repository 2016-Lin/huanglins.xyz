---
title: "读《深入理解kubernetse》之深入解析声明式API（1）"
date: 2020-11-08T12:00:05+08:00
draft: false
tags: ["云原生","kubernetes","go"]
categories: [ "kubernetes教程" ]
series: ["读《深入理解kubernetes》"]
toc: true
---

#### 概念

我们要了解kubernetes声明式API，首先需要知道什么是**GVR**和**GVK**

**GVR**: GroupVersionResource
**GVK**: GroupVersionKind

Group(API组)，Version(API版本)，可以用下面的一张图详细的描述API对象的结构。

![API对象结构](/images/blog/2020-11/API对象结构.png)

核心资源（Pod，Node等），不需要Group（为""）,直接再/api下匹配

非核心资源（Job，CronJob等），需要再/apis、而它们的Group就是"batch",也就是再"/apis/batch"下匹配

通常同一类型的对象都会放在同一路径下，例如上面提到的"batch"，表示离线业务。

---

Resource和Kind通常情况下，表示是同一对象，都表示资源类型，Resouce我们可以理解为在kubernetes中对象的描述，而Kind表示的是实际的go type代码表示的对象，例如，下面代码表示Kind表示cronJob,Resouces表示cronjobs也用短命令表示cj,它们表示都是同一对象。


通过上面的解释，可以看出，kubernetes是通过GV来控制不同类型和不同版本，然后通过Kind和Rources来指定对应的对象资源。

```yaml
apiVersion: batch/v2aplha1
kind: CronJob
```

---

根据上面的yaml对象，详细的解析逻辑，可以详见下面的图。
![API解析](/images/blog/2020-11/APIServer解析.png)

1. 我们将CronJob通过POST发送到APIServer，同时APIServer做一些例如授权，超时处理，审计等操作
2. APIServer通过解析，GV，进入MUX和Routes,就像http请求url路径一样，最后达到Handler处理函数，进行处理。
3. 找到Handler，通过Kind创建CronJob对象，同时APIServer会进行把用户提交的yaml文件解析到Super Version对象上，它正是该 API 资源类型所有版本的字段全集。这样用户提交的不同版本的 YAML 文件，就都可以用这个 Super Version 对象来进行处理了。
4. APIServer 会先后进行 Admission() 和 Validation() 操作。也就是 Admission Controller 和 Initializer，就都属于 Admission 的内容。而 Validation，则负责验证这个对象里的各个字段是否合法。这个被验证过的 API 对象，都保存在了 APIServer 里一个叫作 Registry 的数据结构中。也就是说，只要一个 API 对象的定义能在 Registry 里查到，它就是一个有效的 Kubernetes API 对象。
5. 最后，APIServer 会把验证过的 API 对象转换成用户最初提交的版本，进行序列化操作，并调用 Etcd 的 API 把它保存起来。

--- 

在下一期中，我们将通过官方提供的[code-generator](https://github.com/kubernetes/code-generator.git)代码生成工具，编写一个CRD(Custom Resource Definition)