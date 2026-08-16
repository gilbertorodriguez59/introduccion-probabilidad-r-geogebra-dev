from pathlib import Path

path = Path('15-variables-conjuntas-marginales-condicionales.qmd')
texto = path.read_text(encoding='utf-8')

# Corregir integrate(): la función debe devolver un vector de la misma longitud que x.
texto = texto.replace(
    'p2 <- integrate(function(x) 2*0.3, 0.3, 0.8)$value',
    'p2 <- integrate(function(x) rep(2*0.3, length(x)), 0.3, 0.8)$value'
)

# Normalizar la jerarquía: sólo el título del capítulo queda como H1.
lineas = texto.splitlines()
salida = []
primer_h1 = True
for linea in lineas:
    if linea.startswith('# '):
        if primer_h1:
            salida.append(linea)
            primer_h1 = False
        else:
            salida.append('#' + linea)
    else:
        salida.append(linea)

path.write_text('\n'.join(salida) + '\n', encoding='utf-8')
print('Capítulo 15 corregido: integrate() vectorizado y jerarquía de encabezados normalizada.')
