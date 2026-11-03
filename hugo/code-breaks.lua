-- Typeset inline code for LaTeX with line breaks allowed only at natural
-- seams: at a separator between two word characters, as in
-- inventories/lab/hosts.yml or ansible_python_interpreter. Following the
-- usual convention for URLs, the break goes before . , - _ / (so a line never
-- ends in what reads as punctuation or a hyphen) and after : =. Short words
-- never split, and option prefixes such as --check stay intact.
--
-- Code in headings is left to Pandoc, which also writes a plain-text form for
-- PDF bookmarks, and code with a class is left to Pandoc's highlighter.

local escapes = {
  ['\\'] = '\\textbackslash{}', ['{'] = '\\{', ['}'] = '\\}',
  ['$'] = '\\$', ['&'] = '\\&', ['#'] = '\\#', ['%'] = '\\%',
  [' '] = '\\ ', ['_'] = '\\_',
  ['^'] = '\\textasciicircum{}', ['~'] = '\\textasciitilde{}',
  ["'"] = '\\textquotesingle{}', ['`'] = '\\textasciigrave{}',
  -- TeX can break after any explicit hyphen; boxing it leaves only the
  -- break inserted before it.
  ['-'] = '\\mbox{-}',
}

local break_before = '[/._,-]'
local break_after = '[:=]'

local function code(el)
  if not FORMAT:match('latex') or #el.classes > 0 then
    return nil
  end
  local chars = {}
  for _, c in utf8.codes(el.text) do
    chars[#chars + 1] = utf8.char(c)
  end
  local out = {}
  for i, c in ipairs(chars) do
    local before, after = chars[i - 1], chars[i + 1]
    local seam = before and after
      and before:match('[%w]') and after:match('[%w]')
    if seam and c:match(break_before) then
      out[#out + 1] = '\\allowbreak{}'
    end
    out[#out + 1] = escapes[c] or c
    if seam and c:match(break_after) then
      out[#out + 1] = '\\allowbreak{}'
    end
  end
  return pandoc.RawInline('latex', '\\texttt{' .. table.concat(out) .. '}')
end

return {
  {
    traverse = 'topdown',
    Header = function(el) return el, false end,
    Code = code,
  },
}
