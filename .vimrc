" vim-html5
execute pathogen#infect()
filetype plugin indent on

" Basic options
set encoding=utf-8
set hlsearch
set number

set bg=dark
" Tabs/spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Leader
let mapleader = ","

" color syntax highlighting
syntax on
filetype on
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead *.map.mako set filetype=map
au BufNewFile,BufRead *.js.mako set filetype=js
au BufNewFile,BufRead *.html.mako set filetype=html

" Use the same symbols as TextMate for tabstops and EOLs
" set list
" set listchars=tab:▸\

"" From Pierre Giraud dotfiles

"appearance options
set t_Co=256

" Soft/hard wrapping
" http://vim.wikia.com/wiki/Automatic_word_wrapping
set wrap
set textwidth=79
set formatoptions=qrn1t

" Fuck you, help key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" text titles and doc helpers
nnoremap <leader>= yypVr=
nnoremap <leader>* yypVr*
noremap <leader>* yypVr*

set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
let g:Powerline_symbols = 'fancy'
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')
" Always show statusline
set laststatus=2

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>


function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
