cd viewer
Remove-Item -Path .\dist\ -Recurse
Remove-Item -Path ../src/viewer.zip
yarn
yarn build
Compress-Archive -Path ./dist -DestinationPath ../src/viewer.zip
cd ..