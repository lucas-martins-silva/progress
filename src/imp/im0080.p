/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0080 2.00.00.016 } /*** "010016" 02/01/2024 17:37:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0080 MIM}
&ENDIF
 
/*****************************************************************************
**
** IM0080 - Integraá∆o entre Importaá∆o e Contas Ö Pagar (EMS)
**
** Objetivo: Contabilizaá∆o de Material em trÉnsito.
**
******************************************************************************/
{cdp/cdcfgmat.i} /* include preprocessadores magnus x ems */
{include/i-epc200.i IM0080} /* definicao referente a UPC */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
&if defined(bf-mat-comex) &then
&else

&if defined(bf_mat_unidade_negocio) &then
{cdp/cd1234.i} /* Validaá∆o Decimais */
&endif

DEF VAR i-empresa-ct LIKE param-global.empresa-prin NO-UNDO.
/***********API FINANCAS****************/
def var h_api_cta          as handle no-undo.
def var h_api_ccust        as handle no-undo.
def var p_cod_format_cta_ctbl   as char   no-undo.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR p_des_titulo        AS CHAR NO-UNDO.
DEF VAR v_cod_cta_ctbl      AS CHAR NO-UNDO.
DEF VAR v_cod_ccusto        AS CHAR NO-UNDO.
DEF VAR v_des_cta_ctbl      AS CHAR NO-UNDO.
DEF VAR v_des_ccusto      AS CHAR NO-UNDO.
DEF VAR v_num_tip_cta_ctbl  AS CHAR NO-UNDO.
DEF VAR v_num_sit_cta_ctbl  AS CHAR NO-UNDO.
DEF VAR v_ind_finalid_cta   AS CHAR NO-UNDO.

run prgint/utb/utb743za.py persistent set h_api_cta.
run prgint/utb/utb742za.py persistent set h_api_ccust.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nﬂmero" column-label "Nﬂmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¨ncia".

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contˇbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situaªío Conta" column-label "Situaªío Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contˇbil".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".

/***************************************/


{include/boerrtab.i}    /* temp-table tt-bo-erro */
{mpp/mpapi006.i}        /* definiá∆o da temp-tabel tt-maquina */

{app/apapi001b.i} /*
                 ** Sempre que a apapi001.i for utilizada junto com a apapi201.i, a apapi001.i sempre deverˇ ser definida 
                 ** primeiro e a variˇvel abaixo c-apapi001-inc deverˇ ser definida(com &scoped-define). Este procedimento
                 ** ≤ obrigat rio pois as includes definem temp-tables com os mesmos nomes, o que ocasionarˇ erro de 
                 ** compila  o caso este procedimento n o seja efetuado 
                 */
{imp/im0080.i1}  /* Definicao de temp tables */

def input        parameter c-cod-grp-usuar          as character format "x(3)".
def input        parameter c-usuario                like param-re.usuario.
def input        parameter da-data-ini              as date.
def input        parameter da-data-fim              as date.
def input        parameter c-ep-codigo              as char.
def input        parameter p-cod-estabel-eadi       like estabelec.cod-estabel no-undo.
def input        parameter p-embarque-eadi          like embarque-imp.embarque no-undo.
def input        parameter p-dt-desembarque-parcial as date                    no-undo.
def input        parameter p-desembarque-parcial    as logical                 no-undo.
def input-output parameter table for tt-retorno-erro.
def output       parameter table for tt-embarque-contab.

def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cod_usuar_corren  as character format "x(12)" no-undo. 
def new global shared var v_cod_grp_usuar_lst as character format "x(3)"  no-undo. 

DEF BUFFER b-ordem-compra    FOR ordem-compra.
DEF BUFFER b-tt-ordens-dupli FOR tt-ordens-dupli.

assign v_cod_usuar_corren  = c-usuario
       v_cod_grp_usuar_lst = c-cod-grp-usuar.

def var i-seq-erro          as int     no-undo init 0.
def var i-msg               as int     no-undo.
def var c-msg               as char    no-undo.
def var c-char              as char    no-undo.
def var c-ordens            as char    no-undo.
def var c-embarque          as char    no-undo.
def var c-cod-estabel       LIKE estabelec.cod-estabel no-undo.
def var de-vl-docto         as decimal no-undo init 0.
def var de-vl-docto-mo      as decimal no-undo init 0.
def var i-ind               as int     no-undo init 0.
def var i-contador          as int     NO-UNDO init 0.
def var i-avanco            as int     no-undo.
def var da-data             as date    no-undo extent 12.
def var da-partida          as date    no-undo.
def var i-parcela           as int     no-undo.
def var i-cont              as integer no-undo.
def var i-aux               as integer no-undo.
def var l-ems50             as logical no-undo init no.
def var l-erro-ems50        as logical no-undo init no.
def var l-emsbas            as logical no-undo init no.
def var l-emsfin            as logical no-undo init no.
def var l-emsuni            as logical no-undo init no.
def var c-cd-maq-aux        as char format "x(01)".
def var c-tipo-erro         as char    no-undo.

def var de-vl-docto-mo-aux  AS DECIMAL NO-UNDO FORMAT ">>>>>>,>>9.99999999" INIT 0.
def var de-vl-docto-aux     AS DECIMAL NO-UNDO FORMAT ">>>>>>,>>9.99999999" INIT 0.
def var de-vl-apagar-aux    AS DECIMAL NO-UNDO FORMAT ">>>>>>,>>9.99999999".  
def var de-vl-apagar-mo-aux AS DECIMAL NO-UNDO FORMAT ">>>>>>,>>9.99999999".
def var de-cotacao          as decimal format ">>>,>9.99999999" initial 1.

def var de-preco-unit         like item-doc-est.preco-unit  no-undo extent 0.
def var de-preco-unit-mo      like item-doc-est.preco-unit  no-undo extent 0.
def var de-valor-conver       like item-doc-est.preco-unit  no-undo extent 0.
def var c-ref-aux             like lin-i-ap.referencia      no-undo.
def var i-mo-codigo           like ordem-compra.mo-codigo   no-undo.
def var i-tipo-despesa        like ordem-compra.tp-despesa  no-undo.
def var de-total-dup          like dupli-apagar.vl-a-pagar  no-undo.
def var de-total-dup-mo       like dupli-apagar.vl-a-pagar  no-undo.

/*variavel epc c-esp-tit-tranist im0080.i*/
DEF VAR c-esp-tit-transit LIKE param-imp.esp-tit-transit NO-UNDO.

DEF VAR l-erro-ap             AS LOGICAL INITIAL NO NO-UNDO.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/*
** Vari†veis utilizadas pi-monta-referància
*/
def var i-empresa-prin   like param-global.empresa-prin     no-undo.

/*
** Vari†veis utilizadas Unidade de Neg¢cio
*/
def var l-unid-neg        as   logical                      no-undo.

&if defined(bf_mat_unidade_negocio) &then

def var l-tem-unid-neg    as   logical                      no-undo.
def var c-char-1          like lin-i-ap.char-1              no-undo.
def var de-vl-unid        like lin-conta-ap.vl-movto        no-undo.
def var de-vl-tot-unid    like lin-conta-ap.vl-movto        no-undo.
def var de-vl-unid-me     like lin-conta-ap.vl-movto        no-undo.
def var de-vl-tot-unid-me like lin-conta-ap.vl-movto        no-undo.

&endif

/* procedure pi-busca-portador-modalidade */
{cdp/cd9900.i5}

/*
** Temp-tables comunicaá∆o btb009za.p - conex∆o/desconex∆o bancos externos (EMS 5)
*/
{btb/btb009za.i}

run pi-limpa-tabelas.

run pi-consiste-parametros.

/*
** EMS - 5.0 Integraá∆o "On-line" Datasul-EMS 2.0
*/
if can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00" and
    funcao.ativo = yes and
    funcao.log-1 = yes) then do:
    run pi-conecta-bases-ems5(input 1).

    if return-value = "NOK":U then 
        assign l-erro-ems50 = yes.
end.

if not l-erro-ems50 then
    run pi-historico-embarque.

if l-ems50 then 
    run pi-conecta-bases-ems5(input 2).
    


/* -------------------------------- PROCEDURES DO PROGRAMA ---------------------------------------- */

procedure pi-consiste-parametros:
    
    find first param-re 
        where param-re.usuario = c-usuario no-lock no-error.
        
    find first param-global no-lock no-error.

    if  not avail param-global then do:
        assign i-msg         = 7006
               c-msg         = ""
               c-char        = ""
               c-embarque    = ""
               c-cod-estabel = "".
        run pi-gera-erro.      
        return.
    end.        
    
    assign i-empresa-prin = param-global.empresa-prin.
    
    if  da-data-ini > da-data-fim then do:    
        assign i-msg         = 7079
               c-msg         = ""
               c-char        = ""
               c-embarque    = ""
               c-cod-estabel = "".
        run pi-gera-erro.
        return.
    end.
    
 &IF "{&mguni_version}" >= "2.071" &THEN
    assign i-ep-codigo-usuario = c-ep-codigo.
 &ELSE
    assign i-ep-codigo-usuario = int(c-ep-codigo).
 &ENDIF
    
    /* Unidade de Neg¢cio */
    &if defined(bf_mat_unidade_negocio) &then
    
    find first param-mat no-lock no-error.
    if avail param-mat and param-mat.ind-unid-neg then
        assign l-unid-neg = yes.
    &endif
    
end procedure.


procedure pi-limpa-tabelas.
    for each tt-retorno-erro:
        delete tt-retorno-erro.
    end.
    for each tt-embarque-contab:
        delete tt-embarque-contab.
    end.
    for each tt-dupli:
        delete tt-dupli.
    end.
    for each tt-maquina:
        delete tt-maquina.
    end.
    for each tt-doc-i-ap:
        delete tt-doc-i-ap.
    end.
    for each tt-lin-i-ap:
        delete tt-lin-i-ap.
    end.
    for each tt-l-ant-ap:
        delete tt-l-ant-ap.
    end.
    for each tt-l-pre-ap:
        delete tt-l-pre-ap.
    end.
    for each tt-lin-conta-ap:
        delete tt-lin-conta-ap.
    end.
    for each tt-impto-tit-pend-ap:
        delete tt-impto-tit-pend-ap.
    end.
    for each tt-retorno-lin-i-ap:
        delete tt-retorno-lin-i-ap.
    end.
end procedure.


procedure pi-historico-embarque:

DEF VAR l-ap-atual AS LOGICAL NO-UNDO.

def buffer b-historico-embarque for historico-embarque.
     
    bloco:
    for each historico-embarque 
        where historico-embarque.dt-efetiva >= da-data-ini
          and historico-embarque.dt-efetiva <= da-data-fim no-lock:    
        
        assign de-vl-docto    = 0
               de-vl-docto-mo = 0
               c-tipo-erro    = "".

        FOR FIRST embarque-imp FIELDS(cod-estabel cdn-pto-chegad cdn-pto-desembar embarque cod-incoterm contabilizado &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                                                                                            embarque-imp.idi-natur-cambial 
                                                                                      &ELSE embarque-imp.int-1 &ENDIF)
            where embarque-imp.cod-estabel = historico-embarque.cod-estabel
              and embarque-imp.embarque    = historico-embarque.embarque EXCLUSIVE-LOCK:
        END.
        
        if  not avail embarque-imp then do:
            assign i-msg         = 17365
                   c-msg         = ""
                   c-char        = ""
                   c-embarque    = historico-embarque.embarque
                   c-cod-estabel = historico-embarque.cod-estabel.
            run pi-gera-erro.
            next.
        end.                
        else do:
            /* Desconsidera Embarques Filhos, quando o parÉmetro em tela estiver desmarcado */
            IF  NOT p-desembarque-parcial AND
                TRIM(substring(embarque-imp.char-1,21,20)) <> "":U THEN NEXT.

            /* 
            ** Embarque sem cobertura cambial 
            */
            IF &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                  embarque-imp.idi-natur-cambial = 2
               &ELSE
                  embarque-imp.int-1 = 2
               &ENDIF
            THEN DO:
               {utp/ut-liter.i Embarque_sem_cobertura_cambial *}
               ASSIGN i-msg         = 38917
                      c-msg         = TRIM(RETURN-VALUE)
                      c-char        = ""
                      c-embarque    = embarque-imp.embarque
                      c-cod-estabel = embarque-imp.cod-estabel.
               RUN pi-gera-erro.
               NEXT.            
            END.

            /*
            ** Verifica se foi executado atravÇs do programa de Desembarque Parcial (im0099/bocx220f)
            */            
            if p-cod-estabel-eadi <> "" and p-embarque-eadi <> "" then do:
                if embarque-imp.cod-estabel <> p-cod-estabel-eadi or
                   embarque-imp.embarque    <> p-embarque-eadi    then
                    next.
            end.             
        
            FOR FIRST incoterm-itiner FIELDS(log-1)
                where incoterm-itiner.cod-itiner    = historico-embarque.cod-itiner
                  and incoterm-itiner.cod-pto-contr = historico-embarque.cod-pto-contr
                  and incoterm-itiner.cod-incoterm  = embarque-imp.cod-incoterm no-lock:
            END.
            IF NOT AVAIL incoterm-itiner THEN
                NEXT.
                  
            FOR FIRST itinerario FIELDS(cod-itiner pto-chegada pto-desembarque)
                where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock:
            END.
            if not avail itinerario then do:
                assign i-msg         = 25757
                       c-msg         = ""
                       c-char        = string(historico-embarque.cod-itiner)
                       c-embarque    = historico-embarque.embarque
                       c-cod-estabel = historico-embarque.cod-estabel.
                run pi-gera-erro.
                next.            
            end.
            
            FOR FIRST b-historico-embarque FIELDS(cod-estabel embarque dt-efetiva cod-itiner cod-pto-contr)
                where b-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
                  and b-historico-embarque.embarque      = historico-embarque.embarque
                  and b-historico-embarque.cod-itiner    = itinerario.cod-itiner 
                  and b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad no-lock:
            END.
            if not avail b-historico-embarque then do:
                assign i-msg         = 15839
                       c-msg         = "Ponto de chegada " + string(embarque-imp.cdn-pto-chegad) + " do itiner†rio" + "~~" + "acompanhamento."
                       c-char        = ""
                       c-embarque    = historico-embarque.embarque
                       c-cod-estabel = historico-embarque.cod-estabel.
                run pi-gera-erro.
                next.
            end.
            else do:
                if b-historico-embarque.dt-efetiva <> ? then do:
                    {utp/ut-field.i mgcex itinerario pto-chegada 1}
                    assign i-msg         = 26202
                           c-msg         = return-value
                           c-char        = ""
                           c-embarque    = b-historico-embarque.embarque
                           c-cod-estabel = b-historico-embarque.cod-estabel.
                    run pi-gera-erro.
                    next.
                end.
            end.

            FOR FIRST b-historico-embarque FIELDS(cod-estabel embarque dt-efetiva cod-itiner cod-pto-contr)
                where b-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
                  and b-historico-embarque.embarque      = historico-embarque.embarque
                  and b-historico-embarque.cod-itiner    = itinerario.cod-itiner 
                  and b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
            END.
            IF AVAIL b-historico-embarque THEN 
                if b-historico-embarque.dt-efetiva <> ? then do:
                    ASSIGN l-ap-atual = NO.

                    FOR FIRST embarq-import-docto 
                        WHERE embarq-import-docto.cod-estab   = historico-embarque.cod-estabel
                          AND embarq-import-docto.cod-embarq  = b-historico-embarque.embarque  NO-LOCK:

                         FIND FIRST docum-est                                                              
                              WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto             
                                AND docum-est.nro-docto    = embarq-import-docto.cod-docto                 
                                AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente              
                                AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK NO-ERROR.
                    END.
                                                   
                    IF AVAIL docum-est AND docum-est.ap-atual THEN DO:
                        assign i-msg         = 29382
                               c-msg         = ""
                               c-char        = ""
                               c-embarque    = b-historico-embarque.embarque
                               c-cod-estabel = b-historico-embarque.cod-estabel.
                        run pi-gera-erro.
                        NEXT.
                    END.
                END.

            if avail incoterm-itiner and historico-embarque.dt-efetiva <> ? then do:
                if  embarque-imp.contabilizado then do:
                    assign i-msg = 4339 
                           c-msg = ""
                           c-char= ""
                           c-embarque    = embarque-imp.embarque
                           c-cod-estabel = embarque-imp.cod-estabel.                       
                    run pi-gera-erro.
                    next.
                end.
                
                {imp/im0080.i} /* Geraá∆o das temp-tables */
                
                assign c-embarque    = historico-embarque.embarque
                       c-cod-estabel = historico-embarque.cod-estabel.
                 
                run pi-gera-titulo.

                IF NOT CAN-FIND(FIRST tt-retorno-erro NO-LOCK WHERE 
                                      tt-retorno-erro.cod-estabel = historico-embarque.cod-estabel AND
                                      tt-retorno-erro.embarque    = historico-embarque.embarque    AND
                                      tt-retorno-erro.tipo-erro  <> "WARNING":U) THEN DO: 
                    
                    assign embarque-imp.contabilizado = yes.
                    for each tt-lin-i-ap: 
                        
                        create tt-embarque-contab.
                        assign tt-embarque-contab.embarque     = tt-lin-i-ap.nr-docto
                               tt-embarque-contab.cod-estabel  = tt-lin-i-ap.cod-estabel
                               tt-embarque-contab.ep-codigo    = tt-lin-i-ap.ep-codigo    
                               tt-embarque-contab.cod-esp      = tt-lin-i-ap.cod-esp   
                               tt-embarque-contab.serie        = tt-lin-i-ap.serie
                               tt-embarque-contab.nr-docto     = tt-lin-i-ap.nr-docto
                               tt-embarque-contab.parcela      = tt-lin-i-ap.parcela
                               tt-embarque-contab.cod-fornec   = tt-lin-i-ap.cod-fornec.
                    end.
                end.
                else do:                  
                    next.
                end.

                for each tt-lin-i-ap:
                    delete tt-lin-i-ap.
                end.
            end.                    
        end.
    end.    
end procedure.


procedure pi-gera-titulo.

    if  not param-global.modulo-ap then do: /*se contas a pagar n∆o est† implantado nesta planta, gera mensagem para multiplanta*/
    
        run rep/re9340a.p ( input table tt-doc-i-ap,
                            input table tt-lin-i-ap,
                            input table tt-l-ant-ap,
                            input table tt-l-pre-ap,                                
                            input table tt-lin-conta-ap,
                            input table tt-impto-tit-pend-ap).

        assign i-msg         = 32268
               c-msg         = historico-embarque.embarque
               c-char        = ""
               c-embarque    = historico-embarque.embarque
               c-cod-estabel = historico-embarque.cod-estabel
               c-tipo-erro   = "WARNING":U.
        run pi-gera-erro.
        next.
    end.
    else do:  /*se est† implantado, chama a api do ap que ir† atualizar esta planta e replicar para as demais*/
    
        if param-estoq.gera-ap = 1 then do:
            find first tt-lin-i-ap no-lock no-error.
            if  avail tt-lin-i-ap then do:
                
                ASSIGN l-erro-ap = NO.
                
                run cdp/cdapi950.p (input table tt-doc-i-ap,
                                    input table tt-lin-i-ap,
                                    input table tt-l-ant-ap,
                                    input table tt-l-pre-ap,
                                    input table tt-lin-conta-ap,
                                    input table tt-impto-tit-pend-ap,
                                    output table tt-retorno-lin-i-ap).

                for each tt-retorno-lin-i-ap:

                    if  int(tt-retorno-lin-i-ap.cod-erro) <> 0 then do:
                        create tt-retorno-erro.
                        assign tt-retorno-erro.sequen      = i-seq-erro
                               tt-retorno-erro.cod-erro    = int(tt-retorno-lin-i-ap.cod-erro)
                               tt-retorno-erro.mensagem    = tt-retorno-lin-i-ap.desc-erro
                               tt-retorno-erro.embarque    = c-embarque
                               tt-retorno-erro.cod-estabel = c-cod-estabel
                               l-erro-ap = YES.
                    end.
                end.
                /*Mensagem colocada para alertar o usuario para verificar se criou documento, pois mesmo dando
                erro o documento Ç criado no contas a pagar como pendente.*/

                IF l-erro-ap THEN DO:
                    create tt-retorno-erro.
                    assign tt-retorno-erro.sequen      = i-seq-erro
                           tt-retorno-erro.cod-erro    = 28275
                           tt-retorno-erro.mensagem    = "Favor verificar se criou documento pendente no Contas a Pagar, se criou elimina-lo."
                           tt-retorno-erro.embarque    = c-embarque
                           tt-retorno-erro.cod-estabel = c-cod-estabel
                           l-erro-ap = NO.
                END.

                for each tt-doc-i-ap:
                   delete tt-doc-i-ap.
                end.
                for each tt-dupli:
                    delete tt-dupli.
                end.
            end.                       
        end.
        
    end.
end procedure.


procedure pi-conecta-bases-EMS5:
    /*
    ** Conecta/Disconecta Bancos EMS 5
    */
    DEF input parameter p-conexao as integer no-undo. /* 1 - conex∆o, 2 - desconex∆o */
    
    DEF VAR h-btb009za AS HANDLE  NO-UNDO.
    DEF VAR l-conecta  AS LOGICAL NO-UNDO.
    
    if not avail param-global then
        find first param-global no-lock no-error.
    
   /*Verifica se os bancos externos estao conectados*/
   
    RUN btb/btb009za.p PERSISTENT SET h-btb009za.

    ASSIGN l-conecta = NO.
    if  valid-handle (h-btb009za) AND
        h-btb009za:TYPE = "PROCEDURE":U AND
        h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:

          run pi-conecta-bco IN h-btb009za (Input 1,                          /*contem a versao de integracao da Api*/
                                            Input p-conexao,                  /*contem a opcao desejada (1-Conexao, 2-Desconexao)*/
                                            Input param-global.empresa-prin,  /*contem o codigo da empresa*/
                                            Input "all",                      /*contem o codigo do banco externo*/ 
                                            Output Table tt_erros_conexao).
          ASSIGN l-conecta = YES.
    END.
    DELETE PROCEDURE h-btb009za.

    IF  l-conecta THEN DO:
        if return-value <> "OK":U then do:
           for each tt_erros_conexao:
               if tt_erros_conexao.cd-erro = 25821 or
                  tt_erros_conexao.cd-erro = 25822 then
                   next.
               assign i-msg         = tt_erros_conexao.cd-erro
                      c-msg         = tt_erros_conexao.param-1
                      c-char        = ""
                      c-embarque    = ""
                      c-cod-estabel = "".
               run pi-gera-erro.
               RETURN "NOK":U.
           end.        
        end.
        ELSE DO:
            
            IF NOT connected("emsbas":U)            /*esses bancos precisam estar conectados para que*/                  
            OR NOT connected("emsfin":U)            /*a integracao com EMS5 e a geracao dos titulos no contas a pagar*/  
            OR NOT connected("emsuni":U) THEN DO:   /*seja gerada com sucesso !*/                                        
                                                                                                                         
                assign i-contador = i-contador + 1.
                assign i-msg         = 25822
                       c-msg         = ""
                       c-char        = ""
                       c-embarque    = ""
                       c-cod-estabel = "".

                 run pi-gera-erro.
                 RETURN "NOK":U.
            END.
        END.
    END.

end procedure.


procedure pi-gera-erro.
    assign i-seq-erro = i-seq-erro + 1.
    run utp/ut-msgs.p (input "msg",input i-msg,input c-msg).
    do transaction: 
        FIND tt-retorno-erro WHERE
             tt-retorno-erro.cod-erro    = i-msg         AND
             tt-retorno-erro.cod-estabel = c-cod-estabel AND
             tt-retorno-erro.embarque    = c-embarque    NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-retorno-erro THEN DO:
            create tt-retorno-erro.
            assign tt-retorno-erro.sequen      = i-seq-erro
                   tt-retorno-erro.cod-erro    = i-msg
                   tt-retorno-erro.mensagem    = return-value + " " + c-char
                   tt-retorno-erro.embarque    = c-embarque
                   tt-retorno-erro.cod-estabel = c-cod-estabel
                   tt-retorno-erro.tipo-erro   = c-tipo-erro.
        END.
    end.
end procedure.

/*
** Procedure pi-monta-referencia
*/
{rep/re9340.i9}

&endif
