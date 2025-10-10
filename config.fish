if status is-interactive
    # Commands to run in interactive sessions can go here
end

thefuck --alias | source

function fish_greeting
     pokemon-colorscripts -r
end

function fish_prompt
    set -l last_status $status
    # Prompt status only if it's not 0
    set -l stat
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status]"(set_color normal)
    end

    string join '' -- '╭─ ' (set_color green -o) (whoami) (set_color normal) '@' (prompt_hostname) ' ' (set_color green) (prompt_pwd) (set_color normal) (fish_git_prompt) (set_color normal) $stat ''
    string join '' -- '╰─$ '
end
