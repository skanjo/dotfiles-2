# Install oh-my-zsh.
[[ ! -d $HOME/.oh-my-zsh ]] || return 1

e_header "Installing oh-my-zsh"
true | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Exit if, for some reason, oh-my-zsh is not installed.
[[ ! -d $HOME/.oh-my-zsh ]] && e_error "oh-my-zsh failed to install." && return 1
