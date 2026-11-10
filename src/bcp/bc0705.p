/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0705 2.00.00.014}  /*** "010014" ***/
/********************************************************************************
** Programa: BC0705.P
** Esta API recebe do RPW o buffer do pedido de execuá∆o e a partir dele procura
** a agenda_rpw
*******************************************************************************/

{bcp/bc0204.i}
{include/i_dbtype.i}

def parameter buffer b-ped-exec for ped_exec.

DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario   AS CHARACTER    NO-UNDO.

def var rw-agenda_rpw as rowid  no-undo.
def var c-erro        as char   no-undo.
def var raw-temp      as raw    no-undo.
def var i-erro        as int    no-undo.
def var c-mensagem    as char   no-undo.
DEF VAR i-tp-atualiz  AS INT    no-undo.
DEF VAR h-convert     AS HANDLE no-undo.

FUNCTION stringToAsc RETURNS INTEGER (INPUT pParam AS CHARACTER) IN h-convert.

find ped_exec_param of b-ped-exec no-lock no-error.
if  avail ped_exec_param then do:

    RUN utp/utConvertCdnTransEdi.p PERSISTENT SET h-convert.     

    create tt-param.
    &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
        raw-transfer ped_exec_param.raw_param_ped_exec to tt-param.
    &ELSE
        run btb/btb928za.p (input  ped_exec_param.raw_param_ped_exec,
                            output raw-temp) no-error.

        if ((   error-status:error
             or error-status:get-number(1) <> 0)
            and error-status:get-number(1) <> 138)
        or return-value = "NOK" then do:
            assign i-erro     = error-status:get-number(1)
                   c-mensagem = error-status:get-message(1).
                   
            if return-value = "NOK" then do:
                {utp/ut-liter.i "Permiss∆o do Diret¢rio Tempor†rio" * L}
                assign c-mensagem = trim(return-value)
                       i-erro     = os-error.
            end.
            
            {utp/ut-liter.i "de Convers∆o do Campo RAW" * L}
            run utp/ut-msgs.p (input "msg",
                               input 15837,
                               input trim(return-value) + " - (" + c-mensagem + " : " + string(i-erro) + ")").
            
            assign c-erro = "15837 - " + trim(return-value).
            return c-erro.
        end.
        else        
            raw-transfer raw-temp to tt-param.
    &ENDIF
    
    if b-ped-exec.cod_prog_dtsul = "bc0204" THEN DO:
        IF  tt-param.tp-movto = YES
        AND tt-param.tp-etiqueta = YES THEN
            ASSIGN i-tp-atualiz = 0.
        ELSE
            IF tt-param.tp-movto = YES THEN
                ASSIGN i-tp-atualiz = 1.
            ELSE
                IF tt-param.tp-etiqueta = YES THEN
                    ASSIGN i-tp-atualiz = 2.
    END.
    ELSE
        ASSIGN i-tp-atualiz = 0.

    /*** find procurando agenda da empresa 0 (isto para agenda j† existente para monoempresas) ***/

    find agenda_rpw where
         agenda_rpw.cdn_modul_refer = 2                     and
         agenda_rpw.cod_trans_cld   = tt-param.tp-trans-ini and
         agenda_rpw.log_sit_rpw     = yes                   and
         agenda_rpw.num_parcei_edi  = i-tp-atualiz          and
         agenda_rpw.cdn_trans_edi   = 0                     and /* empresa */
         agenda_rpw.cdn_operac      = (if b-ped-exec.cod_prog_dtsul = "bc0204"
                                       then 1 else 2)
         no-lock no-error.

    /*** Caso n∆o seja encontrado com empresa 0, ser† verificado a empresa do usu†rio do pedido exec ***/    

    if  not avail agenda_rpw then 
        find agenda_rpw where
             agenda_rpw.cdn_modul_refer = 2                                and
             agenda_rpw.cod_trans_cld   = tt-param.tp-trans-ini            and
             agenda_rpw.log_sit_rpw     = yes                              and
             agenda_rpw.num_parcei_edi  = i-tp-atualiz                     and
             agenda_rpw.cdn_trans_edi   = stringToAsc(i-ep-codigo-usuario) and /* empresa */
             agenda_rpw.cdn_operac      = (if b-ped-exec.cod_prog_dtsul = "bc0204"
                                           then 1 else 2)
             no-lock no-error.

    DELETE PROCEDURE h-convert NO-ERROR.
    
    if  avail agenda_rpw then do:
        assign rw-agenda_rpw = rowid(agenda_rpw).

        rpw:
        do on error  undo rpw, leave rpw
           on quit   undo rpw, leave rpw
           on stop   undo rpw, leave rpw
           on endkey undo rpw, leave rpw:

           run bcp/bc0704.p (input rw-agenda_rpw) no-error.

        end.
        if  error-status:error = yes or 
            (error-status:get-number(1) <> 138 and
             error-status:num-messages  <> 0) then do: 
            assign c-erro = error-status:get-message(1).
            return c-erro.
        end.
        else do:
            if  return-value <> "OK" then do:
                assign c-erro = return-value.
                return c-erro.
            end.
            else
                return "OK".
        end.
    end. 
    else do:
        {utp/ut-table.i mguni agenda_rpw 1}
        run utp/ut-msgs.p (input "msg",
                           input 56,
                           input return-value).
        assign c-erro = "56 - " + return-value.
        return c-erro.
    end.
end.
else do:
    {utp/ut-table.i mguni ped_exec_param 1}
    run utp/ut-msgs.p (input "msg",
                       input 56,
                       input return-value).
    assign c-erro = "56 - " + return-value.
    return c-erro.
end.

/* fim */
