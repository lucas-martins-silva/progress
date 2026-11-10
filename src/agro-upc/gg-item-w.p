/********************************************************************************
** Copyright TOTVS S.A. (2018)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-ITEM-W 2.00.00.000 } /*** 010000 ***/

/***********************************************************************
**  Programa...: agro-upc/gg-item-w.p
**  Descricao..: replicar parƒmetros comerciais do grupo de estoque grÆos para o item
**  data.......: out/2018
************************************************************************/

DEFINE PARAM BUFFER b-item     FOR item.
DEFINE PARAM BUFFER b-old-item FOR item.

IF  NEW(b-item) AND
    b-item.ge-codigo <> 0
THEN DO:
    FIND FIRST gg-ext-grup-estoque NO-LOCK
        WHERE  gg-ext-grup-estoque.ge-codigo = b-item.ge-codigo NO-ERROR.

    IF  AVAIL gg-ext-grup-estoque                    AND
              gg-ext-grup-estoque.des-un-preco <> "" AND
             (gg-ext-grup-estoque.tipo-docto = 1      OR /* Tecnologia */
              gg-ext-grup-estoque.tipo-docto = 2)        /* Origina‡Æo */
    THEN DO:
        FIND FIRST gg-param-item NO-LOCK
            WHERE  gg-param-item.it-codigo = b-item.it-codigo NO-ERROR.

        IF  NOT AVAIL gg-param-item
        THEN DO:
            CREATE gg-param-item.
            ASSIGN gg-param-item.it-codigo    = b-item.it-codigo
                   gg-param-item.des-un-preco = gg-ext-grup-estoque.des-un-preco           
                   gg-param-item.dia-mes      = gg-ext-grup-estoque.dia-mes                
                   gg-param-item.log-2        = gg-ext-grup-estoque.log-hedge-moed         
                   gg-param-item.cod-item-ext = gg-ext-grup-estoque.cod-item-ext           
                   gg-param-item.log-1        = gg-ext-grup-estoque.log-control-clas       
                   gg-param-item.log-livre-3  = gg-ext-grup-estoque.log-permite-contrat-bal
                   gg-param-item.log-livre-4  = gg-ext-grup-estoque.log-numer-boleta.
        END. /* IF  NOT AVAIL gg-param-item */
    END. /* IF  AVAIL gg-ext-grup-estoque                    AND */
END. /* IF  NEW(b-item) AND */

RETURN "ok".
