#!/bin/sh

EXTENSION="BetterInfo"

#Copy js files:
rsync -zarv --include="*/" --include="*.js" --include="*.css" --include="*.png" --exclude="*" bin/js-debug/ app

#copy and rename the html file
cp bin/js-debug/index.html ./app/index.html

rsync -zarv --include="*/" ./ /Library/Application\ Support/Adobe/CEP/extensions/$EXTENSION
