set nocompatible              " be iMproved, required
filetype off                  " required

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
set rtp+=~/.fzf/plugin/fzf.vim
call vundle#begin()
"alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

"let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"The following are examples of different formats supported.
"Keep Plugin commands between vundle#begin/end.
"plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
"plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
"git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"The sparkup vim script is in a subdirectory of this repo called vim.
"Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"Install L9 and avoid a Naming conflict if you've already installed a
"different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}
"Plugin 'Valloric/YouCompleteMe'
Plugin 'sheerun/vim-polyglot'
"Plugin 'mileszs/ack.vim'
"Plugin 'mhinz/vim-grepper'
"Plugin 'junegunn/fzf.vim'
"All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"execute pathogen#infect()
"To ignore plugin indent changes, instead use:
"filetype plugin on
"
"Brief help
":PluginList       - lists configured plugins
":PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
":PluginSearch foo - searches for foo; append `!` to refresh local cache
":PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
"see :h vundle for more details or wiki for FAQ
"Put your non-Plugin stuff after this line


set tabstop=4
set shiftwidth=4
set expandtab
set number
set ignorecase
set smartcase
set foldmethod=syntax
set foldlevel=99
set shellcmdflag=-ic
set timeoutlen=100
let g:commentchar=split(&commentstring,'%s')[0]
"set nofoldenable
syntax on
inoremap <expr> jk col('.')==1 ? "\<esc>" : "\<esc>l"
inoremap <expr> JK col('.')==1 ? "\<esc>" : "\<esc>l"
"inoremap <expr> JK col('.')==1 ? "\<esc>" : "\<esc>l" echo "CAPS_LOCK ON"
"function! FixUp(lines)
				"let i = 0
				"execute "normal! mq"
				"while i < a:lines
				"				execute "normal! ^ciwf\<esc>j"
				"				" ciwf<esc>j 
				"				" echom i
				"				let i = i + 1
				"endwhile
				"execute "normal! `q"				
"endfunction
xnoremap fu :s,^pick,f,<cr>
xnoremap re :s,^pick,r,<cr>
"xnoremap jk <esc>l
xnoremap <expr> jk col('.')==1 ? "\<esc>" : "\<esc>l"
xnoremap <expr> JK col('.')==1 ? "\<esc>" : "\<esc>l"
xnoremap <expr> Jk col('.')==1 ? "\<esc>" : "\<esc>l"
xnoremap <c-_> :s,^\/\/ \\|^,\=submatch(0) == "\/\/ " ? "" : "\/\/ ",<cr>gv
"xnoremap <c-_> :s,^\(\s*\)\=&commentchar,___\1,<cr>gv
"command Grep GrepperRg
"nnoremap <c-p> :FZF<cr>
"nnoremap // :!rgo 
"nnoremap <leader>q :q<cr>
"nnoremap <leader>w :w<cr>
nnoremap Q @q
vnoremap Q :norm @q<cr>
function! LogMacro(name, tag, comment)
		let logmacro = ['#define DEBUG_' . a:name]
		call add(logmacro, '#ifdef DEBUG_' . a:name)
		call add(logmacro, '#define ' . a:name . '_DEBUG(...) ERSP_LOG_DEBUG("' . a:tag . ' " __VA_ARGS__) // ' . a:comment)
		call add(logmacro, '#else')
		call add(logmacro, '#define ' . a:name . '_DEBUG(...)')
		call add(logmacro, '#endif')
		call append(line('.'), logmacro)
endfunction
"command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed -strings --ignore-case -no-ignore --hidden --follow --glob "!.git/*" --color "always"'.shellescape(<q-args>), 1, <bang>0)
