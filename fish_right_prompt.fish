# Harleen theme only displays a clock on the right prompt...
function fish_right_prompt
  echo -n -s (dim)(date +%H(yellow):(dim)%M(yellow):(dim)%S)(off)
end
