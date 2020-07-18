###############################################################################
# Author: Akhilesh Reddy
# Date: 2/6/2020
# Pledge:I pledge my honor that I have abided by the Stevens Honor System.
# Description:junk assignment
##############################################################################
#!/bin/bash



readonly junkdir=~/.junk
#how to copy the command line 
display_usage(){

varname=$(basename "$0") 
cat <<USAGE
Usage: $varname [-hlp] [list of files]    
   -h: Display help. 
   -l: List junked files.  
   -p: Purge all files.  
   [list of files] with no other arguments to junk those files. 
USAGE
}


#checks if the directory doesnt exist, then we create it 
if [ ! -d $junkdir ]; then  
	mkdir $junkdir
fi

#checks if the file is in the current directory, and if it is then we move it into the junk directory
#else send an error to the user 
declare -a filenames

shift "$((OPTIND-1))" #proces where we are left off
index=0

for f in $@; do 
	filenames[$index]="$f"
	(( ++index ))
done

#echo ${filenames[*]}

param=0
display_help=0
list_junk=0
purge_file=0

while getopts ":hlp" option; do
		case "$option" in
			h)  (( ++param ))
				display_help=1
				;;
			l) (( ++param )) 
				list_junk=1
				;;
			p) (( ++param ))
				purge_file=1
				;;

			?) 
			  	(( ++param ))
			   	printf "Error: Unknown option '-%s'.\n" $OPTARG >&2
			   	display_usage
			   	exit 1
			  ;;
		esac
	done


#if there is no parameters, then display just the usage
#and must check if there are no filenames 
if [ $param -eq 0 ]; then
	if [ $index -eq 0 ]; then
		display_usage
		exit 0	
	fi
fi


var=$(( $index - $param ))
#if there is more than one parameter then display error message
#add if param == 1 and there are files in addition to it
#if param ==1 and index is greater than 1, display too many options
if [ $param -gt 1 ];then
	printf "Error: Too many options enabled. \n"
	display_usage
	exit 1
fi

if [ $param -eq 1 ];then
	if [ $index -gt 1 ];then
		printf "Error: Too many options enabled. \n"
		display_usage
		exit 1
	fi
fi



#subtract param and index, if param - index = 0, then its only getopts

sub=$(( $param - $index ))



#list the junk files , purge the files, or display help if given proper parameters
#number of filenames must be 0
#$param eq 1
if [  $sub -eq 0 ];then
	if [ $list_junk -eq 1 ];then
		ls -lAF "$junkdir"
		exit 0
	elif [ $purge_file -eq 1 ];then
		rm -rf $junkdir/* $junkdir/.* 2>/dev/null
		exit 0
	elif [ $display_help -eq 1 ];then
		display_usage
		exit 0
	fi
fi

#-f only checks if it is a file that is executable or txt file or etc...
#how to check if its a getopts command
#for f in $filenames; do
#for f in *; do file $filenames
for f in ${filenames[@]}; do
	if [ ! -e "$f" ] ; then 
		printf "Warning: '$f' not found. \n"
	else 
		mv $f $junkdir
	fi
done

#if the file is already in the .junk , do u have to override it 

