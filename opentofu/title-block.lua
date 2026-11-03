-- GitHub shows YAML front matter as a table, so the Markdown gives its subtitle
-- as an emphasised paragraph under the title and its date as the next paragraph.
-- In the PDF, both belong on the title page rather than after the contents.
-- Pandoc promotes the first heading to the title only after filters have run.
function Pandoc(doc)
  local title, subtitle, date = doc.blocks[1], doc.blocks[2], doc.blocks[3]
  if not (title and subtitle and date and title.t == 'Header'
          and subtitle.t == 'Para' and date.t == 'Para'
          and #subtitle.content == 1 and subtitle.content[1].t == 'Emph') then
    return nil
  end
  doc.meta.subtitle = subtitle.content[1].content
  doc.meta.date = date.content
  doc.blocks:remove(2)
  doc.blocks:remove(2)
  return doc
end
