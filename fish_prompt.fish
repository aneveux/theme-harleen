# Harleen theme displays useful information while browsing git repositories.
#
# Defining some useful functions for retrieving information out of git repositories.

# Checks if the current folder is a git repository
function git::is_repo
  command git rev-parse 2> /dev/null
end

# Checks if the current git repository contains stashed files
function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

# Checks if there are local modifications in the current git repository
function git::is_touched
  test -n (echo (command git status --porcelain))
end

# Retrieves the current branch name from the current git repository
function git::branch_name
  command git symbolic-ref --short HEAD
end

# Retrieves the current reference from the current git repository
function git::reference
  command git show-ref --head --abbrev | awk '{print substr($0,0,7)}' | sed -n 1p
end

# Retrieves the remote branches from the current git repository
function git::remote
  command git remote
end

# Retrieves the number of ahead modification in the current git repository
function git::ahead_count
  command git rev-list (git::remote)/(git::branch_name)..(git::branch_name) ^/dev/null | wc -l | tr -d " "
end

# Retrieves the number of behind modification in the current git repository
function git::behind_count
  command git rev-list (git::branch_name)..(git::remote)/(git::branch_name) ^/dev/null | wc -l | tr -d " "
end

# Function actually displaying the fish prompt
function fish_prompt
  # Retrieving status of last command - directly using it to set colors for displaying prompt symbols
  test $status -ne 0;
    and set -l colors 666 aaa f02093
    or set -l colors 666 aaa 03adf1

  # Then displaying the path we're at
  set cwd (basename (prompt_pwd))
  printf (blue)"("(dim)$cwd(blue)") "(off)

  # Then if it's a Git repository, bring some magic
  if git::is_repo
    git::is_stashed; and echo -n -s (purple)"^ "(off)

    echo -n -s (pink)"("(off)
    git::is_touched; and echo -n -s (yellow)"* "(off)
    echo -n -s (dim)(git::branch_name)(off)
    set -l behind_count (git::behind_count)
    test $behind_count -eq 0; or echo -n -s (blue)" -"$ahead_count" "(off)
    set -l ahead_count (git::ahead_count)
    test $ahead_count -eq 0; or echo -n -s (green)" +"$ahead_count" "(off)
    echo -n -s (pink)") "(off)
  end

  # Finally display the prompt symbols
  for color in $colors
    echo -n (set_color $color)">"
  end

  echo -n -s " "
end
