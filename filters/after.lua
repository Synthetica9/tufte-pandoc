function Div(div)
  _, index = div.classes.find("sidebar")
  if index then
    print("Transforming sidebar into sidebarfigure")
    return pandoc.Div({
      pandoc.RawBlock("latex", "\\begin{marginfigure}"),
      div,
      pandoc.RawBlock("latex", "\\end{marginfigure}")
    })

  end
end

function Str(str)
  start, ref, finish = string.match(str.text, "^(.*)%[%!(.+)%](.*)$")
  if not ref then return end

  print("transforming " .. ref .. " to cleverref")
  isUpper = string.match(ref, "^%u")

  if isUpper then
    cref = "Cref"
  else
    cref = "cref"
  end
  ref = string.lower(ref)

  return pandoc.Span({
    pandoc.Str(start),
    pandoc.RawInline("latex", "\\" .. cref .. "{" .. ref .. "}"),
    pandoc.Str(finish)
  })
end
