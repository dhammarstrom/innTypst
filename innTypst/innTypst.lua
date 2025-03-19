function Div(el)
  if el.classes:includes('article') then
    local blocks = pandoc.List({
      pandoc.RawBlock('typst', '#article[')
    })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  end
end


function Meta(meta)
  -- Check if we're using Typst format
  if quarto.doc.is_format("typst") then
    -- Set our own bibliography title to take precedence
    meta["suppress-bibliography"] = false
    
    -- Explicitly tell Quarto not to generate a bibliography heading
    if meta["bibliography-heading"] then
      -- If we have specified our own heading, suppress Quarto's
      meta["nocite"] = meta["nocite"] or pandoc.List({})
      meta["nocite"]:insert("@*")
    end
  end
  
  return meta
end


-- table-captions.lua
-- Ensures table captions are properly positioned above tables

function Table(tbl)
  -- Check if we're in Typst format and the table has a caption
  if quarto.doc.is_format("typst") and tbl.caption and tbl.caption.long and #tbl.caption.long > 0 then
    -- Process only for tables that appear to be from R
    -- (this is a heuristic that might need adjustment based on your specific R output)
    if tbl.classes:includes("cell-border") or tbl.classes:includes("dataframe") then
      -- Get the caption text
      local caption = pandoc.utils.stringify(tbl.caption.long)
      
      -- Get the identifier if any
      local identifier = tbl.identifier or ""
      
      -- Convert the table to a string representation
      local table_content = pandoc.write(pandoc.Pandoc({pandoc.Plain({tbl:clone()})}, pandoc.Meta({})), "typst")
      
      -- Create a Typst raw block with proper table and caption position
      local typst_code = string.format(
        "#figure(\n  kind: table,\n  caption: [%s],\n  ref: \"%s\",\n  %s\n)",
        caption, identifier, table_content
      )
      
      return pandoc.RawBlock("typst", typst_code)
    end
  end
  
  return tbl
end


-- figure-captions.lua
-- Ensures figure captions are properly passed to Typst

function Image(img)
  -- Check if we're in Typst format and the image has a caption
  if quarto.doc.is_format("typst") and img.caption and img.caption.long and #img.caption.long > 0 then
    -- Get the image path
    local path = img.src
    
    -- Get the caption text
    local caption = pandoc.utils.stringify(img.caption.long)
    
    -- Get the identifier if any
    local identifier = img.identifier or ""
    
    -- Create a Typst raw block with proper figure and caption
    local typst_code = string.format(
      "#figure(\n  image(\"%s\"),\n  caption: [%s],\n  ref: \"%s\"\n)",
      path, caption, identifier
    )
    
    return pandoc.RawBlock("typst", typst_code)
  end
  
  return img
end