#!/bin/sh -e
# See http://people.freebsd.org/~kientzle/libarchive/man/cpio.5.txt
#
# Missing features:
# - hard links
# - block/character devices
# - cpio does not erase existing files by default
 
set -e
 
DEBUG=''
 
usage() {
printf "Usage: %s: -i [-d] [-m] [-v] \n" $0
exit 2
}
 
EXTRACT=''
VERBOSE=''
MAKEDIR=''
PRESERVEMTIME=''
while getopts dimv name
do
case $name in
d) MAKEDIR='y';;
i) EXTRACT='y';;
m) PRESERVEMTIME='y';;
v) VERBOSE='y';;
?) usage;;
esac
done
 
if [ -z "$EXTRACT" ]; then
usage
fi
 
settrap() {
trap "trap - INT HUP 0; $1 exit 2" INT HUP
trap "trap - INT HUP 0; $1" 0
}
 
# Print an error if we do not exit on our own terms
settrap 'echo "Error during extraction.";'
 
# readnpad n
# Read n bytes, and discard padding, such that n+pad is a multiple of 4
readnpad() {
head -c "$1"
head -c "$(( (4 - ($1 % 4)) % 4 ))" > /dev/null
}
 
# readnpadheader n
# Read n bytes, and discard padding, such that header size is a multiple of 4
# Also discards null-termination
readnpadheader() {
local n="$(($1-1))"
# 110 bytes of header plus terminating \0
local extra=111
local pad="$(( (4 - (($n + $extra) % 4)) % 4 + 1 ))"
head -c "$n"
head -c "$pad" > /dev/null
}
 
while true; do
# FIXME: endianness?!?!? Format is middle-weird endian:
# The four-byte integer is stored with the most-significant 16 bits
# first followed by the least-significant 16 bits. Each of the two
# 16 bit values are stored in machine-native byte order.
 
eval "`head -c 110 | awk '{
if (substr($0, 0, 6) != "070701") {
print "Invalid magic" > "/dev/stderr"
exit 1
}
i=0;
print "ino=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "mode=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "uid=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "gid=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "nlink=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "mtime=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "filesize=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "devmajor=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "devminor=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "rdevmajor=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "rdevminor=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "namesize=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
print "check=\\"$((0x" substr($0, 7+i++*8, 8) "))\\""
}'`"
 
type="$((($mode & 0170000) >> 12))"
filename="`readnpadheader $namesize`"
 
if [ "$type" -eq 0 -a "$filename" = "TRAILER!!!" ]; then
# We reached the end of the archive (isn't that awesome?)
if [ -n "$DEBUG" ]; then
echo "EOF"
fi
# Do not print error
settrap 'true;'
exit 0
fi
 
if [ -n "$VERBOSE" ]; then
echo "$filename"
fi
 
if [ -n "$MAKEDIR" ]; then
mkdir -p "`dirname $filename`"
fi
 
case $type in
4)
if [ ! -d "$filename" ]; then
mkdir "$filename"
fi
;;
8)
readnpad $filesize > "$filename"
;;
10)
target="`readnpad $filesize`"
ln -sTf "$target" "$filename"
;;
*)
echo "Type $type unsupported" 1>&2
exit 1
;;
esac
 
# Crude octal conversion (also contains SUID/SGID bits)
perm="$((($mode & 07000) >> 9))$((($mode & 00700) >> 6))$((($mode & 00070) >> 3))$(($mode & 00007))"
 
# Do not update ownership and permissions for symlinks
if [ "$type" -ne 10 ]; then
chown $uid:$gid "$filename"
chmod $perm "$filename"
fi
if [ -n "$PRESERVEMTIME" ]; then
touch -c -h -d "@$mtime" "$filename"
fi

done