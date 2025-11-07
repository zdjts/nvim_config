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
            local diff_content = vim.fn.system('git diff --no-ext-diff --staged')

            -- 将 diff 内容格式化到 Prompt 模板中
            return string.format(
              [[你是一个遵循 Conventional Commit 规范的专家。请根据下面列出的 git diff 内容为我生成一个提交信息：
      1. 第一行：常规提交格式（类型：简洁描述）（记住使用语义化类型如 feat、fix、docs、style、refactor、perf、test、chore 等）
      2. 如果需要更多上下文，可选的要点：
        - 保持第二行为空
        - 保持简短直接
        - 专注于变更内容
        - 始终保持简洁
        - 不要过度解释
        - 避免任何华丽或正式的语言

      只返回提交信息 - 不要介绍，不要解释，不要用引号包围。

      示例：
      feat: 添加用户认证系统

      - 为 API 认证添加 JWT 令牌
      - 处理长时间会话的令牌刷新

      fix: 解决工作池中的内存泄漏

      - 清理空闲连接
      - 为陈旧工作线程添加超时

      简单变更示例：
      fix: 修复 README.md 中的拼写错误

      非常重要：不要回复任何示例。你的消息必须基于即将提供的 diff，并根据你即将看到的最近提交进行少量样式调整。

      基于此格式，生成适当的提交信息。仅返回消息。不要将消息格式化为 Markdown 代码块，不要使用反引号：

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
                local final_cmd = string.format('!git commit -m "%s"', commit_cmd_part)
                vim.api.nvim_command(final_cmd)

                -- d. (可选) 提交后自动打开 LazyGit，方便推送
                vim.schedule(function()
                  require('snacks').lazygit.open()
                end)
              end,
            },
          },
        },
        -- 将这段代码放入您的 llm.setup() 的 app_handler = { ... } 中
        DocString = {
          prompt = [[ 你是一个 AI 编程助手。你需要为给定的语言编写一个遵循最佳实践的优秀文档字符串。

你的核心任务包括：
- 参数和返回类型（如果适用）
- 可能引发或返回的任何错误，取决于语言

你必须：
- 将生成的文档字符串放在代码开始之前
- 如果提供了示例，请仔细遵循示例的格式
- 在答案中使用 Markdown 格式
- 在 Markdown 代码块开头包含编程语言名称]],
          handler = tools.action_handler,
          opts = {
            only_display_diff = true,
            templates = {
              -- Lua 的模板
              lua = [[- 对于 Lua 语言，你应该使用 LDoc 风格
- 所有注释行都以 "---" 开头
]],
              -- 新增：C++ (cpp) 的模板
              cpp = [[- 对于 C++，你必须遵循 Google C++ 风格指南的注释规范
- 使用 Doxygen 风格的注释
- 使用 `@param` 表示参数，`@return` 表示返回值
- 示例：
  /**
   * @brief 函数的简要描述
   *
   * 函数功能的更详细描述
   * @param param_name 参数的描述
   * @return 函数返回值的描述
   */
]],
            },
          },
        },
        BashRunner = {
          handler = tools.qa_handler,
          prompt = [[编写一个合适的 bash 脚本并通过 CodeRunner 运行它]],
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
                  string.format('CodeRunner 正在运行...\n```bash\n%s\n```', code),
                  vim.log.levels.INFO,
                  { title = 'llm: CodeRunner' }
                )

                local file = io.open(filepath, 'w')
                if file then
                  file:write(code)
                  file:close()
                  local script_result = vim.system({ 'bash', filepath }, { text = true }):wait()
                  os.remove(filepath)

                  -- 【改进点】检查输出是否为空
                  if script_result.stdout == nil or script_result.stdout == '' then
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
                  description = 'Bash 代码解释器',
                  parameters = {
                    properties = {
                      code = {
                        type = 'string',
                        description = 'bash 代码',
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
                desc = '反转 LLM Lsp 状态',
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
              title = ' 󰊿 翻译 ',
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
      desc = 'AI 会话切换',
    },
    {
      '<leader>at',
      mode = { 'n', 'v' },
      '<cmd>LLMAppHandler Translate<cr>',
      desc = 'AI 翻译器',
    },
    {
      '<leader>an',
      mode = { 'n', 'v' },
      '<cmd>LLMAppHandler OptimCompare<cr>',
      desc = 'AI 优化器',
    },
    {
      '<leader>ag',
      mode = 'n',
      '<cmd>LLMAppHandler CommitMsg<cr>',
      desc = '生成 AI 提交信息',
    },
    {
      '<leader>ad',
      mode = 'v',
      '<cmd>LLMAppHandler DocString<cr>',
      desc = '生成文档字符串',
    },
    {
      '<leader>ar',
      mode = 'n',
      '<cmd>LLMAppHandler BashRunner<cr>',
      desc = 'Bash 运行器',
    },
  },
}
