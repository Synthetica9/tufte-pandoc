function Div(div)
  if div.identifier == "refs" then
    for i, block in ipairs(div.content) do
      block.content = {
        pandoc.RawBlock("latex", "\\parbox{\\linewidth}{"),
        table.unpack(block.content),
        pandoc.RawBlock("latex", "} \\smallskip"),
      }
    end
    return div
  end
end
