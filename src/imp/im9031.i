/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*
**
** IM9031.I - Definicao Temp-tables
**
*/

def temp-table tt-desp NO-UNDO
    field cod-desp  like desp-imp.cod-desp
    field descricao like desp-imp.descricao
    field val-desp  like docum-est-cex.val-desp format ">>>>>,>>>,>>9.99"
    index codigo is unique primary
        cod-desp.
        
/* IM9031.I */        
