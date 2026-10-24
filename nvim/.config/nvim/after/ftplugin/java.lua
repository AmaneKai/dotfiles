local ok, jdtls = pcall(require, "jdtls")
if not ok then return end

local root = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", "mvnw", "gradlew", ".git" })
if not root then return end

-- one persistent workspace per project so the index is reused between sessions
local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root) .. "_" .. vim.fn.sha256(root):sub(1, 8)

local cmd = {
  "jdtls",
  "-data", workspace,
  "--jvm-arg=-Xms1g",
  "--jvm-arg=-Xmx4g",
  "--jvm-arg=-XX:+UseParallelGC",
  "--jvm-arg=-XX:+UseStringDeduplication",
}

-- optional: drop lombok.jar here if a project needs it
local lombok = vim.fn.expand("~/.local/share/lombok/lombok.jar")
if vim.uv.fs_stat(lombok) then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok)
end

jdtls.start_or_attach({
  cmd = cmd,
  root_dir = root,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    java = {
      autobuild = { enabled = false },
      signatureHelp = { enabled = false },
      references = { includeDecompiledSources = false },
      contentProvider = { preferred = nil },
      import = {
        exclusions = {
          "**/node_modules/**",
          "**/.metadata/**",
          "**/archetype-resources/**",
          "**/META-INF/maven/**",
          "**/target/**",
          "**/build/**",
          "**/.gradle/**",
        },
      },
      completion = { maxResults = 50 },
    },
  },
  init_options = { bundles = {} },
})
