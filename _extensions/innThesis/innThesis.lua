-- innThesis.lua
--
-- Turns Quarto's book structure into the Typst calls that innThesis's template
-- understands:
--
--   * `part:` entries in _quarto.yml   -> #inn-part[...]
--   * the first numbered chapter       -> #show: inn-mainmatter  (arabic page
--                                         numbers restarting at 1) preceded by
--                                         the table of contents and friends
--   * `appendices:` in _quarto.yml     -> #show: inn-appendices.with(...)
--   * the `#refs` div                  -> the bibliography, so that the
--                                         reference list sits where the author
--                                         put it rather than after the
--                                         appendices
--
-- It also rewrites boolean values under `thesis:` to strings, because a Pandoc
-- template cannot tell `false` from "not set".

local stringify = pandoc.utils.stringify

-- Options read from metadata, filled in by the first pass.
local opts = {
  toc_position = "before-chapters",
  bibliography = {},
  bib_style = nil,
}

-- State carried across the header traversal.
local seen_first_numbered = false
local front_lists_emitted = false
local appendices_started = false
local bibliography_emitted = false

local function is_typst()
  return quarto.doc.is_format("typst")
end

local function raw(typst)
  return pandoc.RawBlock("typst", typst)
end

-- Render inline content as Typst so that markup in chapter/part titles survives.
local function inlines_to_typst(inlines)
  local ok, out = pcall(
    pandoc.write,
    pandoc.Pandoc({ pandoc.Plain(inlines) }),
    "typst"
  )
  if not ok then
    return stringify(inlines)
  end
  return (out:gsub("%s+$", ""))
end

local function quoted_list(items)
  local parts = {}
  for _, item in ipairs(items) do
    parts[#parts + 1] = '"' .. item:gsub('"', '\\"') .. '"'
  end
  return "(" .. table.concat(parts, ", ") .. ",)"
end

-- The `#inn-bibliography(...)` call. `titled` adds a heading, which is only
-- wanted when we have to fall back to the end of the document.
local function bibliography_block(titled)
  if #opts.bibliography == 0 then
    return nil
  end
  local args = { quoted_list(opts.bibliography) }
  if opts.bib_style then
    args[#args + 1] = 'style: "' .. opts.bib_style .. '"'
  end
  if titled then
    args[#args + 1] = 'title: inn-t("references")'
  else
    args[#args + 1] = "title: none"
  end
  return raw("#inn-bibliography(" .. table.concat(args, ", ") .. ")")
end

-- ---------------------------------------------------------------- metadata --

local BOOLEAN_THESIS_KEYS = {
  "two-sided",
  "open-right",
  "running-head",
  "colophon",
  "list-of-papers",
}

local function read_meta(meta)
  if not is_typst() then
    return nil
  end

  local thesis = meta.thesis
  if thesis ~= nil then
    -- `$if(x)$` in a Pandoc template is false for both `false` and "unset", so
    -- booleans have to reach the template as strings to be usable at all.
    for _, key in ipairs(BOOLEAN_THESIS_KEYS) do
      local value = thesis[key]
      if type(value) == "boolean" then
        thesis[key] = pandoc.MetaString(tostring(value))
      end
    end
    if thesis["toc-position"] ~= nil then
      opts.toc_position = stringify(thesis["toc-position"])
    end
    meta.thesis = thesis
  end

  -- Where to find the bibliography, and in which style.
  local bib = meta.bibliography
  if bib ~= nil then
    if bib.t == "MetaList" then
      for _, entry in ipairs(bib) do
        opts.bibliography[#opts.bibliography + 1] = stringify(entry)
      end
    else
      opts.bibliography[1] = stringify(bib)
    end
  end
  if meta.csl ~= nil then
    opts.bib_style = stringify(meta.csl)
  elseif meta.bibliographystyle ~= nil then
    opts.bib_style = stringify(meta.bibliographystyle)
  end

  return meta
end

-- --------------------------------------------------------------- structure --

local structure = {
  Header = function(el)
    if not is_typst() or el.level ~= 1 then
      return nil
    end

    local state = quarto.doc.file_metadata()
    local file = state and state.file
    if file == nil then
      return nil
    end

    local item_type = file.bookItemType
    if item_type == nil then
      return nil
    end

    -- A `part:` entry gets a divider page of its own.
    if item_type == "part" then
      return raw("#inn-part[" .. inlines_to_typst(el.content) .. "]")
    end

    -- The synthetic divider that Quarto inserts before `appendices:`.
    if item_type == "appendix" and not appendices_started then
      appendices_started = true
      local title = stringify(el.content)
      if title == "" then
        title = "Appendices"
      end
      return {
        raw('#show: inn-appendices.with("' .. title:gsub('"', '\\"') .. '")'),
        el,
      }
    end

    -- The first numbered chapter ends the front matter.
    if item_type == "chapter" and file.bookItemNumber ~= nil and not seen_first_numbered then
      seen_first_numbered = true
      local blocks = {}
      if opts.toc_position ~= "after-title" and opts.toc_position ~= "none" then
        front_lists_emitted = true
        blocks[#blocks + 1] = raw("#inn-front-lists()")
      end
      blocks[#blocks + 1] = raw("#show: inn-mainmatter")
      blocks[#blocks + 1] = el
      return blocks
    end

    return nil
  end,

  -- The references chapter: Quarto leaves an empty `#refs` div where the
  -- reference list belongs.
  Div = function(el)
    if not is_typst() or el.identifier ~= "refs" then
      return nil
    end
    local block = bibliography_block(false)
    if block == nil then
      return nil
    end
    bibliography_emitted = true
    return block
  end,
}

-- ---------------------------------------------------------------- finalise --

local function finalise(doc)
  if not is_typst() then
    return nil
  end

  local blocks = doc.blocks

  -- Front lists that were never placed: either the author asked for them
  -- straight after the title page, or the book has no numbered chapter.
  if not front_lists_emitted and opts.toc_position ~= "none" then
    table.insert(blocks, 1, raw("#inn-front-lists()"))
  end

  -- No `#refs` div anywhere: put the reference list at the end, with a heading.
  if not bibliography_emitted then
    local block = bibliography_block(true)
    if block ~= nil then
      blocks[#blocks + 1] = block
    end
  end

  return doc
end

return {
  { Meta = read_meta },
  quarto.utils.combineFilters({
    quarto.utils.file_metadata_filter(),
    structure,
  }),
  { Pandoc = finalise },
}
