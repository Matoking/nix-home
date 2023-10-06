{ pkgs, lib, ... }:

let fixedVimIsort = pkgs.vimPlugins.vim-isort.overrideAttrs (old: rec {
    postPatch = ''
      substituteInPlace ftplugin/python_vimisort.vim \
        --replace 'import vim' 'import vim; import sys; sys.path.append("${pkgs.python3Packages.isort}/${pkgs.python3.sitePackages}")'
    '';
  });
  myVimPlugins = with pkgs.vimPlugins; [
    ale                             # Asynchronous linting
    ctrlp-vim                       # Fuzzy search with ctrl+p
    nerdtree                        # Tree file browser
    vim-airline                     # Status/tabline for vim
    vim-jinja                       # Jinja syntax highlighting
    vim-easymotion                  # Fast cursor motions
    vim-better-whitespace           # Highlight trailing whitespace
    vim-polyglot                    # Better syntax highlighting for languages
                                    # including Python
    fzf-vim                         # Fuzzy grep for files using :Ag

    nerdtree-git-plugin             # git status icons in file browser
    fixedVimIsort                   # :Isort command to sort Python imports
    vim-prettier                    # Opinionated JS formatter
  ];
  # Use virtual text prefix with note type if ALE is new enough
  virtualtextPrefix = if lib.versionAtLeast pkgs.vimPlugins.ale.version "2023-05-05" then " %type%: " else " : ";
in
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
      silver-searcher           # Enables faster CtrlP searches

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
          let mapleader = ","

          filetype plugin indent on
          syntax on
          set encoding=utf8
          set number

          let NERDTreeIgnore = ['\.pyc$']

          " Fixes performance issues with Vue linting
          let g:vue_pre_processors = []

          " Define specific linters for Python
          let g:ale_linters = {
          \ 'python': ['pylint', 'ruff']
          \ }

          " Tune highlighting colors for Tango color scheme
          highlight ALEVirtualTextError ctermfg=Red
          highlight ALEVirtualTextWarning ctermfg=Yellow

          " Start linting earlier after writing
          let g:ale_lint_delay = 50

          " Enable virtualtext for warning and use a glyph from Nerd font
          " for the warning label
          let g:ale_virtualtext_cursor = 2  " 'all'
          let g:ale_virtualtext_prefix = '${virtualtextPrefix}'

          " Disable mouse support by default
          set mouse=

          autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
          autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
          autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab

          " Activate EasyMotion with only 's' letter
          map s <Plug>(easymotion-s)

          " Activate :Ag (fuzzy grep) with Ctrl+L
          nmap <C-l> :Ag<CR>

          " Allow closing FZF window with Esc
          autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

          " Alias :W to :w
          cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

          let g:airline_powerline_fonts = 1
          let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
          let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

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

          " Only autoformat using Prettier if the project is configured to
          " use it
          let g:prettier#autoformat_config_present = 1
          let g:prettier#autoformat_require_pragma = 0

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
