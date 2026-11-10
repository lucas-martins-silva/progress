/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI005 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi005 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1998)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*************************************************************************
**
**   Programa: BCAPI005         - API de Valida‡Æo do Tipo de Codigo do Item
**                                                                       
**   Parametros: tt-cod-unico   - Contem o c¢digo do item digitado
**
**               tt-erro        - Apos a execucao da API contera os possiveis
**                                erros na verifica‡Æo do codigo do item
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (05/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{cdp/cd0666.i}      /* Definicao da temp-table de erros     */
{bcp/bcapi005.i}    /* Definicao da temp-table de cod-unico */

{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

def var l-erro as logical init no.

def input-output param table for tt-cod-unico.
def input-output param table for tt-erro.
def temp-table tt-erro-aux NO-UNDO like tt-erro.

find first tt-cod-unico no-lock no-error.
if avail tt-cod-unico then do:
    if  tt-cod-unico.opcao = 1
    then do:
        /*** Teste da versao de integracao ***/
        if  tt-cod-unico.cod-versao-integracao <> {&Versao-Integracao} then do:
            run utp/ut-msgs.p (input "msg",
                               input 3941,
                               input "").
            create tt-erro.
            assign tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 3941
                   tt-erro.mensagem = return-value
                   l-erro = yes.
        end.
        /*** Teste Tipo de Codigo do Item ***/
        find first param-bc no-lock no-error.

        if  (param-bc.int-1 = 1) then do:          /* Codigo Unico */
            find bc-ext-saldo-estoq where 
                 bc-ext-saldo-estoq.cod-unico = tt-cod-unico.it-codigo
                 no-lock no-error.

            if   not available bc-ext-saldo-estoq then do:
                run utp/ut-msgs.p (input "msg",
                                   input 4144,
                                   input "").
                create tt-erro.
                assign tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 4144
                       tt-erro.mensagem = return-value
                       l-erro = yes.
            end.
            else
                 assign tt-cod-unico.cod-estabel    = bc-ext-saldo-estoq.cod-estabel
                        tt-cod-unico.it-codigo      = bc-ext-saldo-estoq.it-codigo
                        tt-cod-unico.cod-depos      = bc-ext-saldo-estoq.cod-depos
                        tt-cod-unico.cod-localiz    = bc-ext-saldo-estoq.cod-localiz
                        tt-cod-unico.lote           = bc-ext-saldo-estoq.lote
                        tt-cod-unico.cod-unico      = bc-ext-saldo-estoq.cod-unico.
        end.
        if  (param-bc.int-1 = 2) then do:          /* Codigo It-codigo */

            run pi-verifica-item ( input tt-cod-unico.it-codigo,
                                   input tt-cod-unico.it-codigo,
                                   input 0,   /* Tipo de Acesso 0=Currente .... */
                                   input 1).
            if  avail ttReturnMessages
            then do:
                run utp/ut-msgs.p (input "msg",
                                   input 4144,
                                   input "").
                create tt-erro.
                assign tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 4144
                       tt-erro.mensagem = return-value
                       l-erro = yes.
            end.
            else
                 assign tt-cod-unico.cod-estabel    = ttItem.cod-estabel
                        tt-cod-unico.it-codigo      = ttItem.it-codigo
                        tt-cod-unico.cod-depos      = ""
                        tt-cod-unico.cod-localiz    = ""
                        tt-cod-unico.lote           = ""
                        tt-cod-unico.cod-unico      = "".
        end.
        if  (param-bc.int-1 = 3) then do:
            find bc-ext-saldo-estoq where 
                 bc-ext-saldo-estoq.cod-unico = tt-cod-unico.it-codigo
                 no-lock no-error.

            if   available bc-ext-saldo-estoq then
                 assign tt-cod-unico.cod-estabel    = bc-ext-saldo-estoq.cod-estabel
                        tt-cod-unico.it-codigo      = bc-ext-saldo-estoq.it-codigo
                        tt-cod-unico.cod-depos      = bc-ext-saldo-estoq.cod-depos
                        tt-cod-unico.cod-localiz    = bc-ext-saldo-estoq.cod-localiz
                        tt-cod-unico.lote           = bc-ext-saldo-estoq.lote
                        tt-cod-unico.cod-unico      = bc-ext-saldo-estoq.cod-unico.
            else do:
                run pi-verifica-item ( input tt-cod-unico.it-codigo,
                                       input tt-cod-unico.it-codigo,
                                       input 0,   /* Tipo de Acesso 0=Currente .... */
                                       input 1).
                if  avail ttReturnMessages
                then do:
                    run utp/ut-msgs.p (input "msg",
                                       input 4144,
                                       input "").
                    create tt-erro.
                    assign tt-erro.i-sequen = 1
                           tt-erro.cd-erro  = 4144
                           tt-erro.mensagem = return-value
                           l-erro = yes.
                     end.
                 else
                     assign tt-cod-unico.cod-estabel    = ttItem.cod-estabel
                            tt-cod-unico.it-codigo      = ttItem.it-codigo
                            tt-cod-unico.cod-depos      = ""
                            tt-cod-unico.cod-localiz    = ""
                            tt-cod-unico.lote           = ""
                            tt-cod-unico.cod-unico      = "".
            end.
        end.
    end.
    if  tt-cod-unico.opcao = 2
    then do:
        find first bc-ext-saldo-estoq
             where bc-ext-saldo-estoq.cod-depos   = tt-cod-unico.cod-depos
               and bc-ext-saldo-estoq.cod-estabel = tt-cod-unico.cod-estabel
               and bc-ext-saldo-estoq.cod-localiz = tt-cod-unico.cod-localiz
               and bc-ext-saldo-estoq.lote        = tt-cod-unico.lote
               and bc-ext-saldo-estoq.it-codigo   = tt-cod-unico.it-codigo
             no-lock no-error.
        if  avail bc-ext-saldo-estoq then
            assign  tt-cod-unico.cod-unico = bc-ext-saldo-estoq.cod-unico.
        else
            assign l-erro = yes.
    end.
    if  tt-cod-unico.opcao = 3
    then do:
        find first bc-ext-saldo-estoq
             where rowid(bc-ext-saldo-estoq) = tt-cod-unico.rowid-bc
             no-lock no-error.
        if  avail bc-ext-saldo-estoq then do:
            assign  tt-cod-unico.cod-estabel    = bc-ext-saldo-estoq.cod-estabel
                    tt-cod-unico.it-codigo      = bc-ext-saldo-estoq.it-codigo
                    tt-cod-unico.cod-depos      = bc-ext-saldo-estoq.cod-depos
                    tt-cod-unico.cod-localiz    = bc-ext-saldo-estoq.cod-localiz
                    tt-cod-unico.lote           = bc-ext-saldo-estoq.lote
                    tt-cod-unico.cod-unico      = bc-ext-saldo-estoq.cod-unico.
        end.
        else assign l-erro = yes.
    end.

    if  l-erro = yes then undo, next.
end.

find first tt-erro no-error.
if  available(tt-erro) then
    return "NOK".
else
    return "OK".
