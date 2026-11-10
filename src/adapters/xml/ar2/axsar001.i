/*
** valores de ggf 
*/

    run addNode in hGenXml ({2}, "Values":U, "", output iValuesId).
                                       
    run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 1                         , output iId).
    run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-mat.valor-ggf-{1}[1], output iId).

    if  param-estoq.tem-moeda1 then do:
        run addNode in hGenXml ({2}, "Values":U, "", output iValuesId).

        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 2                         , output iId).
        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-mat.valor-ggf-{1}[2], output iId).
    end.

    if  param-estoq.tem-moeda2 then do:
        run addNode in hGenXml ({2}, "Values":U, "", output iValuesId).

        run addNodeDec in hGenXml (iValuesId, "Sequence":U     , 3                         , output iId).
        run addNodeDec in hGenXml (iValuesId, "OverHeadValue":U, movto-mat.valor-ggf-{1}[3], output iId).
    end.
