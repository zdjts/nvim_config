-- Merge project rust-analyzer.toml at client start (not at module load).

local function get_local_toml_settings(root)
    local names = { '.rust-analyzer.toml', 'rust-analyzer.toml' }
    local config_file = vim.fs.find(names, {
        path = root,
        upward = true,
        stop = vim.uv.os_homedir(),
    })[1]

    if not config_file then
        return {}
    end

    local script = [[
import json, sys, tomllib
with open(sys.argv[1], 'rb') as f:
    print(json.dumps(tomllib.load(f)))
]]
    local result = vim.system({ 'python3', '-c', script, config_file }, { text = true }):wait()
    if result.code ~= 0 or not result.stdout or result.stdout == '' then
        return {}
    end

    local ok, decoded = pcall(vim.json.decode, result.stdout)
    if ok and decoded then
        return { ['rust-analyzer'] = decoded }
    end
    return {}
end

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

---@type vim.lsp.Config
return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    settings = my_base_settings,
    before_init = function(_, config)
        local extra = get_local_toml_settings(config.root_dir or vim.fn.getcwd())
        config.settings = vim.tbl_deep_extend('force', config.settings or {}, extra)
    end,
}
