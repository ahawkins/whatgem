url=$1
name=$(basename $url .git)
repos_path=~/repos
repo_path=$repos_path/$name

echo Processing $repo
echo Cloning into $repo_path

if [ -d $repo_path ]
then
  echo "$repo_path already exists, deleting"
  rm -rf $repo_path
fi

cd $repos_path
git clone $url

rvmrc=$repo_path/.rvmrc

echo "Checking to see if $rvmrc is present"

if [ -f $rvmrc ]
then
  rvm use 1.8.7@$name
else
  echo "Using provided .rvmrc"
fi

cd $repos_path

echo "Now in $(pwd)"

echo "Running bundle"
bundle

echo "Running rake"
rake
