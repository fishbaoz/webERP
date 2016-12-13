
grep --color "\<$1\>" . -r --exclude-dir=mysql --exclude-dir=.svn --exclude="*.po" --exclude="*.mo" --exclude-dir=doc --exclude-dir=locale
echo "find -name \"*.php\" -exec sed -i 's/\<$1\>/weberp_$1/g' {} \;"
