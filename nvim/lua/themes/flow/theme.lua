local M = {}

M.palette = {
	-- Backgrounds
	background         = "#0F1219",
	background_dark    = "#0b0e14",
	background_lighter = "#161b24",
	element_bg         = "#0F1219",
	element_active     = "#2c313a",
	element_selected   = "#2c313a",
	popup_bg           = "#0F1219",

	-- Foregrounds
	bright_foreground  = "#d7dae0",
	foreground         = "#abb2bf",
	muted_foreground   = "#697082",
	light_gray         = "#697082",
	gray               = "#3e4452",

	-- Borders / UI chrome
	border             = "#23283a",
	border_focused     = "#495162",

	-- Selections
	selection_bg       = "#3b4559",
	selection_fg       = "#d7dae0",

	-- Syntax
	red                = "#e06c75",
	bright_red         = "#ff616e",
	green              = "#98c379",
	bright_green       = "#a5e075",
	yellow             = "#e5c07b",
	bright_yellow      = "#ebc275",
	blue               = "#61afef",
	bright_blue        = "#5ab0f6",
	purple             = "#c678dd",
	bright_purple      = "#de73ff",
	cyan               = "#56b6c2",
	bright_cyan        = "#4dbdcb",
	gold               = "#d19a66",

	-- Diagnostics
	error              = "#ff4757",
	warning            = "#e5c07b",
	info               = "#5ab0f6",
	hint               = "#abb2bf",

	-- Diff
	diff_add           = "#3b5135",
	diff_change        = "#4e3e30",
	diff_delete        = "#572a32",

	-- Indent guides
	indent_guide        = "#1e242e",
	indent_guide_active = "#3e4452",

	-- Terminal (16 colors)
	t_black        = "#3f4451",
	t_bright_black = "#4f5666",
	t_white        = "#d7dae0",
	t_bright_white = "#e6e6e6",
}

function M.setup()
	local p = M.palette
	local set = vim.api.nvim_set_hl

	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
	vim.g.colors_name = "flow"
	vim.o.termguicolors = true

	-- ── Editor UI ──────────────────────────────────────────────────────────
	set(0, "Normal",        { fg = p.bright_foreground, bg = p.background })
	set(0, "NormalNC",      { fg = p.bright_foreground, bg = p.background })
	set(0, "NormalFloat",   { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "FloatBorder",   { fg = p.border,            bg = p.background_dark })
	set(0, "FloatTitle",    { fg = p.bright_blue,       bold = true })

	set(0, "Cursor",        { fg = p.background,        bg = p.bright_foreground })
	set(0, "CursorLine",    {})
	set(0, "CursorLineNr",  {})
	set(0, "LineNr",        { fg = p.light_gray })
	set(0, "SignColumn",    { bg = "none" })
	set(0, "ColorColumn",   { bg = p.background_lighter })
	set(0, "FoldColumn",    { fg = p.light_gray })
	set(0, "Folded",        { fg = p.light_gray, bg = p.background_lighter })
	set(0, "EndOfBuffer",   { fg = p.gray })

	set(0, "VertSplit",     { fg = p.border })
	set(0, "WinSeparator",  { fg = p.border })

	set(0, "Visual",        { fg = p.selection_fg, bg = p.selection_bg })
	set(0, "VisualNOS",     { fg = p.selection_fg, bg = p.selection_bg })
	set(0, "Search",        { fg = p.background,   bg = p.bright_blue })
	set(0, "IncSearch",     { fg = p.background,   bg = p.bright_yellow })
	set(0, "CurSearch",     { fg = p.background,   bg = p.bright_purple })
	set(0, "MatchParen",    { fg = p.bright_blue,  underline = true })

	set(0, "Pmenu",         { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "PmenuSel",      { fg = p.bright_foreground, bg = p.element_active, bold = true })
	set(0, "PmenuSbar",     { bg = p.background_dark })
	set(0, "PmenuThumb",    { bg = p.gray })

	set(0, "StatusLine",    { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "StatusLineNC",  { fg = p.light_gray })
	set(0, "WinBar",        { fg = p.bright_foreground })
	set(0, "WinBarNC",      { fg = p.light_gray })
	set(0, "TabLine",       { fg = p.light_gray,        bg = p.background_dark })
	set(0, "TabLineFill",   { bg = p.background })
	set(0, "TabLineSel",    { fg = p.bright_foreground, bg = p.element_active })

	set(0, "WildMenu",      { fg = p.bright_foreground, bg = p.element_active })
	set(0, "Directory",     { fg = p.blue })
	set(0, "Title",         { fg = p.bright_blue, bold = true })
	set(0, "NonText",       { fg = p.gray })
	set(0, "SpecialKey",    { fg = p.gray })
	set(0, "TermCursor",    { bg = p.bright_foreground })
	set(0, "TermCursorNC",  { bg = p.light_gray })

	-- ── Syntax ─────────────────────────────────────────────────────────────
	set(0, "Comment",       { fg = p.light_gray, italic = true })
	set(0, "Constant",      { fg = p.yellow,     bold = true })
	set(0, "String",        { fg = p.green })
	set(0, "Character",     { fg = p.green })
	set(0, "Number",        { fg = p.yellow })
	set(0, "Boolean",       { fg = p.yellow })
	set(0, "Float",         { fg = p.yellow })
	set(0, "Identifier",    { fg = p.foreground })
	set(0, "Function",      { fg = p.blue })
	set(0, "Statement",     { fg = p.purple, bold = true })
	set(0, "Conditional",   { fg = p.purple, italic = true })
	set(0, "Repeat",        { fg = p.purple, italic = true })
	set(0, "Label",         { fg = p.purple })
	set(0, "Operator",      { fg = p.bright_foreground })
	set(0, "Keyword",       { fg = p.purple, bold = true })
	set(0, "Exception",     { fg = p.purple })
	set(0, "PreProc",       { fg = p.purple })
	set(0, "Include",       { fg = p.purple })
	set(0, "Define",        { fg = p.purple })
	set(0, "Macro",         { fg = p.purple })
	set(0, "PreCondit",     { fg = p.purple })
	set(0, "Type",          { fg = p.yellow, bold = true })
	set(0, "StorageClass",  { fg = p.yellow })
	set(0, "Structure",     { fg = p.yellow })
	set(0, "Typedef",       { fg = p.yellow })
	set(0, "Special",       { fg = p.cyan })
	set(0, "SpecialChar",   { fg = p.cyan, bold = true })
	set(0, "Tag",           { fg = p.red })
	set(0, "Delimiter",     { fg = p.bright_foreground })
	set(0, "SpecialComment",{ fg = p.light_gray, italic = true })
	set(0, "Debug",         { fg = p.red })
	set(0, "Underlined",    { underline = true })
	set(0, "Error",         { fg = p.error })
	set(0, "Todo",          { fg = p.purple, bold = true })

	-- ── Diff ───────────────────────────────────────────────────────────────
	set(0, "DiffAdd",       { bg = p.diff_add })
	set(0, "DiffChange",    { bg = p.diff_change })
	set(0, "DiffDelete",    { bg = p.diff_delete })
	set(0, "DiffText",      { bg = p.diff_change, bold = true })

	-- ── Diagnostics ────────────────────────────────────────────────────────
	set(0, "DiagnosticError",              { fg = p.error })
	set(0, "DiagnosticWarn",               { fg = p.warning })
	set(0, "DiagnosticInfo",               { fg = p.info })
	set(0, "DiagnosticHint",               { fg = p.hint })
	set(0, "DiagnosticUnderlineError",     { undercurl = true, sp = p.error })
	set(0, "DiagnosticUnderlineWarn",      { undercurl = true, sp = p.warning })
	set(0, "DiagnosticUnderlineInfo",      { undercurl = true, sp = p.info })
	set(0, "DiagnosticUnderlineHint",      { undercurl = true, sp = p.hint })
	set(0, "DiagnosticVirtualTextError",   { fg = p.error })
	set(0, "DiagnosticVirtualTextWarn",    { fg = p.warning })
	set(0, "DiagnosticVirtualTextInfo",    { fg = p.info })
	set(0, "DiagnosticVirtualTextHint",    { fg = p.hint })
	set(0, "DiagnosticSignError",          { fg = p.error })
	set(0, "DiagnosticSignWarn",           { fg = p.warning })
	set(0, "DiagnosticSignInfo",           { fg = p.info })
	set(0, "DiagnosticSignHint",           { fg = p.hint })

	-- ── LSP ────────────────────────────────────────────────────────────────
	set(0, "LspReferenceText",             { bg = p.element_active })
	set(0, "LspReferenceRead",             { bg = p.element_active })
	set(0, "LspReferenceWrite",            { bg = p.element_selected })
	set(0, "LspSignatureActiveParameter",  { fg = p.bright_yellow, bold = true, italic = true })
	set(0, "LspCodeLens",                  { fg = p.light_gray, italic = true })
	set(0, "LspInlayHint",                 { fg = p.light_gray, italic = true })

	-- ── Treesitter ─────────────────────────────────────────────────────────
	set(0, "@comment",                     { fg = p.light_gray,       italic = true })
	set(0, "@string",                      { fg = p.green })
	set(0, "@string.escape",               { fg = p.cyan,             bold = true })
	set(0, "@string.special",              { fg = p.cyan })
	set(0, "@character",                   { fg = p.green })
	set(0, "@boolean",                     { fg = p.yellow })
	set(0, "@number",                      { fg = p.yellow })
	set(0, "@float",                       { fg = p.yellow })
	set(0, "@function",                    { fg = p.blue })
	set(0, "@function.builtin",            { fg = p.bright_blue })
	set(0, "@function.call",               { fg = p.blue })
	set(0, "@function.macro",              { fg = p.purple })
	set(0, "@function.method",             { fg = p.blue })
	set(0, "@function.method.call",        { fg = p.blue })
	set(0, "@constructor",                 { fg = p.red,              bold = true })
	set(0, "@variable",                    { fg = p.bright_foreground })
	set(0, "@variable.builtin",            { fg = p.yellow,           italic = true })
	set(0, "@variable.parameter",          { fg = p.bright_foreground, italic = true })
	set(0, "@variable.member",             { fg = p.red })
	set(0, "@constant",                    { fg = p.yellow,           bold = true })
	set(0, "@constant.builtin",            { fg = p.yellow,           bold = true })
	set(0, "@constant.macro",              { fg = p.yellow })
	set(0, "@keyword",                     { fg = p.purple,           bold = true })
	set(0, "@keyword.function",            { fg = p.purple,           bold = true })
	set(0, "@keyword.operator",            { fg = p.bright_foreground })
	set(0, "@keyword.return",              { fg = p.purple,           bold = true })
	set(0, "@keyword.import",              { fg = p.purple })
	set(0, "@keyword.storage",             { fg = p.purple })
	set(0, "@keyword.repeat",              { fg = p.purple,           italic = true })
	set(0, "@keyword.conditional",         { fg = p.purple,           italic = true })
	set(0, "@keyword.conditional.ternary", { fg = p.purple,           italic = true })
	set(0, "@keyword.exception",           { fg = p.purple })
	set(0, "@keyword.directive",           { fg = p.purple })
	set(0, "@operator",                    { fg = p.bright_foreground })
	set(0, "@type",                        { fg = p.yellow,           bold = true })
	set(0, "@type.builtin",                { fg = p.yellow,           italic = true })
	set(0, "@type.definition",             { fg = p.yellow,           bold = true })
	set(0, "@attribute",                   { fg = p.gold })
	set(0, "@property",                    { fg = p.red })
	set(0, "@module",                      { fg = p.yellow })
	set(0, "@label",                       { fg = p.purple })
	set(0, "@tag",                         { fg = p.red })
	set(0, "@tag.attribute",               { fg = p.gold })
	set(0, "@tag.delimiter",               { fg = p.bright_foreground })

	-- ── LSP semantic tokens ────────────────────────────────────────────────
	set(0, "@lsp.type.class",         { link = "@type" })
	set(0, "@lsp.type.enum",          { link = "@type" })
	set(0, "@lsp.type.enumMember",    { link = "@constant" })
	set(0, "@lsp.type.function",      { link = "@function" })
	set(0, "@lsp.type.interface",     { fg = p.yellow, italic = true })
	set(0, "@lsp.type.macro",         { link = "Macro" })
	set(0, "@lsp.type.method",        { link = "@function.method" })
	set(0, "@lsp.type.namespace",     { link = "@module" })
	set(0, "@lsp.type.parameter",     { link = "@variable.parameter" })
	set(0, "@lsp.type.property",      { link = "@property" })
	set(0, "@lsp.type.struct",        { link = "@type" })
	set(0, "@lsp.type.type",          { fg = p.bright_yellow, bold = true })
	set(0, "@lsp.type.variable",      { link = "@variable" })
	set(0, "@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
	set(0, "@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })

	-- ── Indent guides (ibl) ────────────────────────────────────────────────
	set(0, "IblIndent", { fg = p.indent_guide })
	set(0, "IblScope",  { fg = p.indent_guide_active })

	-- ── Git signs ──────────────────────────────────────────────────────────
	set(0, "GitSignsAdd",    { fg = p.bright_green })
	set(0, "GitSignsChange", { fg = p.bright_yellow })
	set(0, "GitSignsDelete", { fg = p.bright_red })

	-- ── Telescope ──────────────────────────────────────────────────────────
	set(0, "TelescopeNormal",        { fg = p.bright_foreground, bg = p.popup_bg })
	set(0, "TelescopeBorder",        { fg = p.border,            bg = p.popup_bg })
	set(0, "TelescopePromptNormal",  { fg = p.bright_foreground, bg = p.element_active })
	set(0, "TelescopePromptBorder",  { fg = p.border_focused,    bg = p.element_active })
	set(0, "TelescopePromptTitle",   { fg = p.popup_bg,          bg = p.bright_blue, bold = true })
	set(0, "TelescopePromptPrefix",  { fg = p.bright_blue })
	set(0, "TelescopeResultsTitle",  { fg = p.popup_bg,          bg = p.green, bold = true })
	set(0, "TelescopePreviewTitle",  { fg = p.popup_bg,          bg = p.purple, bold = true })
	set(0, "TelescopeSelection",     { fg = p.bright_foreground, bg = p.element_selected })
	set(0, "TelescopeMatching",      { fg = p.bright_blue,       bold = true })
	set(0, "TelescopeSelectionCaret",{ fg = p.bright_blue })

	-- ── Which-key ──────────────────────────────────────────────────────────
	set(0, "WhichKey",          { fg = p.bright_purple, bold = true })
	set(0, "WhichKeyGroup",     { fg = p.bright_blue })
	set(0, "WhichKeySeparator", { fg = p.light_gray })
	set(0, "WhichKeyDesc",      { fg = p.bright_foreground })
	set(0, "WhichKeyFloat",     { bg = p.element_bg })
	set(0, "WhichKeyBorder",    { fg = p.border, bg = p.element_bg })

	-- ── nvim-cmp ───────────────────────────────────────────────────────────
	set(0, "CmpItemAbbr",           { fg = p.bright_foreground })
	set(0, "CmpItemAbbrMatch",      { fg = p.bright_blue, bold = true })
	set(0, "CmpItemAbbrMatchFuzzy", { fg = p.bright_blue })
	set(0, "CmpItemKind",           { fg = p.light_gray })
	set(0, "CmpItemMenu",           { fg = p.light_gray })

	-- ── Terminal colors ────────────────────────────────────────────────────
	vim.g.terminal_color_0  = p.t_black
	vim.g.terminal_color_1  = p.red
	vim.g.terminal_color_2  = p.green
	vim.g.terminal_color_3  = p.yellow
	vim.g.terminal_color_4  = p.blue
	vim.g.terminal_color_5  = p.purple
	vim.g.terminal_color_6  = p.cyan
	vim.g.terminal_color_7  = p.t_white
	vim.g.terminal_color_8  = p.t_bright_black
	vim.g.terminal_color_9  = p.bright_red
	vim.g.terminal_color_10 = p.bright_green
	vim.g.terminal_color_11 = p.bright_yellow
	vim.g.terminal_color_12 = p.bright_blue
	vim.g.terminal_color_13 = p.bright_purple
	vim.g.terminal_color_14 = p.bright_cyan
	vim.g.terminal_color_15 = p.t_bright_white
end

return M
