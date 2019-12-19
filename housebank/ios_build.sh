#!/bin/sh

echo "----------- iPhone APP housebank start at : `date "+%Y-%m-%d_%H%M%S"` --------------"

security unlock-keychain -p "housebank-"

#BUILD_PATH="$HOME/Library/housebank_build/housebank"
BUILD_PATH="$HOME/Library/hefa_build"
DOWNLOAD_PATH="${BUILD_PATH}/ios" #下载
BACKUP_PATH="${BUILD_PATH}/backup"     #备份

#echo "Make Directory $BUILD_PATH"
#mkdir -p "$BUILD_PATH"

#echo "Make Directory $DOWNLOAD_PATH"
#mkdir -p "$DOWNLOAD_PATH"

#echo "Make Directory $BACKUP_PATH"
#mkdir -p "$BACKUP_PATH"


# 项目名
workspace_name="housebank"
project_name="housebank"
#
# 需被编译的configuration
build_names=(
"Test"
"PreOnline"
"Online"
)
# -a && -o ||
# 不等于空 && 等于Test
if [ x$1 != x -a $1 == 'Test' ]
    then
    build_names=("Test")
fi

if [ x$1 != x -a $1 == 'PreOnline' ]
then
build_names=("PreOnline")

fi

if [ x$1 != x -a $1 == 'Online' ]
then
build_names=("Online")

fi


# info.plist
info_plist_path="./housebank/info.plist"
# 版本号
build_version=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${info_plist_path}")

for build_name in ${build_names[*]}
do
echo "------------ ${build_name} Start Building --------------"

xcodebuild -workspace ${workspace_name}.xcworkspace -scheme ${project_name} -configuration ${build_name}
temp_file="/tmp/housebank_${build_name}.ipa"
# PackageApplication 在Xcode8以后不再支持，需要自己下载PackageApplication文件
xcrun -sdk iphoneos PackageApplication -v "Build/Products/${build_name}-iphoneos/${project_name}.app" -o ${temp_file}

download_file="${DOWNLOAD_PATH}/housebank_${build_name}.ipa"
backup_file="${BACKUP_PATH}/housebank_${build_name}_${build_version}.ipa"

rm -rf ${download_file}
rm -rf ${backup_file}
mv ${temp_file} ${download_file}
cp ${download_file} ${backup_file}
echo "${build_name}打包成功：${download_file}"

echo "------------ ${build_name} Successfully Builded --------------"
done








