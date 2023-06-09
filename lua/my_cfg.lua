-- lua的缩进不影响语法 

-- require('telescope').setup{
--       defaults = {
--                   -- config_key = value,
--                   },
--       pickers = {
--         -- picker_name = {
--         --   picker_config_key = value,
--         -- }
--         -- Now the picker_config_key will be applied every time you call this builtin picker
--       },
--       extensions = {
--         -- Your extension configuration goes here:
--         -- extension_name = {
--         --   extension_config_key = value,
--         -- }
--         -- please take a look at the readme of the extension you want to configure
--       }
--     }


function Kill_popUP()
    for _,  win in ipairs(vim.api.nvim_list_wins())
        do local config = vim.api.nvim_win_get_config(win);
            if config.relative ~= ""  then
                vim.api.nvim_win_close(win,  false)
            -- print('Closing window',  win)
        end
    end
end

-- 插件abbrev-man
    -- if vim.api.nvim_eval("if !exist('g:vscode')") then
    -- lua 的boolean:
         -- false: boolean false and nil.
         -- true:  Any other value evaluates
    -- if vim.fn.exists('g:vscode') then
    if vim.fn.exists('g:vscode') == 0 then
    -- if vim.fn.exists('g:vscode') ~= 0 then
                            --lua里: ~=表示不等

        local abbrev_man = require("abbrev-man")
        -- 空格触发
        -- 对cnoreabb无效
        abbrev_man.setup({
            load_natural_dictionaries_at_startup = true,
            load_programming_dictionaries_at_startup = true,

            natural_dictionaries = {
                -- 把作者的dict全复制来了
                -- 会捣乱? 自己错过的才加进来?
                -- 对于复制进来的string, 只会纠正最后一个单词(会"晃一下", 挺明显)
                ["nt_en"] = {
                    ["sukc"] = "suck",
                    ["zpeling"] = "spelling",
                    ["yuor"] = "your",
                },
                ["nt_my_slangs"] = {
                    ["lmao"] = "LMAO",
                    ["_ht"] = "💚",
                    ["_up"] = "⬆",
                    ["_bug"] = "",
                }
            },
            programming_dictionaries = {
                ["pr_py"] = {
                    ["improt"] = "import",
                    ["whole"] = "while",  -- i和o挨着 容易敲错
                    ["prant"] = "print"
                }
            }
        }
        )
    else
        print("进了vscode")
    end

    -- 或者:
    -- if not vim.g.vscode then
    --     print("g:vscode does not exist")
    -- else
    --     print("g:vscode was set to "..vim.g.vscode)
    -- end
    
-- 之前以为treesitter导致老是弹窗, 后来发现是coc的错
require "nvim-treesitter.configs".setup {
    -- ensure_installed = {"vim", "bash", "python", "regex","markdown", "lua"},
    --                   不能识别vim里括号包裹的换行注释
    ensure_installed = {"bash"     ,
                        "python"   ,
                        "regex"    ,
                        "markdown" ,
                        "lua"      ,
                        "norg"     ,
                        "scheme"   ,
                       }, 
                -- " 每种语言的parser分别包含下面的Module:
                    --    " highlight 
                       -- incremental_selection
                       -- indent
                       -- matchup
                       -- playground
                       -- query_linter
                       --
                    --    " highlight module是最简单的? 

                --    " A feature needs a language-specific query file 
-- 各Module
    highlight = {
        enable = true,
            --true导致vimtex里let b:current_syntax被unlet,
                            -- 调用官方的syntax/tex.vim
                            --就算 diasble了highlight,
                            --但下面的Rainbow还是会影响括号的颜色
            -- `false` will disable the whole extension

        disable = {"c"     ,
                   "rust"     ,
                   "json"     ,
                   "jsonc"    ,
                   "latex"    ,
                   "vim"      ,
                   "markdown" ,
                   "help"     ,
                   "python"   ,
                  },
                  -- 列了这么多disable, 干脆彻底disable?
            -- To disable highlighting for the `tex` filetype,
            -- you need to include:    'latex'
            -- (these are the names of the parsers and not the filetype)

        additional_vim_regex_highlighting = true,
        -- additional_vim_regex_highlighting = {"vim","python"},
        -- 不设这个 syntax off?
            -- Set this to `true` if you depend on '¿syntax¿' being enabled (like for indentation).
            -- Using this option may slow down your editor,
                -- and you may see some duplicate highlights.
    },

    incremental_selection = {
        enable = true,
        keymaps = {init_selection    = "gnn",
                   node_incremental  = "grn",
                   scope_incremental = "grc",
                   node_decremental  = "grm",
                  },
      },

    indent = {  enable = true  },
    -- A experimental feature

    -- textobjects = { enable = true },

    -- rainbow = {
        -- -- enable = true,  -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        -- disable = { "jsx", "tex" },
        -- extended_mode = true, -- Also highlight non-bracket delimiters(成对符号)
        --                       -- like html tags,
        --                       -- boolean or table: lang -> boolean
        -- max_file_lines = 500, -- Do not enable for files with more than n lines, int
        -- -- colors = {}, -- table of hex strings
        -- -- termcolors = {} -- table of colour name strings
        --     -- " If you want to override some colours (you can only change colours 1 through 7 this way),
        --     -- you can do it in your init.vim:
        --         -- hi rainbowcol1 guifg=#123456
        -- },


    playground = {
    -- 仅用于开发colorscheme等
        enable      = true,
        updatetime  = 25, -- Debounced time for highlighting nodes in the playground from source code
        keybindings = {
                        toggle_query_editor       = 'o'    ,
                        toggle_hl_groups          = 'i'    ,
                        toggle_injected_languages = 't'    ,
                        toggle_anonymous_nodes    = 'a'    ,
                        toggle_language_display   = 'I'    ,
                        focus_language            = 'f'    ,
                        unfocus_language          = 'F'    ,
                        update                    = 'R'    ,
                        goto_node                 = '<cr>' ,
                        show_help                 = '?'    ,
                        },
          }

}

-- 更新后貌似就报错:
    -- require"nvim-treesitter.highlight".set_custom_captures {
    --     -- Highlight the ¿@foo.bar¿ `capture group
    --      -- with the "Identifier" highlight group.
    --     ["leo_identifier_test_tree_sitter"] = "Identifier",
    -- }

-- require'regexplainer'.setup {
    --     mode = 'narrative',
    --
    --     -- automatically show the explainer when the cursor enters a regexp
    --     auto = false,
    --
    --     -- Whether to log debug messages
    --     debug = true,
    --
    --     display = 'popup',
    --     -- display = 'split',
    --     -- 或者 'split'
    --
    --     mappings = {
    --     toggle = 'gR',
    --     -- examples, not defaults:
    --     show = 'gS',
    --     hide = 'gH',
    --     show_split = 'gP',
    --     show_popup = 'gU',
    --     },
    --
    --
    --     narrative = {
    --         separator = function(component)
    --             local sep = '\n';
    --             if component.depth > 0 then
    --                 for _ = 1, component.depth do
    --                     sep = sep .. '> '
    --                 end
    --             end
    --             return sep
    --       end
    --     },
    -- }
-- must after `nvim-treesitter`'s setup
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    mary = "~/dotF/n-org/mary",
                    lucy = "~/dotF/n-org/lucy",
                }
            }
        },
        ["core.norg.concealer"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
            -- Configuration here
            }
        },
     }
} 

-- dap
    local dap, dapui = require("dap"), require("dapui")
        -- todo
        -- 等价于下面?
        -- local dap  =  require("dap")
        -- local dapui = require("dapui") 
        --
    -- vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapBreakpoint', {text='▸', texthl='', linehl='', numhl=''})
    
        
        dap.defaults.fallback.focus_terminal = true  
        dap.defaults.fallback.terminal_win_cmd = '70vsplit new'

        -- require("dapui").setup({  上面已经出现了require("dapui"), 再出现会有个warning啥的
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
                expand = { "<CR>", "<2-LeftMouse>" } ,  -- Use a table to apply multiple mappings
                open   = "o"                         ,
                remove = "d"                         ,
                edit   = "e"                         ,
                repl   = "r"                         ,
                toggle = "t"                         ,
            },

            expand_lines = vim.fn.has("nvim-0.7"),  -- for lines larger than the window

            layouts = {
                -- Layouts are opened in order
                -- so that earlier layouts take priority in window sizing.
                { 
                    elements = {
                    -- Elements can be strings or table with id and size keys.
                        { id = "scopes", size = 0.25 } ,  -- Displays the available scopes and variables within them.
                        "stacks"                       ,  --  running threads and their stack frames.
                        "breakpoints"                  ,
                        -- "watches"                      ,
                    },
                    size = 40, -- 40 columns
                        -- specifies the height/width depending on position.
                    position = "right" 
                    -- position = "left",  --  "right", "top" or "bottom".
                },

                {
                    elements = { "repl"} ,
                    -- elements = { "repl", "console" } ,
                    size     = 3                   , -- 25% of total lines
                    position = "bottom"            ,
                },
            },

            floating = {
                max_height = 0.8, -- These can be integers or a float between 0 and 1.
                max_width = 0.9, 
                border = "single", -- Border style. Can be "single", "double" or "rounded"
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },

            windows = { indent = 1 },

            render = {
                -- integer or nil.
                max_type_length = nil,
                max_value_lines = 10, --  影响 format_value(value_start, value) 
            }
        }) 
    

        -- listeners
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end

            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

    -- dap-python
        require('dap-python').setup()
                            -- 或者直接改:
                                -- /home/wf/PL/py-debugAP/lua/dap-python.lua
                                -- pythonPath = opts.pythonPath,
        dap.configurations.python = {  -- a list of config
            {
            type       = 'python';  --  established the link to the adapter definition: `dap.adapters.python` 
            request    = 'launch';  -- 或者 attach
            name       = 'leo杰作';
            -- The first three options are required by nvim-dap

            -- Options below are for debugpy,
            --   -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program    = '${file}';    --   launch the current file
            console    = 'integratedTerminal';  --  The supported values are 一般还有: 
                                                    --  `internalConsole`,
                                                    --   and `externalTerminal`, 
            justMyCode =  false ;
            redirectOutput  = true ;
            -- python     = {"/home/wf/d/miniconda3/envs/t_pool3/bin/python3", "-W", "ignore"} ;
                         -- debugpy里好像说 这要求是个array, lua的array用 {xxxxx, yyyy}
            -- "pythonPath" is not valid if "python" is specified
            -- pythonPath = '~/d/miniconda3/envs/t_pool3/bin/python3' ,
                        -- todo:
                        -- $HOME/miniconda3/envs/$(cat $cache_X/conda_name)/bin/python3 

                        -- 或
                        -- pythonPath = function()
                        --     -- debugpy supports launching an application
                            --     with a different interpreter
                            --     then the one used to launch debugpy itself.
                        --     -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        --     
                        --     if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                        --       return cwd .. '/venv/bin/python'
                        --     elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                        --       return cwd .. '/.venv/bin/python'
                        --     else
                        --       return '/usr/bin/python'
                        --     end
                        --   end;
                        -- }, 
            },
        }  



        -- print('换了conda环境, 就得手动改dap-python的路径 ???')  
        --  然而, 又看到这个:
            -- The debugger will automatically pick-up another virtual environment
            -- if it is activated before neovim is started.

-- 新出, 先用coc-tabnine
-- require('tabnine').setup({
--     disable_auto_comment = true,
--     accept_keymap        = "<Tab>",
--     dismiss_keymap       = "<C-]>",
--     debounce_ms          = 300,
--     suggestion_color     = {gui = "#808080", cterm = 244},
--     execlude_filetypes   = {"TelescopePrompt"}
-- })
--

-- 启动nvim时报错
-- 用packer管理 才行?

-- 要用再开吧
-- require('bqf').setup({
    -- auto_enable        = true ,
    -- auto_resize_height = true ,-- highly recommended enable
    -- preview            = {
    --     win_height   = 12                                            ,
    --     win_vheight  = 12                                            ,
    --     delay_syntax = 80                                            ,
    --     border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'} ,
    --     show_title   = false,
    --     should_preview_cb = function(bufnr, qwinid)
    --         local ret     = true
    --         local bufname = vim.api.nvim_buf_get_name(bufnr)
    --         local fsize   = vim.fn.getfsize(bufname)
    --         if fsize > 100 * 1024 then
    --             -- skip file size greater than 100k
    --             ret = false
    --         elseif bufname:match('^fugitive://') then
    --             -- skip fugitive buffer
    --             ret = false
    --         end
    --         return ret
    --     end
    -- },
    -- -- make `drop` and `tab drop` to become preferred
    -- func_map = {
    --     drop        = 'o',
    --     openc       = 'O',
    --     split       = '<C-s>',
    --     tabdrop     = '<C-t>',
    --     -- set to empty string to disable
    --     tabc        = '',
    --     ptogglemode = 'z,',
    -- },
    -- filter = {
    --     fzf = {
    --         action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop'},
    --         extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
    --     }
    -- }
-- })


vim.filetype.add({
    extension = {
        ['crontab']  = 'crontab' ,
    },
})


