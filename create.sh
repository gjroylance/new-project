#!/bin/bash

dir=$(pwd | sed 's/\/[^/]*$//' | sed 's/.*\///' )
name=$(echo $1 | sed 's/-service//g' | sed 's/-//g' | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2)) }')
basename=$(echo $1 | sed 's/-service//g')
template='sme-service'
templatedb='smedb'
templateName='SmeService'

echo 'dir:' ${dir}
echo 'name:' ${name}
echo 'basename:' ${basename}
echo 'template:' ${template}

mkdir -p ../$1/src/main/java ../$1/src/main/resources
mkdir -p ../$1/src/test/java ../$1/src/test/resources
mkdir -p ../$1/src/main/java/com/canopy/service ../$1/src/test/java/com/canopy/service

cp .gitignore ../$1/
sed "s/$template/$1/g" ../${template}/settings.gradle > ../$1/settings.gradle

sed "s/$templatedb/${basename}db/g" ../${template}/build.gradle > ../$1/build.gradle
sed -i '' "s/$templateName/${name}Service/g" ../$1/build.gradle

lf=$'\n'
sed -i '' "s/\(^.*if.*$\)/\1\\$lf        compile project(':$1')/" ../all/build.gradle
sed -i '' "s/\(^.*else.*$\)/\1\\$lf        compile 'canopytax:$1:+'/" ../all/build.gradle
sed -i '' "s/$template/$1', '$template/" ../all/settings.gradle

sed "s/Service/${name}Service/g" templates/Service.java > ../$1/src/main/java/com/canopy/service/${name}Service.java
sed -i '' "s/service/${name}/g" ../$1/src/main/java/com/canopy/service/${name}Service.java

sed "s/Service/${name}Service/g" templates/ServiceTest.java > ../$1/src/test/java/com/canopy/service/${name}ServiceTest.java
sed -i '' "s/service/${name}/g" ../$1/src/test/java/com/canopy/service/${name}ServiceTest.java

cd ../$1
git init
git add .
git commit -m "Initial $1 setup"
git remote add origin git@github.com:CanopyTax/$1.git
cd -