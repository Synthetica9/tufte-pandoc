function Meta(m)
  if pandoc.utils.stringify(m.date) == "today" then
    m.date = os.date("%Y-%m-%d")
  end
  return m
end
