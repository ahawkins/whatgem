url=$1
name=$(basename $url .git)
repos_path=/tmp/repos
repo_path=$repos_path/$name

echo Processing $repo

rm -rf $repo_path
cd $repos_path
git clone $url
cd $name

if [ -f .rvmrc]
then
  rvm use 1.8.7@$name
else
  echo "Using provided .rvmrc"
fi

bundle
rake
