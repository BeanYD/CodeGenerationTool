### mac下环境变量文件内容（vim .bash_profile）

```shell
# HomeBrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# HomeBrew END

# Flutter
export PATH=$PATH:/Users/mac/developer/flutter/bin
# Flutter END

# Maven
export PATH="/Users/mac//developer/apache-maven:$PATH"
export PATH="/Users/mac/developer/apache-maven/bin:$PATH"
# Maven END

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Android
export PAHT=$PATH:/Users/mac/Library/Android/sdk/tools export PATH=$PATH:/Users/mac/Documents/android-ndk-r10e/ ANDROID_NDK_ROOT=/Users/mac/Documents/android-ndk-r10e/ export ANDROID_NDK_ROOT ANDROID_SDK_ROOT=/Users/mac/Library/Android/sdk/ export ANDROID_SDK_ROOT
~                          
```

