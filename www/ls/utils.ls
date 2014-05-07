ig.utils = utils = {}

utils.abbr =
    \AT : "Rakousko"
    \BE : "Belgie"
    \BG : "Bulharsko"
    \CY : "Kypr"
    \CZ : "Česká republika"
    \DE : "Německo"
    \DK : "Dánsko"
    \EE : "Estonsko"
    \ES : "Španělsko"
    \FI : "Finsko"
    \FR : "Francie"
    \GR : "Řecko"
    \HU : "Maďarsko"
    \IE : "Irsko"
    \IT : "Itálie"
    \LA : "Lotyšsko"
    \LT : "Litva"
    \LU : "Luxembursko"
    \MT : "Malta"
    \NL : "Nizozemí"
    \PL : "Polsko"
    \PT : "Portugalsko"
    \RO : "Rumunsko"
    \SE : "Svédsko"
    \SI : "Slovinsko"
    \SK : "Slovensko"
    \UK : "Anglie"

utils.draw-bg = (baseElement, padding = {}) ->
    bgElement = document.createElement \div
        ..className    = "ig-background"
    ihned = document.querySelector '#ihned'
    if ihned
        that.parentNode.insertBefore bgElement, ihned
    reposition = -> reposition-bg baseElement, bgElement, padding
    reposition!
    setInterval reposition, 1000


reposition-bg = (baseElement, bgElement, padding) ->
    {top} = utils.offset baseElement
    height = baseElement.offsetHeight
    if padding.top
        top += that
        height -= that
    if padding.bottom
        height += that
    bgElement
        ..style.top    = "#{top}px"
        ..style.height = "#{height}px"


utils.offset = (element, side) ->
    top = 0
    left = 0
    do
        top += element.offsetTop
        left += element.offsetLeft
    while element = element.offsetParent
    {top, left}

utils.deminifyData = (minified) ->
    out = for row in minified.data
        row_out = {}
        for column, index in minified.columns
            row_out[column] = row[index]
        for column, indices of minified.indices
            row_out[column] = indices[row_out[column]]
        row_out
    out

utils.draw-bg = (element, padding = {}) ->
    top = element.offsetTop
    height = element.offsetHeight
    if padding.top
        top += that
        height -= that
    if padding.bottom
        height += that

    bg = document.createElement \div
        ..style.top    = "#{top}px"
        ..style.height = "#{height}px"
        ..className    = "ig-background"

    ihned = document.querySelector '#ihned'
    if ihned
        that.parentNode.insertBefore bg, ihned

utils.formatPrice = (price) ->
    price .= toString!
    out = []
    len = price.length
    for i in [0 til len]
        out.unshift price[len - i - 1]
        if 2 == i % 3 and i isnt len - 1
            out.unshift ' '
    out.join ''
