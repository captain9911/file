#!/bin/bash
echo 版本号自增脚本调试开始
#buildVersion=$CURRENT_PROJECT_VERSION
buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
if [ $buildVersion = "\$(CURRENT_PROJECT_VERSION)" ]
then 
    echo 没有取到测试版本号，重新取。
    buildVersion=$CURRENT_PROJECT_VERSION
else
    echo 取到了测试版本号
fi
echo 当前测试版本号：$buildVersion
appVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$INFOPLIST_FILE")
if [ $appVersion = "\$(MARKETING_VERSION)" ]
then
    echo 没有取到发布版本号，重新取。
    appVersion=$MARKETING_VERSION
else
    echo 取到了发布版本号
fi
echo 当前发布版本号：$appVersion
buildNumber=${buildVersion##*.}
echo 提取到的版本尾号：$buildNumber
buildVersionPre=${buildVersion%.*}
echo 提取到的测试版本号前段：$buildVersionPre
if [ $appVersion != $buildVersionPre ]
then
    echo 发布版本号与测试版本号前段不同，清除获取到的版本尾号
    buildNumber=0
fi
buildVersion=$appVersion.$(($buildNumber+1))
echo 拼接完的新版本号：$buildVersion
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildVersion" "$INFOPLIST_FILE"
if [ $? = 0 ]
then
    echo 版本号修改成功
else
    echo 版本号修改失败
fi
echo 版本号自增脚本调试结束
