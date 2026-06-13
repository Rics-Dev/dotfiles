-- ============================================================
-- Flow — Neovim Colorscheme
-- ============================================================
-- Design principles:
--   • Luminance hierarchy: bg → syntax → fg (nothing fights the cursor)
--   • Purple = control flow / keywords  (highest weight, draws the eye)
--   • Blue   = functions / methods      (action, callable things)
--   • Yellow = types / constants        (data shape, bold for visibility)
--   • Red    = struct fields / tags     (ownership markers)
--   • Green  = strings / success        (safe, literal data)
--   • Cyan   = specials / builtins      (language magic)
--   • Gold   = attributes / decorators  (meta-level)
--   • Gray   = comments (italic, visually subordinate)
-- ============================================================

local M = {}

M.palette = {
	-- ── Backgrounds ──────────────────────────────────────────────────────
	-- Carefully stepped: each level is distinct but never distracting
	background         = "#0F1219",   -- primary canvas
	background_dark    = "#090c11",   -- popups, statusline, darker panels
	background_darker  = "#060810",   -- deepest chrome (scrollbar tracks)
	background_lighter = "#141820",   -- subtle cursorline tint

	-- ── UI chrome ────────────────────────────────────────────────────────
	element_bg         = "#0F1219",
	element_active     = "#20252f",   -- autocomplete selection, highlights
	element_selected   = "#1c2130",   -- secondary selections, LSP refs
	element_hover      = "#191e28",

	-- ── Borders & separators ─────────────────────────────────────────────
	border             = "#1c2230",   -- window splits, float borders
	border_focused     = "#3a4460",   -- active/focused border accent
	bracket_color      = "#6a7896",   -- matching brackets (subtle but findable)

	-- ── Selection ────────────────────────────────────────────────────────
	selection_bg       = "#2c3a50",   -- visual mode, shifted slightly toward blue
	selection_fg       = "#d7dae0",

	-- ── Foregrounds ──────────────────────────────────────────────────────
	-- Three tiers: identifiers → body text → secondary/muted
	bright_foreground  = "#d7dae0",   -- identifiers, cursor-adjacent text
	foreground         = "#abb2bf",   -- normal body text
	muted_foreground   = "#697082",   -- light_gray, line numbers, inactive
	comment_color      = "#4d5566",   -- comments — clearly subordinate
	disabled           = "#3a4050",   -- truly inactive

	gray               = "#3e4452",   -- EndOfBuffer, faint UI chrome

	-- ── Core syntax palette ──────────────────────────────────────────────
	-- Each pair: base + bright (used for gutter signs, diff, emphasis)
	red                = "#e06c75",   -- struct fields, tags, error-adjacent
	bright_red         = "#ff616e",   -- error signs, diff deletions
	green              = "#98c379",   -- strings, success
	bright_green       = "#a5e075",   -- diff additions, success signs
	yellow             = "#e5c07b",   -- types, constants, numbers
	bright_yellow      = "#ebc275",   -- inlay hints type, warnings
	blue               = "#61afef",   -- functions, methods
	bright_blue        = "#5ab0f6",   -- builtin fns, search highlight
	purple             = "#c678dd",   -- keywords, control flow
	bright_purple      = "#de73ff",   -- macros, jump labels
	cyan               = "#56b6c2",   -- special strings, builtins, escape seqs
	bright_cyan        = "#4dbdcb",   -- diff moved
	gold               = "#d19a66",   -- attributes, decorators, interpolation

	-- ── Semantic extras ──────────────────────────────────────────────────
	muted_blue         = "#4d7fa8",   -- doc comments

	-- ── Diagnostics ──────────────────────────────────────────────────────
	error              = "#ff4757",   -- distinct from red syntax: purer hue
	warning            = "#e5c07b",   -- maps to yellow
	info               = "#5ab0f6",   -- maps to bright_blue
	hint               = "#56b6c2",   -- maps to cyan (different from abb2bf for clarity)

	-- ── Diff ─────────────────────────────────────────────────────────────
	diff_add           = "#253b22",   -- green-tinted, low saturation
	diff_change        = "#3a2e14",   -- amber-tinted
	diff_delete        = "#3d1820",   -- red-tinted
	diff_text          = "#1e3248",   -- changed text within a changed line

	-- ── Indent & decoration ──────────────────────────────────────────────
	indent_guide        = "#181e2c",
	indent_guide_active = "#2e3548",

	-- ── Terminal 16-color palette ─────────────────────────────────────────
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

	-- ====================================================================
	-- ── Editor UI
	-- ====================================================================

	-- Core surfaces
	set(0, "Normal",           { fg = p.bright_foreground, bg = p.background })
	set(0, "NormalNC",         { fg = p.foreground,        bg = p.background })
	set(0, "NormalFloat",      { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "FloatBorder",      { fg = p.border_focused,    bg = p.background_dark })
	set(0, "FloatTitle",       { fg = p.bright_blue,       bg = p.background_dark, bold = true })
	set(0, "FloatFooter",      { fg = p.muted_foreground,  bg = p.background_dark })

	-- Cursor & current line
	-- Minimal cursorline: just enough to see where you are without visual noise
	set(0, "Cursor",           { fg = p.background,        bg = p.bright_foreground })
	set(0, "lCursor",          { fg = p.background,        bg = p.bright_foreground })
	set(0, "CursorIM",         { fg = p.background,        bg = p.bright_blue })
	set(0, "CursorLine",       { bg = p.background_lighter })
	set(0, "CursorLineNr",     { fg = p.foreground,        bg = p.background_lighter, bold = true })
	set(0, "CursorColumn",     { bg = p.background_lighter })

	-- Line numbers
	set(0, "LineNr",           { fg = p.disabled })
	set(0, "LineNrAbove",      { fg = p.disabled })
	set(0, "LineNrBelow",      { fg = p.disabled })

	-- Gutter / signs
	set(0, "SignColumn",       { fg = p.muted_foreground,  bg = "none" })
	set(0, "FoldColumn",       { fg = p.muted_foreground,  bg = "none" })
	set(0, "Folded",           { fg = p.muted_foreground,  bg = p.element_active })

	-- Column & buffer bounds
	set(0, "ColorColumn",      { bg = p.background_lighter })
	set(0, "EndOfBuffer",      { fg = p.gray })

	-- Splits
	set(0, "VertSplit",        { fg = p.border })
	set(0, "WinSeparator",     { fg = p.border })

	-- Visual / Selection
	-- Offset from element_active to remain distinct when completion menu overlaps
	set(0, "Visual",           { bg = p.selection_bg })
	set(0, "VisualNOS",        { bg = p.selection_bg })
	set(0, "SelectionForeground", { fg = p.selection_fg })

	-- Search
	-- Hierarchy: IncSearch (active match) > CurSearch (exact) > Search (all)
	set(0, "Search",           { fg = p.background, bg = p.bright_blue })
	set(0, "IncSearch",        { fg = p.background, bg = p.bright_yellow })
	set(0, "CurSearch",        { fg = p.background, bg = p.bright_purple })
	set(0, "Substitute",       { fg = p.background, bg = p.bright_red })
	set(0, "MatchParen",       { fg = p.bright_blue, underline = true, bold = true })

	-- Completion menu (Pmenu)
	set(0, "Pmenu",            { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "PmenuSel",         { fg = p.bright_foreground, bg = p.element_active, bold = true })
	set(0, "PmenuKind",        { fg = p.muted_foreground,  bg = p.background_dark })
	set(0, "PmenuKindSel",     { fg = p.bright_blue,       bg = p.element_active })
	set(0, "PmenuExtra",       { fg = p.muted_foreground,  bg = p.background_dark })
	set(0, "PmenuExtraSel",    { fg = p.foreground,        bg = p.element_active })
	set(0, "PmenuSbar",        { bg = p.background_dark })
	set(0, "PmenuThumb",       { bg = p.border_focused })

	-- Statusline
	set(0, "StatusLine",       { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "StatusLineNC",     { fg = p.muted_foreground,  bg = p.background_dark })
	set(0, "StatusLineTerm",   { link = "StatusLine" })
	set(0, "StatusLineTermNC", { link = "StatusLineNC" })

	-- Winbar (breadcrumbs)
	set(0, "WinBar",           { fg = p.foreground })
	set(0, "WinBarNC",         { fg = p.muted_foreground })

	-- Tabline / Bufferline
	set(0, "TabLine",          { fg = p.muted_foreground, bg = p.background_dark })
	set(0, "TabLineFill",      { bg = p.background })
	set(0, "TabLineSel",       { fg = p.bright_foreground, bg = p.element_active, bold = true })

	-- Command line / messages
	set(0, "ModeMsg",          { fg = p.bright_foreground, bold = true })
	set(0, "MsgArea",          { fg = p.foreground })
	set(0, "MoreMsg",          { fg = p.bright_blue })
	set(0, "Question",         { fg = p.bright_blue })
	set(0, "ErrorMsg",         { fg = p.error, bold = true })
	set(0, "WarningMsg",       { fg = p.warning })

	-- Wild / Command completion
	set(0, "WildMenu",         { fg = p.bright_foreground, bg = p.element_active })

	-- Misc UI
	set(0, "Directory",        { fg = p.blue })
	set(0, "Title",            { fg = p.bright_blue, bold = true })
	set(0, "NonText",          { fg = p.gray })
	set(0, "SpecialKey",       { fg = p.gray })
	set(0, "Conceal",          { fg = p.muted_foreground })
	set(0, "Whitespace",       { fg = p.indent_guide })
	set(0, "TermCursor",       { bg = p.bright_foreground })
	set(0, "TermCursorNC",     { bg = p.muted_foreground })

	-- Quickfix / loclist
	set(0, "QuickFixLine",     { bg = p.element_active, bold = true })
	set(0, "qfLineNr",         { fg = p.muted_foreground })
	set(0, "qfFileName",       { fg = p.blue })

	-- Spell
	set(0, "SpellBad",         { undercurl = true, sp = p.error })
	set(0, "SpellCap",         { undercurl = true, sp = p.warning })
	set(0, "SpellRare",        { undercurl = true, sp = p.cyan })
	set(0, "SpellLocal",       { undercurl = true, sp = p.info })

	-- ====================================================================
	-- ── Traditional Syntax (Vim builtin groups)
	-- ====================================================================
	-- These anchor the theme for non-treesitter files and legacy plugins.

	set(0, "Comment",          { fg = p.comment_color, italic = true })
	set(0, "Constant",         { fg = p.yellow, bold = true })
	set(0, "String",           { fg = p.green })
	set(0, "Character",        { fg = p.green })
	set(0, "Number",           { fg = p.yellow })
	set(0, "Boolean",          { fg = p.yellow, bold = true })
	set(0, "Float",            { fg = p.yellow })
	set(0, "Identifier",       { fg = p.bright_foreground })
	set(0, "Function",         { fg = p.blue })
	set(0, "Statement",        { fg = p.purple, bold = true })
	set(0, "Conditional",      { fg = p.purple, italic = true })
	set(0, "Repeat",           { fg = p.purple, italic = true })
	set(0, "Label",            { fg = p.purple })
	set(0, "Operator",         { fg = p.bright_foreground })
	set(0, "Keyword",          { fg = p.purple, bold = true })
	set(0, "Exception",        { fg = p.purple, bold = true })
	set(0, "PreProc",          { fg = p.gold })
	set(0, "Include",          { fg = p.purple })
	set(0, "Define",           { fg = p.purple })
	set(0, "Macro",            { fg = p.bright_purple })
	set(0, "PreCondit",        { fg = p.purple })
	set(0, "Type",             { fg = p.yellow, bold = true })
	set(0, "StorageClass",     { fg = p.purple })
	set(0, "Structure",        { fg = p.yellow, bold = true })
	set(0, "Typedef",          { fg = p.yellow })
	set(0, "Special",          { fg = p.cyan })
	set(0, "SpecialChar",      { fg = p.cyan, bold = true })
	set(0, "Tag",              { fg = p.red })
	set(0, "Delimiter",        { fg = p.bright_foreground })
	set(0, "SpecialComment",   { fg = p.comment_color, italic = true })
	set(0, "Debug",            { fg = p.bright_red })
	set(0, "Underlined",       { underline = true })
	set(0, "Ignore",           { fg = p.disabled })
	set(0, "Error",            { fg = p.error, bold = true })
	set(0, "Todo",             { fg = p.background, bg = p.bright_purple, bold = true })

	-- ====================================================================
	-- ── Diff
	-- ====================================================================
	set(0, "DiffAdd",          { bg = p.diff_add })
	set(0, "DiffChange",       { bg = p.diff_change })
	set(0, "DiffDelete",       { bg = p.diff_delete })
	set(0, "DiffText",         { bg = p.diff_text, bold = true })
	set(0, "diffAdded",        { fg = p.bright_green })
	set(0, "diffRemoved",      { fg = p.bright_red })
	set(0, "diffChanged",      { fg = p.bright_yellow })
	set(0, "diffNewFile",      { fg = p.bright_green, bold = true })
	set(0, "diffOldFile",      { fg = p.bright_red, bold = true })
	set(0, "diffFile",         { fg = p.blue })
	set(0, "diffLine",         { fg = p.bright_cyan })
	set(0, "diffIndexLine",    { fg = p.muted_foreground })

	-- ====================================================================
	-- ── Diagnostics
	-- ====================================================================
	set(0, "DiagnosticError",                { fg = p.error })
	set(0, "DiagnosticWarn",                 { fg = p.warning })
	set(0, "DiagnosticInfo",                 { fg = p.info })
	set(0, "DiagnosticHint",                 { fg = p.hint })
	set(0, "DiagnosticOk",                   { fg = p.bright_green })

	set(0, "DiagnosticUnderlineError",       { undercurl = true, sp = p.error })
	set(0, "DiagnosticUnderlineWarn",        { undercurl = true, sp = p.warning })
	set(0, "DiagnosticUnderlineInfo",        { undercurl = true, sp = p.info })
	set(0, "DiagnosticUnderlineHint",        { undercurl = true, sp = p.hint })
	set(0, "DiagnosticUnderlineOk",          { underdotted = true, sp = p.bright_green })

	set(0, "DiagnosticVirtualTextError",     { fg = p.error,   bg = "#1e0a0c", italic = true })
	set(0, "DiagnosticVirtualTextWarn",      { fg = p.warning, bg = "#1c1608", italic = true })
	set(0, "DiagnosticVirtualTextInfo",      { fg = p.info,    bg = "#07131e", italic = true })
	set(0, "DiagnosticVirtualTextHint",      { fg = p.hint,    bg = "#091316", italic = true })

	set(0, "DiagnosticSignError",            { fg = p.error })
	set(0, "DiagnosticSignWarn",             { fg = p.warning })
	set(0, "DiagnosticSignInfo",             { fg = p.info })
	set(0, "DiagnosticSignHint",             { fg = p.hint })

	set(0, "DiagnosticFloatingError",        { fg = p.error,   bg = p.background_dark })
	set(0, "DiagnosticFloatingWarn",         { fg = p.warning, bg = p.background_dark })
	set(0, "DiagnosticFloatingInfo",         { fg = p.info,    bg = p.background_dark })
	set(0, "DiagnosticFloatingHint",         { fg = p.hint,    bg = p.background_dark })

	-- ====================================================================
	-- ── LSP
	-- ====================================================================
	set(0, "LspReferenceText",               { bg = p.element_selected })
	set(0, "LspReferenceRead",               { bg = p.element_selected })
	set(0, "LspReferenceWrite",              { bg = p.element_active, underline = true })
	set(0, "LspSignatureActiveParameter",    { fg = p.bright_yellow, bold = true, italic = true })
	set(0, "LspCodeLens",                    { fg = p.comment_color, italic = true })
	set(0, "LspCodeLensSeparator",           { fg = p.disabled })
	set(0, "LspInlayHint",                   { fg = p.comment_color, italic = true })

	-- ====================================================================
	-- ── Treesitter (nvim-treesitter)
	-- ====================================================================

	-- Comments
	set(0, "@comment",                        { fg = p.comment_color, italic = true })
	set(0, "@comment.documentation",         { fg = p.muted_blue, italic = true })
	set(0, "@comment.error",                  { fg = p.error, italic = true })
	set(0, "@comment.warning",                { fg = p.warning, italic = true })
	set(0, "@comment.todo",                   { fg = p.background, bg = p.bright_purple, bold = true })
	set(0, "@comment.note",                   { fg = p.background, bg = p.bright_blue, bold = true })

	-- Strings
	set(0, "@string",                         { fg = p.green })
	set(0, "@string.regexp",                  { fg = p.cyan })
	set(0, "@string.escape",                  { fg = p.cyan, bold = true })
	set(0, "@string.special",                 { fg = p.cyan })
	set(0, "@string.special.path",            { fg = p.bright_blue, underline = true })
	set(0, "@string.special.url",             { fg = p.bright_blue, underline = true })
	set(0, "@string.special.symbol",          { fg = p.cyan, bold = true })

	-- Characters
	set(0, "@character",                      { fg = p.green })
	set(0, "@character.special",              { fg = p.cyan, bold = true })

	-- Literals
	set(0, "@boolean",                        { fg = p.yellow, bold = true })
	set(0, "@number",                         { fg = p.yellow })
	set(0, "@number.float",                   { fg = p.yellow })
	set(0, "@float",                          { fg = p.yellow })

	-- Functions
	-- Blue for all callables — consistent mental model of "things you invoke"
	set(0, "@function",                       { fg = p.blue })
	set(0, "@function.call",                  { fg = p.blue })
	set(0, "@function.builtin",               { fg = p.bright_blue })
	set(0, "@function.macro",                 { fg = p.bright_purple })
	set(0, "@function.method",                { fg = p.blue })
	set(0, "@function.method.call",           { fg = p.blue })
	set(0, "@constructor",                    { fg = p.red, bold = true })

	-- Variables
	-- Identifiers in the neutral bright_foreground keep noise low
	set(0, "@variable",                       { fg = p.bright_foreground })
	set(0, "@variable.builtin",               { fg = p.yellow, italic = true })  -- self, this
	set(0, "@variable.parameter",             { fg = p.bright_foreground, italic = true })
	set(0, "@variable.parameter.builtin",     { fg = p.cyan, italic = true })
	set(0, "@variable.member",                { fg = p.red })  -- struct fields stand out

	-- Constants
	set(0, "@constant",                       { fg = p.yellow, bold = true })
	set(0, "@constant.builtin",               { fg = p.yellow, bold = true })
	set(0, "@constant.macro",                 { fg = p.gold })

	-- Keywords
	set(0, "@keyword",                        { fg = p.purple, bold = true })
	set(0, "@keyword.coroutine",              { fg = p.purple, bold = true })
	set(0, "@keyword.function",               { fg = p.purple, bold = true })
	set(0, "@keyword.operator",               { fg = p.bright_foreground })  -- `and`, `or`, `in`
	set(0, "@keyword.return",                 { fg = p.purple, bold = true })
	set(0, "@keyword.import",                 { fg = p.purple })
	set(0, "@keyword.storage",                { fg = p.purple })
	set(0, "@keyword.repeat",                 { fg = p.purple, italic = true })
	set(0, "@keyword.conditional",            { fg = p.purple, italic = true })
	set(0, "@keyword.conditional.ternary",    { fg = p.purple, italic = true })
	set(0, "@keyword.exception",              { fg = p.purple, bold = true })
	set(0, "@keyword.directive",              { fg = p.gold })
	set(0, "@keyword.directive.define",       { fg = p.gold, bold = true })
	set(0, "@keyword.debug",                  { fg = p.bright_red })

	-- Operators & Punctuation
	set(0, "@operator",                       { fg = p.bright_foreground })
	set(0, "@punctuation",                    { fg = p.bright_foreground })
	set(0, "@punctuation.delimiter",          { fg = p.bright_foreground })
	set(0, "@punctuation.bracket",            { fg = p.bracket_color })
	set(0, "@punctuation.special",            { fg = p.cyan })  -- string interpolation `{}`

	-- Types
	set(0, "@type",                           { fg = p.yellow, bold = true })
	set(0, "@type.builtin",                   { fg = p.yellow, italic = true })
	set(0, "@type.definition",                { fg = p.yellow, bold = true })
	set(0, "@type.qualifier",                 { fg = p.purple })  -- const, mut qualifiers
	set(0, "@type.parameter",                 { fg = p.yellow, italic = true })  -- generics

	-- Attributes / Decorators / Modules
	set(0, "@attribute",                      { fg = p.gold })
	set(0, "@attribute.builtin",              { fg = p.gold, bold = true })
	set(0, "@property",                       { fg = p.red })  -- object property access
	set(0, "@module",                         { fg = p.yellow })
	set(0, "@module.builtin",                 { fg = p.yellow, italic = true })

	-- Labels (loop labels, lifetimes in Rust)
	set(0, "@label",                          { fg = p.bright_purple })

	-- Tags (HTML/XML/JSX/TSX)
	set(0, "@tag",                            { fg = p.red })
	set(0, "@tag.builtin",                    { fg = p.red })
	set(0, "@tag.attribute",                  { fg = p.gold })
	set(0, "@tag.delimiter",                  { fg = p.bright_foreground })

	-- Markup
	set(0, "@markup.heading",                 { fg = p.bright_blue, bold = true })
	set(0, "@markup.heading.1",               { fg = p.bright_blue, bold = true })
	set(0, "@markup.heading.2",               { fg = p.blue, bold = true })
	set(0, "@markup.heading.3",               { fg = p.bright_purple, bold = true })
	set(0, "@markup.heading.4",               { fg = p.purple, bold = true })
	set(0, "@markup.heading.5",               { fg = p.cyan, bold = true })
	set(0, "@markup.heading.6",               { fg = p.muted_blue, bold = true })
	set(0, "@markup.heading.marker",          { fg = p.comment_color })
	set(0, "@markup.list",                    { fg = p.bright_foreground })
	set(0, "@markup.list.unnumbered",         { fg = p.red })
	set(0, "@markup.list.numbered",           { fg = p.yellow })
	set(0, "@markup.list.checked",            { fg = p.bright_green, bold = true })
	set(0, "@markup.list.unchecked",          { fg = p.comment_color })
	set(0, "@markup.bold",                    { fg = p.bright_yellow, bold = true })
	set(0, "@markup.italic",                  { fg = p.purple, italic = true })
	set(0, "@markup.strikethrough",           { fg = p.comment_color, strikethrough = true })
	set(0, "@markup.link",                    { fg = p.bright_blue, underline = true })
	set(0, "@markup.link.url",                { fg = p.bright_blue, underline = true, italic = true })
	set(0, "@markup.link.label",              { fg = p.bright_purple })
	set(0, "@markup.link.text",               { fg = p.bright_blue })
	set(0, "@markup.quote",                   { fg = p.comment_color, italic = true })
	set(0, "@markup.math",                    { fg = p.yellow })
	set(0, "@markup.raw",                     { fg = p.green })
	set(0, "@markup.raw.inline",              { fg = p.green })
	set(0, "@markup.raw.block",               { fg = p.green })
	set(0, "@markup.environment",             { fg = p.gold })
	set(0, "@markup.environment.name",        { fg = p.yellow })

	-- ====================================================================
	-- ── LSP Semantic Tokens
	-- ====================================================================
	set(0, "@lsp.type.class",                 { link = "@type" })
	set(0, "@lsp.type.comment",               { link = "@comment" })
	set(0, "@lsp.type.decorator",             { fg = p.gold })
	set(0, "@lsp.type.enum",                  { link = "@type" })
	set(0, "@lsp.type.enumMember",            { link = "@constant" })
	set(0, "@lsp.type.function",              { link = "@function" })
	set(0, "@lsp.type.interface",             { fg = p.yellow, italic = true })
	set(0, "@lsp.type.keyword",               { link = "@keyword" })
	set(0, "@lsp.type.macro",                 { link = "@function.macro" })
	set(0, "@lsp.type.method",                { link = "@function.method" })
	set(0, "@lsp.type.modifier",              { fg = p.purple })
	set(0, "@lsp.type.namespace",             { link = "@module" })
	set(0, "@lsp.type.number",                { link = "@number" })
	set(0, "@lsp.type.operator",              { link = "@operator" })
	set(0, "@lsp.type.parameter",             { link = "@variable.parameter" })
	set(0, "@lsp.type.property",              { link = "@property" })
	set(0, "@lsp.type.regexp",                { link = "@string.regexp" })
	set(0, "@lsp.type.string",                { link = "@string" })
	set(0, "@lsp.type.struct",                { link = "@type" })
	set(0, "@lsp.type.type",                  { link = "@type" })
	set(0, "@lsp.type.typeParameter",         { fg = p.yellow, italic = true })
	set(0, "@lsp.type.variable",              { link = "@variable" })
	set(0, "@lsp.type.selfKeyword",           { fg = p.yellow, italic = true })
	set(0, "@lsp.type.lifetime",              { fg = p.bright_purple, italic = true })
	set(0, "@lsp.typemod.function.defaultLibrary",  { link = "@function.builtin" })
	set(0, "@lsp.typemod.variable.defaultLibrary",  { link = "@variable.builtin" })
	set(0, "@lsp.typemod.type.defaultLibrary",      { link = "@type.builtin" })
	set(0, "@lsp.typemod.operator.injected",        { link = "@keyword.operator" })
	set(0, "@lsp.typemod.string.injected",          { link = "@string" })
	set(0, "@lsp.typemod.variable.constant",        { link = "@constant" })
	set(0, "@lsp.typemod.variable.injected",        { link = "@variable" })
	set(0, "@lsp.typemod.variable.static",          { fg = p.yellow, bold = true })

	-- ====================================================================
	-- ── Indent guides (indent-blankline / ibl)
	-- ====================================================================
	set(0, "IblIndent",           { fg = p.indent_guide })
	set(0, "IblScope",            { fg = p.indent_guide_active })
	set(0, "IndentBlanklineChar", { fg = p.indent_guide })
	set(0, "IndentBlanklineScopeChar", { fg = p.indent_guide_active })

	-- ====================================================================
	-- ── Git Signs (lewis6991/gitsigns.nvim)
	-- ====================================================================
	set(0, "GitSignsAdd",              { fg = p.bright_green })
	set(0, "GitSignsChange",           { fg = p.bright_yellow })
	set(0, "GitSignsDelete",           { fg = p.bright_red })
	set(0, "GitSignsAddLn",            { bg = p.diff_add })
	set(0, "GitSignsChangeLn",         { bg = p.diff_change })
	set(0, "GitSignsDeleteLn",         { bg = p.diff_delete })
	set(0, "GitSignsAddNr",            { fg = p.bright_green })
	set(0, "GitSignsChangeNr",         { fg = p.bright_yellow })
	set(0, "GitSignsDeleteNr",         { fg = p.bright_red })
	set(0, "GitSignsStagedAdd",        { fg = p.green })
	set(0, "GitSignsStagedChange",     { fg = p.yellow })
	set(0, "GitSignsStagedDelete",     { fg = p.red })
	set(0, "GitSignsUntracked",        { fg = p.comment_color })

	-- ====================================================================
	-- ── Telescope (nvim-telescope/telescope.nvim)
	-- ====================================================================
	set(0, "TelescopeNormal",          { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "TelescopeTitle",           { fg = p.background, bg = p.bright_blue, bold = true })
	set(0, "TelescopeBorder",          { fg = p.border,         bg = p.background_dark })
	set(0, "TelescopePromptNormal",    { fg = p.bright_foreground, bg = p.element_active })
	set(0, "TelescopePromptBorder",    { fg = p.border_focused, bg = p.element_active })
	set(0, "TelescopePromptTitle",     { fg = p.background, bg = p.bright_blue, bold = true })
	set(0, "TelescopePromptPrefix",    { fg = p.bright_blue, bg = p.element_active })
	set(0, "TelescopePromptCounter",   { fg = p.muted_foreground, bg = p.element_active })
	set(0, "TelescopeResultsTitle",    { fg = p.background, bg = p.green, bold = true })
	set(0, "TelescopeResultsBorder",   { fg = p.border,         bg = p.background_dark })
	set(0, "TelescopePreviewTitle",    { fg = p.background, bg = p.purple, bold = true })
	set(0, "TelescopePreviewBorder",   { fg = p.border,         bg = p.background_dark })
	set(0, "TelescopePreviewNormal",   { bg = p.background_dark })
	set(0, "TelescopeSelection",       { fg = p.bright_foreground, bg = p.element_active })
	set(0, "TelescopeSelectionCaret",  { fg = p.bright_blue })
	set(0, "TelescopeMultiSelection",  { fg = p.bright_purple })
	set(0, "TelescopeMatching",        { fg = p.bright_blue, bold = true })

	-- ====================================================================
	-- ── Blink.cmp / nvim-cmp
	-- ====================================================================
	-- blink.cmp
	set(0, "BlinkCmpMenu",             { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "BlinkCmpMenuBorder",       { fg = p.border_focused,    bg = p.background_dark })
	set(0, "BlinkCmpMenuSelection",    { fg = p.bright_foreground, bg = p.element_active, bold = true })
	set(0, "BlinkCmpScrollBarThumb",   { bg = p.border_focused })
	set(0, "BlinkCmpScrollBarGutter",  { bg = p.background_darker })
	set(0, "BlinkCmpLabel",            { fg = p.bright_foreground })
	set(0, "BlinkCmpLabelMatch",       { fg = p.bright_blue, bold = true })
	set(0, "BlinkCmpLabelDetail",      { fg = p.muted_foreground })
	set(0, "BlinkCmpLabelDescription", { fg = p.comment_color })
	set(0, "BlinkCmpKind",             { fg = p.muted_foreground })
	set(0, "BlinkCmpDoc",              { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "BlinkCmpDocBorder",        { fg = p.border,            bg = p.background_dark })
	set(0, "BlinkCmpSignatureHelp",    { fg = p.bright_foreground, bg = p.background_dark })

	-- ====================================================================
	-- ── Mini.clue (which-key equivalent)
	-- ====================================================================
	set(0, "MiniClueBorder",      { fg = p.border_focused, bg = p.background_dark })
	set(0, "MiniClueDescGroup",   { fg = p.bright_blue })
	set(0, "MiniClueDescSingle",  { fg = p.bright_foreground })
	set(0, "MiniClueNextKey",     { fg = p.bright_yellow, bold = true })
	set(0, "MiniClueNextKeyWithPostkeys", { fg = p.bright_purple, bold = true })
	set(0, "MiniClueSeparator",   { fg = p.muted_foreground })
	set(0, "MiniClueTitle",       { fg = p.background, bg = p.bright_blue, bold = true })

	-- ====================================================================
	-- ── Which-key (folke/which-key.nvim)
	-- ====================================================================
	set(0, "WhichKey",            { fg = p.bright_purple, bold = true })
	set(0, "WhichKeyGroup",       { fg = p.bright_blue })
	set(0, "WhichKeySeparator",   { fg = p.comment_color })
	set(0, "WhichKeyDesc",        { fg = p.bright_foreground })
	set(0, "WhichKeyFloat",       { bg = p.background_dark })
	set(0, "WhichKeyBorder",      { fg = p.border_focused, bg = p.background_dark })
	set(0, "WhichKeyValue",       { fg = p.muted_foreground })

	-- ====================================================================
	-- ── Bufferline (akinsho/bufferline.nvim)
	-- ====================================================================
	set(0, "BufferLineFill",           { bg = p.background_darker })
	set(0, "BufferLineBackground",     { fg = p.muted_foreground, bg = p.background_dark })
	set(0, "BufferLineBufferSelected", { fg = p.bright_foreground, bg = p.background, bold = true })
	set(0, "BufferLineBufferVisible",  { fg = p.foreground, bg = p.background_dark })
	set(0, "BufferLineSeparator",      { fg = p.border, bg = p.background_dark })
	set(0, "BufferLineIndicatorSelected", { fg = p.bright_blue, bg = p.background })
	set(0, "BufferLineModifiedSelected", { fg = p.bright_yellow, bg = p.background })
	set(0, "BufferLineCloseButtonSelected", { fg = p.bright_red, bg = p.background })

	-- ====================================================================
	-- ── FFF / Telescope-adjacent fuzzy finders
	-- ====================================================================
	set(0, "FffNormal",   { fg = p.bright_foreground, bg = p.background_dark })
	set(0, "FffBorder",   { fg = p.border_focused,    bg = p.background_dark })
	set(0, "FffMatch",    { fg = p.bright_blue, bold = true })
	set(0, "FffSelection",{ fg = p.bright_foreground, bg = p.element_active })

	-- ====================================================================
	-- ── Mason
	-- ====================================================================
	set(0, "MasonNormal",    { bg = p.background_dark })
	set(0, "MasonHeader",    { fg = p.background, bg = p.bright_blue, bold = true })
	set(0, "MasonHighlight", { fg = p.bright_blue })
	set(0, "MasonHighlightBlock",   { fg = p.background, bg = p.bright_blue })
	set(0, "MasonHighlightBlockBold", { fg = p.background, bg = p.bright_blue, bold = true })
	set(0, "MasonMuted",     { fg = p.muted_foreground })
	set(0, "MasonMutedBlock",{ fg = p.muted_foreground, bg = p.element_active })

	-- ====================================================================
	-- ── Yazi (terminal, inherits from Terminal 16)
	-- ====================================================================
	-- Handled via terminal color vars below.

	-- ====================================================================
	-- ── Terminal 16-color assignments
	-- ====================================================================
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
