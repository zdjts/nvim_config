return {
  'Kurama622/llm.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  cmd = { 'LLMSessionToggle', 'LLMSelectedTextHandler', 'LLMAppHandler' },
  config = function()
    require('llm.state').completion.enable = false -- [!code focus]
    local tools = require('llm.tools')
    require('llm').setup({
      url = 'https://api.siliconflow.cn/v1/chat/completions',
      model = 'Qwen/Qwen3-Coder-30B-A3B-Instruct',
      api_type = 'openai',
      max_tokens = 4096,
      temperature = 0.3,
      top_p = 0.7,
      keys = {
        ['Session:Close'] = { mode = 'n', key = { '<esc>', 'Q', 'q' } },
      },
      -- 所有的工具都应该放在 app_handler 这个 table 里面
      app_handler = {
        OptimCompare = {
          handler = tools.action_handler,
          opts = {},
        },
        -- 将这段代码放入您的 llm.setup() 的 app_handler = { ... } 中

        CommitMsg = {
          -- 1. 选择正确的处理器
          handler = tools.flexi_handler,

          -- 2. 动态生成 Prompt
          prompt = function()
            -- 获取暂存区的 diff 内容
            local diff_content =
              vim.fn.system('git diff --no-ext-diff --staged')

            -- 将 diff 内容格式化到 Prompt 模板中
            return string.format(
              [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
      1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)
      2. Optional bullet points if more context helps:
        - Keep the second line blank
        - Keep them short and direct
        - Focus on what changed
        - Always be terse
        - Don't overly explain
        - Drop any fluffy or formal language

      Return ONLY the commit message - no introduction, no explanation, no quotes around it.

      Examples:
      feat: add user auth system

      - Add JWT tokens for API auth
      - Handle token refresh for long sessions

      fix: resolve memory leak in worker pool

      - Clean up idle connections
      - Add timeout for stale workers

      Simple change example:
      fix: typo in README.md

      Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided, with a little bit of styling informed by the recent commits you're about to see.

      Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

      ```diff
      %s
      ```
      ]],
              diff_content
            )
          end,

          -- 3. 为工具定制选项
          opts = {
            -- 指定 AI 模型和 API Key
            -- 核心配置：上下文不来自视觉选择，而是来自上面的 prompt 函数
            apply_visual_selection = false,

            -- 自动聚焦到弹出的结果窗口
            enter_flexible_window = true,

            -- 配置窗口居中显示
            win_opts = {
              relative = 'editor',
              position = '50%',
            },

            -- 4. 定义接受操作：这是最精彩的部分！
            accept = {
              mapping = {
                mode = 'n',
                keys = '<cr>', -- 在结果窗口的普通模式下，按回车键触发
              },
              action = function()
                -- a. 获取 AI 生成的所有行（commit message）
                local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

                -- b. 巧妙地将多行 message 转换为多个 -m 参数
                -- 例如 ["feat: new", "body"] 会变成 "feat: new\" -m \"body"
                local commit_cmd_part = table.concat(contents, '" -m "')

                -- c. 构建并执行 git commit 命令
                local final_cmd =
                  string.format('!git commit -m "%s"', commit_cmd_part)
                vim.api.nvim_command(final_cmd)

                -- d. (可选) 提交后自动打开 LazyGit，方便推送
                vim.schedule(function()
                  vim.api.nvim_command('LazyGit')
                end)
              end,
            },
          },
        },
        -- 将这段代码放入您的 llm.setup() 的 app_handler = { ... } 中
        DocString = {
          prompt = [[ You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],
          handler = tools.action_handler,
          opts = {
            only_display_diff = true,
            templates = {
              -- Lua 的模板
              lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".
]],
              -- 新增：C++ (cpp) 的模板
              cpp = [[- For C++, you must follow the Google C++ Style Guide for comments.
- Use Doxygen-style comments.
- Use `@param` for parameters and `@return` for return values.
- Example:
  /**
   * @brief A brief description of the function.
   *
   * A more detailed description of what the function does.
   * @param param_name A description of the parameter.
   * @return A description of what the function returns.
   */
]],
            },
          },
        },
        BashRunner = {
          handler = tools.qa_handler,
          prompt = [[Write a suitable bash script and run it through CodeRunner]],
          opts = {
            enable_thinking = false,

            component_width = '60%',
            component_height = '50%',
            query = {
              title = '  CodeRunner ',
              hl = { link = 'Define' },
            },
            input_box_opts = {
              size = '15%',
              win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
              },
            },
            preview_box_opts = {
              size = '85%',
              win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
              },
            },
            functions_tbl = {
              CodeRunner = function(code)
                local filepath = '/tmp/script.sh'

                vim.notify(
                  string.format(
                    'CodeRunner is running...\n```bash\n%s\n```',
                    code
                  ),
                  vim.log.levels.INFO,
                  { title = 'llm: CodeRunner' }
                )

                local file = io.open(filepath, 'w')
                if file then
                  file:write(code)
                  file:close()
                  local script_result = vim
                    .system({ 'bash', filepath }, { text = true })
                    :wait()
                  os.remove(filepath)

                  -- 【改进点】检查输出是否为空
                  if
                    script_result.stdout == nil or script_result.stdout == ''
                  then
                    if script_result.stderr and script_result.stderr ~= '' then
                      return '脚本执行出错: ' .. script_result.stderr
                    else
                      return '脚本执行成功，但没有输出内容。'
                    end
                  else
                    return script_result.stdout
                  end
                else
                  return '创建脚本文件失败。'
                end
              end,
            },
            schema = {
              {
                type = 'function',
                ['function'] = {
                  name = 'CodeRunner',
                  description = 'Bash code interpreter',
                  parameters = {
                    properties = {
                      code = {
                        type = 'string',
                        description = 'bash code',
                      },
                    },
                    required = { 'code' },
                    type = 'object',
                  },
                },
              },
            },
          },
        },
        Completion = {
          handler = tools.completion_handler,
          opts = {
            -------------------------------------------------
            ---                   ollama
            -------------------------------------------------
            -- url = 'http://localhost:11434/v1/completions',
            -- model = 'qwen2.5-coder:1.5b',
            -- api_type = 'ollama',
            ------------------- end ollama ------------------

            -------------------------------------------------
            ---                  deepseek
            -------------------------------------------------
            -- url = "https://api.deepseek.com/beta/completions",
            -- model = "deepseek-chat",
            -- api_type = "deepseek",
            -- fetch_key = function()
            --   return "your api key"
            -- end,
            ------------------ end deepseek -----------------
            -------------------------------------------------
            ---                 siliconflow
            -------------------------------------------------
            url = 'https://api.siliconflow.cn/v1/completions',
            model = 'Qwen/Qwen2.5-Coder-7B-Instruct',
            api_type = 'openai',
            ------------------ end siliconflow -----------------

            -------------------------------------------------
            ---                  codeium
            ---    dependency: "Exafunction/codeium.nvim"
            -------------------------------------------------
            -- api_type = "codeium",
            ------------------ end codeium ------------------

            n_completions = 3,
            context_window = 512,
            max_tokens = 256,

            -- A mapping of filetype to true or false, to enable completion.
            filetypes = { sh = false },

            -- Whether to enable completion of not for filetypes not specifically listed above.
            default_filetype_enabled = true,

            auto_trigger = false,

            -- just trigger by { "@", ".", "(", "[", ":", " " } for `style = "nvim-cmp"`
            only_trigger_by_keywords = true,

            style = 'virtual_text', -- nvim-cmp or blink.cmp

            timeout = 10, -- max request time

            -- only send the request every x milliseconds, use 0 to disable throttle.
            throttle = 1000,
            -- debounce the request in x milliseconds, set to 0 to disable debounce
            debounce = 400,

            --------------------------------
            ---   just for virtual_text
            --------------------------------
            keymap = {
              toggle = {
                mode = 'n',
                keys = '<leader>cp',
                desc = 'reverse LLM Lsp status',
              },
              virtual_text = {
                accept = {
                  mode = 'i',
                  keys = '<A-a>',
                },
                next = {
                  mode = 'i',
                  keys = '<A-n>',
                },
                prev = {
                  mode = 'i',
                  keys = '<A-p>',
                },
                toggle = {
                  mode = 'n',
                  keys = '<leader>cp',
                },
              },
            },
          },
        },
        Translate = {
          handler = tools.qa_handler,
          opts = {
            component_width = '60%',
            component_height = '50%',
            query = {
              title = ' 󰊿 Trans ',
              hl = { link = 'Define' },
            },
            input_box_opts = {
              size = '15%',
              win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
              },
            },
            preview_box_opts = {
              size = '85%',
              win_options = {
                winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
              },
            },
          },
        },
      },
    })
  end,
  keys = {
    {
      '<leader>ac',
      mode = 'n',
      '<cmd>LLMSessionToggle<cr>',
      desc = 'AI Session Toggle',
    },
    {
      '<leader>at',
      mode = { 'n', 'v' },
      '<cmd>LLMAppHandler Translate<cr>',
      desc = 'AI Translator',
    },
    {
      '<leader>an',
      mode = { 'n', 'v' },
      '<cmd>LLMAppHandler OptimCompare<cr>',
      desc = 'AI Optimizer',
    },
    {
      '<leader>ag',
      mode = 'n',
      '<cmd>LLMAppHandler CommitMsg<cr>',
      desc = ' Generate AI Commit Message',
    },
    {
      '<leader>ad',
      mode = 'v',
      '<cmd>LLMAppHandler DocString<cr>',
      desc = ' Generate a Docstring',
    },
    {
      '<leader>ar',
      mode = 'n',
      '<cmd>LLMAppHandler BashRunner<cr>',
      desc = ' BashRunner',
    },
  },
}
