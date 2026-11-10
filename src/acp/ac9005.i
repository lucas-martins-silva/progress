/* ac9005.i */
find b-base-cota where
     b-base-cota.cod-estabel = c-cod-estabel and
     b-base-cota.cd-produto  = c-cd-produto and
     b-base-cota.dt-inicial  = da-dt-inicial 
     no-lock no-error.


if  avail b-base-cota then 
    assign de-valor-base = b-base-cota.qt-prevista.
else
    assign l-erro-base-cota = yes.

if  {&cond-base-cota}  then do:
    assign l-utiliza-base-cota = yes.
end.

