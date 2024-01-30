# 【施工中】萤火虫🪲

一个相当业余相当民科的神经仿真的概念验证模型 ~（其实我也不知道该怎么定义）~，**可能随时放弃推进**。

[English](/README.md)

记录着想法来源的内容 [Interactive testbed for cortical modeling? - Elixir Framework Forums / Nx Forum - Elixir Programming Language Forum](https://elixirforum.com/t/interactive-testbed-for-cortical-modeling/61178/3) （如果要中文的话请提 issue ，我会加上去），同时也参考了 [amiryt/Erlang-project](https://github.com/amiryt/Erlang-project) 项目。

分层架构的设计理念来自于 Elixir 的 HTTP 服务器 [ThousandIsland](https://github.com/mtrudel/thousand_island) 。

项目架构如下图展示：

```mermaid
graph TD
  Application["应用（Application）"] --> NeuronSupervisor["神经元监视器（NeuronSupervisor）"]
  NeuronSupervisor --1..n--> Neuron["神经元（Neuron） :gen_statem"]
  Application --> PortScheduler("端口管理器（PortScheduler）")
  PortScheduler --1..m--> Port("端口（Port）")
  Port <-.刺激或记录.-> Neuron
  Neuron <-.神经元之间的通信.-> Neuron
  Neuron --> NeuronRunner("神经元状态的仿真（NeuronRunner） Task")
  Neuron --> SynapseRunner("突触的仿真（SynapseRunner） Task")
  SynapseRunner -.输入电流.-> NeuronRunner
  Models["模型（通常用 NIF 实现）"] -.require.-> NeuronRunner
  Models["模型（通常用 NIF 实现）"] -.require.-> SynapseRunner
```
