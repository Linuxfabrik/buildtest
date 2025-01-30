echo "Linuxfabrik $(uname -a)"
for dir in check-plugins/*; do
  check=$(basename $dir)
  if [ -e $dir/.windows ]; then
      echo $check >> /tmp/windows-checks
      echo "'$check'," >> /tmp/windows-checks-ps-list
  fi
done
