-- Apply heading and link markers written as empty spans, for the PDF.
--
-- Markdown read on GitHub cannot carry Pandoc heading attributes such as {#id}
-- or {.unnumbered}: it shows them as text. Empty spans in their own paragraphs
-- before a heading carry them instead, and this moves their ids and classes onto
-- the heading. A span can also be a link target at the start of a paragraph, so
-- this starts the paragraph before the span. Either way, a page break cannot
-- separate a target from its text and make a link land on the wrong page.

local function is_marker(inline)
  return inline ~= nil and inline.t == "Span" and #inline.content == 0
    and (inline.identifier ~= "" or #inline.classes > 0)
end

local function is_marker_para(block)
  return block.t == "Para" and #block.content == 1 and is_marker(block.content[1])
end

local function start_paragraph(block)
  if block.t == "Para" and is_marker(block.content[1]) then
    block.content:insert(1, pandoc.RawInline("latex", "\\leavevmode{}"))
  end
  return block
end

local function apply_markers(header, markers)
  local identifier = nil
  for _, marker in ipairs(markers) do
    local span = marker.content[1]
    if span.identifier ~= "" then
      if identifier then
        error("two ids before one heading: " .. identifier .. " and " .. span.identifier)
      end
      identifier = span.identifier
      header.identifier = identifier
    end
    header.classes:extend(span.classes)
  end
end

function Blocks(blocks)
  local result = pandoc.Blocks({})
  local pending = {}
  for _, block in ipairs(blocks) do
    if is_marker_para(block) then
      table.insert(pending, block)
    else
      if block.t == "Header" then
        apply_markers(block, pending)
      else
        for _, marker in ipairs(pending) do
          result:insert(start_paragraph(marker))
        end
      end
      pending = {}
      result:insert(start_paragraph(block))
    end
  end
  for _, marker in ipairs(pending) do
    result:insert(start_paragraph(marker))
  end
  return result
end
