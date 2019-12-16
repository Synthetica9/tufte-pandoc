function Str(str)
  start, excls, ref, finish = string.match(str.text, "^(.*)%[(%!+)(.+)%](.*)$")

  if not ref then return end

  origRef = ref
  ref = string.lower(ref)

  if excls == "!" then
    print("transforming " .. ref .. " to cleverref")

    isUpper = string.match(origRef, "^%u")

    if isUpper then
        cref = "Cref"
    else
        cref = "cref"
    end

    latex = "\\" .. cref .. "{" .. ref .. "}"
  else
    if excls == "!!" then
        print("transforming " .. ref .. " to label")
        latex = "\\label{" .. ref .. "}";
    else
        return
    end
  end

  return pandoc.Span({
    pandoc.Str(start),
    pandoc.RawInline("latex", latex),
    pandoc.Str(finish)
  })
end

-- https://stackoverflow.com/a/33511182
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function latexInline(s)
    return pandoc.RawInline("latex", s)
end

function latexBlock(s)
    return pandoc.RawBlock("latex", s)
end

function extract_caption(blocks)
    dlist = blocks[1]
    if dlist.t ~= "DefinitionList" then
        return nil
    end
    fst = dlist.content[1]

    if fst == nil then
        return nil
    end
    table.remove(dlist.content, 1)

    label_arg = {}
    table.insert(label_arg, latexInline("\\label{"))
    for _, v in ipairs(fst[1]) do
        table.insert(label_arg, v)
    end
    table.insert(label_arg, latexInline("}"))

    label = pandoc.Para(label_arg)

    caption_text = {latexBlock("\\caption{")}
    for _, v in ipairs(fst[2]) do
        table.insert(caption_text, pandoc.Div(v))
    end
    table.insert(caption_text, latexBlock("}"))


    caption = pandoc.Div {
        pandoc.Para(pandoc.utils.blocks_to_inlines(caption_text, {pandoc.Space()})),
        label,
    }

    return caption
end


function divEnv(div, keyword, env)
  included = has_value(div.classes, keyword)
  if included then
    print("Transforming div " .. keyword .. " to env " .. env)
    caption = extract_caption(div.content)
    if caption == nil then
        caption = pandoc.Div({})
    end
    return pandoc.Div({
      pandoc.RawBlock("latex", "\\begin{" .. env .. "}"),
      pandoc.Div(div.content),
      caption,
      pandoc.RawBlock("latex", "\\end{" .. env .. "}")
    })
  end
end

function Div(div)
  tab = {
    figure="figure",
    sidebar="marginfigure",
    marginfigure="marginfigure",
    widefigure="figure*",
    twocolumn="widetwocolumn",
  }
  for k, v in pairs(tab) do
    trans = divEnv(div, k, v)
    if trans ~= nil then
      return trans
    end
  end
end
