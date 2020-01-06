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
