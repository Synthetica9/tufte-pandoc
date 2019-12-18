function Meta(m)
  if pandoc.utils.stringify(m.date) == "today" then
    m.date = os.date("%Y-%m-%d")
  end
  return m
end

function Div(div)
  if div.identifier == "outer-refs" then
    for _, block in pairs(div.content) do
      if block.identifier == "refs" then
        len = #block.content
        has_content = #block.content > 0
      end
    end

    if not has_content then
      print("Dropping Bibliography, it is empty.")
      return pandoc.Div({})
    end
  end
end
