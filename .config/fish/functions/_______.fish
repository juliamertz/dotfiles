function n
    echo (set_color normal)
end

function t
    echo (set_color $argv)
end

function b 
    echo (set_color -b $argv)
end

set directories (string split / (pwd))
set colors blue cyan blue

set dirLength (count $directories)
set dirStart (math $dirLength - 2) 
set relevantDirs $directories[$dirStart..$dirLength]

function fish_prompt
    set dir1 (echo (t $colors[1])(n))(b $colors[1])"   "$relevantDirs[1]" "(n)
    set dir2 (b $colors[2])" "$relevantDirs[2]" "(n)
    set dir3 (b $colors[3])" "$relevantDirs[3]"  "(n)(t $colors[3])"  "

    echo \n
    echo $dir1$dir2$dir3
end

# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 

