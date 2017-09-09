set -eu

title() {
    echo '#'
    echo "# $*"
    echo '#'
}

title Version
uname -a

title Environment Variables
env | sort

title Running Processes
ps
