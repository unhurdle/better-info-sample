#!/bin/sh

#Copy js files:
#cd `dirname $0`
#echo `dirname $0`
EXTENSION="BetterInfo"
rm -rf app

rsync -zarv --include="*/" --include="*.js" --include="*.css" --include="*.png" --include="*.map" --exclude="*" bin/js-release/ app
#rsync -r -u --include="*.js" bin/js-debug/ app

#copy and rename the html file
cp bin/js-release/index.html ./app/index.html

rm -rf /Library/Application\ Support/Adobe/CEP/extensions/$EXTENSION

rsync -zarv --include="*/" ./ /Library/Application\ Support/Adobe/CEP/extensions/$EXTENSION
#include all cd commands in a sub-shell
(cd /Library/Application\ Support/Adobe/CEP/extensions/$EXTENSION/jsx
mv bin/* .
rmdir bin
rm *.jsx
rm *.txt
for f in *.jsxbin; do mv -- "$f" "${f%.jsxbin}.jsx"; done
cd ..
ls
echo deleting unnecessary files...
rm *.sh
rm *.xml
rm asconfig.json
#invisible files
rm .*
#vscode folder
rm -rf .vscode
rm -rf src
rm -rf bin
rm -rf assets
rm -rf lib
rm -rf typedefs
rm -rf dev
ls
cd ..
#ls
rm -rf $EXTENSION.zxp
echo enter the certificate password
read password
./ZXPSignCmd -sign $EXTENSION $EXTENSION.zxp cert.p12 $password -tsa http://timestamp.digicert.com/
ditto $EXTENSION.zxp $TARGET_DIRECTORY/$EXTENSION.zxp
)
