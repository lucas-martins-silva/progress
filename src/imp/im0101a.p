/******************************************************************************* 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0101A 2.00.00.027 } /*** "010027" 18/11/2025 16:45:17 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101a MIM}
&ENDIF

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/boerrtab.i}                  /* tt-bo-erro                */
{imp/im0101.i tt-parametros}          /* tt-param                  */
{imp/im0091.i}                        /* tt-desp-rateio            */
{inbo/boin090.i tt-docum-est-orig}    /* tt-docum-est-orig         */
{cdp/cd4300.i3}                       /* tratamento atributo livre */
{include/i-epc200.i im0101a} /** Upc **/

&if  '{&bf_mat_versao_ems}' >= '2.062' &then
    {cdp/cd9590.i}
&endif

&if "{&bf_mat_versao_ems}":U >= "2.04":U &then
    {rep/reapi190a.i}
    {cxbo/bocx310a.i tt-selecao-despesa}  
    def temp-table tt-desp-cond-pagto no-undo
        field embarque          like embarque-imp.embarque
        field cod-desp          as int  format ">>,>>9"
        field cod-emitente-desp as int  format ">>>>>>>>9"
        field cod-cond-pag      as int  format ">>9"
        field mo-codigo         as int  
        index chave cod-desp cod-emitente-desp.
&endif

DEFINE TEMP-TABLE tt-docum-est-2 NO-UNDO
    FIELD serie-docto  LIKE docum-est.serie-docto  
    FIELD nro-docto    LIKE docum-est.nro-docto    
    FIELD cod-emitente LIKE docum-est.cod-emitente 
    FIELD nat-operacao LIKE docum-est.nat-operacao 
    FIELD embarque     like docum-est.embarque
    INDEX embarque embarque.

/*VisÆo DI*/
def temp-table tt-desp-rateio-item no-undo
    field num-di-ems        LIKE decla-import-ord.num-di-ems
    field num-adic          LIKE decla-import-adic.num-adic
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela
    field num-seq           like decla-import-adic-itens.num-seq
    field cod-desp          like desp-imp.cod-desp    
    field val-desp-unit     like despes-decla-import.val-despes
    field val-desp          like despes-decla-import.val-despes    
    index codigo is unique primary
        num-di-ems
        num-adic
        numero-ordem
        parcela
        cod-desp
    index despesa 
        cod-desp.

DEF VAR i-empresa LIKE param-globa.empresa-prin NO-UNDO.
FIND FIRST param-global NO-LOCK NO-ERROR.
ASSIGN i-empresa = param-global.empresa-prin WHEN AVAIL param-global.
/***********API FINANCAS****************/
def var h_api_cta             as handle no-undo.
def var p_cod_format_cta_ctbl as char   no-undo.
DEF VAR p_cod_format_ccusto   AS CHAR NO-UNDO.
DEF VAR p_des_titulo          AS CHAR NO-UNDO.
DEF VAR v_des_ccusto          AS CHAR NO-UNDO.
def var v_cod_cta_ctbl        as char no-undo.
def var v_des_cta_ctbl        as char no-undo.
def var v_num_tip_cta_ctbl    as char no-undo.
def var v_num_sit_cta_ctbl    as int no-undo.
def var v_ind_finalid_cta     as char no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".

def temp-table tt_cta_integr no-undo
    field ttv_cod_cta_ctbl         as char format "x(20)" label "Conta Contÿbil"
    field ttv_des_titulo           as char format "x(40)"
    field ttv_num_tip_cta_ctbl     as int  format ">9" label "Tipo Conta" column-label "Tipo Conta"
    field ttv_num_sit_cta_ctbl     as int  format ">9" label "Situa»’o Conta" column-label "Situa»’o Cta"
    field ttv_ind_finalid_ctbl_cta as char format "X(40)" label "Finalidade Contÿbil".

def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".
/***************************************/

/** No caso de multipolos embarques guarda um registro da tt-parametros por vez **/
def temp-table tt-parametros-2 no-undo like tt-parametros.
DEF BUFFER bfdocum-est FOR docum-est.

def var i-seq-erro             as integer no-undo.
def var h-acomp                as handle  no-undo.
def var c-acomp                as char    no-undo.
def var h-im0101a1             as handle  no-undo.    
def var l-im0101               as log     no-undo.
DEF VAR i-tipo-geracao         AS INT     NO-UNDO.
&if defined(bf-mat-comex) &then
&else
/* procedure pi-busca-portador-modalidade */
{cdp/cd9900.i5}
&endif

procedure setTtSelecao:
    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        define input parameter table for tt-selecao-despesa.
    &endif
    
end procedure.

procedure createNFComplementar:
    /** Gera‡Æo nota fiscal complementar **/
    DEF INPUT PARAM pi-tipo-geracao AS INT NO-UNDO.
    def input parameter table for tt-parametros.
    def output parameter table for tt-docum-est.
    def output parameter table for tt-bo-erro.
    
    find first tt-parametros no-error.
    find first param-global  no-lock no-error.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    ASSIGN i-tipo-geracao = pi-tipo-geracao.
    if  not valid-handle (h-im0101a1) then
        run imp/im0101a1.p persistent set h-im0101a1 (INPUT TABLE tt-docum-est-2).
    
    if  tt-parametros.l-acomp then do:
        run utp/ut-acomp.p persistent set h-acomp.
        {utp/ut-liter.i Gera‡Æo_NF_Complementar * L}        
        assign c-acomp = trim(return-value).
        run pi-inicializar in h-acomp (input c-acomp).
        run pi-desabilita-cancela in h-acomp.
        {utp/ut-liter.i Validando_Parƒmetros... * L}
        assign c-acomp = trim(return-value).
        run pi-acompanhar in h-acomp (input c-acomp).
    end.
    
    for each tt-parametros break by tt-parametros.embarque:
        
        run validateParameters.
        if  return-value = "NOK" then do:
            /** Identifica o embarque que possui erros **/
            {imp/im0101a.i}
        end.    
        
        find first tt-parametros-aux no-error.
           
        run readParameters.
        if  return-value = "NOK" then do:
            /** Identifica o embarque que possui erros **/
            {imp/im0101a.i}
        end.    
            
        if  tt-parametros.l-acomp then do:
            {utp/ut-liter.i Gerando_Documento/Itens_Tempor rios... * L}
            assign c-acomp = trim(return-value).
            run pi-acompanhar in h-acomp (input c-acomp).
        end.
        
        create tt-parametros-2.
        buffer-copy tt-parametros to tt-parametros-2.
    
        /** Programa Auxiliar **/
        run loadParameters in h-im0101a1 (input table tt-parametros-2,
                                          input table tt-parametros-aux,
                                          input table tt-docum-est-orig,
                                          input table tt-desp-rateio,   
                                          input table tt-ordens-totais,
                                          input table tt-selecao-despesa).
        
        /** Gera apenas uma nf complementar para todos os embarques **/
        if  first (tt-parametros.embarque) then do:

            run generateTT-docum-est in h-im0101a1.
            if  return-value = "NOK":U then do:
                /** Identifica o embarque que possui erros **/
                {imp/im0101a.i}
            end.
        end.
    
        run generateTT-item-doc-est  in h-im0101a1.
        if  return-value = "NOK":U then do:
            /** Identifica o embarque que possui erros **/
            {imp/im0101a.i}
        end.
    
        if  last (tt-parametros.embarque) then do:
    
            &if defined(bf-mat-comex) &then
            &else
                if  tt-parametros.l-acomp then do:
                    {utp/ut-liter.i Calculando_Impostos... * L}
                    assign c-acomp = trim(return-value).
                    run pi-acompanhar in h-acomp (input c-acomp).
                end.
            &endif
            
            &if defined(bf-mat-comex) &then
                run generateTT-dupli-apagar in h-im0101a1.
                if  return-value = "NOK":U then do:
                    /** Identifica o embarque que possui erros **/
                    {imp/im0101a.i}
                end.    
            &elseif  "{&bf_mat_versao_ems}":U < "2.04":U &then
                run generateTT-dupli-apagar in h-im0101a1.            
                if  return-value = "NOK":U then do:
                    /** Identifica o embarque que possui erros **/
                    {imp/im0101a.i}
                end.    
            &endif
            
            run calculateImpostos in h-im0101a1.
            if  return-value = "NOK":U then do:
                /** Identifica o embarque que possui erros **/
                {imp/im0101a.i}
            end.    
    
            run setObservacao in h-im0101a1.
    
            &if defined(bf-mat-comex) &then
            &else
                if  tt-parametros.l-acomp then do:
                    {utp/ut-liter.i Gerando_Documento_Recebimento... * L}
                    assign c-acomp = trim(return-value).
                    run pi-acompanhar in h-acomp (input c-acomp).
                end.
            &endif
    
            run generateDocumento in h-im0101a1.
            if  return-value = "NOK":U then do:
                /** Identifica o embarque que possui erros **/
                {imp/im0101a.i}
            end.    
            
            &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
                run setTtDespTotaisEmbarquesMult in h-im0101a1 (input table tt-desp-totais-embarques-mult).
                run generateTT-dupli-apagar-cex  in h-im0101a1.
                if  return-value = "NOK":U then do:
                    /** Identifica o embarque que possui erros **/
                    {imp/im0101a.i}
                end.    
            &endif
        end.
    
        for each tt-parametros-2:
            delete tt-parametros-2.
        end.
        for each tt-parametros-aux:
            delete tt-parametros-aux.
        end.
        for each tt-docum-est-orig:
            delete tt-docum-est-orig.
        end.
        for each tt-desp-rateio:
            delete tt-desp-rateio.
        end.
        for each tt-ordens-totais:
            delete tt-ordens-totais.
        end.
        for each tt-desp-totais:
            delete tt-desp-totais.
        end.
        for each tt-docum-est-2:
            delete tt-docum-est-2.
        end.
    end.

    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        run getTT-docum-est-im0101a1 in h-im0101a1 (output table tt-docum-est).
    &endif

    run getTT-bo-erro in h-im0101a1 (output table tt-bo-erro append).

    if  valid-handle (h-im0101a1) then do:
        delete procedure h-im0101a1.
        assign h-im0101a1 = ?.
    end.
    
    if  valid-handle(h-acomp) then
        run pi-finalizar in h-acomp.
    
    return "OK":U.
end procedure.

procedure validateParameters:
    /** Valida parƒmetros informados em tela **/
    def var l-docum                 as   logical no-undo.
    def var l-docum-atual           as   logical no-undo.
    def var i-cod-itiner            like itinerario.cod-itiner no-undo.
    def var i-pto-desembarque       like pto-contr.cod-pto-contr no-undo.
    def var i-seq-desembarque       like historico-embarque.sequencia no-undo.
    def var l-desp-complementares   as   logical no-undo.
    def var l-forn-complementares   as   logical no-undo.

    {rep/re1001a.i50} /*Vari veis do embarque*/

    assign l-im0101 = yes.
    
    /** Valida‡äes gerais **/
    {cxbo/bocx220a.i2 -desp}
    
    if  can-find(first tt-bo-erro) then return "NOK":U.    

    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    /*Valida Item Servi‡o*/
    IF tt-parametros.cod-item-serv <> "" THEN DO:
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-parametros.cod-item-serv NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.parametros = tt-parametros.cod-item-serv.
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input tt-bo-erro.parametros).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
            return "NOK":U.
        END.
    END.

    /*Se o c¢digo de observa‡Æo ‚ igual 4, entÆo o item de servi‡o deve ser informado*/
    IF  tt-parametros.cod-observacao = 4
    AND tt-parametros.cod-item-serv  = "" THEN DO:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Item_Servi‡o_em_branco * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_de_observa‡Æo_‚_igual_4,_entÆo_o_Item_Servi‡o_deve_ser_informado" *}
        assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + RETURN-VALUE.
        run utp/ut-msgs.p (input "msg":U,
                           input 17006,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 17006
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.
    END.
        
    /** Verifica data do fechamento **/
    &if defined(bf_dis_versao_ems) &then
        &if "{&bf_dis_versao_ems}" >= "2.04":U &then
            for estab-mat fields(mensal-ate) NO-LOCK
                where estab-mat.cod-estabel = tt-parametros.cod-estabel:
                if  tt-parametros.da-transacao <= estab-mat.mensal-ate then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Data_de_transa‡Æo * L}
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(return-value).
                    {utp/ut-liter.i £ltimo_m‚dio_calculado * L}
                    assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value).
                    run utp/ut-msgs.p (input "msg":U,
                                       input 7744,
                                       input tt-bo-erro.parametros).
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 7744
                           tt-bo-erro.mensagem = return-value.
                    return "NOK":U.
                end.            
            end.
        &else
            if  tt-parametros.da-transacao <= param-estoq.mensal-ate then do:            
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Data_de_transa‡Æo * L}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = trim(return-value).
                {utp/ut-liter.i £ltimo_m‚dio_calculado * L}
                assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value).
                run utp/ut-msgs.p (input "msg":U,
                                   input 7744,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 7744                    
                       tt-bo-erro.mensagem = return-value.
                return "NOK":U.        
            end.
        &endif
        &else
          &if defined(bf-mat-comex) &then 
            if  tt-parametros.da-transacao <= param-estoq.medio-ate then do:                    
          &else
            if  tt-parametros.da-transacao <= param-estoq.mensal-ate then do:            
          &endif        
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Data_de_transa‡Æo * L}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = trim(return-value).
                {utp/ut-liter.i £ltimo_m‚dio_calculado * L}
                assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value).
                run utp/ut-msgs.p (input "msg":U,
                                   input 7744,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 7744
                       tt-bo-erro.mensagem = return-value.
                return "NOK":U.
            end.
    &endif    
    
    /** Cria temp-table auxiliar para parƒmetros **/
    create tt-parametros-aux.
    assign tt-parametros-aux.cod-estabel = tt-parametros.cod-estabel
           tt-parametros-aux.embarque    = tt-parametros.embarque.
        
    /** Verifica se natureza de opera‡Æo ‚ de rateio **/
    if  not &if defined (bf-mat-comex) &then natur-oper.log-1 &else natur-oper.nota-rateio &endif then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Natureza_de_Opera‡Æo * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        {utp/ut-liter.i Nota_de_Rateio * L}
        assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 17167,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 17167
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.
    end.

    /** Verifica se a nota complementar tem a a mesma natureza de operacao da nota de compra**/
    IF CAN-FIND(FIRST docum-est
                WHERE trim(substring(docum-est.char-1,1,20)) = tt-parametros.embarque
                  AND docum-est.nat-operacao                 = tt-parametros.nat-operacao) THEN DO:
        
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        run utp/ut-msgs.p (input "msg":U,
                           input 53105,
                           input tt-parametros.nat-operacao).
        assign tt-bo-erro.i-sequen   = i-seq-erro
               tt-bo-erro.cd-erro    = 53105
               tt-bo-erro.mensagem   = return-value
               tt-bo-erro.parametros = tt-parametros.nat-operacao.
        return "NOK":U.
    END.
    
    assign tt-parametros-aux.consum-final      = natur-oper.consum-final
           tt-parametros-aux.cod-mensagem      = natur-oper.cod-mensagem
           tt-parametros-aux.natur-oper-char-2 = natur-oper.char-2
           tt-parametros-aux.cd-trib-iss       = natur-oper.cd-trib-iss
           tt-parametros-aux.imp-nota          = natur-oper.imp-nota
           tt-parametros-aux.emite-duplic      = natur-oper.emite-duplic.
        
    /** Embarque encerrado **/
    if  embarque-imp.situacao = 2 then do:
        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        run utp/ut-msgs.p (input "msg":U,
                           input 6036,
                           input "").
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 6036
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.           
    end.

    find first ordens-embarque
        where  ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          and  ordens-embarque.embarque    = embarque-imp.embarque no-lock no-error.
    if  avail  ordens-embarque then
        find ordem-compra 
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.
    
            /** Nao existe ordem relacionada ao embarque **/
    if  not avail ordem-compra then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Ordens_do_Embarque * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.           
    end.

    /*
    ** Busca notas fiscais relacionadas aos embarques selecionados
    */

    for each embarq-import-docto 
       where embarq-import-docto.cod-estab   = embarque-imp.cod-estabel
         and embarq-import-docto.cod-embarq  = embarque-imp.embarque    no-lock,
       first docum-est                                                              
       where docum-est.serie-docto  = embarq-import-docto.cod-ser-docto             
         and docum-est.nro-docto    = embarq-import-docto.cod-docto                 
         and docum-est.cod-emitente = embarq-import-docto.cdn-emitente              
         and docum-est.nat-operacao = embarq-import-docto.cod-natur-operac no-lock: 
         {imp/im0101a.i1}
    end.

    /** Nao encontrou documento **/
    if  not l-docum then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Documento_de_entrada * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.
    end.
    
    /** Documento encontrado nÆo atualizado **/
    if  not l-docum-atual then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Documento_relacionado_ao_Embarque * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        {utp/ut-liter.i atualizado_no_recebimento * L}
        assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 25368,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 25368
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.
    
    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        /** Mais de um embarque com uma mesma despesa, porem cond pagto diferentes **/
        for each  tt-selecao-despesa
            where tt-selecao-despesa.cod-estabel = embarque-imp.cod-estabel
            and   tt-selecao-despesa.embarque    = embarque-imp.embarque no-lock
            USE-INDEX ch-embarque:
            
            find tt-desp-cond-pagto 
                where tt-desp-cond-pagto.cod-desp          = tt-selecao-despesa.cod-desp
                and   tt-desp-cond-pagto.cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp no-error. 
            if  not avail tt-desp-cond-pagto then do:      
                create tt-desp-cond-pagto.
                assign tt-desp-cond-pagto.embarque          = embarque-imp.embarque
                       tt-desp-cond-pagto.cod-desp          = tt-selecao-despesa.cod-desp
                       tt-desp-cond-pagto.cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp
                       tt-desp-cond-pagto.cod-cond-pag      = tt-selecao-despesa.cond-pagto
                       tt-desp-cond-pagto.mo-codigo         = tt-selecao-despesa.moeda.
            end.
            else do:
                if  tt-desp-cond-pagto.cod-cond-pag <> tt-selecao-despesa.cond-pagto
                or  tt-desp-cond-pagto.mo-codigo    <> tt-selecao-despesa.moeda then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = tt-desp-cond-pagto.embarque + tt-selecao-despesa.embarque.
                    run utp/ut-msgs.p (input "msg":U,
                                       input 29372,  
                                       input "").
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 29372 
                           tt-bo-erro.mensagem = return-value.
                    return "NOK":U.
                end.
            end.
        end.
    &endif
    
    run validateDespesas.
    if  return-value = "NOK":U then
        return "NOK":U.
    
    return "OK":U.
end procedure.


procedure validateDespesas:
    /** Valida as despesas que serÆo geradas para a nota complemenetar **/
    def var h-im0091 as handle no-undo.
    
    find first tt-docum-est-orig no-error.
    
    /** Rateio Despesas de Importacao **/
    if  not valid-handle (h-im0091) then
        run imp/im0091.p persistent set h-im0091.

    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        run setTtSelecaoDespesa in h-im0091 (input table tt-selecao-despesa).
    &endif
    
    run setaValorinicial    in h-im0091 (input tt-parametros.da-cotacao, /*today*/
                                         input tt-docum-est-orig.cod-estabel).
    
    run rateioDocumento     in h-im0091 (input tt-docum-est-orig.cod-estabel,
                                         input tt-parametros.cod-estabel, /*frank*/
                                         input tt-parametros.embarque,
                                         input tt-docum-est-orig.serie-docto,
                                         input tt-docum-est-orig.nro-docto,
                                         input tt-docum-est-orig.cod-emitente,
                                         input tt-docum-est-orig.nat-operacao,
                                         input tt-parametros.cod-emitente-desp,
                                         &if defined(bf_mat_nf_simp_remes_desp_imp) &then
                                             input tt-parametros.l-agrupar-unico-forn,
                                         &endif
                                         output table tt-desp-rateio).

    run getTTdesp-totais    in h-im0091 (output table tt-desp-totais).
    run getTTordens-totais  in h-im0091 (output table tt-ordens-totais).
    run getTTbo-erro        in h-im0091 (output table tt-bo-erro).

    if  valid-handle (h-im0091) then do:
        delete procedure h-im0091.
        assign h-im0091 = ?.
    end.

    &if "{&bf_mat_versao_ems}":U >= "2.04":U &then
        for each tt-desp-totais:
            find tt-desp-totais-embarques-mult
                where tt-desp-totais-embarques-mult.cod-desp          = tt-desp-totais.cod-desp
                and   tt-desp-totais-embarques-mult.cod-emitente-desp = tt-desp-totais.cod-emitente-desp no-error.
            if  not avail tt-desp-totais-embarques-mult then do:
                create tt-desp-totais-embarques-mult.
                buffer-copy tt-desp-totais except val-desp val-desp-mo to tt-desp-totais-embarques-mult .
            end.
            assign tt-desp-totais-embarques-mult.val-desp    = tt-desp-totais-embarques-mult.val-desp    + tt-desp-totais.val-desp
                   tt-desp-totais-embarques-mult.val-desp-mo = tt-desp-totais-embarques-mult.val-desp-mo + tt-desp-totais.val-desp-mo.
        end.
    &endif

    if  can-find(first tt-bo-erro) then
        return "NOK":U.
        
    if  not can-find(first tt-desp-rateio) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Embarque * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        {utp/ut-liter.i despesa_complementar * L}
        assign tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + trim(return-value) + "~~" + tt-parametros.embarque.
        run utp/ut-msgs.p (input "msg":U,
                           input &if "{&bf_mat_versao_ems}":U >= "2.04":U &then 29348 &else 1342 &endif,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = &if "{&bf_mat_versao_ems}":U >= "2.04":U &then 29348 &else 1342 &endif
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.
    end.
    
    find first tt-desp-totais no-error.
    assign tt-parametros-aux.mo-codigo    = tt-desp-totais.mo-codigo
           tt-parametros-aux.cod-cond-pag = tt-desp-totais.cod-cond-pag.

    for each  historico-embarque fields(dt-efetiva cod-pto-contr)
        where historico-embarque.cod-estabel = tt-parametros.cod-estabel
        and   historico-embarque.embarque    = tt-parametros.embarque no-lock
        USE-INDEX codigo:

        if  historico-embarque.cod-pto-contr = tt-desp-totais.cod-pto-contr then
            assign tt-parametros-aux.da-partida = historico-embarque.dt-efetiva.
    end.                        
    
    /** Encontra cotacao que sera utilizada **/
    find cotacao
        where cotacao.mo-codigo   = tt-parametros-aux.mo-codigo
        and   cotacao.ano-periodo = string(year(tt-parametros.da-cotacao)) 
                                  + string(month(tt-parametros.da-cotacao),"99")
        and cotacao.cotacao[int(day(tt-parametros.da-cotacao))] <> 0 no-lock no-error.
    if  not avail cotacao then do:
        if  tt-parametros-aux.mo-codigo <> 0 then do:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.parametros = string(tt-parametros-aux.mo-codigo) 
                                         + "~~" + string(tt-parametros.da-cotacao).
            run utp/ut-msgs.p (input "msg":U,
                               input 1847,
                               input tt-bo-erro.parametros).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 1847
                   tt-bo-erro.mensagem = return-value.
            return "NOK":U.
        end.
        else
            assign tt-parametros-aux.cotacao-dia = 1.
    end.
    else
        assign tt-parametros-aux.cotacao-dia = cotacao.cotacao[int(day(tt-parametros.da-cotacao))].
        
    if  not can-find(FIRST cond-pagto 
                      where cond-pagto.cod-cond-pag = tt-parametros-aux.cod-cond-pag) then do:

        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        {utp/ut-field.i mgcex desp-embarque cod-cond-pag 1}
        assign tt-bo-erro.parametros = trim(return-value) + "~~" + string(tt-parametros-aux.cod-cond-pag).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
        return "NOK":U.                
    end.
            
    return "OK":U.
end procedure.


procedure readParameters:
    /** Le os parametros utilizados no decorrer do programa **/
    for first param-imp fields(esp-tit-rec)
        where param-imp.cod-estabel = tt-parametros-aux.cod-estabel no-lock:
        assign tt-parametros-aux.esp-tit-rec = param-imp.esp-tit-rec.    
    end.
    
    for first param-re fields(seq-item-um inc-seq) no-lock:
        assign tt-parametros-aux.seq-item-um = param-re.seq-item-um
               tt-parametros-aux.inc-seq     = param-re.inc-seq.
    end.
    
    for first estabelec fields(estado cidade pais cod-estabel)
        where estabelec.cod-estabel = tt-parametros.cod-estabel no-lock:
        assign tt-parametros-aux.estado-estab = estabelec.estado
               tt-parametros-aux.cidade       = estabelec.cidade
               tt-parametros-aux.pais         = estabelec.pais.
    end.
    
    for first emitente fields(tp-desp-padrao nome-abrev natureza estado char-1
                              portador modalidade
                              &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
                              portador-ap modalidade-ap
                              &endif )
        where emitente.cod-emitente = tt-parametros.cod-emitente-desp no-lock:

        &if defined(bf-mat-comex) &then
        assign tt-parametros-aux.portador   = emitente.portador
               tt-parametros-aux.modalidade = emitente.modalidade.
        &else
        run pi-busca-portador-modalidade (buffer emitente,
                                          output i-portador-emit,
                                          output i-modalidade-emit).

        assign tt-parametros-aux.portador   = i-portador-emit   
               tt-parametros-aux.modalidade = i-modalidade-emit .
        &endif

        assign tt-parametros.estado-emit    = emitente.estado
               tt-parametros-aux.tp-despesa = emitente.tp-desp-padrao
               tt-parametros-aux.nome-abrev = emitente.nome-abrev
               tt-parametros-aux.natureza   = emitente.natureza.
    end.
    
    return "OK":U.
end procedure.
/* IM0101A.P */
