/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*******************************************************************************
**   Programa..: bc8118.i
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Include de temp-tables para Proxy de Acesso a tabela Emitente com
**               CGC para BC
**
**   Autor.....: Denis Roberto Eloterio - FEV/2001
*********************************************************************************/

/**********************************  bc8118.i  **********************************/

Define temp-table ttParamEmitente{1} NO-UNDO
    Field cod-emitente-ini as Integer   Label 'Emitente Inicial'
    Field cod-emitente-fim as Integer   Label 'Emitente Final'
    Field cgc-ini          as Character Label 'CGC Inicial'
    Field cgc-fim          as Character Label 'CGC Final'
    Field nome-emit-ini    as Character Label 'Nome Emitente Inicial'
    Field nome-emit-fim    as Character Label 'Nome Emitente Final'
    Field identific-ini    as Integer   Label 'Identific Inicial'
    Field identific-fim    as Integer   Label 'Identific Final'
    Field cod-aux          as char      label 'Auxilizar' extent 10
    Field acess-mode       as Integer   Label 'Tipo de Acesso'
            /* 0=current,1=First,2=Prev,3=Next,4=Last,5=each 6=PrevN 7=NextN */
    Field num-of-rec       as Integer   Label 'N£mero Registros'  /* only if acess-mode eq 6 or 7 */
    Field record-phrase    as Integer   Label 'Frase Registro'.   /* only if acess-mode eq 5 */

Define temp-table ttEmitente{1} NO-UNDO
    Field cod-emitente     as Integer   Label 'Emitente'
    Field nome-abrev       as Character Label 'Nome Abreviado'
    Field nome-emit        as Character Label 'Nome Emitente'
    Field cgc              as character label 'CGC'
    Field identific        as Integer   Label 'Identific'
    field cod-aux          as char      label 'Auxilizar' extent 10
    Field rowid-value      as Rowid    
        Index cdmtnt cod-emitente
        Index nmbrv  nome-abrev
        Index dntfc  identific
        Index nmmt   nome-emit.

Define Frame fttEmitente{1}
        ttEmitente
        with STREAM-IO.
Define Frame fttParamEmitente{1}
        ttParamEmitente
        with STREAM-IO.

/**********************************  bc8118.i  **********************************/

