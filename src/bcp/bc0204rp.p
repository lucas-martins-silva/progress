/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0204RP 2.00.00.046 } /*** "010046" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0204rp MBC}
&ENDIF


{include/i_fnctrad.i}

/*************************************************************************
**
**     Programa BC0204RP.P
**
**************************************************************************/
def temp-table tt-raw-digita NO-UNDO 
    field raw-digita    as raw.

{bcp/bc0204.i}
{cdp/cd0666.i}
{include/i_dbtype.i}
{include/i_dbvers.i}
{cdp/cdcfgint.i}

DEFINE NEW SHARED TEMP-TABLE tt-erro-aux NO-UNDO LIKE tt-erro
    FIELD   cd-transacao    LIKE bc-trans.cd-trans
    FIELD   nr-trans        LIKE bc-trans.nr-trans.

def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.

def var c-lit-selecao    as char format "x(07)" no-undo.
def var c-lit-impressao  as char format "x(09)" no-undo.
def var c-destino        as char format "x(10)" no-undo.
def var i-erro           as int                 no-undo.
def var i-cont-erro      as int                 no-undo.
def var c-erro           as char                no-undo.
def var c-arquivo        as char                no-undo.
def var c-rpw-msg        as char                no-undo.

def var da-exec        as date    no-undo.
def var i-cod-erro     as INT NO-UNDO.
def var h-acomp        as handle  no-undo.
def var l-abrir        as log     no-undo init yes.
def var l-erro         as logical no-undo.
def var c-msg          as char    no-undo.
def var c-estado       as char format "x(15)" no-undo.
def var c-transacao    as CHAR NO-UNDO.
def var c-processo     as CHAR NO-UNDO.
def var raw-temp       as RAW NO-UNDO.
def var c-mensagem     as CHAR NO-UNDO.
def var i-error        as INT NO-UNDO.
def var i-tp-movto      as int     no-undo.
def var i-tp-movto-etiq as int     no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo  format "x(03)" NO-UNDO.
&ELSE
def var i-empresa-prin as int  format ">>9" NO-UNDO.
&ENDIF
def buffer b-bc-trans   for bc-trans.
DEF VAR lEfetivaComErro AS LOGICAL  INITIAL NO NO-UNDO.
DEF VAR v_log_impl_cl AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE vLogEfetivNOK    AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VAR cDetalhe              AS CHAR FORMAT "X(100)" NO-UNDO.

DEF VAR c-comando     AS CHAR NO-UNDO.
DEF VAR v-texto       AS CHAR FORMAT "x(500)" VIEW-AS EDITOR SIZE 70 BY 10 NO-UNDO.
DEF VAR c-estado-nova AS CHAR NO-UNDO.
DEF VAR c-estado-erro AS CHAR NO-UNDO.
DEF VAR c-selecao     AS CHAR NO-UNDO.
{cdp/cdapi523.i h-param-global} 

def  NEW global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cod_empres_usuar   as character format "x(3)"  no-undo.
def new global shared var i-num-ped-exec-rpw   as integer             no-undo.

/**** stream para o arquivo de etiqueta ****/
def new   shared stream s-etiqueta. 
/*******************************************/

/*** Definicao da temp-table tt-epc ***/
{include/i-epc200.i bc0204rp}



create tt-param.
raw-transfer r-raw to tt-param.

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Atualizando * r}
run pi-inicializar in h-acomp (input return-value).

find first param-bc no-lock no-error.

form
    bc-trans.nr-trans
    cDetalhe        FORMAT "X(100)"
    c-estado
    with stream-io down width 132 frame f-corpo.

form
    tt-erro-aux.cd-transacao
    tt-erro-aux.nr-trans
    tt-erro-aux.cd-erro 
    tt-erro-aux.mensagem format "x(115)"
    with stream-io down width 132 frame f-erro.

FORM 
   c-selecao format "x(60)" NO-LABEL 
   with stream-io down width 132 frame f-selecao.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-selecao:HANDLE).


{utp/ut-field.i mgcld bc-trans estado-trans 1}
assign c-estado:label in frame f-corpo = trim(return-value).

{utp/ut-liter.i Mensagem * L}
assign tt-erro-aux.mensagem:label in frame f-erro = trim(return-value).

{utp/ut-liter.i C¢digo * L}
assign tt-erro-aux.cd-erro:label in frame f-erro = trim(return-value).

{utp/ut-liter.i Detalhe * L}
assign cDetalhe:label in frame f-corpo = trim(return-value).

{utp/ut-liter.i Transaá∆o * L}
assign c-transacao  = trim(return-value).

{utp/ut-liter.i Processo * L}
assign c-processo   = trim(return-value).

{utp/ut-liter.i Seleá∆o_Estado_Transaá∆o:_Nova * L}
ASSIGN c-estado-nova = TRIM(RETURN-VALUE).

{utp/ut-liter.i Seleá∆o_Estado_Transaá∆o:_Com_Erro * L}
ASSIGN c-estado-erro = TRIM(RETURN-VALUE).

form
    skip(2)
    c-lit-selecao                   no-label                    colon 55
    skip(1)
    tt-param.trans-ini              format "zzzzzzzzz9"         colon 60    "|< >|"
    tt-param.trans-fim              format "zzzzzzzzz9" no-label
    tt-param.da-ini                                             colon 60   space(1) "|< >|"
    tt-param.da-fim                 no-label
    tt-param.hr-ini                 label "Hora Transaá∆o"      colon 60   space(3) "|< >|"
    tt-param.hr-fim                 no-label
    skip(1)
    c-lit-impressao                 no-label                    colon 55
    skip(1)
    c-destino                                                   colon 60 "-"
    tt-param.arquivo                no-label format "x(30)"
    tt-param.usuario                                            colon 60
    with side-label stream-io width 132 frame f-fim.

{utp/ut-liter.i Seleá∆o * r}
assign c-lit-selecao = trim(return-value).

{utp/ut-liter.i Impress∆o * r}
assign c-lit-impressao = trim(return-value).

{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Uau†rio * r}
assign tt-param.usuario:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans nr-trans 1}
assign tt-param.trans-ini:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans data 1}
assign tt-param.da-ini:label in frame f-fim = trim(return-value).

{include/i-rpvar.i}

find first empresa
     where empresa.ep-codigo = tt-param.ep-codigo
     no-lock no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Efetivaá∆o de Transaá‰es" * L}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i "Coleta de Dados" * C}
assign c-sistema  = trim(return-value).

run utp/ut-trfrrp.p (input frame f-fim:handle).
run utp/ut-trfrrp.p (input frame f-erro:handle).
run utp/ut-trfrrp.p (input frame f-corpo:handle).
{include/i-rpcab.i}
{include/i-rpout.i}

DEFINE QUERY qry-bc-trans FOR b-bc-trans.

view frame f-cabec.
view frame f-rodape.

/********************************************************************************************/
ASSIGN  v_log_impl_cl = NO.
&if '{&mgcld_version}' <= '2.04' &then
    IF  param-bc.int-2 = 1 /*EMS*/
&else
    IF  param-bc.ind-sistema = 1 /*EMS*/
&endif
THEN DO:
    run cdp/cdapi523.p persistent set h-param-global. /* Magnus */

    IF  VALID-HANDLE(h-param-global)
    THEN DO:
        IF  RETURN-VALUE = "OK" THEN
            ASSIGN  v_log_impl_cl = modulo-cl().
        ELSE
            ASSIGN  v_log_impl_cl = NO.
    END.
    ELSE 
        ASSIGN  v_log_impl_cl = NO.
    DELETE PROCEDURE h-param-global.
END.
&if '{&mgcld_version}' <= '2.04' &then
    ELSE IF  param-bc.int-2 = 2 /*Magnus*/
&else
    ELSE IF  param-bc.ind-sistema = 2 /*Magnus*/
&endif  
THEN do:
    RUN cdp/cdapi525.p persistent set h-param-global. /* Magnus */
    IF VALID-HANDLE(h-param-global)
    THEN DO:
        IF  RETURN-VALUE = "OK" THEN
            ASSIGN  v_log_impl_cl = modulo-cl().
        ELSE
            ASSIGN  v_log_impl_cl = NO.
    END.
    DELETE PROCEDURE h-param-global.
END.

IF  NOT v_log_impl_cl
THEN DO:
    {utp/ut-liter.i "Coleta de Dados" * L}
    RUN utp/ut-msgs.p ( INPUT "MSG",
                        INPUT 924,
                        INPUT TRIM(RETURN-VALUE)).
    CREATE tt-erro-aux.
    ASSIGN tt-erro-aux.i-sequen = 1
           tt-erro-aux.cd-erro  = 924
           tt-erro-aux.mensagem = TRIM(RETURN-VALUE)
           c-erro = STRING(tt-erro-aux.cd-erro) + " - " + tt-erro-aux.mensagem.

    run pi-impressao.
    return c-erro.
END.
/********************************************************************************************/

if  not avail param-bc
then do:
    {utp/ut-liter.i ParÉmetro_do_Coleta_de_Dados * L}
    run utp/ut-msgs.p (input "msg",
                       input 56,
                       input trim(return-value)).



    create tt-erro.
    assign tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 56
           tt-erro.mensagem = return-value
           c-erro = string(tt-erro.cd-erro) + " - " + tt-erro.mensagem.

    run pi-impressao.
    return c-erro.
end.

assign l-abrir    = yes
       i-tp-movto      = (if tt-param.tp-movto then 2 else 1)
       i-tp-movto-etiq = (if tt-param.tp-etiqueta then 1 else 2)
       c-selecao  = "". 


for each tt-epc:
  delete tt-epc.
end.

create  tt-epc.
assign  tt-epc.cod-event        = "Before_Execution"
        tt-epc.cod-parameter    = "Before_Execution"
        tt-epc.val-parameter    = "".

{include/i-epc201.i "Before_Execution"}

/* Atualiza as transacoes com erro */
IF tt-param.tp-estado-erro 
THEN do:
    
    OPEN QUERY qry-bc-trans 
            FOR EACH b-bc-trans WHERE
                     b-bc-trans.estado-trans  = 3
                 AND b-bc-trans.ep-codigo     = tt-param.ep-codigo
                 and b-bc-trans.nr-trans     >= tt-param.trans-ini
                 and b-bc-trans.nr-trans     <= tt-param.trans-fim
                 and b-bc-trans.data         >= tt-param.da-ini
                 and b-bc-trans.data         <= tt-param.da-fim
                 and b-bc-trans.horario      >= tt-param.hr-ini
                 and b-bc-trans.horario      <= tt-param.hr-fim
                 and b-bc-trans.cd-trans     >= tt-param.tp-trans-ini
                 and b-bc-trans.cd-trans     <= tt-param.tp-trans-fim
                 and (    &if '{&mgcld_version}' < '2.04' &then
                           b-bc-trans.log-1  = (not tt-param.tp-movto) 
                           &else
                           b-bc-trans.Ind-tipo-trans = i-tp-movto
                           &endif                  

                       or           

                           &if '{&mgcld_version}' < '2.04' &then
                           b-bc-trans.log-1   = tt-param.tp-etiqueta 
                           &else
                           b-bc-trans.Ind-tipo-trans = i-tp-movto-etiq
                           &endif              
                       ) NO-LOCK.     
    GET FIRST qry-bc-trans.
    IF AVAILABLE(b-bc-trans) THEN do:
       ASSIGN c-selecao = c-estado-erro.
       DISP c-selecao WITH FRAME f-selecao.
       DOWN WITH FRAME f-selecao.
    END.
    RUN  pi-atualiza-transacao.

END.

/* Atualiza as transacoes novas */
IF tt-param.tp-estado-nova 
THEN do:

    OPEN QUERY qry-bc-trans 
        FOR EACH b-bc-trans WHERE
                 b-bc-trans.estado-trans  = 1
             AND b-bc-trans.ep-codigo     = tt-param.ep-codigo
             and b-bc-trans.nr-trans     >= tt-param.trans-ini
             and b-bc-trans.nr-trans     <= tt-param.trans-fim
             and b-bc-trans.data         >= tt-param.da-ini
             and b-bc-trans.data         <= tt-param.da-fim
             and b-bc-trans.horario      >= tt-param.hr-ini
             and b-bc-trans.horario      <= tt-param.hr-fim
             and b-bc-trans.cd-trans     >= tt-param.tp-trans-ini
             and b-bc-trans.cd-trans     <= tt-param.tp-trans-fim
             and (    &if '{&mgcld_version}' < '2.04' &then
                       b-bc-trans.log-1  = (not tt-param.tp-movto) 
                       &else
                       b-bc-trans.Ind-tipo-trans = i-tp-movto
                       &endif                  

                   or           

                       &if '{&mgcld_version}' < '2.04' &then
                       b-bc-trans.log-1   = tt-param.tp-etiqueta 
                       &else
                       b-bc-trans.Ind-tipo-trans = i-tp-movto-etiq
                       &endif              
                   ) NO-LOCK. 
    GET FIRST qry-bc-trans.
    IF AVAILABLE(b-bc-trans) THEN do:
       ASSIGN c-selecao = c-estado-nova.
       DISP c-selecao WITH FRAME f-selecao.
       DOWN WITH FRAME f-selecao.
    END.
    RUN  pi-atualiza-transacao.

END.
IF  VALID-HANDLE(h-acomp) THEN DO:
    run pi-finalizar in h-acomp.
END.
/******************************************************************************/
PROCEDURE pi-atualiza-transacao:

DO WHILE AVAILABLE(b-bc-trans):

        /*UPC NGK*/
        EMPTY TEMP-TABLE tt-epc.
        {include/i-epc200.i2 &CodEvent='"filtra-pto-controle"'
                             &CodParameter='"handle-tt-param"'
                             &ValueParameter="STRING(TEMP-TABLE tt-param:HANDLE)"}
                             
        {include/i-epc200.i2 &CodEvent='"filtra-pto-controle"'
                             &CodParameter='"bc-trans-detalhe"'
                             &ValueParameter="b-bc-trans.detalhe"}
                             
        {include/i-epc200.i2 &CodEvent='"filtra-pto-controle"'
                             &CodParameter='"bc-trans-cd-trans"'
                             &ValueParameter="b-bc-trans.cd-trans"}
                             
        {include/i-epc201.i "filtra-pto-controle"}
        IF CAN-FIND(FIRST tt-epc
                    WHERE tt-epc.cod-event     = "filtra-pto-controle":U 
                    AND   tt-epc.cod-parameter = "ERROR":U) THEN DO:
            GET NEXT qry-bc-trans.
            NEXT.
        END.
        do transaction:
            find first bc-trans
                 where rowid(bc-trans) = rowid(b-bc-trans)
                 exclusive-lock no-wait no-error.
    
            if  locked bc-trans then next.

            IF tt-param.tp-estado-erro
            THEN DO:
                FOR each bc-trans-erros WHERE
                         bc-trans-erros.nr-trans  = bc-trans.nr-trans EXCLUSIVE-LOCK:
                   DELETE bc-trans-erros.
                END.

            END.
        end.

        assign lefetivacomerro = no.
                                    
        IF NOT VALID-HANDLE(h-acomp)
        THEN DO:
            run utp/ut-acomp.p persistent set h-acomp.

            {utp/ut-liter.i Atualizando * r}
            run pi-inicializar in h-acomp (input return-value).
        END.

        run pi-acompanhar in h-acomp (input (  c-transacao 
                                             + ": "
                                             + bc-trans.cd-trans
                                             + "  "
                                             + c-processo
                                             + ": " 
                                             + string(bc-trans.nr-trans)) ).

        if  tt-param.tp-trans-ini =  ""
        and i-num-ped-exec-rpw    <> 0
        then do:
    
            FIND FIRST agenda_rpw
                 where agenda_rpw.cdn_modul_refer = 2
                   and agenda_rpw.cod_trans_cld   = lc(bc-trans.cd-trans)
                   and agenda_rpw.log_sit_rpw     = yes
                   and agenda_rpw.cdn_operac      = 1
                 no-lock no-error.
    
            if  avail agenda_rpw
            then do:
                next.
            end.
        end.

        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = bc-trans.cd-trans
             no-lock no-error.
    
        if  not available(bc-tipo-trans)
        then do:
            {utp/ut-table.i mgcld bc-tipo-trans 1}
    
            run utp/ut-msgs.p (input "msg",
                               input 729,
                               input trim(return-value)).
    
            do transaction:
                assign  bc-trans.estado-trans = 3.
                create  bc-trans-erros.
                assign  bc-trans-erros.nr-trans  = bc-trans.nr-trans
                        bc-trans-erros.cd-msg    = 729
                        bc-trans-erros.texto-msg = return-value.
            end.
        end.
        else do:
            if  &if '{&mgcld_version}' < '2.04' &then
                b-bc-trans.log-1   
                &else
                bc-trans.Ind-tipo-trans = 1
                &endif
            and bc-tipo-trans.prog-etiq = ""
            then 
                next.
    
            for each tt-erro:
                delete tt-erro.
            end.
    
            if  &if '{&mgcld_version}' < '2.04' &then
                b-bc-trans.log-1   
            &else
                bc-trans.Ind-tipo-trans = 1
            &endif
            and l-abrir 
            then do:
    
                assign file-info:file-name = param-bc.nome-dir-etiq
                       l-abrir   =  no.
    
                if  file-info:pathname = ?
                then do:
                    {utp/ut-liter.i Etiquetas_-_Diret¢rio * L}
                    run utp/ut-msgs.p (input "msg",
                                       input 15891,
                                       input trim(return-value)).
    
                    create  tt-erro.
                    assign  tt-erro.i-sequen = 1
                            tt-erro.cd-erro  = 15891
                            tt-erro.mensagem =  return-value
                                             + " ("
                                             + param-bc.nome-dir-etiq
                                             + ")"
                            c-erro =  string(tt-erro.cd-erro) 
                                   + " - " 
                                   + tt-erro.mensagem.
    
                    run pi-impressao.
                    return c-erro.
                end.
            end.
    
            ASSIGN  vLogEfetivNOK = YES.
    
            RUN PI-ZERA-RETURN-VALUE.
    
            rpw:
            do  on error  undo rpw, leave rpw
                on quit   undo rpw, leave rpw
                on stop   undo rpw, leave rpw
                on endkey undo rpw, leave rpw: 
    
                &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
    
                    if 
                    &if '{&mgcld_version}' < '2.04' &then
                        bc-trans.log-1 = no
                    &else
                        bc-trans.Ind-tipo-trans = 2
                    &endif 
                    then
                        run value(bc-tipo-trans.api-atualizacao)
                                 (input bc-trans.nr-trans,
                                  input bc-trans.conteudo-trans,
                                  input-output table tt-erro) no-error.
                    else 
                        run value(bc-tipo-trans.prog-etiq)
                                 (input bc-trans.nr-trans,
                                  input bc-trans.conteudo-trans,
                                  input-output table tt-erro) no-error.
    
                &ELSE
                    run btb/btb928za.p (input bc-trans.conteudo-trans,
                                        output raw-temp) no-error.
    
                    if ((   error-status:error
                         or error-status:get-number(1) <> 0)
                        and error-status:get-number(1) <> 138)
                    or return-value = "NOK" then do:
    
                        assign i-error    = error-status:get-number(1)
                               c-mensagem = error-status:get-message(1).
    
                        if return-value = "NOK" then do:
                            {utp/ut-liter.i "Permiss∆o do Diret¢rio Tempor†rio" * L}
                            assign c-mensagem = trim(return-value)
                                   i-error    = os-error.
                        end.
    
                        {utp/ut-liter.i "de Convers∆o do Campo RAW" * L}
                        run utp/ut-msgs.p (input "msg",
                                           input 15837,
                                           input trim(return-value) + " - (" + c-mensagem + " : " + string(i-error) + ")").
    
                        create tt-erro.
                        assign tt-erro.cd-erro  = 15837
                               tt-erro.mensagem = trim(return-value).
    
                    end.
    
                    else do:
    
    
                      if 
                      &if '{&mgcld_version}' < '2.04' &then
                          bc-trans.log-1 = no
                      &else
                          bc-trans.Ind-tipo-trans = 2
                      &endif 
                      then 
                            run value(bc-tipo-trans.api-atualizacao)
                                     (input bc-trans.nr-trans,
                                      input raw-temp,
                                      input-output table tt-erro) no-error.
                      else
                            run value(bc-tipo-trans.prog-etiq)
                                     (input bc-trans.nr-trans,
                                      input raw-temp,
                                      input-output table tt-erro) no-error.
                    end.
    
                &ENDIF
    
                ASSIGN  vLogEfetivNOK = NO.
    
            end.
    
            IF  vLogEfetivNOK /* Erro Travamento de Registro */
            OR  (RETURN-VALUE = "NOK")
            THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input 27611,
                                   input "").
                create  tt-erro.
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-bc0204rp AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "bc0204rp" *}
                ASSIGN c-lbl-liter-bc0204rp = TRIM(RETURN-VALUE).
                Assign  tt-erro.cd-erro  = 27611
                        tt-erro.mensagem = "*** " + c-lbl-liter-bc0204rp + ": " + TRIM(c-lbl-liter). 
            END.
    
            if  error-status:error = yes or
                (error-status:get-number(1) <> 138  and
                 error-status:num-messages  <>   0) then do:
    
                do  i-erro = 1 to 5
                    while(error-status:get-message(i-erro) <> " "):
    
                    assign i-cod-erro = error-status:get-number(i-erro).
    
                    run utp/ut-msgs.p (input "msg",
                                       input 15837,
                                       input (if 
                                              &if '{&mgcld_version}' < '2.04' &then
                                                  bc-trans.log-1 = no
                                              &else
                                                  bc-trans.Ind-tipo-trans = 2
                                              &endif 
                                              then
                                                  bc-tipo-trans.api-atualizacao
                                              else 
                                                  bc-tipo-trans.prog-etiq) ).
    
                    create tt-erro.
                    assign tt-erro.cd-erro  = 15837
                           tt-erro.mensagem = trim(return-value). 
    
                    {utp/ut-liter.i Transaá∆o * L}
                    assign tt-erro.mensagem     = tt-erro.mensagem
                                                        + " " + trim(return-value)
                                                        + " (" 
                                                        + bc-trans.cd-trans
                                                        + ")".
                    {utp/ut-liter.i Erro_Progress * L}
                    assign tt-erro.mensagem =  tt-erro.mensagem
                                                        + " - " + trim(return-value)
                                                        + " (" 
                                                        + string(i-cod-erro)
                                                        + ")".
                end. 
            end.

            ASSIGN i-cont-erro = 0.
            FOR EACH tt-erro:
                CREATE  bc-trans-erros.
                ASSIGN  i-cont-erro             = i-cont-erro + 1
                        bc-trans-erros.nr-trans  = bc-trans.nr-trans
                        bc-trans-erros.cd-msg    = tt-erro.cd-erro
                        bc-trans-erros.texto-msg = tt-erro.mensagem
                        &IF  '{&mgcld_version}'   >= '2.02' &THEN
                        bc-trans-erros.num-sequencial = i-cont-erro
                        &ENDIF.
    
                FIND FIRST cadast_msg
                     WHERE cadast_msg.cdn_msg = tt-erro.cd-erro
                     NO-LOCK NO-ERROR.
    
                IF  AVAIL cadast_msg
                AND cadast_msg.idi_tip_msg = 1
                THEN
                    ASSIGN  lEfetivaComErro = YES.
    
                CREATE  tt-erro-aux.
                BUFFER-COPY tt-erro TO tt-erro-aux NO-ERROR.
                ASSIGN  tt-erro-aux.cd-transacao = bc-trans.cd-trans
                        tt-erro-aux.nr-trans     = bc-trans.nr-trans.
    
            END.
    
            IF  lEfetivaComErro
            THEN
                DO TRANSACTION:
                    ASSIGN  bc-trans.estado-trans       = 3
                            bc-trans.hora-atualizacao   = ""
                            bc-trans.data-atualizacao   = ?.
                END.
            ELSE
                DO TRANSACTION:
                    ASSIGN  bc-trans.estado-trans       = 2
                            bc-trans.hora-atualizacao   = string(time,"HH:MM:SS")
                            bc-trans.data-atualizacao   = today.
                END.
        END.

        &if "{&FNC_MULTI_IDIOMA}" = "Yes" 
        &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {clinc/i01cl012.i 04 bc-trans.estado-trans}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                 INPUT "",
                                 INPUT "").
            ASSIGN c-estado = RETURN-VALUE.
        &else
            ASSIGN c-estado = {clinc/i01cl012.i 04 bc-trans.estado-trans}.
        &endif
        
        ASSIGN cDetalhe = bc-trans.detalhe.

        DISP bc-trans.nr-trans
             cDetalhe
             c-estado
             WITH FRAME f-corpo.
        DOWN WITH FRAME f-corpo.

        release bc-trans.
        release bc-trans-erros.

        GET NEXT qry-bc-trans.

END. /* End while  */

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao002 = {varinc/var00002.i 04 tt-param.destino}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  c-destino = RETURN-VALUE.
&else
    ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.
&endif

run pi-impressao.

{include/i-rpclo.i}

if  c-rpw-msg <> "" 
then 
    return c-rpw-msg.
else
    return "OK".
                   
END PROCEDURE. /* End procedure */

/************************************************************************************************************/
PROCEDURE pi-impressao:

IF  VALID-HANDLE(h-acomp) THEN DO:
    run pi-finalizar in h-acomp.
END.

{utp/ut-liter.i Erros_na_Atualizaá∆o * r}

FIND FIRST tt-erro-aux NO-LOCK NO-ERROR.

IF  AVAIL tt-erro-aux
THEN
    ASSIGN c-rpw-msg = return-value + " ---> ".
ELSE 
    ASSIGN c-rpw-msg = "".

assign v-texto   = ''.

for each tt-erro-aux:

    disp tt-erro-aux.cd-transacao
         tt-erro-aux.nr-trans
         tt-erro-aux.cd-erro 
         tt-erro-aux.mensagem
         with frame f-erro.

    down with frame f-erro.

    assign  c-rpw-msg = c-rpw-msg + IF  LENGTH(c-rpw-msg) < 4000
                                    then "*** " + tt-erro-aux.cd-transacao
                                                + " ("
                                                + c-processo
                                                + ":"
                                                + STRING(tt-erro-aux.nr-trans)
                                                + " )"
                                                + STRING(tt-erro-aux.cd-erro)
                                                + " - "
                                                + tt-erro-aux.mensagem
                                                + CHR(13)
                                    else "".

    FIND bc-trans WHERE bc-trans.nr-trans = tt-erro-aux.nr-trans 
         NO-LOCK NO-ERROR.

    /* TIJEE4 */
    /* CHAMADA EPC */
    for each tt-epc
        where tt-epc.cod-event = "ALTERA-TRANSACAO":
        delete tt-epc.
    end.
    create tt-epc.
    assign tt-epc.cod-event     = "ALTERA-TRANSACAO"
           tt-epc.cod-parameter = "rowid-bc-trans"
           tt-epc.val-parameter = string(rowid(bc-trans)).
    CREATE tt-epc.
    assign tt-epc.cod-event     = "ALTERA-TRANSACAO"
           tt-epc.cod-parameter = "tt-erro"
           tt-epc.val-parameter = string(tt-erro-aux.cd-erro).
    CREATE tt-epc.
    assign tt-epc.cod-event     = "ALTERA-TRANSACAO"
           tt-epc.cod-parameter = "tt-erro-msg"
           tt-epc.val-parameter = string(tt-erro-aux.mensagem).
    {include/i-epc201.i "altera-transacao"}

    ASSIGN v-texto = v-texto 
                     + (IF  LENGTH(v-texto) < 4000 
                        THEN 
                            "Cod Trans:" + tt-erro-aux.cd-transacao + " Nr Trans:" + STRING(tt-erro-aux.nr-trans) 
                            + " ->> "      + tt-erro-aux.mensagem     + " Usuario:"
                            + (IF AVAIL bc-trans 
                               THEN bc-trans.usuario + " Data:" + string(bc-trans.data,"99/99/9999") + " - " + bc-trans.horario 
                               ELSE "")  
                            + CHR (10) 
                        ELSE 
                            "").
    DELETE tt-erro-aux.
end.

for each tt-epc:
    delete tt-epc.
end.

create  tt-epc.
assign  tt-epc.cod-event        = "End_File"
        tt-epc.cod-parameter    = "Fim_arquivo"
        tt-epc.val-parameter    = v-texto.

{include/i-epc201.i "End_File"}

RETURN.

end procedure.

/************************************************************************************************************************************/
PROCEDURE pi-zera-return-value.
RETURN "".
END PROCEDURE.


