# CodeGenerationTool
rt

## 如何在应用内进行应用程序更新？

- 方案1：下载安装包dmg文件，下载完成后open。
  缺陷：还是需要用户手动拖拽覆盖应用程序内的程序。
- 方案2：直接下载.app文件，进行打开。
  实践中，只在开发环境下试过，可以打开，但是会开启另一个同名app。
- 方案3：通过命令行mv操作将cache中的.app文件移动到mac的应用程序中进行覆盖。
  未实践，理论上不可行：如果程序还在运行，mv后覆盖需要当前程序退出；当前程序退出，无法继续执行mv操作
