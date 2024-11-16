return {
  "siduck/showkeys",
  cmd = "ShowkeysToggle",
  opts = {
    exclude_modes = {"i"},
    maxkeys = 3,
    position = 'bottom-center',
    timeout = 1,
    -- more opts
  },
  keys = {
    {';ss', ':ShowkeysToggle<cr>', desc = 'ShowkeysToggle'}
  },
}
