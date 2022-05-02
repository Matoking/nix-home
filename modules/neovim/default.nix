{ pkgs,  ... }:

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
    vim-javascript                  # JavaScript syntax highlighting
    vim-jinja                       # Jinja syntax highlighting
    vim-easymotion                  # Fast cursor motions
    vim-better-whitespace           # Highlight trailing whitespace
    vim-vue                         # Vue syntax highlighting
    plantuml-syntax                 # PlantUML syntax highlighting

    vim-nix                         # Nix syntax highlighting
    nerdtree-git-plugin             # git status icons in file browser
    fixedVimIsort                   # :Isort command to sort Python imports
  ];
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
          let mapleader = "\<Space>"

          filetype plugin indent on
          syntax on
          set encoding=utf8
          set number

          let NERDTreeIgnore = ['\.pyc$']

          autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
          autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
          autocmd FileType vue setlocal ts=2 sts=2 sw=2 expandtab

          " Activate EasyMotion with only 's' letter
          map s <Plug>(easymotion-s)

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
