/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI012 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI012 MUT}
&ENDIF


/*************************************************************************************************************
** Programa: API012
** Objetivo: Esta api retorna os registros da tabela bc-trans conforme parametrizado
*************************************************************************************************************/
{bcp/bcapi012.i}    /* defini‡Æo  temp-table tt_bc_trans tt_param   */
{include/i_dbtype.i}

def input       param       table for tt_param.
def output      param       table for tt_bc_trans.
def variable    rw-trans    as raw      no-undo.

find first tt_param no-lock no-error.

if  not avail tt_param then return "NOK".

case tt_param.opcao:
    when 1 then     /*  Nr.Transacao            */
    do:
        if  tt_param.nr-transacao = 0
        then return "NOK".

        find first bc-trans
             where bc-trans.nr-trans = tt_param.nr-transacao
             no-lock no-error.
        if  avail bc-trans
        then do:
            run Pi-Assign.
        end.
    end.
    when 2 then     /*  Cod.Transacao           */
    do:
        if  tt_param.cd-transacao = ""
        then return "NOK".

        for  each bc-trans no-lock
            where bc-trans.cd-trans = tt_param.cd-transacao:

            run Pi-Assign.

        end.
    end.
    when 3 then     /*  String Campo Detalhe    */
    do:
        if  tt_param.detalhe = ""
        then return "NOK".

        for  each bc-trans no-lock
            where ( &IF "{&mgcld_dbtype}" = "PROGRESS"
                    &THEN bc-trans.detalhe contains(tt_param.detalhe)
                    &ELSE bc-trans.detalhe MATCHES "*" + trim(tt_param.detalhe) + "*"
                    &ENDIF):

            run Pi-Assign.

        end.
    end.
    when 4 then     /*  Todos os Dados  */
    do:
        for  each bc-trans no-lock
            where bc-trans.cd-trans >= tt_param.cd-trans-ini
              and bc-trans.cd-trans <= tt_param.cd-trans-fim
              and bc-trans.nr-trans >= tt_param.nr-trans-ini
              and bc-trans.nr-trans <= tt_param.nr-trans-fim
              and bc-trans.data     >= tt_param.data-ini
              and bc-trans.data     <= tt_param.data-fim
              and bc-trans.horario  >= tt_param.hora-ini
              and bc-trans.horario  <= tt_param.hora-fim
              and bc-trans.usuario  >= tt_param.usuario-ini
              and bc-trans.usuario  <= tt_param.usuario-fim:

            run Pi-Assign.

        end.
    end.
    OTHERWISE return "NOK".
END.
return "OK".

/************************************************************************************************************/
Procedure Pi-Assing:
    create  tt_bc_trans.
    buffer-copy bc-trans except bc-trans.conteudo-trans to tt_bc_trans.
    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
        assign  rw-trans = bc-trans.conteudo-trans.
    &ELSE
        /**** TRATAMENTO PARA BASES DE DADOS NÇO PROGRESS ****/
        run btb/btb928za.p (input bc-trans.conteudo-trans, output rw-trans) no-error.
    
        if (  (    error-status:error
               or  error-status:get-number(1) <> 0)
            and error-status:get-number(1) <> 138
            and error-status:get-number(1) <> 91)
        or  return-value = "NOK"
        then do:
            {utp/ut-field.i mgcld bc-trans conteudo-trans 1}
            run utp/ut-msgs.p ( input "SHOW",
                                input 18895,
                                input return-value + " (RAW)").
    
            return "NOK".
         end.
    &ENDIF
    assign  tt_bc_trans.conteudo-trans = rw-trans.

END PROCEDURE.
