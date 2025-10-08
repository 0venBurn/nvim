return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")
    
    -- Get the jdtls installation path from Mason
    local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

    local config = {
      cmd = {
        "/opt/homebrew/opt/openjdk@21/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration", jdtls_install .. "/config_mac", -- Use config_linux or config_win on other OS
        "-data", vim.fn.expand("~/.cache/jdtls/workspace") .. vim.fn.getcwd(),
      },
      root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
        }
      },
      init_options = {
        bundles = {}
      },
    }

    jdtls.start_or_attach(config)
  end,
}
