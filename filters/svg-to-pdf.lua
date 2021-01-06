-- http://lua-users.org/wiki/StringRecipes
local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

if FORMAT:match 'latex' then
  function Image(elem)
    local src = elem.src
    if ends_with(src, '.svg') then
      elem.src = src .. '.pdf'
    end
    return elem
  end
end
