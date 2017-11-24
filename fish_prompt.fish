# Harleen Theme. Made with <3.

function fish_prompt
  # Retrieving status of last command
  # Directly using it to set colors for displaying prompt symbols
  test $status -ne 0;
    and set -l last_status_colors 666 aaa f02093
    or set -l last_status_colors 666 aaa 03adf1

  # Defining some helper functions for playing with colors.
  # Thanks to http://www.colourlovers.com/palette/4537580/lisa_frank_rainbow~ for the colors inspiration :)
  set -l color_pink   (set_color -o f02093)
  set -l color_yellow (set_color -o fdf215)
  set -l color_green  (set_color -o abd543)
  set -l color_blue   (set_color -o 03adf1)
  set -l color_purple (set_color -o a23095)
  set -l color_dim    (set_color -o c0c0c0)
  set -l color_off    (set_color -o normal)

  # Defining symbols to use for information in Git repositories
  set -l stashed  "^"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "*"
  set -l none     ""

  # Displaying useful information in case of browsing a Git repository
  if git_is_repo
    # Displaying the path we're at using short path by default.
    # Particular treatment in case of browsing a Git repository.
    set root_folder (command git rev-parse --show-toplevel ^/dev/null)
    set parent_root_folder (dirname $root_folder)
    set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")
    echo -n -s $color_blue "("$color_dim $cwd $color_blue")" $color_off " "

    # Writing an indication in case there's some stashed content in the repository
    if git_is_stashed
      echo -n -s $color_purple $stashed $color_off
    end

    # Starting displaying information about the current branch
    echo -n -s $color_pink "(" $color_off

    # Displaying a marker in case the repository isn't clean
    if git_is_touched
      echo -n -s $color_yellow $dirty $color_off " "
    else
      echo -n -s " "
    end

    # Displaying the branch name
    echo -n -s $color_dim (git_branch_name) $color_off " "
    # Displaying information about the branch status
    echo -n -s $color_green (git_ahead $ahead $behind $diverged $none) $color_off

    # Ending the display :)
    echo -n -s $color_pink ")" $color_off " "

  else
    # Displaying the path we're at using short path by default.
    set cwd (basename (prompt_pwd))
    echo -n -s $color_blue "("$color_dim $cwd $color_blue")" $color_off " "
  end

  # Finally display the prompt symbols
  for color in $last_status_colors
    echo -n (set_color $color)">"
  end

  # And one last space. It does everything.
  echo -n -s " "

end
