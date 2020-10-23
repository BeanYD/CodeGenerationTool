# CodeGenerationTool

## Common文模块

对通用的UI样式进行修改，子类化，重写`-drawRect`方法，达到某些特定的效果，暂时只封装如下控件

1. CGTCustomButton

   有默认的样式。

   ------

   **样式接口的封装待优化：`borderColor`, `borderWidth`, `alignment`, `textColor`, `backgroundColor`, `cornerRadius`。仿造`NSMutableAttributedString`的方式，通过传入`@{}`键值对的方式进行修改，定义键值对的键的宏提供给其他页面使用**

   ------

   通过`xib`加载`window`，在`- (void)windowDidLoad`中直接修改样式即可。其他方式待补充。

   如果单独在方法中修改边框颜色等样式，需要手动调用`-updateLayout`，如：

   ```objective-c
   - (void)updateMicroButtonAndTableStatus {
       self.microSelectButton.borderColor = [NSColor colorWithRed:47./256 green:154./256 blue:255./256 alpha:1.];
       [self.microSelectButton updateLayer];
   }
   ```

   

2. CGTCustomScrollView

3. CGTCustomTextField

   封装富文本下，点击链接`url`，跳转其他页面（不一定是`url`）的方法，未在`demo`中使用-后续使用

   调用方式：

   ```objective-c
   - (void)windowDidLoad {
       [super windowDidLoad];
   
     	self.remindLabel.textColor = [NSColor whiteColor];
       self.remindLabel.delegate = self;
       NSString *urlText = @"直播设置>上下课设置";
       NSString *textStr = [NSString stringWithFormat:@"确定要下课？下课5分钟后将自动结束课堂。如要修改时 间，请先前往%@进行修改", urlText];
       NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
       [attrStr beginEditing];
       [attrStr addAttributes:@{NSForegroundColorAttributeName : [NSColor colorWithRed:47./256 green:154./256 blue:255./256 alpha:1.f], NSLinkAttributeName : [NSURL URLWithString : @"set_to_class"]} range:[textStr rangeOfString:urlText]];
       [attrStr endEditing];
   
       self.remindLabel.attributedStringValue = attrStr;
   }
   
   #pragma mark - CustomTextFieldDelegate
   - (void)hyperlinkToUrl:(NSURL *)url {
       if ([url.absoluteString isEqual:@"set_to_class"]) {
           // 弹出设置框
           NSLog(@"go to class set");
       }
   }
   
   ```

   

4. CGTPopover

   待开发

5. CGTCustomTableHeaderCell

   重写`NSTableHeaderCell`，修改`header`的背景色和文字位置，内部目前写死样式，后续可添加样式传入的接口，统一使用

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
  
  

## 经验记录：

`NSTextField`在`xib`中创建后，会自带白色背景，在`xib`中修改：找到`Display`，勾选`Draw Background`，所选的背景色才会生效。