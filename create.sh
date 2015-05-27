#!/bin/bash

dir=$(pwd | sed 's/\/[^/]*$//' | sed 's/.*\///' )

mkdir -p ../$1
cp .gitignore ../$1/
sed "s/new-project/$1/g" build.gradle > ../$1/build.gradle
sed -i '' "s/company-name/$dir/g" ../$1/build.gradle
sed "s/new-project/$1/g" settings.gradle > ../$1/settings.gradle
mkdir -p ../$1/src/main/java ../$1/src/main/resources
mkdir -p ../$1/src/test/java ../$1/src/test/resources

cp ../vertx-shared/vertx.gradle .
cp ../vertx-shared/gradle.properties .

git init
git commit -a -m "Initial $1 setup"
git remote add origin https://github.com/CanopyTax/$1.git