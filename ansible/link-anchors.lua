-- Keep link targets written as empty spans together with their text in a PDF.
--
-- Markdown read on GitHub cannot put an explicit id on a heading, so a link
-- target is written as an empty span: in its own paragraph before a heading, or
-- at the start of a paragraph. In a PDF each would be a separate anchor, and a
-- page break can fall between it and the text it marks, so a link would land on
-- the wrong page. This moves the id onto the heading, and starts the paragraph
-- before the span.

local function is_anchor(inline)
  return inline ~= nil and inline.t == "Span" and #inline.content == 0
    and inline.identifier ~= ""
end

function Blocks(blocks)
  local result = pandoc.Blocks({})
  for i, block in ipairs(blocks) do
    local next_block = blocks[i + 1]
    if block.t == "Para" and #block.content == 1 and is_anchor(block.content[1])
      and next_block and next_block.t == "Header" then
      next_block.identifier = block.content[1].identifier
    else
      if block.t == "Para" and is_anchor(block.content[1]) then
        block.content:insert(1, pandoc.RawInline("latex", "\\leavevmode{}"))
      end
      result:insert(block)
    end
  end
  return result
end
