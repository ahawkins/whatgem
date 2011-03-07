url=$1
name=$(basename $url .git)
repos_path=/tmp/repos
repo_path=$repos_path/$name

echo Processing $repo
echo Cloning into $repo_path

rm -rf $repo_path
cd $repos_path
git clone $url
cd $name

echo "Now in: $(pwd)"

rvmrc=$repo_path/.rvmrc

echo "Checking to see if $rmvrc is present"

if [ -f $rmvrc]
then
  rvm use 1.8.7@$name
else
  echo "Using provided .rvmrc"
fi

echo "Running bundle"
bundle

echo "Running rake"
rake
