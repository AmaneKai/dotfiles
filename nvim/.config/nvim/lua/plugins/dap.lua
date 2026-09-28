local ADAPTERS_DIR = vim.fn.stdpath("data")
local JS_DEBUG_SERVER = ADAPTERS_DIR .. "/js-debug/src/dapDebugServer.js"
local DEBUGPY_VENV_PYTHON = ADAPTERS_DIR .. "/debugpy/bin/python"

local function prompt_for_file(prompt, start_dir)
  return function()
    return vim.fn.input(prompt, start_dir or (vim.fn.getcwd() .. "/"), "file")
  end
end

local function launch_program(adapter, overrides)
  return vim.tbl_extend("force", {
    name    = "Launch program",
    type    = adapter,
    request = "launch",
    program = prompt_for_file("Program: "),
    cwd     = "${workspaceFolder}",
  }, overrides or {})
end

local function use_for_filetypes(dap, filetypes, configurations)
  for _, filetype in ipairs(filetypes) do
    dap.configurations[filetype] = configurations
  end
end

local function setup_gdb(dap)
  dap.adapters.gdb = {
    type    = "executable",
    command = "gdb",
    args    = { "--interpreter=dap", "--eval-command", "set print pretty on" },
  }
  use_for_filetypes(dap, { "c", "cpp", "rust" }, {
    launch_program("gdb", { stopAtBeginningOfMainSubprogram = false }),
  })
end

local function setup_netcoredbg(dap)
  dap.adapters.coreclr = {
    type    = "executable",
    command = "netcoredbg",
    args    = { "--interpreter=vscode" },
  }
  use_for_filetypes(dap, { "cs" }, {
    launch_program("coreclr", { program = prompt_for_file("Program (.dll): ", vim.fn.getcwd() .. "/bin/Debug/") }),
  })
end

local function setup_js_debug(dap)
  dap.adapters["pwa-node"] = {
    type       = "server",
    host       = "localhost",
    port       = "${port}",
    executable = { command = "node", args = { JS_DEBUG_SERVER, "${port}" } },
  }
  use_for_filetypes(dap, { "javascript", "typescript", "javascriptreact", "typescriptreact" }, {
    { name = "Launch current file", type = "pwa-node", request = "launch", program = "${file}", cwd = "${workspaceFolder}" },
    { name = "Attach to process", type = "pwa-node", request = "attach", processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
  })
end

local function python_with_debugpy()
  return vim.fn.executable(DEBUGPY_VENV_PYTHON) == 1 and DEBUGPY_VENV_PYTHON or "python3"
end

local function open_ui_while_debugging(dap, dapui)
  for _, event in ipairs({ "attach", "launch" }) do
    dap.listeners.before[event].dapui = dapui.open
  end
  for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.before[event].dapui = dapui.close
  end
end

local function dap_action(method)
  return function() require("dap")[method]() end
end

local keys = {
  { "<leader>b",  dap_action("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
  { "<leader>B",  function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Debug: conditional breakpoint" },
  { "<leader>cc", dap_action("continue"),          desc = "Debug: start or continue" },
  { "<leader>cn", dap_action("step_over"),         desc = "Debug: step over" },
  { "<leader>ci", dap_action("step_into"),         desc = "Debug: step into" },
  { "<leader>co", dap_action("step_out"),          desc = "Debug: step out" },
  { "<leader>cl", dap_action("run_last"),          desc = "Debug: run last" },
  { "<leader>cq", dap_action("terminate"),         desc = "Debug: stop" },
  { "<leader>cr", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
  { "<leader>cu", function() require("dapui").toggle() end,    desc = "Debug: toggle UI" },
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = keys,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      open_ui_while_debugging(dap, dapui)

      setup_gdb(dap)
      setup_netcoredbg(dap)
      setup_js_debug(dap)
      require("dap-python").setup(python_with_debugpy())
      require("dap-go").setup()
    end,
  },
}
