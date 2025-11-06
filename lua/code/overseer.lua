return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerRun',
    'OverseerToggle',
    'OverseerBuild',
    'OverseerClose',
    'OverseerOpen',
  },
  opts = {
    templates = { 'make', 'shell', 'user.cpp_single_file', 'user.run_script' },
  },
}
