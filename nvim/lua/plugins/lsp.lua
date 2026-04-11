-- ============================================
-- LSP: mason.nvim + mason-lspconfig + nvim-lspconfig
-- ============================================
-- Mason installs language servers; mason-lspconfig wires them into
-- nvim-lspconfig with sensible defaults. Servers configured here cover the
-- languages from the user's request: python, go, terraform, kubernetes/yaml,
-- helm, plus the usual supporting cast (lua, bash, docker, json, ts).

return {
  -- Mason: package manager for LSPs / formatters / linters / DAPs
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- Core LSP client config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = {} }, -- LSP progress UI
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Diagnostics presentation
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      -- Buffer-local mappings, only when an LSP attaches
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition,      "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration,     "Go to declaration")
        map("n", "gr", vim.lsp.buf.references,      "References")
        map("n", "gi", vim.lsp.buf.implementation,  "Implementation")
        map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
        map("n", "K",  vim.lsp.buf.hover,           "Hover docs")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("n", "<leader>cr", vim.lsp.buf.rename,    "Rename symbol")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
      end

      -- Per-server overrides. Anything not listed here uses the default
      -- mason-lspconfig handler with our shared capabilities + on_attach.
      local servers = {
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
              semanticTokens = true,
            },
          },
        },

        -- Terraform / OpenTofu (tflint is configured as a linter in formatting.lua)
        terraformls = {
          filetypes = { "terraform", "terraform-vars", "tf" },
        },

        -- YAML — extended for Kubernetes via schemastore + kubernetes schema
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                -- Disable the built-in store; schemastore.nvim provides a richer one.
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas({
                extra = {
                  {
                    name = "Kubernetes 1.29",
                    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json",
                    fileMatch = {
                      "k8s/**/*.yaml", "k8s/**/*.yml",
                      "kubernetes/**/*.yaml", "kubernetes/**/*.yml",
                      "manifests/**/*.yaml", "manifests/**/*.yml",
                      "deploy/**/*.yaml", "deploy/**/*.yml",
                    },
                  },
                },
              }),
            },
          },
        },

        -- Helm charts
        helm_ls = {
          settings = {
            ["helm-ls"] = {
              yamlls = { path = "yaml-language-server" },
            },
          },
        },

        -- JSON with schemastore
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- Lua (for editing this very config)
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              diagnostics = { globals = { "vim" } },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },

        -- Bash
        bashls = {},

        -- Docker
        dockerls = {},
        docker_compose_language_service = {},

        -- TypeScript / JavaScript
        ts_ls = {},
        eslint = {},
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              capabilities,
              server_opts.capabilities or {}
            )
            server_opts.on_attach = on_attach
            lspconfig[server_name].setup(server_opts)
          end,
        },
      })
    end,
  },

  -- JSON / YAML schema catalog used by jsonls + yamlls above
  { "b0o/schemastore.nvim", lazy = true },
}
