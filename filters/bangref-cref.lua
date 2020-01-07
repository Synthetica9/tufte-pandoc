function Str(str)
  local start, excls, ref, finish = string.match(str.text, "^(.*)%[(%!+)(.+)%](.*)$")

  if not ref then return end

  local origRef = ref
  ref = string.lower(ref)

  local latex = ""
  if excls == "!" then
    print("transforming " .. ref .. " to cleverref")

    local isUpper = string.match(origRef, "^%u")

    local cref = "cref"
    if isUpper then
        cref = "Cref"
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
