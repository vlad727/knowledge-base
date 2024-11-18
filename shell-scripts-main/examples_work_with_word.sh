#  test len
echo ${#file}
# test delemiter
a=( $file )
echo ${a[0]}
echo ${a[1]}
# test split
echo 'version: 1.8.0.110' | sed 's/\./ /g'