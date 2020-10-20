# CodeGenerationTool

## Common文模块

对通用的UI样式进行修改，子类化，重写`-drawRect`方法，达到某些特定的效果，暂时只封装如下控件

1. CGTCustomButton

   有默认的样式。

   通过`xib`加载`window`，在`- (void)windowDidLoad`中直接修改样式即可。其他方式待补充。

   如果单独在方法中修改边框颜色等样式，需要手动调用`-updateLayout`，如：

   ```objective-c
   - (void)updateMicroButtonAndTableStatus {
       self.microSelectButton.borderColor = [NSColor colorWithRed:47./256 green:154./256 blue:255./256 alpha:1.];
       [self.microSelectButton updateLayer];
   }
   ```

   

2. CGTCustomScrollView

## Base模块

创建基类，子类化`NSWindowController`和`NSViewController`，统一的样式在该类中进行添加

#### NSWindowController+TitleBar分类

对`WindowController`中的中的`window`进行统一修改，`import`了2个类`CommonTitleView`和`CommonTitleBarViewController`

`CommonTitleBarViewController`：子类化`NSTitleBarViewController`，修改`window`的`titleBar`样式

`CommonTitleView`：`titleBar`子类化后，需要添加新的`titleView`样式供显示。

## Main模块

App的主页面，所有其他窗口都由该页面进入

## Opengl模块

待开发

## MouseEvent模块

待开发

## Other模块

目前功能：纯代码实现`NSCollectionView`和`NSTableView`

`NSTableView`已实现，在`CGTDDTableWindowController`和`CGTDDTableViewController`中

`NSCollectionView`未完成

## 设备检测模块

摄像头数据展示：`DeviceMediaManager`类封装

基于`IOBlueTooth`的蓝牙设备搜索：`CGTIOBlueToothWindowController`

基于`CoreBlueTooth`的蓝牙设备搜索：`CGTCoreBlueToothWindowController`


## 如何在应用内进行应用程序更新？

- 方案1：下载安装包dmg文件，下载完成后open。
  缺陷：还是需要用户手动拖拽覆盖应用程序内的程序。
- 方案2：直接下载.app文件，进行打开。
  实践中，只在开发环境下试过，可以打开，但是会开启另一个同名app。
- 方案3：通过命令行mv操作将cache中的.app文件移动到mac的应用程序中进行覆盖。
  未实践，理论上不可行：如果程序还在运行，mv后覆盖需要当前程序退出；当前程序退出，无法继续执行mv操作
  
  
