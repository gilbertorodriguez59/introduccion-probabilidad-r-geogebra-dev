local capitulos = {
  ["incertidumbre y probabilidad"]={colab="01-incertidumbre-probabilidad-colab.ipynb",r="01-incertidumbre-probabilidad.Rmd",interactivo="cap01-frecuencia-relativa.html"},
  ["conjuntos, espacios muestrales y eventos"]={colab="02-espacios-eventos-colab.ipynb",r="02-espacios-eventos.Rmd",interactivo="cap02-eventos-venn.html"},
  ["técnicas de conteo y enumeración"]={colab="03-conteo-probabilidad-colab.ipynb",r="03-conteo-probabilidad.Rmd",interactivo="cap03-conteo.html"},
  ["axiomas y propiedades de la probabilidad"]={colab="04-axiomas-probabilidad-colab.ipynb",r="04-axiomas-probabilidad.Rmd",interactivo="cap04-axiomas.html"},
  ["probabilidad condicional e independencia"]={colab="05-condicional-independencia-colab.ipynb",r="05-condicional-independencia.Rmd",interactivo="cap05-condicional-independencia.html"},
  ["particiones, probabilidad total y teorema de bayes"]={colab="06-probabilidad-total-bayes-colab.ipynb",r="06-probabilidad-total-bayes.Rmd",interactivo="cap06-bayes.html"},
  ["variable aleatoria y función de distribución acumulada"]={colab="07-variable-aleatoria-cdf-colab.ipynb",r="07-variable-aleatoria-cdf.Rmd",interactivo="cap07-variable-aleatoria-cdf.html"},
  ["variables aleatorias discretas y función de masa de probabilidad"]={colab="08-variables-discretas-pmf-colab.ipynb",r="08-variables-discretas-pmf.Rmd",interactivo="cap08-pmf-cdf.html"},
  ["variables aleatorias continuas y función de densidad"]={colab="09-variables-continuas-densidad-colab.ipynb",r="09-variables-continuas-densidad.Rmd",interactivo="cap09-densidad-area.html"}
}

local function chapter_title(doc)
  for _, b in ipairs(doc.blocks) do
    if b.t == "Header" and b.level == 1 then
      return pandoc.utils.stringify(b.content):lower()
    end
  end
  return nil
end

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
  local titulo = chapter_title(doc)
  local cfg = titulo and capitulos[titulo] or nil
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
  if not insertado then
    for _,x in ipairs(extra) do table.insert(nuevos,x) end
  end
  doc.blocks=nuevos
  return doc
end
