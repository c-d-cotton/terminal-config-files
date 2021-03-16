# BASH_PREAMBLE_START_COPYRIGHT:{{{
# Christopher David Cotton (c)
# http://www.cdcotton.com
# BASH_PREAMBLE_END:}}}

#Tab: menu-complete
#"\e[Z": menu-complete-backward
set show-all-if-ambiguous on

#Change Ctrl-w with punctuation behaviour: Can't get the unbinding to work
#bind -r "\C-w"
#"\C-w": backward-kill-word
#Meta-Rubout: backward-kill-word

#Turning on color for completions:
set colored-stats on

#Removing hidden directories from bash completion
set match-hidden-files off

#Turn off annoying display more possibilities on Bash completion:
set completion-query-items 0
set page-completions off
