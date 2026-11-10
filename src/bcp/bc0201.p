/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0201 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0201 MBC}
&ENDIF



run utp/ut-msgs.p (input "show", 
                   input 31681,
                   INPUT "").
RETURN "OK":U.

/******************************************************************************
**
**     Copyright 1996 Datasul S.A. - All rights reserved.
**
**     Programa...: BC0201.P
**
**     Finalidade.: Transactions Main Menu - RF mode emulating terminal
**
**     Criado em..: Junho de 1996
**
**     Versao.....: A.00 Datasul-EMS
**                  01.00.00 - Datasul-EMS 2.00 - Gustavo
**
******************************************************************************/
&if "~{&WINDOW-SYSTEM~}" <> "TTY" &then
    run utp/ut-msgs.p (input "show",
                       input 7891,
                       input "").
    return.
&endif

def var c-coletor   like bc-coletor.id-coletor.
{cep/ce9220.i2}     /* verifica o ambiente de trabalho UNIX, DOS... */
{bcp/bcapi006.i}    /* definicao da temp-table coletor              */
{cdp/cd0666.i}      /* definicao da temp-table de erro              */

do trans on error undo, return:
    for each tt-erro:
        delete tt-erro.
    end.
    for each tt-coletor:
        delete tt-coletor.
    end.
    create  tt-coletor.
    assign  tt-coletor.cod-versao-integracao = 1
            tt-coletor.usuario               = c-user.

    run bcp/bcapi006.p (input-output table tt-coletor,
                        input-output table tt-erro).

    find first tt-erro no-lock no-error.
    if avail tt-erro then do:
        put screen color message row 8 col 1 string(tt-erro.mensagem,"X(16)").
        pause 2 no-message.
        hide all no-pause.
        undo, return.
    end.
    find first tt-coletor no-lock no-error.
    assign c-coletor = tt-coletor.coletor.
end.

def var c-ems    as char format "X(16)" no-undo.
def var c-saida  as char format "X(05)" no-undo.
def var c-transf as char format "X(13)" no-undo.
def var c-rep    as char format "X(12)" no-undo.
def var c-rep-it as char format "X(13)" no-undo.
def var c-cont   as char format "X(12)" no-undo.
def var c-opc    as char format "X(05)" no-undo.
def var c-tempo  as char format "X(06)" no-undo.
def var c-requis as char format "X(10)" no-undo.

status input off.    

{utp/ut-liter.i Datasul-EMS * r}
assign c-ems = return-value.
{utp/ut-liter.i Saida_ * r}
assign c-saida = return-value.
{utp/ut-liter.i Transferencia_ * r}
assign c-transf = return-value.
{utp/ut-liter.i Rep_Producao_ * r}
assign c-rep = return-value.
{utp/ut-liter.i Rep_Repetitivo * r}
assign c-rep-it = return-value.
{utp/ut-liter.i Cont_Estoque_ * r}
assign c-cont = return-value.
{utp/ut-liter.i Opcao_ * r}
assign c-opc = trim(return-value).
{utp/ut-liter.i Aguarde * r}
assign c-tempo = return-value.
{utp/ut-liter.i Requisicao_ * r}
assign c-requis = return-value.

opcao:
repeat on error undo, leave on stop undo, leave:
    put screen color message row 1 col 1 string(c-ems,"x(16)").
    put screen row 2 column 1 "0-" + c-saida.
    put screen row 3 column 1 "1-" + c-transf.
    put screen row 4 column 1 "2-" + c-rep.
    put screen row 5 column 1 "3-" + c-rep-it.
    put screen row 6 column 1 "4-" + c-cont.
    put screen row 7 column 1 "5-" + c-requis.
    put screen row 8 column 1 c-opc + ":".
    repeat:        
        readkey.
        if keyfunction(lastkey) = 'end-error' 
        or keyfunction(lastkey) = '0' then
            leave opcao.
        if keyfunction(lastkey) > '6' then do:
            bell.
            next.
        end.
        put screen row 8 column 9 color message string(c-tempo,"x(7)").
        case keyfunction(lastkey):
            when '1' then
                run cep/ce9225.p.
            when '2' then
                run cpp/cp9270.p.
            when '3' then
                run cpp/cp9276.p.
            when '4' then
                run cep/ce9220.p.
            when '5' then
                run cpp/cp9272.p.
        end.
        hide all.
        leave.
    end.
end.

do trans:
    find bc-coletor where
         bc-coletor.id-coletor = c-coletor EXCLUSIVE-LOCK NO-ERROR.
    release bc-coletor.
end.

/* fim do programa */


