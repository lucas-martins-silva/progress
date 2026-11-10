/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI004 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI004 MUT}
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
**   Programa: BCAPI004     - API de verifica‡Æo da rela‡Æo de programas com a 
**                            transa‡Æo
**                                                                       
**   Parametros: tt-param   - Contem o c¢digo do programa que sera verificado na
**                            rela‡Æo de programa com a transa‡Æo e retornar  o
**                            c¢digo da trasa‡Æo
**               tt-erro    - Apos a execucao da API contera  os  possiveis
**                            erros de criacao de transacoes
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (05/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{include/i_dbvers.i}
{cdp/cd0666.i}  /* Definicao da temp-table de erros */
{bcp/bcapi004.i} /* Definicao da temp-table de parametros */

def input-output param table for tt-prog-bc.
def input-output param table for tt-erro.

def temp-table tt-erro-aux NO-UNDO like tt-erro.
def var l-erro as logical init no.

for each tt-prog-bc:
    if  tt-prog-bc.opcao = 1
    then do:
        if  tt-prog-bc.cod-prog-dtsul <> ""
        then do:
            /*** Teste da relacao programa X transa‡Æo ***/
            find first bc-prog-trans
                 where bc-prog-trans.cod_prog_dtsul = tt-prog-bc.cod-prog-dtsul
                   and bc-prog-trans.situacao-trans = yes
                 no-lock no-error.

            if not avail bc-prog-trans then do:
                return "NOK":U.
            end.
            else assign tt-prog-bc.cd-trans = bc-prog-trans.cd-trans.
        end.
        else assign l-erro = yes.
    end.

    find first param-bc no-lock no-error.

    /*** Teste do parametro do cl ***/
    if  not avail param-bc then do:

        {utp/ut-liter.i Parƒmetro_do_Coleta_de_Dados * L}

        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input trim(return-value)).

        create tt-erro.
        assign tt-erro.i-sequen = 1
               tt-erro.cd-erro  = 56
               tt-erro.mensagem = return-value
               l-erro           = yes.
    end.

    /*** Teste da versao de integracao ***/
    if  tt-prog-bc.cod-versao-integracao <> {&Versao-Integracao} then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").

        create tt-erro.
        assign tt-erro.i-sequen = 1
               tt-erro.cd-erro  = 3941
               tt-erro.mensagem = return-value
               l-erro           = yes.
    end.

    /* Procura pelo numero da transa‡Æo */
    if  tt-prog-bc.opcao = 2
    then do:
        if  tt-prog-bc.nr-trans <> 0
        then do:
            find first bc-trans
                 where bc-trans.nr-trans = tt-prog-bc.nr-trans
                 no-lock no-error.

            if  not available(bc-trans) then do:
                {utp/ut-field.i mgcld bc-trans nr-trans 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input trim(return-value)).

                create tt-erro.
                assign tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = return-value
                       l-erro           = yes.
            end.
            else assign tt-prog-bc.cd-trans = bc-trans.cd-trans.
        end.
        else assign l-erro = yes.
    end.

    if  l-erro = yes then undo, next.

    if (   tt-prog-bc.opcao     = 1
        or tt-prog-bc.opcao     = 2
        or tt-prog-bc.opcao     = 3)
    then do:
        if  tt-prog-bc.cd-trans <> ""
        then do:
            /*** Teste do tipo de transacao ***/
            find first bc-tipo-trans
                 where bc-tipo-trans.cd-trans = tt-prog-bc.cd-trans
                 no-lock no-error.

            if  not available(bc-tipo-trans) then do:
                {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input trim(return-value)).


                create tt-erro.
                assign tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = return-value
                       l-erro           = yes.
            end.

            /*** Teste do tipo backflus ***/
            find first bc-tipo-backflush
                 where bc-tipo-backflush.cd-trans = bc-tipo-trans.cd-trans
                 no-lock no-error.

            if  not available(bc-tipo-backflush) then do:
                {utp/ut-field.i mgcld bc-tipo-backflush cd-trans 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input trim(return-value)).
                create tt-erro.
                assign tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = return-value
                       l-erro           = yes.
            end.
        end.
        else assign l-erro = yes.
    end.

    if  l-erro = yes then undo, next.

    assign  tt-prog-bc.cd-trans               = bc-tipo-trans.cd-trans
            tt-prog-bc.descricao              = bc-tipo-trans.descricao
            tt-prog-bc.prog-api-atualizacao   = bc-tipo-trans.api-atualizacao
            tt-prog-bc.prog-altera            = bc-tipo-trans.prog-altera
            tt-prog-bc.prog-etiq              = bc-tipo-trans.prog-etiq
            tt-prog-bc.prog-import            = bc-tipo-trans.prog-import
            tt-prog-bc.prog-criacao           = bc-tipo-trans.prog-criacao
            tt-prog-bc.prog-leitura           = bc-tipo-trans.prog-leitura
            tt-prog-bc.gera-etiq-total        = bc-tipo-trans.gera-etiq-total
            tt-prog-bc.imp-apos-trans         = bc-tipo-trans.imp-apos-trans
            tt-prog-bc.atualiza-on-line       = bc-tipo-trans.atualiza-on-line
            tt-prog-bc.erros-on-line          = bc-tipo-trans.erros-on-line
            tt-prog-bc.atualiz-etiq           = bc-tipo-trans.atualiz-etiq
            tt-prog-bc.baixa-reserva          = bc-tipo-backflush.baixa-reserva
            tt-prog-bc.codigo-rejei           = bc-tipo-backflush.codigo-rejei
            /*inicio altera‡äes projeto - 107*/
            tt-prog-bc.cod-cta-aplic-unif     = bc-tipo-backflush.cod-cta-ctbl-aplic-unif
            tt-prog-bc.cod-ccusto-aplic-unif  = bc-tipo-backflush.cod-ccusto-aplic-unif
            tt-prog-bc.cod-cta-refugo-unif    = bc-tipo-backflush.cod-cta-ctbl-refugo-unif
            tt-prog-bc.cod-ccusto-refugo-unif = bc-tipo-backflush.cod-ccusto-refugo-unif
            /*fim altera‡äes projeto - 107*/
            tt-prog-bc.motivo-backflush       = bc-tipo-backflush.motivo-backflush
            tt-prog-bc.muda-status            = bc-tipo-backflush.muda-status
            tt-prog-bc.nome-dir-etiq          = param-bc.nome-dir-etiq.


    if  avail bc-prog-trans then
        assign  tt-prog-bc.cod-prog-dtsul         =  bc-prog-trans.cod_prog_dtsul.

    if  avail bc-trans then do:
        assign  tt-prog-bc.data                   = bc-trans.data
                tt-prog-bc.data-atualizacao       = bc-trans.data-atualizacao
                tt-prog-bc.detalhe                = bc-trans.detalhe
                tt-prog-bc.ep-codigo              = bc-trans.ep-codigo
                tt-prog-bc.estado-trans           = bc-trans.estado-trans
                tt-prog-bc.etiq-impressa          = bc-trans.etiq-impressa
                tt-prog-bc.hora-atualizacao       = bc-trans.hora-atualizacao
                tt-prog-bc.horario                = bc-trans.horario
                &if "{&mgcld_version}" < "2.04" &then
                    tt-prog-bc.log-1                  = bc-trans.log-1.
                &else
                    tt-prog-bc.log-1         = IF bc-trans.ind-tipo-trans = 1 THEN YES ELSE NO.
                &ENDIF
    end.
end.

find first tt-erro no-error.

if  available(tt-erro) then
    return "NOK".
else
    return "OK".
