# Harleen theme only displays a clock on the right prompt...
function fish_right_prompt
  set -l color_green  (set_color -o abd543)
  set -l color_dim    (set_color -o c0c0c0)
  set -l color_off    (set_color -o normal)

  echo -n -s $color_dim (date +%H$color_green:$color_dim%M$color_green:$color_dim%S)$color_off

end
