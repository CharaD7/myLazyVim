return {
  'dccsillag/magma-nvim',
  cmd = 'UpdateRemotePlugins',
  config = function()
    require('magma-nvim').setup { installation_method = 'pip' }
  end
}
