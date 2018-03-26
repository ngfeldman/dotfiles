# When using `!!` history substitution, make Enter/Return key substitute in line editor instead
# of running the command straight away. Hit Enter again to run it.
setopt hist_verify
setopt append_history  # looks like noappendhistory is disabled by default so this doesn't do anything???
setopt extended_history

# /usr/local/opt/python/libexec/bin is here for the Homebrew 'python' package, which currently refers to python2
# but doesn't want to put python in your $PATH and assume you want it to run version 2.
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

export HISTFILE=~/.history  # where to save history
export SAVEHIST=1000000  # max number of commands saved in history file
export HISTSIZE=1000000  # max number of commands remembered by session
                         # and written to history at end of session
