/*******************************************************************************
**
**   BH0102.I -  Atualiza workfile w-per - Transf. Movimento para Historico
**
*******************************************************************************/
find first w-per where
           w-per.i-emp = i-empresa and
           w-per.c-mod = "{1}" no-error.
if  not avail w-per then do:
    create w-per.
    assign w-per.i-emp  = i-empresa
           w-per.c-mod  = "{1}"
           w-per.da-per = date(month({2}),01,year({2})) - 1. 
end.

if  w-per.da-per > {2} then do:
    assign w-per.da-per = date(month({2}),01,year({2})) - 1 .
end.    

/* fim */



