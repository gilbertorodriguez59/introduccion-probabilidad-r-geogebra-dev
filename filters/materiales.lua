local capitulos = {
  ["01-incertidumbre-probabilidad.qmd"]={colab="01-incertidumbre-probabilidad-colab.ipynb",r="01-incertidumbre-probabilidad.Rmd",interactivo="cap01-frecuencia-relativa.html"},
  ["02-espacios-eventos.qmd"]={colab="02-espacios-eventos-colab.ipynb",r="02-espacios-eventos.Rmd",interactivo="cap02-eventos-venn.html"},
  ["03-conteo-probabilidad.qmd"]={colab="03-conteo-probabilidad-colab.ipynb",r="03-conteo-probabilidad.Rmd",interactivo="cap03-conteo.html"},
  ["04-axiomas-probabilidad.qmd"]={colab="04-axiomas-probabilidad-colab.ipynb",r="04-axiomas-probabilidad.Rmd",interactivo="cap04-axiomas.html"},
  ["05-condicional-independencia.qmd"]={colab="05-condicional-independencia-colab.ipynb",r="05-condicional-independencia.Rmd",interactivo="cap05-condicional-independencia.html"},
  ["06-probabilidad-total-bayes.qmd"]={colab="06-probabilidad-total-bayes-colab.ipynb",r="06-probabilidad-total-bayes.Rmd",interactivo="cap06-bayes.html"},
  ["07-variable-aleatoria-cdf.qmd"]={colab="07-variable-aleatoria-cdf-colab.ipynb",r="07-variable-aleatoria-cdf.Rmd",interactivo="cap07-variable-aleatoria-cdf.html"}
}
local function basename(path) return path:match("([^/\\]+)$") or path end
local function material_blocks(cfg)
  local colab="https://colab.research.google.com/github/gilbertorodriguez59/introduccion-probabilidad-r-geogebra-dev/blob/main/notebooks/"..cfg.colab
  local rurl="https://github.com/gilbertorodriguez59/introduccion-probabilidad-r-geogebra-dev/blob/main/cuadernos-r/"..cfg.r
  local inturl="interactivos/"..cfg.interactivo
  local md=string.format([[## Materiales complementarios del capítulo

| Material | Formato | Acceso | Propósito |
|---|---|---|---|
| Cuaderno de Google Colab | Notebook interactivo (R) | [Abrir en Colab](%s) | Ejecutar, modificar y experimentar con los ejemplos computacionales del capítulo. |
| Cuaderno de R | R Markdown | [Abrir cuaderno R](%s) | Reproducir y ampliar los ejemplos en R/RStudio. |
| Interactivo | HTML / GeoGebra | [Abrir recurso](%s) | Explorar visualmente los conceptos centrales del capítulo. |
| Presentación | PDF / PPT | Próximamente | Se incorporará cuando se proporcionen los enlaces. |
| Video | Video | Próximamente | Explicación audiovisual complementaria. |
| Infografía | Imagen / PDF | Próximamente | Síntesis visual de conceptos y fórmulas clave. |

Los **cuadernos de R** acompañan cada capítulo para reproducir, modificar y extender los ejemplos. El cuaderno de Google Colab permite trabajar desde el navegador. Las presentaciones, videos e infografías se enlazarán en esta misma tabla cuando estén disponibles.
]],colab,rurl,inturl)
  return pandoc.read(md,"markdown").blocks
end
function Pandoc(doc)
  if not PANDOC_STATE.input_files or #PANDOC_STATE.input_files==0 then return doc end
  local cfg=capitulos[basename(PANDOC_STATE.input_files[1])]
  if not cfg then return doc end
  local extra=material_blocks(cfg)
  local nuevos={}
  local insertado=false
  for _,b in ipairs(doc.blocks) do
    if not insertado and b.t=="Header" and pandoc.utils.stringify(b.content):lower():match("referencias del capítulo") then
      for _,x in ipairs(extra) do table.insert(nuevos,x) end
      insertado=true
    end
    table.insert(nuevos,b)
  end
  if not insertado then for _,x in ipairs(extra) do table.insert(nuevos,x) end end
  doc.blocks=nuevos
  return doc
end
