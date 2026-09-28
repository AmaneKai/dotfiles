return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local mason_path   = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    local workspace_dir = vim.fn.stdpath("cache")
      .. "/jdtls-workspace/"
      .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local launcher_jar = vim.fn.glob(
      mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
    )

    local os_config = "config_linux"
    if vim.fn.has("mac") == 1 then
      os_config = "config_mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "config_win"
    end

    local cmd = {
      "java",
      "-javaagent:" .. mason_path .. "/lombok.jar",
      "-Xmx2G",
      "-XX:+UseG1GC",
      "-jar", launcher_jar,
      "-configuration", mason_path .. "/" .. os_config,
      "-data", workspace_dir,
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED",
      "--add-opens", "java.base/java.io=ALL-UNNAMED",
      "--add-opens", "java.base/java.util.concurrent=ALL-UNNAMED",
    }

    require("jdtls").start_or_attach({
      cmd          = cmd,
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      root_dir     = vim.fs.dirname(
        vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
      ),
      settings = {
        java = {
          signatureHelp    = { enabled = true },
          contentProvider  = { preferred = "fernflower" },
          format           = { enabled = true },
          autobuild        = { enabled = false },
        },
      },
      on_attach = function(_, bufnr)
        local opts = { silent = true, buffer = bufnr }

        vim.keymap.set("n", "<leader>jw", function()
          vim.fn.delete(workspace_dir, "rf")
          vim.cmd("JdtlsRestart")
          vim.notify("JDTLS: workspace wiped & restarted", vim.log.levels.INFO)
        end, { desc = "[J]dtls [W]ipe cache", buffer = bufnr })

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer   = bufnr,
          callback = function() vim.lsp.buf.format({ async = false }) end,
        })
      end,
    })
  end,
}
