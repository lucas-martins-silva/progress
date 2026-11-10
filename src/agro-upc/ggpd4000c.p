/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGPD4000C 2.00.00.007 } /*** "010007" 19/06/2024 15:24:45  ***/



/*****************************************************************************
* Programa: ggpd4000c.p
* Objetivo: No "ENTRY" do qt-pedida atualizar o pre‡o original   
* OBS     : Chamado pela ggpd4000.p
*****************************************************************************/
{utp/ut-glob.i}
DEF NEW GLOBAL SHARED VAR c-nr-pedcli-pd4000      AS CHAR FORMAT "x(15)". 
DEF NEW GLOBAL SHARED VAR c-nome-abrev-pd4000     AS CHAR FORMAT "x(12)". 
DEF NEW GLOBAL SHARED VAR wh-qt-pedida-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-preori-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-tabpre-pd4000     AS HANDLE NO-UNDO.

define variable de-fator as decimal no-undo.

/****************************************************************************/

FIND FIRST gg-ext-ped-venda NO-LOCK
    WHERE gg-ext-ped-venda.nr-pedcli  = c-nr-pedcli-pd4000 
      AND gg-ext-ped-venda.nome-abrev = c-nome-abrev-pd4000 NO-ERROR.
IF  AVAIL gg-ext-ped-venda THEN DO:
    
    FIND FIRST gg-contrato-ant NO-LOCK
        WHERE gg-contrato-ant.ep-codigo    = i-ep-codigo-usuario
          and gg-contrato-ant.cod-contrato = gg-ext-ped-venda.cod-contrato
          and gg-contrato-ant.it-codigo    = wh-it-codigo-pd4000:SCREEN-VALUE no-error. 
    IF  AVAIL gg-contrato-ant THEN DO:
        IF  wh-nr-tabpre-pd4000:SCREEN-VALUE = "":U THEN DO:
            ASSIGN wh-vl-preori-pd4000:SCREEN-VALUE = STRING(gg-contrato-ant.val-preco).
                  
            IF  gg-contrato-ant.des-un <> gg-contrato-ant.des-un-preco THEN DO:
               run ggp/ggapi056.p (input gg-contrato-ant.it-codigo,
                                   input gg-contrato-ant.des-un      ,
                                   input gg-contrato-ant.des-un-preco,
                                   output de-fator).
                    ASSIGN wh-vl-preori-pd4000:SCREEN-VALUE = STRING(DECIMAL(wh-vl-preori-pd4000:SCREEN-VALUE) * de-fator). 
            END.
        END.
    END.
END.








     
