-- ============================================
-- Formatting & linting (conform.nvim + nvim-lint)
-- ============================================
-- Keeps formatters/linters separate from LSPs so we don't depend on every
-- language server's built-in formatter. Mason installs the underlying tools.

return {
  -- Ensure CLI tools are present via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",          -- lua
        "black",           -- python
        "isort",           -- python imports
        "gofumpt",         -- go
        "goimports",       -- go imports
        "prettier",        -- js/ts/json/yaml/md
        "shfmt",           -- shell
        "terraform",       -- terraform fmt comes with terraform itself, but ok
        -- Linters
        "shellcheck",      -- shell
        "hadolint",        -- dockerfile
        "tflint",          -- terraform
        "yamllint",        -- yaml
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- conform.nvim — format on save
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cF",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format (conform)",
      },
    },
    opts = {
      formatters_by_ft = {
        lua          = { "stylua" },
        python       = { "isort", "black" },
        go           = { "goimports", "gofumpt" },
        terraform    = { "terraform_fmt" },
        tf           = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        yaml         = { "prettier" },
        json         = { "prettier" },
        jsonc        = { "prettier" },
        markdown     = { "prettier" },
        javascript   = { "prettier" },
        typescript   = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        sh           = { "shfmt" },
        bash         = { "shfmt" },
        zsh          = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Allow disabling with :FormatDisable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1500, lsp_fallback = true }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable autoformat-on-save", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable autoformat-on-save" })
    end,
  },

  -- nvim-lint — run linters on save / read
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh         = { "shellcheck" },
        bash       = { "shellcheck" },
        dockerfile = { "hadolint" },
        terraform  = { "tflint" },
        yaml       = { "yamllint" },
      }

      -- Only run linters whose CLI is actually installed. This avoids ENOENT
      -- spam on a fresh install before mason-tool-installer has caught up.
      local function lint_available()
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft] or {}
        local available = {}
        for _, name in ipairs(linters) do
          local linter = lint.linters[name]
          local cmd = type(linter) == "table" and linter.cmd or nil
          if cmd and vim.fn.executable(cmd) == 1 then
            table.insert(available, name)
          end
        end
        if #available > 0 then
          lint.try_lint(available)
        end
      end

      local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = lint_available,
      })
    end,
  },
}
