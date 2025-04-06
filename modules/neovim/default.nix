{ pkgs, lib, ... }:

let
  myVimPlugins = with pkgs.vimPlugins; [
    ale                             # Asynchronous linting
    ctrlp-vim                       # Fuzzy search with ctrl+p
    nerdtree                        # Tree file browser
    vim-airline                     # Status/tabline for vim
    vim-easymotion                  # Fast cursor motions
    vim-better-whitespace           # Highlight trailing whitespace
    fzf-vim                         # Fuzzy grep for files using :Ag
    nerdtree-git-plugin             # git status icons in file browser
    vim-isort                       # :Isort command to sort Python imports
    vim-prettier                    # Opinionated JS formatter
    nvim-treesitter.withAllGrammars # Pattern-based syntax highlighting
    catppuccin-nvim                 # Color scheme
    vim-fugitive                    # git integration
    git-blame-nvim                  # :GitBlameToggle command to git blame
  ];
in
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
      silver-searcher           # Enables faster CtrlP searches
      ripgrep                   # Enables faster FZF fuzzy searches

  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = myVimPlugins;
    extraLuaConfig = /* lua */''
      require("catppuccin").setup({
        default_integrations = false,
      })
      require("gitblame").setup({
        enabled = false,
      })

      vim.cmd.colorscheme "catppuccin-mocha"
    '';
    extraConfig = /* vim */''
      set colorcolumn=80
      set nowrap

      set expandtab
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set autoindent

      " Relative line numbers by default
      set rnu

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
      \ 'python': ['ruff']
      \ }

      " Tune highlighting colors for Tango color scheme
      highlight ALEVirtualTextError ctermfg=Red
      highlight ALEVirtualTextWarning ctermfg=Yellow

      " Start linting earlier after writing
      let g:ale_lint_delay = 50

      " Enable virtualtext for warning
      let g:ale_virtualtext_cursor = 2  " 'all'

      " Disable mouse support by default
      set mouse=

      " Use 2 character tab length for other languages
      autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
      autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
      autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab
      autocmd FileType nix setlocal ts=2 sts=2 sw=2 expandtab

      " Activate EasyMotion with only 's' letter
      map s <Plug>(easymotion-s)

      " Activate :Rg/FZF (fuzzy grep) with Ctrl+L
      nmap <C-l> :Rg<CR>

      " Allow closing FZF window with Esc
      autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

      " Alias :W to :w
      cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

      " Map 'ä' to change between relative and absolute line numbers
      map ä :set rnu!<CR>

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

      " Alias :GBB to :GitBlameToggle
      :command GBB GitBlameToggle

      " Only autoformat using Prettier if the project is configured to
      " use it
      let g:prettier#autoformat_config_present = 1
      let g:prettier#autoformat_require_pragma = 0

      function! StartUp()
          if 0 == argc()
              NERDTree
          end

          " Enable nvim-treesitter highlighting
          :TSEnable highlight
      endfunction

      autocmd VimEnter * call StartUp()

    '';
  };
}
