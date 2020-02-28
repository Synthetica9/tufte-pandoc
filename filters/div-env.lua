hrule = pandoc.HorizontalRule()

local function elem(xs, x, eq)
  eq = eq or function (a, b)
     return a == b
  end
  for k, v in pairs(xs) do
    if eq(v, x) then
      return k
    end
  end
end

-- https://forums.coronalabs.com/topic/61784-function-for-reversing-table-order/
local function reverse (arr)
  local i, j = 1, #arr

  while i < j do
    arr[i], arr[j] = arr[j], arr[i]

    i = i + 1
    j = j - 1
  end
end

local function extract_caption(blocks)
  local blocks_copy = {table.unpack(blocks)}
  reverse(blocks_copy)

  local idx = elem(blocks_copy, hrule, pandoc.utils.equals)

  if idx == nil then
    return
  end

  idx = #blocks - idx + 1

  local caption = {}

  for i = idx+1,#blocks do
    table.insert(caption, table.remove(blocks))
  end

  table.remove(blocks) -- remove hrule

  reverse(caption)

  caption = pandoc.utils.blocks_to_inlines(caption, {pandoc.Space()})

  return pandoc.Para({
    pandoc.RawInline("latex", "\\caption{"),
    pandoc.Span(caption),
    pandoc.RawInline("latex", "}")
  })
end

local function divEnv(div, keyword, env)
  local included = elem(div.classes, keyword)
  if included then
    print("Transforming div " .. keyword .. " to env " .. env)
    local caption = extract_caption(div.content)
    if caption == nil then
        caption = pandoc.Null()
    end
    print(pandoc.utils.stringify(caption))
    return pandoc.Div({
      pandoc.RawBlock("latex", "\\begin{" .. env .. "}"),
      pandoc.Div(div.content),
      caption,
      pandoc.RawBlock("latex", "\\end{" .. env .. "}")
    })
  end
end

local function setConversions(meta)
  divConversions = meta["div-conversions"] or {}
  codeConversions = meta["code-conversions"] or {}
end

local function transformDivs(div)
  for k, v in pairs(divConversions) do
    local trans = divEnv(div, k, pandoc.utils.stringify(v))
    if trans ~= nil then
      return trans
    end
  end
  return div
end

local function transformCodeBlocks(code)
  for k, v in pairs(code.classes) do
    env = codeConversions[v]
    if env ~= nil then
      env = pandoc.utils.stringify(env)
      return pandoc.RawBlock("latex",
        "\\begin{" .. env .. "}\n" ..
        code.text ..
        "\\end{" .. env .. "}"
      )
    end
  end
end


return {
  { Meta = setConversions },
  {
    Div = transformDivs,
    CodeBlock = transformCodeBlocks,
  },
}
