#!/usr/bin/sh

# Fetch script

# Get some gap
printf "\n"

# Define colors
color1='\e[38;5;063m'
color2='\e[38;5;048m'
color3='\e[38;5;202m'
color4='\e[38;5;057m'
color5='\e[38;5;199m'
color6='\e[38;5;226m'
colorrest='\e[0m'

# Declare function to print spaces
print_space(){
    for ((j=0; j<$1; j++))
    do
        printf " "
    done
    return 0
}

# Declare func to calc to longest string
calc_longest(){
    for ((i=1; i<${len}; i++))
    do
        if [ $i == 5 ];then
            # Use this in order to skip a position.
            continue
        fi
        prev_i=$((i - 1))
        prev="${info[prev_i]} ${data[prev_i]}"
        next="${info[i]} ${data[i]}"
        if [ ${#prev} -gt ${#next} ];then
            longest=$prev
            index_long=$prev_i
        else
            longest=$next
            index_long=$i
        fi
    done
}

# Ceiling function
ceil(){
    i=$1
    ans=$((${i%.*} + 1))
}


# Function for bars
print_bars(){
    no=$1
    color=$2
    for ((i=0; i<$no; i++))
    do
        printf "$color=="
    done
    printf "$colorrest"
}

# Grab distro name
grab_distro(){
    distro=$(cat /etc/issue)

    removals=("( ) \r \n \l")

    for remove in $removals
    do
        distro=${distro[@]//"$remove"/""}
    done
}

# Grab kernel
grab_kernel(){
    kernel=$(uname -mrs)
    # Rrmove some stuff
    #removals=("MANJARO x86_64 x86 -")

    #for remove in $removals
    #do
    #    kernel=${kernel[@]//"$remove"/""}
    #done
}

# Declare info array
info=("distro" "kernel" "song" "wm" "packages" "cpu" "memory" "temperature")

grab_distro
data[0]=$distro

grab_kernel
data[1]=$kernel

# Grab Song
song=$(mpc current)
data[2]=$song

# Grab no. of packages
data[4]=$(pacman -Qq | wc -l)

#WM
data[3]=$(printf "$XDG_CURRENT_DESKTOP")

# Calculate the longest string
len=${#data[@]}
longest="${info[0]} ${data[0]}"
index_long=0

# Call the function
calc_longest

# Calculate spcae
COLUMNS=$(tput cols)
LONGEST=${#longest}
HALF_COL=$((COLUMNS/2))
HALF_LON=$((LONGEST/2))
HALF=$((HALF_COL - HALF_LON))

# Print a hello message
msg="Hello Deepjyoti, I'm Playground"
len_msg=${#msg}
req_spaces=$((COLUMNS - len_msg))
req_spaces=$((req_spaces/2))
print_space req_spaces
printf "${msg[@]:0:5}$color1${msg[@]:5:11}$colorrest${msg[@]:16:4}$color1${msg[@]:20}\n\n"


# Now printing the main part
for ((i=0; i<${len}; i++))
do
    if [ $i == 7 ];then
        continue
    fi
    # First print the space for info
    info_line=${#info[i]}
    len_info=${#info_line[@]}
    # echo "$info_line $len_info"

    req_spaces=$((HALF - info_line))
    # echo "$req_spaces"
    print_space $req_spaces
    n=$?
    title=${data[i]}
    # Now print the info_name
    printf "$color3${info[i]}$color2 $title$colorrest\n"
    # read nana
done

# Put some gap
printf "\n\n"

#----------CPU------------
# Get CPU percent
CPU=$(awk '/cpu /{print 100*($2+$4)/($2+$4+$5)}' /proc/stat)

# dot_space req for spaces
dot_as_last="${CPU%%.*}"
dot_pos=${#dot_as_last}

# Get the value in range of 10
eq=${CPU[@]:0:dot_pos}
ceil $eq
conv_percent=$((ans/10))

# Calculate the rest
rest=$((10 - conv_percent))
info_line=${info[5]}
len_info=${#info_line}

## Print the info
#- Calculate Space req
req_spaces=$((HALF - len_info - 5))
print_space req_spaces
printf "${info[5]} $color6$eq%%$colorrest"

# Print space between info and bar
no_spaces=$((4 - $dot_pos))
print_space no_spaces

# Print the bars
print_bars conv_percent $color4
print_bars rest $color5
printf "\n"

#-------------MEM-----------
# Get mem percentage
MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get position of dot
dot_as_last="${MEM%%.*}"
dot_pos=${#dot_as_last}

# Get value in range of 10
eq=${MEM[@]:0:2}
ceil $eq
conv_percent=$((ans/10))

# Calculate the rest
rest=$((10 - conv_percent))

info_line=${info[6]}
len_info=${#info_line}

## Print the info
#- Calculate Space req
req_spaces=$((HALF - len_info - 5))
print_space req_spaces
printf "${info[6]} $color6$eq%%$colorrest"

# Print space between info and bar
no_spaces=$((4 - $dot_pos))
print_space no_spaces

# Print the bars
print_bars conv_percent $color4
print_bars rest $color5
printf "\n"


#--------------TEMP---------------
# Get the CPU temperature
temp=$(cat /sys/class/thermal/thermal_zone1/temp)

# Get position of dot
dot_as_last="${MEM%%.*}"
dot_pos=${#dot_as_last}

temp=$((temp/1000))

eq=${temp[@]:0:2}
ceil $eq
conv_percent=$((ans/10))

# Calculate the rest
rest=$((10 - conv_percent))
info_line=${info[7]}
len_info=${#info_line}

## Print the info
#- Calculate Space req
req_spaces=$((HALF - len_info - 5))
print_space req_spaces
printf "${info[7]} $color6${temp[@]:0:$dot_pos}\u2103$colorrest"

# Print space between info and bar
no_spaces=$((4 - $dot_pos))
print_space no_spaces

# Print the bars
print_bars conv_percent $color4
print_bars rest $color5
printf "\n"

printf "\n\n"