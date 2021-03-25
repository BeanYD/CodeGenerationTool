# CodeGenerationTool

## Common文模块

对通用的UI样式进行修改，子类化，重写`-drawRect`方法，达到某些特定的效果，暂时只封装如下控件

1. CustomButton

   有默认的样式，一般使用在高度自定义的界面中。

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

6. ProgressHUD

   自定义加载视图，加载动画图片名称为`加载`，可进行替换

   通过重写鼠标事件，屏蔽加载视图背后的各类事件，目前仍有缺陷，无法屏蔽鼠标移动事件的传递

   ```objective-c
   - (void)mouseDown:(NSEvent *)event
   - (void)mouseUp:(NSEvent *)event
   - (void)mouseMoved:(NSEvent *)event
   - (void)mouseEntered:(NSEvent *)event
   - (void)mouseExited:(NSEvent *)event
   ```

   

## Base模块

创建基类，子类化`NSWindowController`和`NSViewController`，统一的样式在该类中进行添加

#### NSWindowController+TitleBar分类

对`WindowController`中的中的`window`进行统一修改，`import`了2个类`CommonTitleView`和`CommonTitleBarViewController`

`CommonTitleBarViewController`：子类化`NSTitleBarViewController`，修改`window`的`titleBar`样式

`CommonTitleView`：`titleBar`子类化后，需要添加新的`titleView`样式供显示。

## Main模块

App的主页面，所有其他窗口都由该页面进入

子窗口显示方式：模态

```objective-c
/** 
 *  Application.h
 *  应用层的模态，所有其他窗口都无法使用
 */
[NSApp runModalForWindow:modalWindow];
[NSApp stopModal];

/** 
 *  NSWindow.h
 *  窗口添加子窗口，位置相对父窗口移动，随父窗口的关闭而关闭，但是父窗口其他功能可以使用
 */
[fatherWindow addChildWindow:childWindow ordered:NSWindowAbove];

/** 
 *  NSWindow.h
 *  sheet的方式出现在窗口中
 */
[window beginSheet:sheetWindow completionHandler:^(NSModalResponse returnCode) {}];
[window endSheet:sheetWindow];

/** 
 *  NSViewController.h
 *  NSViewControllerPresentationAndTransitionStyles
 *  viewController弹出和转场框
 */
- (void)presentViewControllerAsSheet:(NSViewController *)viewController;
- (void)presentViewControllerAsModalWindow:(NSViewController *)viewController;
- (void)presentViewController:(NSViewController *)viewController asPopoverRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge behavior:(NSPopoverBehavior)behavior;
- (void)transitionFromViewController:(NSViewController *)fromViewController toViewController:(NSViewController *)toViewController options:(NSViewControllerTransitionOptions)options completionHandler:(void (^ _Nullable)(void))completion API_AVAILABLE(macos(10.10));
```



## Opengl模块

待开发

## MouseEvent模块

待开发

## DrawLayer模块

### 更新2021-03-23

1. 标注的两个点之间距离小于3的，不进行绘制
2. 单点标注添加以实心圆的方式进行显示
3. 笔锋功能添加

------

该模块下代码demo主要基于`CALayer`层画图，对其他现有项目中基于NSImage进行绘制的优化

优化原因：基于`NSImage`进行绘制，简单的画线功能可以完成。但是在添加图片内容且需要对图片内容进行拖拽后，持续的拖动加上持续的重绘，占用大量CPU，直接导致应用卡死。在多端同步的情况下，`NSImage`中标注过多也容易导致卡死。

### 优化方案：

方案1.现有现有`DrawLayer`模块中实现的方案。每个标注添加时，都添加一个`CALayer`在`drawView`中，对于不会发生改变的标注，不会有明显效果。当拖动图片标注时，持续的拖动，可单独操作单个`CALayer`，更新`CALayer`中图片的位置实现。在各自的`CALayer`中仍然可以通过添加`NSImage`进行绘制，看具体需要。

方案2.原有项目中的基于`NSImage`绘制，优化`NSImage`的绘制方式，参考`iOS`中对图片加载的优化方案——暂未实现

### 遇到的困难：

#### 困难1

单个`CALayer`，只能存在一个`Path`内容，当橡皮擦功能选中该`CALayer`中标注内容后，需要添加边框的方式显示出标注已经被橡皮擦框住。

注：后续研究如何添加多个`Path`。移动端可以通过`CGContextRef context = UIGraphicsGetCurrentContext();`获取当前图形上下文，使用`CGContextRef`比较方便

标注绘制使用`Path`，边框在

```objective-c
- (void)drawInContext:(CGContextRef)ctx
```

方法中使用`CGContext`实现，通过

```objective-c
[self setNeedsDisplayInRect:self.frame];
```

更新。

#### 困难2

图片在`CALayer`下无法通过`Path`的方式绘制

在当前`CALayer`下，添加一个`CALayer`，使用`contents`的方式添加图片

```objective-c
- (void)drawImage:(NSImage *)image rect:(CGRect)rect {
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
//    self.frame = NSMakeRect(20, 20, width, height);
//    self.contents = image;
    
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.frame = rect;
    imageLayer.position = NSMakePoint(rect.size.width / 2 + 10, rect.size.height / 2 + 10);
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    imageLayer.contents = image;
    [self addSublayer:imageLayer];
}
```

但是在后续进行移动缩放时，需要遍历`CALayer`的`sublayers`进行更新内容

#### 困难3

`NSTextView`文本框输入后，添加到`CALayer`中。

也是通过添加子`CALayer`的方式进行实现

```objective-c
- (void)drawTextInRect:(CGRect)rect string:(NSString *)drawStr {
//    NSDictionary* dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSFont systemFontOfSize:12.], [NSColor blackColor], nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName,NSForegroundColorAttributeName, nil]];
//    [drawStr drawAtPoint:NSMakePoint(rect.origin.x, rect.origin.y) withAttributes:dic];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = rect;
    textLayer.backgroundColor = [NSColor clearColor].CGColor;
    textLayer.string = drawStr;
    textLayer.font = (__bridge CFTypeRef _Nullable)(@"HiraKakuProN-W3");
    textLayer.fontSize = 12.;
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.foregroundColor = [NSColor redColor].CGColor;
    [self addSublayer:textLayer];
}
```



## Excel模块

实现简单的excel文档的写入和读取功能



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

  

## Mark：

1. `NSTextField`在`xib`中创建后，会自带白色背景，在`xib`中修改：找到`Display`，勾选`Draw Background`，所选的背景色才会生效。

2. 关于`NSView`属性`toolTip`使用的说明：常规使用直接添加字符串`view.toolTip = @"..."`，在特定情况下需要不显示内容，可以置为`@""`或者`nil`，但尽量使用`nil`，在一些情况下，置为`@""`在后续需要显示时，无法显示正常的字符串。

   ```objective-c
   @property (nullable, copy) NSString *toolTip;
   ```

   

## OSX10.15系统下，修改鼠标图标的方法说明

[Github上相关问题修复](https://github.com/AvaloniaUI/Avalonia/issues/3000])

`NSCursor`相关方法

```objective-c
- (void)resetCursorRects;
// 在10.15系统下，容易发生崩溃
- (void)addCursorRect:(NSRect)rect cursor:(NSCursor *)object;
- (void)set;
```

崩溃日志：

```objective-c
Application Specific Information:
assertion failure: "_needsGeometryInWindowDidChangeNotificationCount < (1 << 8) - 1" -> %lld
:
:  
5 com.apple.AppKit 0x00007fff30a4771c -[NSView(NSInternal) enableGeometryInWindowDidChangeNotification] + 216
6 com.apple.AppKit 0x00007fff30bf9d99 -[NSWindow(NSCursorRects) _addCursorRect:cursor:forView:] + 962
7 com.apple.AppKit 0x00007fff30bf95c4 -[NSView addCursorRect:cursor:] + 607
8 libAvaloniaNative.dylib 0x000000010aaecf01 WindowBaseImpl::UpdateCursor() + 125
9 libAvaloniaNative.dylib 0x000000010aaece6e WindowBaseImpl::SetCursor(IAvnCursor*) + 78
```

