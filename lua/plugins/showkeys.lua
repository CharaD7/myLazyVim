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
    {';sk', ':ShowkeysToggle<cr>', desc = 'ShowkeysToggle'}
  },
}
