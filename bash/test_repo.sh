url=$1
name=$(basename $url .git)
repos_path=~/repos
repo_path=~/repos/$name

echo Processing $repo

rm -rf $repo_path
cd $repos_path
git clone $url
cd $name
rvm use 1.8.7@$name
bundle
rake
