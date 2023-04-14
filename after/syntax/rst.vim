"\ syn match  rstTilde   #:meth:`\zs\~#  conceal
"\ 还得是matchadd来暴力封印
    call matchadd('Conceal' , ':param '                , 100 , -1 , {'conceal':''})
    call matchadd('Conceal' , ':file:'                 , 100 , -1 , {'conceal':''})
    call matchadd('Conceal' , '.. versionadded:: '     , 100 , -1 , {'conceal':''})
    call matchadd('Conceal' , '.. code-block:: python' , 100 , -1 , {'conceal':''})
    call matchadd('Conceal' , ':ref:'                  , 100 , -1 , {'conceal':''})
    call matchadd('Conceal' , ':meth:'                 , 100 , -1 , {'conceal':''})
        "\ syn match  rstMeth   #:meth:#  conceal

    call matchadd('Conceal', '\v:\w+:`\zs\~', 100, -1, {'conceal':''})
    call matchadd('Conceal', '\*\*', 100, -1, {'conceal':''})
    call matchadd('Conceal', ':class:', 100, -1, {'conceal':'קּ'})



syn region  rstDouble_BackTick  concealends matchgroup=conceal  start=/``/ end=/``/
hi link rstDouble_BackTick String

"\ syn region  rstDouble_BackTick  concealends   start=#``# end=#``#
"\ syn region  rstDouble_BackTick concealends matchgroup=conceal  start=#``# end=#``#
"\ conceal contained containedin=rstInlineLiteral
"\ syn match  rstDouble_BackTick   #``#  conceal contained containedin=rstCruft

