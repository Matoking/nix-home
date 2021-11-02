{ pkgs,  ... }:

let
  myVimPlugins = with pkgs.vimPlugins; [
    ale
    ctrlp-vim
    nerdtree
    rust-vim
    vim-airline
    vim-flake8
    vim-javascript
    vim-jinja
    vim-easymotion
    vim-better-whitespace
    vim-isort
    vim-nix
    nerdtree-git-plugin
  ];
  linterPackages = with pkgs; [
    # Various linters
    yamllint
    python38Packages.flake8
    python38Packages.pylint
    python38Packages.isort
    shellcheck
  ];
in
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
      (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = myVimPlugins;
          opt = [];
        };
        customRC = ''
          set colorcolumn=80
          set nowrap

          set expandtab
          set tabstop=4
          set softtabstop=4
          set shiftwidth=4
          set autoindent

          inoremap jk <ESC>
          let mapleader = "\<Space>"

          filetype plugin indent on
          syntax on
          set encoding=utf8
          set number

          let NERDTreeIgnore = ['\.pyc$']

          autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

          " Activate EasyMotion with only 's' letter
          map s <Plug>(easymotion-s)

          " Alias :W to :w
          cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

          let g:airline_powerline_fonts = 1
          let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
          if executable('ag')
            let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
          endif

          let g:vim_isort_python_version = 'python3'

          let g:vimchant_spellcheck_lang = 'fi'

          let g:NERDTreeGitStatusIndicatorMapCustom = {
              \ "Modified"  : "✹",
              \ "Staged"    : "✚",
              \ "Untracked" : "✭",
              \ "Renamed"   : "➜",
              \ "Unmerged"  : "═",
              \ "Deleted"   : "✖",
              \ "Dirty"     : "✗",
              \ "Clean"     : "✔︎",
              \ 'Ignored'   : '☒',
              \ "Unknown"   : "?"
              \ }

          map Q :qa<CR>

          " Enable word wrap for TeX files
          augroup WrapLineInTeXFile
              autocmd!
              autocmd FileType tex setlocal wrap
          augroup END

          tnoremap <Esc> <C-\><C-n>

          " Use Ctrl+K and Ctrl+J to move between ALE warnings
          nmap <silent> <C-k> <Plug>(ale_previous_wrap)
          nmap <silent> <C-j> <Plug>(ale_next_wrap)

          function! StartUp()
              if 0 == argc()
                  NERDTree
              end
          endfunction

          autocmd VimEnter * call StartUp()

        '';
      };
    })
  ];
}
