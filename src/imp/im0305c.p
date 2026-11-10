/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0305C 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0305C MIM}
&ENDIF

/*****************************************************************************
**
**  IM0305C - Integracao Importacao Compras
**
**  Objetivo: Atualiza Ordem
**
*****************************************************************************/

DEF INPUT PARAMETER prOrdem AS ROWID NO-UNDO.

{cdp/cdcfgmat.i} /* defini‡Æo pre-processador importa‡Æo */

FOR FIRST ordem-compra 
    WHERE ROWID(ordem-compra) = prOrdem EXCLUSIVE-LOCK:
    &IF DEFINED(bf-mat-comex) &THEN 
    &ELSE
        ASSIGN ordem-compra.ordem-emitida = YES.
    &ENDIF
END.
