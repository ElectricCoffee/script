#!/bin/bash

function compile-c {
    local args="-Wall -Werror -ansi -pedantic"
    
    if [ $# -eq 0 ]
    then
	echo "Please specify an file to compile."
	echo "How to use this function:"
	echo "compile-c <c-source-file> [<output-file>]"
    elif [ -z "$2" ]
    then
	# if no second argument supplied,
	# use a.out as the output file
	echo "Compiling $1 into a.out..."
	gcc $1 $args
    else
	# if a second argument is supplied,
	# use that as the name of the output file
	echo "Compiling $1 into $2..."
	gcc $1 -o $2 $args
    fi
}
	

function autoupdate {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get autoremove
}

function mkcd {
    if [ ! -d $1 ]
    then
	mkdir $1
    fi
    
    cd $1
}

function touch-cpp {
    for file in "$@"
    do
	local classname=$(basename $file)
	local directory=$(dirname $file)
	local cpp="$file.cpp"
	local hpp="$file.hpp"
	if [ ! -d $directory ]
	then
	    echo ">> Directory '$directory' doesn't exist, no action taken."
	elif [ -f $cpp -o -f $hpp ]
	then
	    echo ">> Either $cpp or $hpp already exists, no action taken."
	else
	    touch $cpp
	    echo "// The implementation of file $classname" > $cpp
	    echo "#include \"$hpp\"" >> $cpp

	    touch $hpp
	    echo "// The header file of $classname" > $hpp
	    echo "#ifndef ${classname}_hpp" >> $hpp
	    echo "#define ${classname}_hpp" >> $hpp
	    echo "// Code goes here"        >> $hpp
	    echo "#endif"                   >> $hpp

	    echo ">> Files $cpp and $hpp written to $directory/."
	fi
    done
}