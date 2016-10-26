#!/bin/sh

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
	local cpp="$file.cpp"
	local hpp="$file.hpp"

	if [ -f $cpp -o -f $hpp ]
	then
	    echo ">> Either $cpp or $hpp already exists, no action taken."
	else
	    touch $cpp
	    echo "// The implementation of file $file" > $cpp
	    echo "#include \"$hpp\"" >> $cpp

	    touch $hpp
	    echo "// The header file of $file" > $hpp
	    echo "#ifndef ${file}_hpp" >> $hpp
	    echo "#define ${file}_hpp" >> $hpp
	    echo "// Code goes here"   >> $hpp
	    echo "#endif"              >> $hpp

	    echo ">> Files $cpp and $hpp written to $(pwd)."
	fi
    done
}
