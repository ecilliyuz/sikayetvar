#!/usr/bin/env/ sh

set -e

npm run build

cd dist

git init
git add -A
git commit -m "New Dep"
git push -f git@github.com:ecilliyuz/sikayetvar.git master:main

cd -