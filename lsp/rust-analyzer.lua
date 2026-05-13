-- 1. 定义：逐级向上查找并解析 TOML 的函数
local function get_local_toml_settings()
    -- 查找文件名
    local names = { '.rust-analyzer.toml', 'rust-analyzer.toml' }
    local config_file = vim.fs.find(names, {
        path = vim.fn.expand('%:p:h'),
        upward = true,
        stop = vim.loop.os_homedir(),
    })[1]

    if not config_file then
        return {}
    end

    -- 【关键点】：由于 Lua 不支持 TOML，这里调用系统命令 python3 或 yq 将其转为 JSON
    -- 这是一个“黑盒”转换，确保你的配置完全由文件内容决定
    local cmd = string.format(
        "python3 -c \"import tomllib, json; print(json.dumps(tomllib.load(open('%s', 'rb'))))\"",
        config_file
    )
    -- print(cmd)
    local handle = io.popen(cmd)
    if not handle then
        return {}
    end

    local result = handle:read('*a')
    handle:close()

    local ok, decoded = pcall(vim.json.decode, result)
    if ok and decoded then
        -- 如果你的 TOML 里直接写 [completion]，转换后需要包一层 rust-analyzer
        return { ['rust-analyzer'] = decoded }
    end
    return {}
end

-- 2. 你原有的默认配置（作为保底）
local my_base_settings = {
    ['rust-analyzer'] = {
        cachePriming = { enable = true },
        imports = {
            granularity = 'module',
            prefix = 'self',
        },
        procMacro = { enable = true },
        checkOnSave = {
            enable = true,
            command = 'check',
            allTargets = false,
        },
        inlayHints = { enable = true },
    },
}

-- 3. 核心合并逻辑：本地文件 > 默认设置
-- 这里实现了“由文件决定行为”
local local_file_settings = get_local_toml_settings()
local final_settings = vim.tbl_deep_extend('force', my_base_settings, local_file_settings)

-- 4. 返回最终配置
return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    settings = final_settings,

    -- 物理压制：如果文件里说要禁用补全，这里确保客户端也不去触发
    -- on_attach = function(client, bufnr)
    --     -- 检查合并后的配置，看是否要把补全能力彻底关掉
    --     local ra_cfg = final_settings['rust-analyzer']
    --     if ra_cfg and ra_cfg.completion and ra_cfg.completion.limit == 0 then
    --         if client.server_capabilities.completionProvider then
    --             client.server_capabilities.completionProvider.triggerCharacters = {}
    --             -- 如果你真想一点补全都不想要，甚至可以设为 nil
    --             -- client.server_capabilities.completionProvider = nil
    --         end
    --     end
    -- end,
}
