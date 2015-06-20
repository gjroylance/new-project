#!/bin/bash

dir=$(pwd | sed 's/\/[^/]*$//' | sed 's/.*\///' )
name=$(echo $1 | sed 's/-service//g' | sed 's/-//g' | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2)) }')

mkdir -p ../$1
cp .gitignore ../$1/
sed "s/new-project/$1/g" build.gradle > ../$1/build.gradle
sed -i '' "s/company-name/$dir/g" ../$1/build.gradle
sed "s/new-project/$1/g" settings.gradle > ../$1/settings.gradle
mkdir -p ../$1/src/main/java ../$1/src/main/resources
mkdir -p ../$1/src/test/java ../$1/src/test/resources

sed "s/new-project/$1/g" mod.json > ../$1/src/main/java/resources/mod.json

mkdir -p ../$1/src/main/java/com/canopy/service
sed "s/XService/${name}Service/g" XService.java > ../$1/src/main/java/com/canopy/service/${name}Service.java

lf=$'\n'
#cp ../all/build.gradle ../all/build.gradle.bak
sed -i '' "s/\(^.*if.*$\)/\1\\$lf        compile project(':$1')/" ../all/build.gradle
sed -i '' "s/\(^.*else.*$\)/\1\\$lf        compile 'com.canopy.$1:$1:+'/" ../all/build.gradle

cd ../$1
git init
git add .
git commit -m "Initial $1 setup"
git remote add origin https://github.com/CanopyTax/$1.git
cd -