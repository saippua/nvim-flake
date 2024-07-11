local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  -- Snippets
  s({trig="newglossaryentry" }, {
    t({ "\\newglossaryentry{" }),
    i(1, "id"),
    t({ "}", "{", "\tname={" }),
    i(2, "name"),
    t({ "},", "\tdescription={" }),
    i(3, "Description Here."),
    t({ "},", "\tsort={" }),
    i(4, "order"),
    t({ "}", "}" })
  }),
  s({trig="test" }, {
    t({ "Test snipper" })
  })
},
{
  -- Autosnippets
}


