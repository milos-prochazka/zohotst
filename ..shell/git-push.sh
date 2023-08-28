#!/bin/sh

BRANCH="main"

read -p "Komentar ke commitu:" comment

read -p "Tag (volitelny):" tag
cd ..

if [[ "$comment" == "" ]] ; then
    read -t 10 -p "Komentar musi byt zadan" none
    exit 0
fi

echo "============== 1 ===================="
git add --all
echo "============== 2 ===================="
git commit --all -m "$comment"
echo "============== 3 ===================="
git push origin $BRANCH --force
echo "============== 4 ===================="

read -p "Kontrola ulozeni gitu"

echo "TAG"
rem read -p "Kontrola ulozeni gitu"

if [[ "$tag" != "" ]] ; then
    git tag "$tag"
    git push origin "$tag"
fi

echo "Cisteni"
git gc
git gc --aggressive
git prune


