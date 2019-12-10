-- https://stackoverflow.com/a/33511182
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function divEnv(div, keyword, env)
  print("trying for " .. keyword .. ":" .. env )
  included = has_value(div.classes, keyword)
  print(type(div.classes))
  if included then
    print("Transforming div " .. keyword .. " to env " .. env)
    return pandoc.Div({
      pandoc.RawBlock("latex", "\\begin{" .. env .. "}"),
      div,
      pandoc.RawBlock("latex", "\\end{" .. env .. "}")
    })
  end
end

function Div(div)
  tab = {
    figure="figure",
    sidebar="marginfigure",
    marginfigure="marginfigure",
    widefigure="figure*"
  }
  for k, v in pairs(tab) do
    trans = divEnv(div, k, v)
    if trans ~= nil then
      return trans
    end
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
