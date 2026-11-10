/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i MLAAPI001 2.00.00.119 } /*** "010019" 17/08/2026 16:09:07 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i mlaapi001 MLA}
&ENDIF

/********************************************************************************
**
**   Programa..:  MLAAPI001.P
**   Data......:  Fevereiro de 2001.
**   Objetivo .:  Gera‡Æo de pendˆncias de aprova‡Æo 
**   Cria‡Æo ..:  Jackson
**
********************************************************************************/
    
    {lap/mlaapi001.i99}
    {cdp/cd0666.i}
    {utp/utapi019.i}
    {cdp/cd0020.i} 
    {utp/ut-glob.i}
    {method/dbotterr.i} /*rowErrors*/
    DEFINE TEMP-TABLE RowErrorsAux NO-UNDO 
        LIKE RowErrors.
    
    /**  Defini‡Æo de elementos referentes a UPC **/
    {include/i-epc200.i "MLAAPI001"}

    /**  Parametros
    **/
    DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-tipo-trans  AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-motivo      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor       AS DECIMAL   NO-UNDO.
    DEFINE INPUT  PARAMETER p-moeda       AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-trans AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuar-doc   AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-lotacao-doc AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-item        AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-referencia  AS CHARACTER NO-UNDO. 
    DEFINE INPUT  PARAMETER p-ep-codigo   LIKE empresa.ep-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

    DEFINE VARIABLE cErrorDescription        AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE cErrorHelp               AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE c-mensagem               AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE c-tipo-doc-prog-aprova   AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE h-mlaapi014              AS HANDLE             NO-UNDO.
    DEFINE VARIABLE h-mlaapi019              AS HANDLE             NO-UNDO.
    DEFINE VARIABLE iNrSolicFluig            AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iTipoCancelamento        AS INTEGER            NO-UNDO.
    DEFINE VARIABLE iErrorSequence           AS INTEGER            NO-UNDO.
    DEFINE VARIABLE i-nr-trans-include       AS INTEGER            NO-UNDO.
    DEFINE VARIABLE l-sempre-gera            AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE l-gera-condpg-valor      AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE lErroFluig               AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE l-fluig-integrated       AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE r-rowid-aux-include      AS ROWID              NO-UNDO.
    DEFINE VARIABLE r-rowid-aux              AS ROWID              NO-UNDO.
    DEFINE VARIABLE l-executa-pi-aprova-auto AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE l-existe-perm-aprov      AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE l-necessita-conversao    AS LOGICAL            NO-UNDO.
    DEFINE VARIABLE i-tipo-conversao         AS INTEGER            NO-UNDO.
    DEFINE VARIABLE i-moeda-conversao        AS INTEGER            NO-UNDO.
    DEFINE VARIABLE de-vl-doc-conv           AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE i-seq-erro               AS INTEGER            NO-UNDO.

    DEF BUFFER b-mla-usuar-aprov    FOR mla-usuar-aprov.
    DEF BUFFER b-mla-doc-pend-aprov FOR mla-doc-pend-aprov.
    DEF NEW GLOBAL SHARED VAR gi-prox-prior AS INTEGER NO-UNDO.

    DEF NEW GLOBAL SHARED VAR gl-not-pendencia-aed  AS LOGICAL NO-UNDO.
    
    def var i-chave         as integer no-undo.
    def var c-chave         as char    no-undo.
    def var l-mestre        as logical no-undo.
    def var de-limite       as decimal no-undo.
    def var de-aux          as decimal no-undo.
    def var i-cod-aprov     as integer no-undo.
    def var i-tip-aprov     as integer no-undo.
    def var c-lotacao       as char    no-undo.
    def var c-lotacao-trans as char    no-undo.
    def var c-apr-lista     as char    no-undo.
    def var i-seq-lista     as integer no-undo.
    def var i-tip-lista     as integer no-undo.
    def var c-ass-e-mail    as char    no-undo.
    def var c-men-e-mail    as char    no-undo.
    def var i-prioridade    as integer no-undo.
    def var c-aprovador     as char    no-undo.
    DEF VAR c-nom-aprov     as char    no-undo.
    def var c-arquivo-anexo as char    no-undo.
    DEF VAR i-cod-cond-pag  LIKE cond-pagto.cod-cond-pag NO-UNDO.
    def var i-mo-codigo     like mla-usuar-aprov.mo-codigo initial 0 no-undo.
    def var de-valor-convert as decimal no-undo.
    def var de-val-doc-convert like mla-doc-pend-aprov.valor-doc no-undo.
    def var c-anexo         as char    no-undo.
    DEF VAR c-desc-aprov-auto  AS CHAR NO-UNDO.
    DEF VAR l-envia-email-auto AS LOG  NO-UNDO.

    def var c-alternativo    as char    no-undo.
    def var c-mail           as char    no-undo.
    def var l-aprovado       as logical no-undo.
    def var l-aprovado-auto  as logical no-undo.

    def var l-achou-lista   as logical no-undo.
    def var i-ordem-lista   as integer no-undo.
    def var i-tenta-lista   as integer no-undo.

    DEF VAR l-proces-compl  AS LOG     NO-UNDO.
    DEF VAR l-prossegue-gerac-elimin AS LOG NO-UNDO.
    
    def var l-lim-lista   as logical no-undo.
    
    def temp-table tt-lista NO-UNDO
        field seq-aprov       like mla-lista-aprov-doc.seq-aprov
        field cod-usuar-aprov like mla-lista-aprov-doc.cod-usuar
        field limite-aprov    like mla-perm-aprov.limite-aprov
        field rowlista        as rowid
        index chave as primary seq-aprov
        index limite limite-aprov.

    define temp-table tt-mla014e no-undo
           field ErrorSequence    as integer
           field ErrorNumber      as integer
           field ErrorDescription as character
           field ErrorParameters  as character
           field ErrorType        as character
           field ErrorHelp        as character
           field ErrorSubType     as character
           index seq ErrorSequence.

    DEF VAR de-limite-auto AS DECIMAL NO-UNDO.
    DEF BUFFER bf-mla-perm-aprov    FOR mla-perm-aprov.
    DEF BUFFER bf-mla-lim-aprov-fam FOR mla-lim-aprov-fam.
    DEF BUFFER bb-mla-usuar-aprov   FOR mla-usuar-aprov.
    DEFINE VARIABLE c-msgs-26593 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-help-26593 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-msgs-26652 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-help-26652 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-mensagens-geradas AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-exchange   AS LOGICAL    NO-UNDO.
    DEF VAR c-arq-email          AS CHAR NO-UNDO.

    DEFINE VARIABLE i-programa  AS INTEGER INITIAL 5  NO-UNDO.
    DEFINE VARIABLE l-elimina   AS LOGICAL INITIAL NO NO-UNDO.
    def var l-aprov-auto-doc    as logical no-undo.
    def var l-desvia            as logical no-undo.
    def var c-chave-doc         as char    no-undo.
    def var l-tem-aprovador     as logical no-undo.
    DEF VAR i-cont              AS INTEGER NO-UNDO.
    DEF VAR l-elimina-pend      AS LOG     NO-UNDO.

    DEFINE VARIABLE l-gera-log          AS LOGICAL    NO-UNDO INITIAL YES.
    DEFINE VARIABLE l-avail-ref         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-doc         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-item        AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-avail-fam         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE h-boin772           AS HANDLE     NO-UNDO.

    /* Tradu‡äes */
    {lap/mlaapi001.i05}
    
    /* Vari vel l-mlaapi100-ativo = yes quando a chamada ‚ a partir da aedapi100 */
    DEFINE NEW GLOBAL SHARED VAR l-aedapi100-ativo AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-anexar-conteudo   AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE i-posicao AS INTEGER INITIAL 0 NO-UNDO.
    DEF VAR p-chave-doc LIKE mla-doc-pend-aprov.chave-doc NO-UNDO.

    DEFINE VARIABLE de-valor-conv-mo AS DECIMAL   NO-UNDO.

    IF THIS-PROCEDURE:PERSISTENT THEN DO:
        RETURN "OK":U.
    END.
    ELSE DO:
        RUN pi-executar (INPUT p-cod-tip-doc,
                         INPUT p-tipo-trans,
                         INPUT p-motivo,
                         INPUT p-valor,
                         INPUT p-moeda,
                         INPUT p-usuar-trans,
                         INPUT p-usuar-doc,
                         INPUT p-lotacao-doc,
                         INPUT p-item,
                         INPUT p-referencia,
                         INPUT p-ep-codigo,
                         INPUT p-cod-estabel,
                         INPUT  TABLE tt-mla-chave,
                         OUTPUT TABLE tt-erro).
        RETURN RETURN-VALUE.
    END.

/*---------------------------------------------------------------------------------------------------------------**
**  Purpose:    Gera‡Æo de pendˆncias MLA                                                                        **
**  Parameters: (input) p-cod-tip-doc-2: Tipo do documento (integer)
**              (input) p-tipo-trans-2: Tipo de transa‡Æo (integer)                                             
**              (input) p-motivo-2: Motivo (character)                                                  
**              (input) p-valor-2: Valor da pendˆncia (decimal)                                                   
**              (input) p-moeda-2: Moeda da pendˆncia (integer)                                                   
**              (input) p-usuar-trans-2: Usu rio da transa‡Æo (character)                                               
**              (input) p-usuar-doc-2: Usu rio do documento (character)                                                
**              (input) p-lotacao-doc-2: Lota‡Æo do documento (character)                                              
**              (input) p-item-2: Item do documento (character)                                                     
**              (input) p-referencia-2: Referˆncia do documento (character)                                                
**              (input) p-ep-codigo-2: Empresa do documento (character)                                                
**              (input) p-cod-estabel-2: Estabelecimento do documento (character) 
**              (output) tt-mla-chave: Chave do documento (temp-table)
**              (output) tt-erro: Erros ocorridos do processo (temp-table)                                              
**
------------------------------------------------------------------------------------------------------------------*/
    PROCEDURE pi-executar:
        DEFINE INPUT  PARAMETER p-cod-tip-doc-2 AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-tipo-trans-2  AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-motivo-2      AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-valor-2       AS DECIMAL   NO-UNDO.
        DEFINE INPUT  PARAMETER p-moeda-2       AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-usuar-trans-2 AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-usuar-doc-2   AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-lotacao-doc-2 AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-item-2        AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-referencia-2  AS CHARACTER NO-UNDO. 
        DEFINE INPUT  PARAMETER p-ep-codigo-2   LIKE empresa.ep-codigo     NO-UNDO.
        DEFINE INPUT  PARAMETER p-cod-estabel-2 LIKE estabelec.cod-estabel NO-UNDO.
        DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

        EMPTY TEMP-TABLE RowErrors.

        ASSIGN p-cod-tip-doc = p-cod-tip-doc-2 
               p-tipo-trans  = p-tipo-trans-2  
               p-motivo      = p-motivo-2      
               p-valor       = p-valor-2       
               p-moeda       = p-moeda-2       
               p-usuar-trans = p-usuar-trans-2 
               p-usuar-doc   = p-usuar-doc-2   
               p-lotacao-doc = p-lotacao-doc-2 
               p-item        = p-item-2        
               p-referencia  = p-referencia-2  
               p-ep-codigo   = p-ep-codigo-2   
               p-cod-estabel = p-cod-estabel-2. 

        /* Converte valor para moeda corrente */
        IF p-moeda <> 0 THEN DO:
           RUN cdp/cd0812.p (p-moeda, 
                             0,
                             p-valor,
                             TODAY,
                             OUTPUT de-valor-conv-mo).  
           IF  de-valor-conv-mo = ? THEN DO:
               /* Cota‡Æo nÆo cadastrada */                                                                                                             
               RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 1847, INPUT p-moeda).  
               ASSIGN cErrorDescription = return-value.                          
                                                                                 
               CREATE tt-erro.                                                   
               ASSIGN tt-erro.i-sequen = i-seq-erro + 1                          
                      tt-erro.mensagem = cErrorDescription.                      
                      tt-erro.cd-erro  = 1847.                                      
                                                                                 
               RUN insertError IN THIS-PROCEDURE (INPUT 1847,                       
                                                  INPUT "EMS":U,                 
                                                  INPUT "ERROR":U,               
                                                  INPUT string(p-moeda)).         
                                                                                 
               RETURN "NOK":U.                                                   
           END.
           ELSE
               ASSIGN p-valor = de-valor-conv-mo
                      p-moeda = 0.           
        END.

        /* Ponto para mudar o valor gl-not-pendencia-aed */
        if c-nom-prog-upc-mg97   <> "":U or 
            c-nom-prog-appc-mg97 <> "":U or 
            c-nom-prog-dpc-mg97  <> "":U then do:
    
            FOR each tt-epc:
                delete tt-epc.
            end.
        
            create tt-epc.
            assign tt-epc.cod-event     = "MLAAPI001-gl-not-pendencia-aed":U
                   tt-epc.cod-parameter = "tipo-documento":U
                   tt-epc.val-parameter = STRING(p-cod-tip-doc).
    
            create tt-epc.
            assign tt-epc.cod-event     = "MLAAPI001-gl-not-pendencia-aed":U
                   tt-epc.cod-parameter = "p-tipo-trans":U
                   tt-epc.val-parameter = STRING(p-tipo-trans).
            
            {include/i-epc201.i "MLAAPI001-gl-not-pendencia-aed"}
        END.
    
        IF gl-not-pendencia-aed THEN
            RETURN.
    
        IF NOT CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
                          AND funcao.ativo) THEN RETURN.
    
        /**   Monta chave do documento
        **/
        {lap/mlachave.i}
    
        if c-nom-prog-upc-mg97  <> "":U or 
           c-nom-prog-appc-mg97 <> "":U or 
           c-nom-prog-dpc-mg97  <> "":U then do:
    
            FOR each tt-epc:
               delete tt-epc.
           end.
        
           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001":U
                  tt-epc.cod-parameter = "tipo-documento":U
                  tt-epc.val-parameter = STRING(p-cod-tip-doc).
        
           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001":U
                  tt-epc.cod-parameter = "chave":U
                  tt-epc.val-parameter = c-chave.

           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001":U
                  tt-epc.cod-parameter = "usuario-doc":U
                  tt-epc.val-parameter = p-usuar-doc.

           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001":U
                  tt-epc.cod-parameter = "valor-doc":U
                  tt-epc.val-parameter = STRING(p-valor).                  
        
           {include/i-epc201.i "beforemlaapi001"}
        
           find first tt-epc no-lock  
                where tt-epc.cod-event = "beforemlaapi001":U no-error.
           
           if avail  tt-epc and  
              string(tt-epc.cod-parameter,"x(20)") = "new-valor":U then
              assign p-valor = DECIMAL(tt-epc.val-parameter).

           if avail  tt-epc and  
                     tt-epc.cod-parameter = "new-usuario":U then
              assign p-usuar-doc = tt-epc.val-parameter.
        
           for each tt-epc:
              delete tt-epc.
           end.    
        end.
    
        IF gl-not-pendencia-aed THEN
            RETURN.

        IF PROGRAM-NAME(i-programa) MATCHES "*cn0309*":U OR
           PROGRAM-NAME(i-programa) MATCHES "*cc0309*":U THEN 
           ASSIGN l-elimina  = YES
                  l-gera-log = NO.

        IF l-gera-log THEN DO:
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
            PUT SKIP(2).
            PUT UNFORMATTED "====================================================================================================" SKIP.
            {utp/ut-liter.i "Log_AED" *}
            PUT UNFORMATTED ".:: " + RETURN-VALUE + " - ":U + string(today) + " - ":U + string(time,"hh:mm:ss") + " ::." SKIP.
            PUT UNFORMATTED "    " + c-lbl-liter-mlaapi001-geracao-de-pendenc skip
                            "    " + c-lbl-liter-versao + ":   " + STRING(c-prg-vrs) SKIP(1).
            OUTPUT CLOSE.
        END.
    
        find first mla-tipo-doc-aprov 
             where mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo   
               and mla-tipo-doc-aprov.cod-estabel = p-cod-estabel 
               and mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.
        
        if available mla-tipo-doc-aprov and not mla-tipo-doc-aprov.apr-tip-doc then
            return.
    
        assign c-tipo-doc-prog-aprova = if avail mla-tipo-doc-aprov then mla-tipo-doc-aprov.prog-aprova else "".
    
        /**  Parametros
        **/
        find first mla-param-aprov 
             where mla-param-aprov.ep-codigo   = p-ep-codigo 
               and mla-param-aprov.cod-estabel = p-cod-estabel no-lock no-error.
    
        if  avail mla-param-aprov then
            assign l-exchange         = if l-aedapi100-ativo then no else mla-param-aprov.log-exchange
                   l-fluig-integrated = (AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.log-integr-fluig AND mla-param-aprov.log-integr-fluig).
    
        /* Se o documento est  integrado com o Fluig instanciar a handle */
        IF l-fluig-integrated THEN DO:
            IF NOT VALID-HANDLE(h-mlaapi014) THEN
                RUN lap/mlaapi014.p PERSISTENT SET h-mlaapi014.
            RUN setHandleFluig IN h-mlaapi014. /* Inicia o handle da api de integra‡Æo com Fluig apenas uma vez, melhorando a performance da integra‡Æo. */
        END.
        /************************/
        
        if c-nom-prog-upc-mg97  <> "":U or 
           c-nom-prog-appc-mg97 <> "":U or 
           c-nom-prog-dpc-mg97  <> "":U then do:
                                                               
            FOR each tt-epc:
               delete tt-epc.
           end.
                           
           create tt-epc.
           assign tt-epc.cod-event     = "beforemlaapi001-2":U
                  tt-epc.cod-parameter = "chave":U
                  tt-epc.val-parameter = c-chave.
           
            {include/i-epc201.i "beforemlaapi001-2"}           
        end.
    
        IF gl-not-pendencia-aed THEN
            RETURN.

        IF p-tipo-trans = 2 THEN DO:
            FIND FIRST mla-doc-pend-aprov WHERE mla-doc-pend-aprov.ep-codigo   = p-ep-codigo
                                          AND   mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc
                                          AND   mla-doc-pend-aprov.chave-doc   = c-chave
                                          AND   mla-doc-pend-aprov.historico   = NO
                                          NO-LOCK NO-ERROR.
            IF AVAIL mla-doc-pend-aprov THEN DO:
                RUN pi-busca-cond-pagto (OUTPUT i-cod-cond-pag).
                IF NOT mla-tipo-doc-aprov.log-excec-val                                      AND     /* MLA0101 - sempre gera pendencia */
                   mla-param-aprov.log-cond-pagto                                            AND     /* MLA0000 - Exce‡Æo gera‡Æo de pendencia: CondPagto x Valor */
                   mla-doc-pend-aprov.valor-doc = p-valor                                    AND
                  (TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) = "":U                    OR
                   TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) = string(i-cod-cond-pag)) THEN
                    RETURN.
            END.
        END.
    
        /**  Gera hist¢ricos
             -Obs.: Documentos do Financeiro utilizam mesma chave para criar "n" pendencias
                    Sendo assim quando passado "1 - inclusao", nao se pode eliminar as pendencias 
                    ja existentes e que ainda nao foram aprovadas ou rejeitadas
        **/
        if (p-tipo-trans = 1 and p-cod-tip-doc < 21 and (p-cod-tip-doc <> 9 and p-cod-tip-doc <> 10)) or  
           p-tipo-trans = 2 or
           p-tipo-trans = 3 then do:
            ASSIGN l-prossegue-gerac-elimin = NO
                   l-sempre-gera            = NO 
                   l-gera-condpg-valor      = NO.
        
            for each mla-doc-pend-aprov where
                mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   and
                mla-doc-pend-aprov.cod-estabel  = p-cod-estabel and        
                mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc and
                mla-doc-pend-aprov.chave-doc    = c-chave       and
                mla-doc-pend-aprov.historico    = NO EXCLUSIVE-LOCK:
        
                /**  Refaz saldo da verba - REFAZER SOMENTE QUANDO A SITUA€ÇO FOR 1, CASO CONTRµRIO ESTARµ REFAZENDO SALDO QUE NÇO FOI CONSUMIDO
                **/
                IF  mla-doc-pend-aprov.ind-situacao = 2 THEN DO:
                
                    find first mla-verba-aprov where
                        mla-verba-aprov.ep-codigo   = p-ep-codigo and
                        mla-verba-aprov.cod-estabel = p-cod-estabel and
                        mla-verba-aprov.cod-usuar   = (if mla-doc-pend-aprov.cod-usuar-altern <> "" then mla-doc-pend-aprov.cod-usuar-altern 
                                                       else mla-doc-pend-aprov.cod-usuar) and
                        mla-verba-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc     and
                        mla-verba-aprov.periodo-ini <= mla-doc-pend-aprov.dt-geracao      and
                        mla-verba-aprov.periodo-fim >= mla-doc-pend-aprov.dt-geracao      and
                        mla-verba-aprov.verba-utilizada <> 0
                        exclusive-lock no-error.
        
                    if available mla-verba-aprov then do:
                        
                        assign de-val-doc-convert = mla-doc-pend-aprov.valor-doc
                               mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada - de-val-doc-convert.
                        release mla-verba-aprov.
                    end.
                END.
                IF  AVAIL mla-param-aprov
                AND mla-param-aprov.log-cond-pagto THEN DO: /*Exce‡Æo gera‡Æo de pendencia: CondPagto x Valor*/
                    
                    FIND FIRST mla-tipo-doc-aprov NO-LOCK
                         WHERE mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo 
                           AND mla-tipo-doc-aprov.cod-estabel = p-cod-estabel 
                           AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-ERROR.
                    IF AVAIL mla-tipo-doc-aprov THEN DO:
                        IF mla-tipo-doc-aprov.log-excec-val THEN DO: /*sempre gera pendencia*/
                            IF mla-doc-pend-aprov.ind-situacao > 1 THEN DO:
        
                                ASSIGN l-elimina-pend = YES.
        
                                IF  p-tipo-trans = 3
                                AND (mla-doc-pend-aprov.cod-tip-doc = 2 OR
                                     mla-doc-pend-aprov.cod-tip-doc = 4)
                                AND CAN-FIND(FIRST it-requisicao 
                                             WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                               AND it-requisicao.numero-ordem <> 0) THEN DO:
                
                                    ASSIGN i-cont = 0.
                                    FOR EACH it-requisicao NO-LOCK
                                       WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                         AND it-requisicao.numero-ordem  = 0
                                         AND it-requisicao.situacao      = 1:
                
                                        ASSIGN i-cont = i-cont + 1.
                                        IF i-cont > 1 THEN
                                            LEAVE.
                                    END.
                
                                    IF i-cont = 1 THEN
                                        ASSIGN l-elimina-pend = NO.
                                END.
                
                                IF l-elimina-pend THEN
                                    assign mla-doc-pend-aprov.historico   = yes
                                           mla-doc-pend-aprov.motivo-hist = p-motivo.
                                ELSE
                                    NEXT.
                            END.
        
                            ASSIGN l-prossegue-gerac-elimin = YES
                                   l-sempre-gera            = YES.
        
                            ASSIGN iTipoCancelamento = 1.
                            RUN pi-elimina-documentos-pendentes.
                        END.
                        ELSE DO: 
                            RUN pi-busca-cond-pagto (OUTPUT i-cod-cond-pag).
        
                            IF mla-doc-pend-aprov.valor-doc    <> p-valor 
                            OR ( TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) <>  "":U
                                 AND TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) <> string(i-cod-cond-pag)) THEN DO:
        
                                ASSIGN l-prossegue-gerac-elimin = YES
                                       l-gera-condpg-valor      = YES.
                                IF mla-doc-pend-aprov.ind-situacao > 1 THEN DO:
        
                                    ASSIGN l-elimina-pend = YES.
        
                                    IF  p-tipo-trans = 3
                                    AND (mla-doc-pend-aprov.cod-tip-doc = 2 OR
                                         mla-doc-pend-aprov.cod-tip-doc = 4)
                                    AND CAN-FIND(FIRST it-requisicao 
                                                 WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                                   AND it-requisicao.numero-ordem <> 0) THEN DO:
                    
                                        ASSIGN i-cont = 0.
                                        FOR EACH it-requisicao NO-LOCK
                                           WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                             AND it-requisicao.numero-ordem  = 0
                                             AND it-requisicao.situacao      = 1:
                    
                                            ASSIGN i-cont = i-cont + 1.
                                            IF i-cont > 1 THEN
                                                LEAVE.
                                        END.
                    
                                        IF i-cont = 1 THEN
                                            ASSIGN l-elimina-pend = NO.
                                    END.
                    
                                    IF l-elimina-pend THEN
                                        assign mla-doc-pend-aprov.historico   = yes
                                               mla-doc-pend-aprov.motivo-hist = p-motivo.
                                    ELSE
                                        NEXT.
                                END.
                                    
                                /**  Elimina documentos pendentes para geracao de nova pendencia **/
                                ASSIGN iTipoCancelamento = 1.
                                RUN pi-elimina-documentos-pendentes.
                            END.
                            ELSE DO:
        
                                IF mla-doc-pend-aprov.ind-situacao > 1 THEN DO:
        
                                    ASSIGN l-elimina-pend = YES.
        
                                    IF  p-tipo-trans = 3
                                    AND (mla-doc-pend-aprov.cod-tip-doc = 2 OR
                                         mla-doc-pend-aprov.cod-tip-doc = 4)
                                    AND CAN-FIND(FIRST it-requisicao 
                                                 WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                                   AND it-requisicao.numero-ordem <> 0) THEN DO:
                    
                                        ASSIGN i-cont = 0.
                                        FOR EACH it-requisicao NO-LOCK
                                           WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                             AND it-requisicao.numero-ordem  = 0
                                             AND it-requisicao.situacao      = 1:
                    
                                            ASSIGN i-cont = i-cont + 1.
                                            IF i-cont > 1 THEN
                                                LEAVE.
                                        END.
                    
                                        IF i-cont = 1 THEN
                                            ASSIGN l-elimina-pend = NO.
                                    END.
                    
                                    IF l-elimina-pend THEN
                                        ASSIGN l-prossegue-gerac-elimin = NO.
                                    ELSE
                                        NEXT.
                                END.
                                ELSE
                                    ASSIGN l-prossegue-gerac-elimin = NO.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
        
                    IF mla-doc-pend-aprov.ind-situacao > 1 THEN DO:
                    
                        ASSIGN l-elimina-pend = YES.
        
                        IF  p-tipo-trans = 3
                        AND (mla-doc-pend-aprov.cod-tip-doc = 2 OR
                             mla-doc-pend-aprov.cod-tip-doc = 4)
                        AND CAN-FIND(FIRST it-requisicao 
                                     WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                       AND it-requisicao.numero-ordem <> 0) THEN DO:
        
                            ASSIGN i-cont = 0.
                            FOR EACH it-requisicao NO-LOCK
                               WHERE it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                 AND it-requisicao.numero-ordem  = 0
                                 AND it-requisicao.situacao      = 1:
        
                                ASSIGN i-cont = i-cont + 1.
                                IF i-cont > 1 THEN
                                    LEAVE.
                            END.
        
                            IF i-cont = 1 THEN
                                ASSIGN l-elimina-pend = NO.
                        END.
        
                        IF l-elimina-pend THEN
                            assign mla-doc-pend-aprov.historico   = yes
                                   mla-doc-pend-aprov.motivo-hist = p-motivo.
                        ELSE
                            NEXT.
                    END.
        
                    /**  Elimina documentos pendentes para geracao de nova pendencia **/
                    ASSIGN l-prossegue-gerac-elimin = YES.
                    IF p-tipo-trans = 3 THEN
                        ASSIGN iTipoCancelamento = 2.
                    ELSE
                        ASSIGN iTipoCancelamento = 1.
                    RUN pi-elimina-documentos-pendentes.
                END.
        
                IF p-tipo-trans = 3 THEN DO:
                    /**  Elimina todas as pendˆncias do documento quando o documento original for eliminado **/
                    ASSIGN l-prossegue-gerac-elimin = YES.
                    ASSIGN iTipoCancelamento = 2.
                    RUN pi-elimina-documentos-pendentes.
                END.
            end.
            
            IF  NOT l-sempre-gera 
            AND NOT l-gera-condpg-valor
            AND NOT CAN-FIND(FIRST mla-doc-pend-aprov 
                            WHERE mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   
                              AND mla-doc-pend-aprov.cod-estabel  = p-cod-estabel 
                              AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
                              AND mla-doc-pend-aprov.chave-doc    = c-chave        
                              AND mla-doc-pend-aprov.historico    = NO)  THEN DO:
                ASSIGN l-prossegue-gerac-elimin = YES.
            END.
        
            /* Quando se esta incluindo um documento por total que tem o controle do char-1(2,4,7,8), e se tem o parametro 
               de valor e condicao de pagamento marcado no MLA0000 precisa seguir o processo para o envio de e-mail, 
               so realizado ao final(fechamento da tela) quando a variavel de controle esta igual a "S"
             */
            IF  p-tipo-trans = 1
            AND (p-cod-tip-doc = 2 OR p-cod-tip-doc = 4 OR p-cod-tip-doc = 7 OR p-cod-tip-doc = 8)
            AND AVAIL mla-param-aprov
            AND mla-param-aprov.log-cond-pagto THEN DO:
        
                for each mla-doc-pend-aprov 
                   where mla-doc-pend-aprov.ep-codigo    = p-ep-codigo   
                     and mla-doc-pend-aprov.cod-estabel  = p-cod-estabel 
                     and mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
                     and mla-doc-pend-aprov.chave-doc    = c-chave       
                     and mla-doc-pend-aprov.historico    = NO EXCLUSIVE-LOCK:
                    
                    /**  Elimina documentos pendentes para geracao de nova pendencia **/
                    ASSIGN iTipoCancelamento = 1.
                    RUN pi-elimina-documentos-pendentes.
                END.
        
                RUN pi-valida-docto(OUTPUT l-proces-compl).
                
                IF l-proces-compl THEN
                    ASSIGN l-prossegue-gerac-elimin = YES.
            END.
            
        
            IF  NOT l-prossegue-gerac-elimin THEN
                RETURN.
            
            /**  Elimina todas as pendˆncias do documento quando o documento original for eliminado
            **/
            
            if  p-tipo-trans = 3 then
                for each  mla-doc-pend-aprov 
                    where mla-doc-pend-aprov.ep-codigo   = p-ep-codigo   
                      and mla-doc-pend-aprov.cod-estabel = p-cod-estabel 
                      and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
                      and mla-doc-pend-aprov.chave-doc   = c-chave exclusive-lock:
                    
                    IF l-gera-log THEN DO:
                        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                        put unformatted skip
                                        c-lbl-liter-elimina-todas-as-pendencias-d + ". " skip
                                        c-lbl-liter-modificacao-2-eliminacao-3         + "             = " p-tipo-trans                   skip
                                        c-lbl-liter-empresa   + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                                        c-lbl-liter-estabelecimento   + "                              = " mla-doc-pend-aprov.cod-estabel skip
                                        c-lbl-liter-documento   + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                                        c-lbl-liter-chave   + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                                        c-lbl-liter-historico   + "                                    = " mla-doc-pend-aprov.historico   skip.     
                        FOR EACH tt-erro:
                            PUT UNFORMATTED tt-erro.mensagem.
                        END.
                        output close.
                    END.

                    IF mla-doc-pend-aprov.cod-tip-doc = 1 AND mla-doc-pend-aprov.historico THEN
                        IF CAN-FIND(FIRST it-requisicao 
                                     where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                                      AND it-requisicao.numero-ordem <> 0) THEN
                            NEXT.
        
                    
                    /** Solicita‡äes Fluig j  aprovadas ou rejeitadas, nÆo podem ser canceladas */
                    IF l-fluig-integrated AND mla-doc-pend-aprov.cdn-workflow-fluig > 0 AND mla-doc-pend-aprov.ind-situacao = 1 THEN DO:
                        RUN cancelProcessFluig IN h-mlaapi014(INPUT mla-doc-pend-aprov.nr-trans,
                                                              INPUT 2,
                                                              OUTPUT TABLE RowErrorsAux).
                        IF RETURN-VALUE <> "OK":U THEN DO:
                            /* Erro na integracao, favor olhar monitor de integra‡Æo*/
                            RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "":U).
                            ASSIGN cErrorDescription = return-value.
                            RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "":U).
                            ASSIGN cErrorHelp = return-value.
            
                            IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                                CREATE tt-erro.
                                ASSIGN tt-erro.mensagem = cErrorDescription + " - ":U + cErrorHelp.
                                       tt-erro.cd-erro  = 54790.
                            END.

                            IF NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorNumber = 54790) THEN DO:
                                RUN insertError IN THIS-PROCEDURE (INPUT 54790,
                                                                   INPUT "EMS":U,
                                                                   INPUT "ERROR":U,
                                                                   INPUT "WARNING":U,
                                                                   INPUT "":U).
                            END.
                        END.
                    END.
                     
                    IF mla-doc-pend-aprov.historico = NO THEN
                        delete mla-doc-pend-aprov.
                end.

            /** Elimina as pendˆncias com o estabelecimento diferente do documento  **/
            for each  mla-doc-pend-aprov 
                where mla-doc-pend-aprov.ep-codigo   = p-ep-codigo   
                  and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
                  and mla-doc-pend-aprov.chave-doc   = c-chave 
                  and mla-doc-pend-aprov.cod-estabel <> p-cod-estabel exclusive-lock:
        
                RUN pi-chama-epc-eliminacao.
            
                IF l-gera-log THEN DO:
                    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                    put unformatted skip
                                    c-lbl-liter-elimina-pendencias-com-o-esta + "." skip
                                    c-lbl-liter-modificacao-2-eliminacao-3 +         "             = " p-tipo-trans                   skip
                                    c-lbl-liter-empresa   + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                                    c-lbl-liter-estabelecimento-novo +     "                       = " mla-doc-pend-aprov.cod-estabel skip
                                    c-lbl-liter-estabelecimento-antigo +     "                     = " p-cod-estabel                  skip
                                    c-lbl-liter-documento   + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                                    c-lbl-liter-chave   + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                                    c-lbl-liter-historico   + "                                    = " mla-doc-pend-aprov.historico   skip.     
                    FOR EACH tt-erro:
                        PUT UNFORMATTED tt-erro.mensagem.
                    END.
                    output close.
                END.
        
                /* Integra‡Æo com o Fluig */
                IF l-fluig-integrated AND mla-doc-pend-aprov.cdn-workflow-fluig > 0 AND mla-doc-pend-aprov.ind-situacao = 1 THEN DO:
                    RUN cancelProcessFluig IN h-mlaapi014(INPUT mla-doc-pend-aprov.nr-trans,
                                                          INPUT 2,
                                                          OUTPUT TABLE RowErrorsAux).
                    IF RETURN-VALUE <> "OK":U THEN DO:
                        /* Erro na integracao, favor olhar monitor de integra‡Æo*/
                        RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "":U).
                        ASSIGN cErrorDescription = return-value.
                        RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "":U).
                        ASSIGN cErrorHelp = return-value.
        
                        IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = cErrorDescription + " - " + cErrorHelp.
                                   tt-erro.cd-erro  = 54790.
                        END.

                        IF NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorNumber = 54790) THEN DO:
                            RUN insertError IN THIS-PROCEDURE (INPUT 54790,
                                                               INPUT "EMS":U,
                                                               INPUT "WARNING":U,
                                                               INPUT "":U).
                        END.
                    END.
                END.
        
                IF mla-doc-pend-aprov.historico = NO THEN
                    delete mla-doc-pend-aprov.
            end.
            
            /** Elimina as pendˆncias com a empresa diferente do documento  **/
            for each  mla-doc-pend-aprov 
                where mla-doc-pend-aprov.ep-codigo   <> p-ep-codigo   
                  and mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc 
                  and mla-doc-pend-aprov.chave-doc   = c-chave 
                  and mla-doc-pend-aprov.cod-estabel <> p-cod-estabel exclusive-lock:
        
                RUN pi-chama-epc-eliminacao.
            
                IF l-gera-log THEN DO:
                    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                    put unformatted skip
                                    c-lbl-liter-elimina-pendencias-com-o-esta + "." skip
                                    c-lbl-liter-modificacao-2-eliminacao-3 + "             = " p-tipo-trans                   skip
                                    c-lbl-liter-empresa + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                                    c-lbl-liter-estabelecimento-novo   + "                       = " mla-doc-pend-aprov.cod-estabel skip
                                    c-lbl-liter-estabelecimento-antigo   + "                     = " p-cod-estabel                  skip
                                    c-lbl-liter-documento + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                                    c-lbl-liter-chave + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                                    c-lbl-liter-historico + "                                    = " mla-doc-pend-aprov.historico   skip.     
                    FOR EACH tt-erro:
                        PUT UNFORMATTED tt-erro.mensagem.
                    END.
                    output close.
                END.
        
                /* Integra‡Æo com o Fluig */
                IF l-fluig-integrated AND mla-doc-pend-aprov.cdn-workflow-fluig > 0 AND mla-doc-pend-aprov.ind-situacao = 1 THEN DO:
                    RUN cancelProcessFluig IN h-mlaapi014(INPUT mla-doc-pend-aprov.nr-trans,
                                                          INPUT 2,
                                                          OUTPUT TABLE RowErrorsAux).
                    IF RETURN-VALUE <> "OK":U THEN DO:
                        /* Erro na integracao, favor olhar monitor de integra‡Æo*/
                        RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "":U).
                        ASSIGN cErrorDescription = return-value.
                        RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "":U).
                        ASSIGN cErrorHelp = return-value.
        
                        IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = cErrorDescription + " - " + cErrorHelp.
                                   tt-erro.cd-erro  = 54790.
                        END.

                        IF NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorNumber = 54790) THEN DO:
                            RUN insertError IN THIS-PROCEDURE (INPUT 54790,
                                                               INPUT "EMS":U,
                                                               INPUT "WARNING":U,
                                                               INPUT "":U).
                        END.
                    END.
                END.
        
                IF mla-doc-pend-aprov.historico = NO THEN
                    delete mla-doc-pend-aprov.
            end.
        end.    /* Fim Geracao de Historico */
    
        find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-trans no-lock no-error.
        if  avail mla-usuar-aprov then
            assign c-lotacao-trans = mla-usuar-aprov.cod-lotacao. 
        ELSE DO:
            /* Usu rio &1 nÆo cadastrqado para o m¢dulo MLA */
            RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 18553, INPUT p-usuar-trans + "~~" + "MLA":U).
            ASSIGN cErrorDescription = return-value.
    
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = RETURN-VALUE.
                   tt-erro.cd-erro  = 18553.

            RUN insertError IN THIS-PROCEDURE (INPUT 18553,
                                               INPUT "EMS":U,
                                               INPUT "ERROR":U,
                                               INPUT p-usuar-trans + "~~" + "MLA":U).
    
            RETURN "NOK":U.
        END.
    
        /* busca a lotacao do usuario da transacao para a geracao da pendencia. Estava sendo gerada com a mesma pendencia do usuario do docto */
    
        /* Alteracao para verificar o usuario parametrizado para a aprovacao automatica */
        if  avail mla-usuar-aprov 
        and mla-usuar-aprov.usuar-mestre then
            /* Usuario mestre */
            assign l-mestre = yes.
        else do:
            if  AVAIL mla-param-aprov
            AND mla-param-aprov.int-1 = 1 then 
                /* 1 - Usuario da transacao */
                find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-trans no-lock no-error.
            else
                /* 2 - Usuario do documento */
                find mla-usuar-aprov where mla-usuar-aprov.cod-usuar = p-usuar-doc no-lock no-error.
        end.
    
        /**  Lota‡Æo
        **/
        RUN setLotacao IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        IF l-gera-log THEN DO:
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_":U + string(today,"99-99-99") + ".txt":U) append.    
            put skip(1).
            PUT UNFORMATTED "    " + c-lit-usuario-trans + "                              = " p-usuar-trans                    SKIP.
            PUT UNFORMATTED "    " + c-lit-lotacao-trans + "                              = " c-lotacao-trans                  SKIP.  
            PUT UNFORMATTED "    " + c-lit-usuario-doc + "                                = " p-usuar-doc                      SKIP. 
            PUT UNFORMATTED "    " + c-lit-lotacao-doc + "                                = " c-lotacao                        SKIP.
            PUT UNFORMATTED "    " + c-lit-lotaca-centro-custo           + "              = " mla-usuar-aprov.destino-lotacao  SKIP.
            PUT UNFORMATTED "    " + c-lit-aprova-auto-usuar-trans-doc   + "              = " mla-param-aprov.int-1            SKIP.
            output close.
        END.
        
        /* Inicio - Chamada EPC - MERIAL repasse AED1 */
        if c-nom-prog-upc-mg97  <> "":U or 
           c-nom-prog-appc-mg97 <> "":U or 
           c-nom-prog-dpc-mg97  <> "":U then do:
           
           for each tt-epc:
               delete tt-epc.
           end.
        
           create tt-epc.
           assign tt-epc.cod-event     = "afterLotacao":U
                  tt-epc.cod-parameter = "tipo-documento":U
                  tt-epc.val-parameter = STRING(p-cod-tip-doc).
        
           create tt-epc.
           assign tt-epc.cod-event     = "afterLotacao":U
                  tt-epc.cod-parameter = "chave":U
                  tt-epc.val-parameter = c-chave.
        
           {include/i-epc201.i "afterLotacao"}
        
           find first tt-epc no-lock  
                where tt-epc.cod-event = "afterLotacao" no-error.
           
    
           if avail  tt-epc and  
              string(tt-epc.cod-parameter,"x(20)") = "lotacao-escolhida":U then
              assign c-lotacao = tt-epc.val-parameter.
        
           for each tt-epc:
              delete tt-epc.
           end.
        end.
        /* FIM - Chamada EPC - MERIAL repasse AED1 */
        
        
        /**  Limite do aprovador **/
        FOR FIRST ITEM FIELD(it-codigo fm-codigo) 
            WHERE item.it-codigo = p-item 
            NO-LOCK: END.
    
        if  mla-usuar-aprov.aprova-auto-aprov then do:
    
            find bf-mla-perm-aprov where bf-mla-perm-aprov.ep-codigo   = p-ep-codigo 
                                     and bf-mla-perm-aprov.cod-estabel = p-cod-estabel 
                                     and bf-mla-perm-aprov.cod-usuar   = mla-usuar-aprov.cod-usuar                  /* bf-mla-perm-aprov.cod-usuar   = p-usuar-trans and */
                                     and bf-mla-perm-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.
    
            if avail bf-mla-perm-aprov then 
               assign de-limite-auto      = bf-mla-perm-aprov.limite-aprov
                      l-existe-perm-aprov = YES.
            ELSE 
                ASSIGN l-existe-perm-aprov = NO.
            if  available item then
                find bf-mla-lim-aprov-fam where bf-mla-lim-aprov-fam.ep-codigo   =  p-ep-codigo 
                                            and bf-mla-lim-aprov-fam.fm-codigo   =  item.fm-codigo 
                                            and bf-mla-lim-aprov-fam.cod-usuar   =  mla-usuar-aprov.cod-usuar        /* bf-mla-lim-aprov-fam.cod-usuar   = p-usuar-trans */
                                            and bf-mla-lim-aprov-fam.cod-tip-doc =  p-cod-tip-doc  no-lock no-error.
    
            if  avail bf-mla-lim-aprov-fam then 
                assign de-limite-auto      = bf-mla-lim-aprov-fam.limite-aprov
                       l-existe-perm-aprov = YES.
    
            if  l-mestre then
                assign de-limite-auto = 9999999999999.99.
    
            IF l-gera-log THEN DO:
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_":U + string(today,"99-99-99") + ".txt":U) APPEND.       
                PUT SKIP(1).
                PUT UNFORMATTED "    " + c-lit-aprova-auto-aprovador SKIP.
                PUT UNFORMATTED "    " + c-lit-usuario + "                                    = " mla-usuar-aprov.cod-usuar SKIP.  
                PUT UNFORMATTED "    " + c-lit-valor-docto + "                                = " p-valor                   SKIP.
                PUT UNFORMATTED "    " + c-lit-limite + "                                     = " de-limite-auto            SKIP. 
                output close.
            END.
        end.
    
        /**  Limite do aprovador
        **/
        if  mla-usuar-aprov.aprova-auto then do:
    		
    		assign de-valor-convert = p-valor.
    		
            find mla-perm-aprov where mla-perm-aprov.ep-codigo    =  p-ep-codigo   
                                  and mla-perm-aprov.cod-estabel  =  p-cod-estabel 
                                  and mla-perm-aprov.cod-tip-doc  =  p-cod-tip-doc 
                                  and mla-perm-aprov.cod-usuar    =  mla-usuar-aprov.cod-usuar 
                                  and mla-perm-aprov.limite-aprov >= de-valor-convert   
                                  and mla-perm-aprov.validade-ini <= today
                                  and mla-perm-aprov.validade-fim >= today no-lock no-error. 
    
            if  avail mla-perm-aprov then 
                assign de-limite-auto = mla-perm-aprov.limite-aprov
                       l-existe-perm-aprov = YES.
            ELSE 
                ASSIGN l-existe-perm-aprov = NO.
    
            if  available item then
                find mla-lim-aprov-fam where mla-lim-aprov-fam.ep-codigo   = p-ep-codigo 
                                         and mla-lim-aprov-fam.fm-codigo   = item.fm-codigo 
                                         and mla-lim-aprov-fam.cod-usuar   = mla-usuar-aprov.cod-usuar      
                                         and mla-lim-aprov-fam.cod-tip-doc = p-cod-tip-doc  no-lock no-error.
            if  available mla-lim-aprov-fam then 
                assign de-limite-auto      = mla-lim-aprov-fam.limite-aprov
                       l-existe-perm-aprov = YES.
            if  l-mestre then
                assign de-limite-auto = 9999999999999.99.
    
            IF l-gera-log THEN DO:
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") APPEND.        
                PUT SKIP(1).
                PUT UNFORMATTED "    " + c-lit-aprova-auto SKIP.
                PUT UNFORMATTED "    " + c-lit-usuario + "                                    = " mla-usuar-aprov.cod-usuar SKIP.  
                put unformatted "    " + c-lit-valor-docto + "                                = " p-valor                   SKIP.
                PUT UNFORMATTED "    " + c-lit-limite + "                                     = " de-limite-auto            SKIP. 
                output close.
            END.
        end.

        if  c-nom-prog-upc-mg97 <> "":U then do:
            for each tt-epc
                where tt-epc.cod-event = "beforeReferencia":U.
                delete tt-epc.
            end.
    
            {include/i-epc200.i2 &CodEvent='"beforeReferencia"'
                                 &CodParameter='"referencia"'
                                 &ValueParameter="string(p-referencia)"}
                                 
            {include/i-epc201.i "beforeReferencia"}
    
            find first tt-epc
                where tt-epc.cod-event     = "beforeReferencia":U
                and   tt-epc.cod-parameter = "referencia-escolhida":U no-error.
            if  avail tt-epc
            and tt-epc.val-parameter <> "":U then
                assign p-referencia = tt-epc.val-parameter.
        end.
        
    
        /**  Gera‡Æo das pendˆncias
        **/
        if  p-tipo-trans = 1 or
            p-tipo-trans = 2 then do:
    
            ASSIGN gi-prox-prior = 0. 
    
            find mla-tipo-doc-aprov where
                mla-tipo-doc-aprov.ep-codigo   = p-ep-codigo and
                mla-tipo-doc-aprov.cod-estabel = p-cod-estabel and
                mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc
                no-lock no-error.
            if avail mla-tipo-doc-aprov then do:
                find first item where item.it-codigo = p-item no-lock no-error.
                if p-cod-tip-doc = 2 or /*Tipos de aprova‡Æo por total do documento*/
                   p-cod-tip-doc = 4 or
                   p-cod-tip-doc = 7 or
                   p-cod-tip-doc = 8 or
                   p-cod-tip-doc = 10 or
                   p-cod-tip-doc = 13 then do:
                   /* Inicio da vali‡Æo para documentos por total - referencia/documento */
                   if mla-tipo-doc-aprov.prioridade-aprov = 3 then do: /* Prioridade:  REFERÒNCIA */
            
                       run pi-verifica-tipo-aprov-ref.
                       if  not l-avail-ref then 
                           run pi-verifica-tipo-aprov-doc.
        
                   end.
                   else if mla-tipo-doc-aprov.prioridade-aprov = 1 then do:    /* Prioridade:  DOCUMENTO */
                       run pi-verifica-tipo-aprov-doc.
                   end. /* Fim da valida‡Æo por referencia e documento por total */ 
                end.
                else  do: /* Inicio valida‡Æo por referencia/item/familia/documento para controle por item */
                   if mla-tipo-doc-aprov.prioridade-aprov = 3 then do:
            
                       run pi-verifica-tipo-aprov-ref.
                       if not l-avail-ref then do:
                           run pi-verifica-tipo-aprov-item.
                           if not l-avail-item then do:
                               run pi-verifica-tipo-aprov-fam.
                               if not l-avail-fam then 
                                   run pi-verifica-tipo-aprov-doc.
                           end.
                       end.
                       
                   end.
                   else if mla-tipo-doc-aprov.prioridade-aprov = 2 then do: /* Inicio valida‡Æo por item/familia/documento */
                       
                       run pi-verifica-tipo-aprov-item.
                       if not l-avail-item then do:
                           run pi-verifica-tipo-aprov-fam.
                           if not l-avail-fam then 
                               run pi-verifica-tipo-aprov-doc.
                       end.
                       
                   end.
                   else if  mla-tipo-doc-aprov.prioridade-aprov = 1 then do: /* Inicio da valida‡Æo por documento */
                       run pi-verifica-tipo-aprov-doc.
                   end.
                end.
            end.
    
            assign gi-prox-prior = i-prioridade.
    
            repeat while i-cod-aprov <> 0:
    
                find mla-tipo-aprov where
                    mla-tipo-aprov.cod-tip-aprov = i-cod-aprov
                    no-lock no-error.
                
                IF AVAIL mla-tipo-aprov THEN DO:
                    CASE mla-tipo-aprov.ind-tip-aprov:
                        WHEN 1 THEN DO:
                            RUN pi-gera-hierarquia.
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                        WHEN 2 THEN DO: 
                            RUN pi-gera-lista.
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                        WHEN 3 THEN DO:
                            RUN pi-gera-padrao.
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                        WHEN 4 THEN DO:
                            RUN pi-gera-padrao.
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                        WHEN 5 THEN DO:
                            RUN pi-gera-faixa.
                            IF RETURN-VALUE = "NOK":U THEN
                                RETURN "NOK":U.
                        END.
                           
                    END CASE.
                END.
    
                /**  Pr¢ximo tipo de aprova‡Æo
                **/
                assign i-cod-aprov = 0.
                /*if gi-prox-prior = 0 then do:*/
                    case i-tip-aprov:
                        when 1 then do:
                            find first mla-tipo-aprov-doc 
                                 where mla-tipo-aprov-doc.ep-codigo        = p-ep-codigo 
                                   and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
                                   and mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                            if available mla-tipo-aprov-doc then
                                assign i-cod-aprov   = mla-tipo-aprov-doc.cod-tip-aprov
                                       gi-prox-prior = mla-tipo-aprov-doc.prioridade-aprov
                                       i-prioridade  = mla-tipo-aprov-doc.prioridade-aprov.
                        end.
                        when 2 then do:
                            find first mla-tipo-aprov-item 
                                 where mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
                                   and mla-tipo-aprov-item.it-codigo        = p-item 
                                   and mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                            if available mla-tipo-aprov-item then
                                assign i-cod-aprov   = mla-tipo-aprov-item.cod-tip-aprov
                                       gi-prox-prior = mla-tipo-aprov-item.prioridade-aprov
                                       i-prioridade  = mla-tipo-aprov-item.prioridade-aprov.
                        end.
                        when 3 then do:
                            if available item then
                            find first mla-tipo-aprov-fam 
                                 where mla-tipo-aprov-fam.ep-codigo        = p-ep-codigo 
                                   and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo
                                   and mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                            if available mla-tipo-aprov-fam then
                                assign i-cod-aprov   = mla-tipo-aprov-fam.cod-tip-aprov
                                       gi-prox-prior = mla-tipo-aprov-fam.prioridade-aprov
                                       i-prioridade  = mla-tipo-aprov-fam.prioridade-aprov.
                        end.
                        when 4 then do:
                            find first mla-tipo-aprov-ref 
                                 where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
                                   and mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc 
                                   and mla-tipo-aprov-ref.codigo           = p-referencia
                                   and mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior + 10 no-lock no-error.
                            if available mla-tipo-aprov-ref then
                                assign i-cod-aprov   = mla-tipo-aprov-ref.cod-tip-aprov
                                       gi-prox-prior = mla-tipo-aprov-ref.prioridade-aprov
                                       i-prioridade  = mla-tipo-aprov-ref.prioridade-aprov.
                        end.
                    end case.
                /*end.*/
            end.
            IF l-executa-pi-aprova-auto THEN DO:
                RUN pi-aprova-auto.
            END.
    
            assign gi-prox-prior = 0.
        end.
    
        /* Elimina o handle da api de integra‡Æo com Fluig apenas uma vez, melhorando a performance da integra‡Æo. */
        IF l-fluig-integrated THEN DO:
            RUN unsetHandleFluig IN h-mlaapi014.
        
            IF VALID-HANDLE(h-mlaapi014) THEN DO:
                DELETE PROCEDURE h-mlaapi014.
                ASSIGN h-mlaapi014 = ?.
            END.
        END.
        
        IF VALID-HANDLE(h-mlaapi019) THEN DO:
            RUN pi-finaliza IN h-mlaapi019.
    
            DELETE PROCEDURE h-mlaapi019.
            ASSIGN h-mlaapi019 = ?.
        END.
        
        RETURN "OK":U.
    END PROCEDURE.

/*---------------------------------------------------------------------------------------------------------------**
**  Purpose:    Gera‡Æo de pendˆncias MLA                                                                        **
**  Parameters: (input) p-cod-tip-doc-2: Tipo do documento (integer)
**              (input) p-tipo-trans-2: Tipo de transa‡Æo (integer)                                             
**              (input) p-motivo-2: Motivo (character)                                                  
**              (input) p-valor-2: Valor da pendˆncia (decimal)                                                   
**              (input) p-moeda-2: Moeda da pendˆncia (integer)                                                   
**              (input) p-usuar-trans-2: Usu rio da transa‡Æo (character)                                               
**              (input) p-usuar-doc-2: Usu rio do documento (character)                                                
**              (input) p-lotacao-doc-2: Lota‡Æo do documento (character)                                              
**              (input) p-item-2: Item do documento (character)                                                     
**              (input) p-referencia-2: Referˆncia do documento (character)                                                
**              (input) p-ep-codigo-2: Empresa do documento (character)                                                
**              (input) p-cod-estabel-2: Estabelecimento do documento (character) 
**              (output) tt-mla-chave: Chave do documento (temp-table)
**              (output) tt-erro: Erros ocorridos do processo (temp-table)                                              
**
------------------------------------------------------------------------------------------------------------------*/
    PROCEDURE pi-executar-2:
        DEFINE INPUT  PARAMETER p-cod-tip-doc-2 AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-tipo-trans-2  AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-motivo-2      AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-valor-2       AS DECIMAL   NO-UNDO.
        DEFINE INPUT  PARAMETER p-moeda-2       AS INTEGER   NO-UNDO.
        DEFINE INPUT  PARAMETER p-usuar-trans-2 AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-usuar-doc-2   AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-lotacao-doc-2 AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-item-2        AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER p-referencia-2  AS CHARACTER NO-UNDO. 
        DEFINE INPUT  PARAMETER p-ep-codigo-2   LIKE empresa.ep-codigo     NO-UNDO.
        DEFINE INPUT  PARAMETER p-cod-estabel-2 LIKE estabelec.cod-estabel NO-UNDO.
        DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.
        DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

        ASSIGN p-cod-tip-doc = p-cod-tip-doc-2 
               p-tipo-trans  = p-tipo-trans-2  
               p-motivo      = p-motivo-2      
               p-valor       = p-valor-2       
               p-moeda       = p-moeda-2       
               p-usuar-trans = p-usuar-trans-2 
               p-usuar-doc   = p-usuar-doc-2   
               p-lotacao-doc = p-lotacao-doc-2 
               p-item        = p-item-2        
               p-referencia  = p-referencia-2  
               p-ep-codigo   = p-ep-codigo-2   
               p-cod-estabel = p-cod-estabel-2.

        RUN pi-executar IN THIS-PROCEDURE (INPUT p-cod-tip-doc,
                                           INPUT p-tipo-trans,
                                           INPUT p-motivo,
                                           INPUT p-valor,
                                           INPUT p-moeda,
                                           INPUT p-usuar-trans,
                                           INPUT p-usuar-doc,
                                           INPUT p-lotacao-doc,
                                           INPUT p-item,
                                           INPUT p-referencia,
                                           INPUT p-ep-codigo,
                                           INPUT p-cod-estabel,
                                           INPUT  TABLE tt-mla-chave,
                                           OUTPUT TABLE tt-erro).
        
        RETURN "OK":U.
    END PROCEDURE.

    /**  Gera hierarquia
    **/
    procedure pi-gera-hierarquia:
        find first mla-hierarquia-aprov where
            mla-hierarquia-aprov.ep-codigo   = p-ep-codigo   and
            mla-hierarquia-aprov.cod-estabel = p-cod-estabel and        
            mla-hierarquia-aprov.cod-lotacao = c-lotacao     and
            mla-hierarquia-aprov.cod-tip-doc = p-cod-tip-doc 
            no-lock no-error.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        PUT SKIP(1).
        PUT UNFORMATTED "    " + c-lit-gera-hierarquia                                                  SKIP.
        PUT UNFORMATTED "    " + c-lit-empresa + "                                    = " p-ep-codigo   SKIP.  
        PUT UNFORMATTED "    " + c-lit-estabelec + "                                  = " p-cod-estabel SKIP.
        PUT UNFORMATTED "    " + c-lit-lotacao + "                                    = " c-lotacao     SKIP.
        PUT UNFORMATTED "    " + c-lit-documento + "                                  = " p-cod-tip-doc SKIP.
        OUTPUT CLOSE.
        
        if available mla-hierarquia-aprov then do:
            run pi-gera-pendencia (mla-hierarquia-aprov.cod-usuar,
                                   0,
                                   mla-hierarquia-aprov.seq-aprov).
        end.
        ELSE DO:
            {utp/ut-liter.i   NÆo_existe_nenhum_aprovador_cadastrado_para_a_hierarquia_(mla0113) }
            RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 32504, INPUT ". ":U + RETURN-VALUE).
            ASSIGN cErrorDescription = return-value.
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-seq-erro + 1
                   tt-erro.mensagem = cErrorDescription.
                   tt-erro.cd-erro  = 32504.

            RUN insertError IN THIS-PROCEDURE (INPUT 32504,
                                               INPUT "EMS":U,
                                               INPUT "ERROR":U,
                                               INPUT STRING(p-cod-tip-doc) + "~~":U + 
                                                     p-ep-codigo           + "~~":U +
                                                     p-cod-estabel         + "~~":U +
                                                     STRING(p-cod-tip-doc) + "~~":U +
                                                     cErrorDescription).
            RETURN "NOK":U.
        END.
    end procedure.
    
    
    /**  Gera lista
    **/
    procedure pi-gera-lista:
        DEFINE VARIABLE i-ordem-lista-orig AS INTEGER     NO-UNDO.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        put skip(1).
        PUT UNFORMATTED "    " + c-lit-gera-lista + "  "                                                SKIP.
        PUT UNFORMATTED "    " + c-lit-empresa + "                                    = " p-ep-codigo   SKIP.  
        PUT UNFORMATTED "    " + c-lit-estabelec + "                                  = " p-cod-estabel SKIP.
        PUT UNFORMATTED "    " + c-lit-documento + "                                  = " p-cod-tip-doc SKIP.
        PUT UNFORMATTED "    " + c-lit-referencia + "                                 = " p-referencia  SKIP.
        OUTPUT CLOSE.
        assign c-apr-lista = "":U
               i-seq-lista = 0
               i-tip-lista = 0.
               
        assign l-achou-lista = no
               i-tenta-lista   = 1
               l-tem-aprovador = no.
        
        case mla-tipo-doc-aprov.prioridade-aprov:
            when 1 then assign i-ordem-lista = 4.
            when 2 then assign i-ordem-lista = 2.
            when 3 then assign i-ordem-lista = 1.
        end case.
               
        ASSIGN i-ordem-lista-orig = i-ordem-lista.
     
        do while not l-achou-lista and
            i-tenta-lista < 5:
            
            case i-ordem-lista:
                when 1 then do:

                   assign l-desvia = no.

                   /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                   if c-nom-prog-upc-mg97  <> "":U or 
                      c-nom-prog-appc-mg97 <> "":U or 
                      c-nom-prog-dpc-mg97  <> "":U then do:
                      for each tt-epc:
                          delete tt-epc.
                      end.
                                           
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF":U
                             tt-epc.cod-parameter = "lotacao":U
                             tt-epc.val-parameter = p-lotacao-doc. 
		
					  assign de-valor-convert = p-valor.
					  
					  find first mla-usuar-aprov
						  where mla-usuar-aprov.cod-usuar = p-usuar-doc no-lock no-error.
						
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF":U
                             tt-epc.cod-parameter = "valor-doc":U
                             tt-epc.val-parameter = string(de-valor-convert). 
                                          
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF":U
                             tt-epc.cod-parameter = "cod-usuar-doc":U
                             tt-epc.val-parameter = p-usuar-doc. 
                       
                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF":U
                             tt-epc.cod-parameter = "cod-tip-doc":U
                             tt-epc.val-parameter = string(p-cod-tip-doc).

                      create tt-epc.
                      assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-REF":U
                             tt-epc.cod-parameter = "codigo-referencia":U
                             tt-epc.val-parameter = p-referencia.
                       
                      {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-REF"}
                      if return-value <> "NOK":U then
                         assign l-desvia = no.
                      else
                         assign l-desvia = yes.
                    
                   end.
                   /* Fim - Chamada EPC - MERIAL repasse AED1 */
                    
                   if l-desvia = no then do:

                      /**  Referˆncia
                      **/
                       find mla-tipo-aprov-ref
                      where mla-tipo-aprov-ref.ep-codigo     = p-ep-codigo 
                        and mla-tipo-aprov-ref.cod-tip-doc   = p-cod-tip-doc
                        and mla-tipo-aprov-ref.codigo        = p-referencia
                        and mla-tipo-aprov-ref.cod-tip-aprov = i-cod-aprov no-lock no-error.
                       if avail mla-tipo-aprov-ref then do:
                          if not l-lim-lista then do: /* todos os aprovadores */
                           
                             for each mla-lista-aprov-ref
                                where mla-lista-aprov-ref.ep-codigo   = p-ep-codigo
                                  and mla-lista-aprov-ref.cod-estabel = p-cod-estabel
                                  and mla-lista-aprov-ref.cod-tip-doc = p-cod-tip-doc
                                  and mla-lista-aprov-ref.codigo      = p-referencia no-lock:
                                  
                                find first mla-perm-aprov
                                     where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                       and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                       and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                       and mla-perm-aprov.cod-usuar     = mla-lista-aprov-ref.cod-usuar no-lock no-error.
                                  
                                if avail mla-perm-aprov then do:
                                   create tt-lista.
                                   assign tt-lista.seq-aprov       = mla-lista-aprov-ref.seq-aprov
                                          tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                          tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                          tt-lista.rowlista        = rowid(mla-lista-aprov-ref).
                                          l-achou-lista            = YES.
                                  
                                end.
                             end.
                             
                          end.
                          else do: /* apenas aprovadores com limite */
                              
                             for each mla-lista-aprov-ref
                                where mla-lista-aprov-ref.ep-codigo   = p-ep-codigo
                                  and mla-lista-aprov-ref.cod-estabel = p-cod-estabel
                                  and mla-lista-aprov-ref.cod-tip-doc = p-cod-tip-doc
                                  and mla-lista-aprov-ref.codigo      = p-referencia no-lock:
                
                                find first mla-perm-aprov
                                     where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                       and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                       and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                       and mla-perm-aprov.cod-usuar     = mla-lista-aprov-ref.cod-usuar no-lock no-error.
									   
								assign de-valor-convert = p-valor.

                                if  avail mla-perm-aprov
                                    and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                    create tt-lista.
                                    assign tt-lista.seq-aprov       = mla-lista-aprov-ref.seq-aprov
                                           tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                           tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                           tt-lista.rowlista        = rowid(mla-lista-aprov-ref)
                                           l-achou-lista            = YES.
                                end.
                             end.
                             
                             release mla-lista-aprov-ref.
                             
                             find first tt-lista no-lock no-error.
                             if available tt-lista then
                                find first mla-lista-aprov-ref 
                                     where rowid(mla-lista-aprov-ref) = tt-lista.rowlista no-lock no-error.
     
                             
                          end.                    

                       end.
                   end.
                end.               
                when 2 then do:
                    /**  Item
                    **/
                    find mla-tipo-aprov-item
                   where mla-tipo-aprov-item.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-item.it-codigo     = p-item
                     and mla-tipo-aprov-item.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-item then do:
                                                           
                       if not l-lim-lista THEN DO: /* todos os aprovadores */
                          for each mla-lista-aprov-item
                             where mla-lista-aprov-item.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-item.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-item.it-codigo   = p-item no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-item.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-item.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-item)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-item
                             where mla-lista-aprov-item.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-item.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-item.it-codigo   = p-item no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-item.cod-usuar no-lock no-error.
                            
						     assign de-valor-convert = p-valor.

                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-item.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-item)
                                        l-achou-lista            = YES.
                             end.
                          end.
   
                          release mla-lista-aprov-item.
                           
                          find first tt-lista no-lock no-error.
                          if available tt-lista THEN
                             find first mla-lista-aprov-item 
                                  where rowid(mla-lista-aprov-item) = tt-lista.rowlista no-lock no-error.
   
                       end.                  
                    end.
                end.         
                when 3 then do:
                    /**  Fam¡lia
                    **/
                    find mla-tipo-aprov-fam
                   where mla-tipo-aprov-fam.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-fam.fm-codigo     = item.fm-codigo
                     and mla-tipo-aprov-fam.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-fam then do:
                       
                       if not l-lim-lista then do: /* todos os aprovadores */
                          for each mla-lista-aprov-fam
                             where mla-lista-aprov-fam.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-fam.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-fam.fm-codigo   = item.fm-codigo no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-fam.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-fam.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-fam)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-fam
                             where mla-lista-aprov-fam.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-fam.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-fam.fm-codigo   = item.fm-codigo no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-fam.cod-usuar no-lock no-error.
								
							 assign de-valor-convert = p-valor.

                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-fam.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-fam).
                                        l-achou-lista            = YES.
                             end.
                          end.
                           
                          release mla-lista-aprov-fam.
                          find first tt-lista no-lock no-error.
                          if available tt-lista then
                             find first mla-lista-aprov-fam 
                                  where rowid(mla-lista-aprov-fam) = tt-lista.rowlista no-lock no-error.
                       
                       end.                    
                    end.
                end.               
                when 4 then do:
                    /**  Documento
                    **/
                   
                    find mla-tipo-aprov-doc
                   where mla-tipo-aprov-doc.ep-codigo     = p-ep-codigo 
                     and mla-tipo-aprov-doc.cod-tip-doc   = p-cod-tip-doc
                     and mla-tipo-aprov-doc.cod-tip-aprov = i-cod-aprov no-lock no-error.
                    if avail mla-tipo-aprov-doc then do:
                       
                       if not l-lim-lista THEN DO: /* todos os aprovadores */
                          for each mla-lista-aprov-doc
                             where mla-lista-aprov-doc.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-doc.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-doc.cod-tip-doc = p-cod-tip-doc no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-doc.cod-usuar no-lock no-error.
                             if avail mla-perm-aprov then do:
                                create tt-lista.
                                assign tt-lista.seq-aprov       = mla-lista-aprov-doc.seq-aprov
                                       tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                       tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                       tt-lista.rowlista        = rowid(mla-lista-aprov-doc)
                                       l-achou-lista            = YES.
                             end.
                          end.
                       end.
                       else do: /* apenas aprovadores com limite */
                           
                          for each mla-lista-aprov-doc
                             where mla-lista-aprov-doc.ep-codigo   = p-ep-codigo
                               and mla-lista-aprov-doc.cod-estabel = p-cod-estabel
                               and mla-lista-aprov-doc.cod-tip-doc = p-cod-tip-doc no-lock:
   
                             find first mla-perm-aprov
                                  where mla-perm-aprov.ep-codigo     = p-ep-codigo
                                    and mla-perm-aprov.cod-estabel   = p-cod-estabel
                                    and mla-perm-aprov.cod-tip-doc   = p-cod-tip-doc
                                    and mla-perm-aprov.cod-usuar     = mla-lista-aprov-doc.cod-usuar no-lock no-error.
									
							 assign de-valor-convert = p-valor.
									
                             if  avail mla-perm-aprov
                                 and mla-perm-aprov.limite-aprov >= de-valor-convert then do: /* verifica limite aprovador */
                                 create tt-lista.
                                 assign tt-lista.seq-aprov       = mla-lista-aprov-doc.seq-aprov
                                        tt-lista.cod-usuar-aprov = mla-perm-aprov.cod-usuar
                                        tt-lista.limite-aprov    = mla-perm-aprov.limite-aprov
                                        tt-lista.rowlista        = rowid(mla-lista-aprov-doc)
                                        l-achou-lista            = YES.
                             end.
                          end.
                           
                          release mla-lista-aprov-doc.
                          find first tt-lista no-lock no-error.
                          if available tt-lista then
                             find first mla-lista-aprov-doc 
                                  where rowid(mla-lista-aprov-doc) = tt-lista.rowlista no-lock no-error.
   
                       end.                    
                    END.
                end.               
            end case.

            IF l-lim-lista THEN DO:
                find first tt-lista no-error.
                assign l-achou-lista = available tt-lista.
            END.
                    
            if not l-achou-lista then
                assign i-ordem-lista = i-ordem-lista + 1.
            
            assign i-tenta-lista = i-tenta-lista + 1.

            IF NOT l-achou-lista AND
               (i-tenta-lista > 4 OR i-ordem-lista > 4) THEN DO:
                {utp/ut-liter.i NÆo_existe_aprovador_cadastrado_para_lista}

                ASSIGN cErrorDescription = return-value.

                /* Prioridade por documento */
                IF i-ordem-lista-orig = 4 THEN
                    ASSIGN cErrorDescription = cErrorDescription + " (MLA0115)":U.
                
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = i-seq-erro + 1
                       tt-erro.mensagem = cErrorDescription.
                       tt-erro.cd-erro  = 32504.
    
                RUN insertError IN THIS-PROCEDURE (INPUT 32504,
                                                   INPUT "EMS":U,
                                                   INPUT "ERROR":U,
                                                   INPUT STRING(p-cod-tip-doc) + "~~":U + 
                                                         p-ep-codigo           + "~~":U +
                                                         p-cod-estabel         + "~~":U +
                                                         STRING(p-cod-tip-doc) + "~~":U +
                                                         cErrorDescription).
                RETURN "NOK":U.
            END. 
        end.

		if i-ordem-lista > 4 then
            assign i-ordem-lista = 1.

        /*************************************************************************/
        /*** INÖCIO CHAMADA EPC - Cliente: XXX / FO: 9999.9999                 ***/
        /*************************************************************************/
        /*** Prop¢sito: Permitir que na aprova‡Æo por lista seja gerada apenas ***/
        /***            uma pendˆncia para um aprovador da lista de acordo com ***/
        /***            o limite de aprova‡Æo                                  ***/
        /*** Parametros:                                                       ***/
        /***    -> HANDLE-TT-LISTA: disponibiliza o handle da tt-lista para    ***/
        /***                        que os aprovadores da lista sejam mani-    ***/
        /***                        pulados, ou seja, permite que os dados     ***/
        /***                        da tt-lista sejam alterados ou eliminados  ***/
        /***                        e devolvidos ao programa para gera‡Æo das  ***/
        /***                        pendˆncias de aprova‡Æo.                   ***/
        /***    -> VALOR-DOCUMENTO: disponibiliza o valor do documento para    ***/
        /***                        que seja verificado se os aprovadores da   ***/
        /***                        lista possuem limite para aprova‡Æo,       ***/
        /***                        gerando apenas uma pendˆncia para o        ***/
        /***                        aprovador que possuir limite para aprova‡Æo***/
        /*************************************************************************/

        if  c-nom-prog-upc-mg97 <> "":U then do:

            for each tt-epc
                where tt-epc.cod-event = "LISTA-APROVADORES":U:
                delete tt-epc.
            end.

            /* handle da temp-table de aprovadores da lista */
            {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                 &CodParameter='"HANDLE-TT-LISTA"'
                                 &ValueParameter="string(temp-table tt-lista:handle)"}

			assign de-valor-convert = p-valor.

			/* valor do pendˆncia */
            {include/i-epc200.i2 &CodEvent='"LISTA-APROVADORES"'
                                 &CodParameter='"VALOR-DOCUMENTO"'
                                 &ValueParameter="string(de-valor-convert)"}

            {include/i-epc201.i "LISTA-APROVADORES"}

            /* caso a EPC retorne erro nÆo deve proceder com a gera‡Æo das pendˆncias */
            if  return-value = "NOK":U then
                return "NOK":U.

        end.

        /*************************************************************************/
        /*** FIM CHAMADA EPC - Cliente: XXX / FO: 9999.9999                    ***/
        /*************************************************************************/

        for each tt-lista no-lock
            by tt-lista.limite-aprov:

            /* gera‡Æo de pendˆncias da lista */
            run pi-gera-pendencia (tt-lista.cod-usuar-aprov,
                                   0,
                                   tt-lista.seq-aprov).
        end.

        RETURN "OK":U.
                                                                                      
    end procedure.
    
    
    /**  Gera padrÆo e t‚cnica
    **/
    procedure pi-gera-padrao:
        find first mla-usuar-padrao where
            mla-usuar-padrao.ep-codigo   = p-ep-codigo and
            mla-usuar-padrao.cod-estabel = p-cod-estabel and        
            mla-usuar-padrao.cod-tip-aprov = mla-tipo-aprov.cod-tip-aprov
            no-lock no-error.
        if available mla-usuar-padrao then do:
            run pi-gera-pendencia (mla-usuar-padrao.cod-usuar,
                                   0,
                                   10).
        end.
        ELSE DO:
            {utp/ut-liter.i NÆo_existe_aprovador_cadastrado_para_o_tipo_de_aprova‡Æo_(MLA0118)}

            ASSIGN cErrorDescription = return-value.
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-seq-erro + 1
                   tt-erro.mensagem = cErrorDescription.
                   tt-erro.cd-erro  = 32504.
            
            RUN insertError IN THIS-PROCEDURE (INPUT 32504,
                                               INPUT "EMS":U,
                                               INPUT "ERROR":U,
                                               INPUT STRING(p-cod-tip-doc) + "~~":U + 
                                                     p-ep-codigo           + "~~":U +
                                                     p-cod-estabel         + "~~":U +
                                                     STRING(p-cod-tip-doc) + "~~":U +
                                                     cErrorDescription).
            RETURN "NOK":U.
        END.

        RETURN "OK":U.
    end procedure.
    
    
    /**  Gera Faixa
    **/
    procedure pi-gera-faixa:
        DEFINE VARIABLE c-literal-lotacao AS CHARACTER   NO-UNDO.
        
        assign de-valor-convert = p-valor.

		find first mla-faixa-aprov where
            mla-faixa-aprov.ep-codigo   = p-ep-codigo   and
            mla-faixa-aprov.cod-estabel = p-cod-estabel and        
            mla-faixa-aprov.cod-tip-doc = p-cod-tip-doc and
            mla-faixa-aprov.cod-lotacao = c-lotacao     and
           (mla-faixa-aprov.limite-ini <= de-valor-convert and
            mla-faixa-aprov.limite-fim >= de-valor-convert)
            no-lock no-error.                  
        
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        PUT UNFORMATTED skip(1) 
                        "    " + c-lit-gera-faixa + "                                   "                SKIP.
        PUT UNFORMATTED "    " + c-lit-empresa + "                                    = " p-ep-codigo    SKIP.  
        PUT UNFORMATTED "    " + c-lit-estabelec + "                                  = " p-cod-estabel  SKIP. 
        PUT UNFORMATTED "    " + c-lit-documento + "                                  = " p-cod-tip-doc  SKIP.
        PUT UNFORMATTED "    " + c-lit-lotacao + "                                    = " c-lotacao      SKIP. 
        PUT UNFORMATTED "    " + c-lit-valor + "                                      = " p-valor        SKIP. 
        OUTPUT CLOSE.

        if available mla-faixa-aprov then do:
            find FIRST mla-hierarquia-faixa where
                       mla-hierarquia-faixa.ep-codigo   = p-ep-codigo   and
                       mla-hierarquia-faixa.cod-estabel = p-cod-estabel and                
                       mla-hierarquia-faixa.cod-tip-doc = p-cod-tip-doc and
                       mla-hierarquia-faixa.cod-lotacao = c-lotacao     and
                       mla-hierarquia-faixa.num-faixa   = mla-faixa-aprov.num-faixa
                no-lock no-error.

            if  available mla-hierarquia-faixa then do:                  
                OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
                PUT unformatted "    " + c-lit-faixa + "                                      = " mla-hierarquia-faixa.num-faixa SKIP.
                PUT UNFORMATTED "    " + c-lit-aprovador + "                                  = " mla-hierarquia-faixa.cod-usuar SKIP.
                PUT UNFORMATTED "    " + c-lit-sequencia-aprov + "                            = " mla-hierarquia-faixa.seq-aprov SKIP.
                output close.


                /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                if c-nom-prog-upc-mg97  <> "":U or 
                   c-nom-prog-appc-mg97 <> "":U or 
                   c-nom-prog-dpc-mg97  <> "":U then do:
                   
                   for each tt-epc:
                      delete tt-epc.
                   end.
    
                   create tt-epc.
                   assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA":U
                          tt-epc.cod-parameter = "cod-usuar-doc":U
                          tt-epc.val-parameter = p-usuar-doc. 

                   create tt-epc.
                   assign tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA":U
                          tt-epc.cod-parameter = "r-aed-hierarquia-faixa":U
                          tt-epc.val-parameter =  string(rowid(mla-hierarquia-faixa)). 
                
                   {include/i-epc201.i "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA"}
                
                   if  return-value = "OK":U then do:
                       find first tt-epc 
                            where tt-epc.cod-event     = "BEFORE-CREATE-mla-DOC-PEND-APROV-FAIXA":U
                              and tt-epc.cod-parameter = "r-aed-hierarquia-faixa":U
                              and tt-epc.val-parameter <> "" no-error.

                       if available tt-epc then 
                          find mla-hierarquia-faixa 
                         where rowid(mla-hierarquia-faixa) = to-rowid(tt-epc.val-parameter) no-lock no-error. 
                   end.
                end.
                /* Fim - Chamada EPC - MERIAL repasse AED1 */


                run pi-gera-pendencia (mla-hierarquia-faixa.cod-usuar,
                                       mla-hierarquia-faixa.num-faixa,
                                       mla-hierarquia-faixa.seq-aprov).

                /* Inicio - Chamada EPC - MERIAL repasse AED1 */
                create tt-epc.
                assign tt-epc.cod-event     = "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA":U
                       tt-epc.cod-parameter = "r-mla-doc-pend-aprov":U
                       tt-epc.val-parameter = STRING(ROWID(mla-doc-pend-aprov)). 

                {include/i-epc201.i "AFTER-CREATE-mla-DOC-PEND-APROV-FAIXA"}
               /* Fim - Chamada EPC - MERIAL repasse AED1 */
             
            end.
            ELSE DO:
                {utp/ut-liter.i   NÆo_existe_nenhum_aprovador_cadastrado_para_a_faixa_(mla0112) }
                RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 32504, INPUT ". ":U + RETURN-VALUE).
                ASSIGN cErrorDescription = return-value.
                
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = i-seq-erro + 1
                       tt-erro.mensagem = cErrorDescription.
                       tt-erro.cd-erro  = 32504.

                RUN insertError IN THIS-PROCEDURE (INPUT 32504,
                                                   INPUT "EMS":U,
                                                   INPUT "ERROR":U,
                                                   INPUT STRING(p-cod-tip-doc) + "~~" + 
                                                         p-ep-codigo           + "~~" +
                                                         p-cod-estabel         + "~~" +
                                                         STRING(p-cod-tip-doc) + "~~" +
                                                         cErrorDescription).

                RETURN "NOK":U.
            END.
        end.
        ELSE DO:
            {utp/ut-liter.i Lota‡Æo}
            ASSIGN c-literal-lotacao = RETURN-VALUE.
            {utp/ut-liter.i   NÆo_existe_faixa_de_aprova‡Æo_cadastrada_para_o_valor_movimentado}
            RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 32504, INPUT ". ":U + RETURN-VALUE + " ":U + string(de-valor-convert) + " - ":U + c-literal-lotacao + ": ":U + c-lotacao).
            ASSIGN cErrorDescription = return-value.
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = i-seq-erro + 1
                   tt-erro.mensagem = cErrorDescription.
                   tt-erro.cd-erro  = 32504.

            RUN insertError IN THIS-PROCEDURE (INPUT 32504,
                                               INPUT "EMS":U,
                                               INPUT "ERROR":U,
                                               INPUT STRING(p-cod-tip-doc) + "~~" + 
                                                     p-ep-codigo           + "~~" +
                                                     p-cod-estabel         + "~~" +
                                                     STRING(p-cod-tip-doc) + "~~" +
                                                     cErrorDescription).

            RETURN "NOK":U.
        END.

        RETURN "OK":U.     
    end procedure.    
    
    
    /**  Gera pendˆncias **/

    PROCEDURE pi-gera-pendencia:
        DEF INPUT PARAMETER p-aprovador AS CHAR    NO-UNDO.
        DEF INPUT PARAMETER p-faixa     AS INTEGER NO-UNDO.
        DEF INPUT PARAMETER p-sequencia AS INTEGER NO-UNDO.

        RUN pi-verifica-sit-ordem (INPUT p-cod-tip-doc).

        IF RETURN-VALUE <> "OK":U THEN
            RETURN.          
		
        ASSIGN de-valor-convert = p-valor.
		
        CREATE mla-doc-pend-aprov.
        ASSIGN mla-doc-pend-aprov.ep-codigo         = p-ep-codigo
               mla-doc-pend-aprov.cod-estabel       = p-cod-estabel
               mla-doc-pend-aprov.chave-doc         = c-chave
               mla-doc-pend-aprov.cod-lotacao-doc   = c-lotacao 
               mla-doc-pend-aprov.cod-lotacao-trans = c-lotacao-trans 
               mla-doc-pend-aprov.cod-tip-aprov     = i-cod-aprov
               mla-doc-pend-aprov.cod-tip-doc       = p-cod-tip-doc
               mla-doc-pend-aprov.cod-usuar         = p-aprovador
               mla-doc-pend-aprov.cod-usuar-doc     = p-usuar-doc
               mla-doc-pend-aprov.cod-usuar-trans   = p-usuar-trans
               mla-doc-pend-aprov.dt-geracao        = TODAY
               mla-doc-pend-aprov.ind-situacao      = 1
               mla-doc-pend-aprov.ind-tip-aprov     = mla-tipo-aprov.ind-tip-aprov
               mla-doc-pend-aprov.it-codigo         = p-item
               mla-doc-pend-aprov.mo-codigo         = p-moeda
               &IF "{&ems_dbtype}":U <> "PROGRESS":U &THEN
                    mla-doc-pend-aprov.motivo-doc   = SUBSTRING(p-motivo, 1, 160)
               &ELSE
                    mla-doc-pend-aprov.motivo-doc   = p-motivo
               &ENDIF
               mla-doc-pend-aprov.num-faixa         = p-faixa
               mla-doc-pend-aprov.seq-aprov         = p-sequencia
               mla-doc-pend-aprov.valor-doc         = de-valor-convert
               mla-doc-pend-aprov.prioridade-aprov  = i-prioridade
               mla-doc-pend-aprov.hora-geracao      = STRING(TIME,"HH:MM:SS":U)
               mla-doc-pend-aprov.cod-referencia    = p-referencia.

        RUN pi-verifica-priorid-aprovacao IN THIS-PROCEDURE.
        RUN pi-busca-cond-pagto  (OUTPUT i-cod-cond-pag).

        ASSIGN OVERLAY(mla-doc-pend-aprov.char-1,25,4) = STRING(i-cod-cond-pag).

        
        /*Permitir que uma pendˆncia tenha seus dados alterados antes do envio do e-mail. */
        IF c-nom-prog-upc-mg97 <> "":U THEN DO:
    
            FOR EACH tt-epc
                WHERE tt-epc.cod-event = "AFTER-CREATE-mla-DOC-PEND-APROV":U.
                DELETE tt-epc.
            END.
        
            /*rowid da tabela mla-doc-pend-aprov*/
            {include/i-epc200.i2 &CodEvent='"AFTER-CREATE-mla-DOC-PEND-APROV"'
                                 &CodParameter='"TABLE-ROWID"'
                                 &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                                 
            {include/i-epc201.i "AFTER-CREATE-mla-DOC-PEND-APROV"}
    
            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "AFTER-CREATE-mla-DOC-PEND-APROV":U
                   AND tt-epc.cod-parameter = "NEW-APROVADOR":U NO-ERROR.

            IF AVAIL tt-epc AND tt-epc.val-parameter <> "":U THEN
                ASSIGN p-aprovador = tt-epc.val-parameter.
        END.
    
        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + STRING(p-cod-tip-doc) + "_" + STRING(TODAY,"99-99-99") + ".txt") APPEND.
        PUT UNFORMATTED skip(1) 
                        "    " + c-lit-gera-pend + "  "                                      SKIP.
        PUT UNFORMATTED "    " + c-lit-empresa + "                                    = " mla-doc-pend-aprov.ep-codigo         SKIP.  
        PUT UNFORMATTED "    " + c-lit-estabelec + "                                  = " mla-doc-pend-aprov.cod-estabel       SKIP. 
        PUT UNFORMATTED "    " + c-lit-documento + "                                  = " mla-doc-pend-aprov.chave-doc         SKIP.
        PUT UNFORMATTED "    " + c-lit-usuario-doc + "                                = " mla-doc-pend-aprov.cod-usuar-doc     SKIP.
        PUT UNFORMATTED "    " + c-lit-lotacao-doc + "                                = " mla-doc-pend-aprov.cod-lotacao-doc   SKIP. 
        PUT UNFORMATTED "    " + c-lit-usuario-trans + "                              = " mla-doc-pend-aprov.cod-usuar-trans   SKIP.
        PUT UNFORMATTED "    " + c-lit-lotacao-trans + "                              = " mla-doc-pend-aprov.cod-lotacao-trans SKIP. 
        PUT UNFORMATTED "    " + c-lit-valor + "                                      = " mla-doc-pend-aprov.valor-doc         SKIP.
        OUTPUT CLOSE.
               
        ASSIGN l-aprovado       = NO
               l-aprovado-auto  = NO.
               
        FIND FIRST bb-mla-usuar-aprov 
             WHERE bb-mla-usuar-aprov.cod-usuar = p-usuar-doc NO-LOCK NO-ERROR.

        /*
        ** Aprova‡Æo Autom tica
        */
        IF  AVAIL bb-mla-usuar-aprov
        AND bb-mla-usuar-aprov.perm-aprov
        AND bb-mla-usuar-aprov.aprova-auto
        AND de-limite-auto >= de-valor-convert
        AND l-existe-perm-aprov                THEN DO:

            IF c-nom-prog-upc-mg97  <> "" THEN DO:

                EMPTY TEMP-TABLE tt-epc.
                   
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "APROVA-AUTO":U
                       tt-epc.cod-parameter = "documento":U
                       tt-epc.val-parameter = STRING(p-cod-tip-doc).
                                     
                {include/i-epc201.i "APROVA-AUTO"}
                   
                FIND FIRST tt-epc
                     WHERE tt-epc.cod-event     = "APROVA-AUTO":U
                       AND tt-epc.cod-parameter = "retorno" NO-ERROR.

                IF AVAIL tt-epc THEN NEXT.
            END.

            ASSIGN l-aprovado        = YES
                   l-aprovado-auto   = YES
                   c-desc-aprov-auto = "Aprova‡Æo Autom tica - Usu rio ".
          
            // Usa a "mla-usuar-aprov" porque ela ‚ lida conforme o parametro do MLA0000, "Considera Lota‡Æo do Usu rio" (mla-param-aprov.int-1), que pode ser transa‡Æo ou documento.
            // E neste caso, na aprova‡Æo autom tica, quem ir  aprovar ‚ o usu rio da transa‡Æo ou do documento.
            ASSIGN mla-doc-pend-aprov.aprov-auto          = YES
                   mla-doc-pend-aprov.dt-aprova           = TODAY
                   mla-doc-pend-aprov.ind-situacao        = 2
                   mla-doc-pend-aprov.cod-usuar           = mla-usuar-aprov.cod-usuar 
                   mla-doc-pend-aprov.narrativa-apr       = c-desc-aprov-auto 
                                                          + STRING(mla-usuar-aprov.cod-usuar) + " parametrizado no MLA0103 como Aprova‡Æo Autom tica"
                   OVERLAY(mla-doc-pend-aprov.char-1,1,8) = STRING(TIME,"hh:mm:ss":U).

            /**  Executa programa parametrizado para Aprovacao Automatica **/
            ASSIGN l-executa-pi-aprova-auto = YES
                   l-proces-compl           = YES.

            /* Verificar se o documento gerou de forma correta, sem interrup‡Æo */
            IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
               p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
               p-cod-tip-doc = 2 /* Solicita‡Æo de Compra Total */ OR
               p-cod-tip-doc = 4 /* Requisi‡Æo de Estoque Total */ THEN DO:
                 RUN pi-valida-docto (OUTPUT l-proces-compl).
            END.

            IF SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "N" OR
               SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "N" THEN
                ASSIGN l-proces-compl = NO.
            
            IF l-proces-compl THEN
                RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).
        END.
        ELSE DO:

            IF c-nom-prog-upc-mg97  <> "":U THEN DO:
                
                EMPTY TEMP-TABLE tt-epc.

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "APROVA-AUTO":U
                       tt-epc.cod-parameter = "documento":U
                       tt-epc.val-parameter = STRING(p-cod-tip-doc).
                                    
                {include/i-epc201.i "APROVA-AUTO"}
                   
                FIND FIRST tt-epc
                     WHERE tt-epc.cod-event     = "APROVA-AUTO":U
                       AND tt-epc.cod-parameter = "retorno":U NO-ERROR.
                
                IF AVAIL tt-epc THEN NEXT.
            END.
    
            FIND FIRST bb-mla-usuar-aprov
                 WHERE bb-mla-usuar-aprov.cod-usuar = p-aprovador NO-LOCK NO-ERROR.
            
            /*
            ** Aprova‡Æo Autom tica para Aprovador
            */
            IF  AVAIL bb-mla-usuar-aprov
            AND bb-mla-usuar-aprov.perm-aprov
            AND bb-mla-usuar-aprov.aprova-auto-aprov
            AND p-aprovador = p-usuar-doc
            AND de-limite-auto > de-valor-convert
            AND l-existe-perm-aprov              THEN DO:
                
                ASSIGN l-aprovado        = YES
                       l-proces-compl    = YES
                       c-desc-aprov-auto = "Aprova‡Æo Autom tica - Usu rio ".

                ASSIGN mla-doc-pend-aprov.aprov-auto          = YES
                       mla-doc-pend-aprov.dt-aprova           = TODAY
                       mla-doc-pend-aprov.ind-situacao        = 2
                       mla-doc-pend-aprov.narrativa-apr       = c-desc-aprov-auto 
                                                              + STRING(p-aprovador) + " parametrizado no MLA0103 como Aprova‡Æo Autom tica"
                       OVERLAY(mla-doc-pend-aprov.char-1,1,8) = STRING(TIME,"hh:mm:ss":U).
    
               /* Verificar se o documento gerou de forma correta, sem interrup‡Æo */
               IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
                  p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
                  p-cod-tip-doc = 2 /* Solicita‡Æo de Compra Total */ OR
                  p-cod-tip-doc = 4 /* Requisi‡Æo de Estoque Total */ THEN DO:
                    RUN pi-valida-docto (OUTPUT l-proces-compl).
               END.

               IF SUBSTRING(mla-tipo-doc-aprov.char-1,1,1) = "N" OR
                  SUBSTRING(mla-tipo-doc-aprov.char-1,5,1) = "N" THEN
                   ASSIGN l-proces-compl = NO.

               IF l-proces-compl THEN
                   RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).

               IF mla-doc-pend-aprov.ind-tip-aprov = 1 THEN DO:
                  ASSIGN l-aprovado = NO.
                  RUN pi-gera-pend-hierarquia (de-limite-auto).
               END.

               IF mla-doc-pend-aprov.ind-tip-aprov = 5 THEN DO:
                  ASSIGN l-aprovado = NO.
                  RUN pi-gera-pend-faixa (de-limite-auto).
               END.

               /**  Executa programa parametrizado para Aprovacao Automatica **/
               ASSIGN l-executa-pi-aprova-auto = YES.
            END.
            ELSE DO:
                /**  Para nÆo gera pendˆncia para o pr¢ximo tipo de aprova‡Æo **/
                ASSIGN gi-prox-prior     = 990.

                IF AVAILABLE mla-param-aprov AND NOT l-aprovado-auto THEN DO:

                    ASSIGN l-proces-compl = YES.

                    /* Verificar se o documento gerou de forma correta, sem interrup‡Æo */
                    IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
                       p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
                       p-cod-tip-doc = 2 /* Solicita‡Æo de Compra Total */ OR
                       p-cod-tip-doc = 4 /* Requisi‡Æo de Estoque Total */ THEN DO:
                        RUN pi-valida-docto (OUTPUT l-proces-compl).
                    END.
                  
                    IF mla-param-aprov.log-email AND l-proces-compl THEN
                        RUN pi-envia-e-mail (p-aprovador).
                END.
            END.
        END.

        /* Se a pendˆncia nÆo for aprovada automaticamente */
        IF mla-doc-pend-aprov.aprov-auto = NO THEN DO:
            RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(mla-doc-pend-aprov)).

            ASSIGN r-rowid-aux-include = ROWID(mla-doc-pend-aprov)
                   i-nr-trans-include  = mla-doc-pend-aprov.nr-trans.
             IF l-fluig-integrated THEN DO:
                {lap/mlaapi001.i03} /* Criar solicita‡Æo no Fluig (integra‡Æo com o fluig) */
             END.
        END.

        /**  E-mail's Alternativos **/
        IF  NOT l-aprovado
        AND AVAIL mla-param-aprov
        AND mla-param-aprov.log-email-altern THEN DO:
            /** Gera‡Æo **/
            RUN lap/mla0130a.p (1, 
                                p-aprovador,
                                ROWID(mla-doc-pend-aprov),
                                INPUT TABLE tt-mla-chave).
        END.

        /* Se a api estiver sendo rodada persistente e dentro de um outro bloco de transacao Ex.:  DO TRANS: ... END.
           Força a liberacao do registro para execucao das triggers de tabela. */
        IF THIS-PROCEDURE:PERSISTENT AND AVAIL mla-doc-pend-aprov THEN
            RELEASE mla-doc-pend-aprov.

        RETURN "OK":U.
    END PROCEDURE.
    
    
    /**  Envia e-mail
    **/
    procedure pi-envia-e-mail:
        def input parameter p-usuar-destino as char no-undo.
    
    /*************************************************************************/
    /*** INÖCIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
    /*************************************************************************/
    /*** Prop¢sito: Interferir no envio do e-mail de pendˆncia, permitindo ***/
    /***            ou nÆo o envio do e-mail ao usu rio aprovador.         ***/
    /*** Parametros:                                                       ***/
    /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
    /***                                 para que a partir deste seja      ***/
    /***                                 poss¡vel identificar o documento  ***/
    /***                                 e permitir ou nÆo o envio do      ***/
    /***                                 e-mail de pendˆncia.              ***/
    /*************************************************************************/

    if  c-nom-prog-upc-mg97 <> "":U then do:

        for each tt-epc
            where tt-epc.cod-event = "SEND-EMAIL":U.
            delete tt-epc.
        end.
    
        /*rowid mla-doc-pend-aprov */
        {include/i-epc200.i2 &CodEvent='"SEND-EMAIL"'
                             &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "SEND-EMAIL"}

        if  return-value = "NOK":U then
            return "NOK":U.

    end.

    /*************************************************************************/
    /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
    /*************************************************************************/
	    CREATE tt-mla-chave. 
            ASSIGN p-chave-doc = mla-doc-pend-aprov.chave-doc.
            assign i-posicao = 0.
            for each mla-chave-doc-aprov no-lock
               where mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc:
                assign i-posicao = i-posicao + 1.
                assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                                      mla-chave-doc-aprov.posicao-ini,
                                                                      (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                                      mla-chave-doc-aprov.posicao-ini))).
            END.


    ASSIGN c-anexo = "":U.

    IF c-nom-prog-upc-mg97 <> "":U THEN DO:

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "pi-envia-e-mail":U.
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"pi-envia-e-mail"'
                             &CodParameter='"rowid-mla-doc-pend-aprov"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc201.i "pi-envia-e-mail"}

        FIND FIRST tt-epc NO-LOCK  
             WHERE tt-epc.cod-event     = "pi-envia-e-mail":U 
               AND tt-epc.cod-parameter = "arquivo-anexo":U NO-ERROR.
            
        IF AVAIL tt-epc THEN
            ASSIGN c-anexo = tt-epc.val-parameter.
    END.

        find b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = p-usuar-destino
            no-lock no-error.

        RUN gera-mensagens. /* carrega as vari veis com as mensagens */

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "":U then do:

            
            IF NOT l-aedapi100-ativo THEN DO:     
                find first b-mla-doc-pend-aprov where
                    b-mla-doc-pend-aprov.ep-codigo       = p-ep-codigo   and
                    b-mla-doc-pend-aprov.cod-estabel     = p-cod-estabel and
                    b-mla-doc-pend-aprov.cod-tip-doc     = mla-tipo-doc-aprov.cod-tip-doc and
                    b-mla-doc-pend-aprov.chave-doc       = c-chave       and
                    b-mla-doc-pend-aprov.ind-situacao    > 1             and
                    b-mla-doc-pend-aprov.historico       = no
                    no-lock no-error.
            
            END.

            if available b-mla-doc-pend-aprov then do:

                /**  E-mail de Aprovador para Aprovador
                **/

                IF mla-tipo-doc-aprov.cod-tip-doc = 7
                OR mla-tipo-doc-aprov.cod-tip-doc = 8 THEN
                   find first b-mla-usuar-aprov where
                        b-mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar-doc
                        no-lock no-error.

                IF b-mla-doc-pend-aprov.cod-usuar-alter <> "":U THEN DO:
                    FIND mla-usuar-aprov 
                         WHERE mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar-alter
                         NO-LOCK NO-ERROR.
                    IF AVAIL mla-usuar-aprov THEN
                        assign c-aprovador = mla-usuar-aprov.cod-usuar
                               i-mo-codigo = mla-usuar-aprov.mo-codigo.
                END.
                ELSE DO: 
                    FIND mla-usuar-aprov 
                         WHERE mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar
                         NO-LOCK NO-ERROR.
                    IF AVAIL mla-usuar-aprov THEN
                        assign c-aprovador = mla-usuar-aprov.cod-usuar
                               i-mo-codigo = mla-usuar-aprov.mo-codigo.
                END.

                IF NOT VALID-HANDLE(h-mlaapi019) THEN DO:
                    RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.
                END.
                
                RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT c-aprovador,
                                                                      OUTPUT l-necessita-conversao,
                                                                      OUTPUT i-tipo-conversao,
                                                                      OUTPUT i-moeda-conversao).               

                IF l-necessita-conversao THEN DO:
                    RUN pi-retorna-valor-convertido IN h-mlaapi019 (INPUT i-moeda-conversao,
                                                                    INPUT IF i-tipo-conversao = 2 AND AVAIL b-mla-doc-pend-aprov THEN b-mla-doc-pend-aprov.dt-geracao ELSE TODAY,
                                                                    INPUT b-mla-doc-pend-aprov.valor-doc,
                                                                    OUTPUT de-vl-doc-conv).                                                              
                END.
                ELSE 
                    ASSIGN de-vl-doc-conv = b-mla-doc-pend-aprov.valor-doc.

                FIND FIRST moeda 
                     WHERE moeda.mo-codigo = i-moeda-conversao NO-LOCK NO-ERROR.
                
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).
        
                assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave,
                                                 moeda.sigla + " " + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                                 c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10).

                if b-mla-doc-pend-aprov.cod-tip-doc = 2 
                or b-mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                   for each it-requisicao
                        where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1]) 
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.
                IF b-mla-doc-pend-aprov.cod-tip-doc = 1 
                or b-mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                   for each it-requisicao
                    where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                    and   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                    and   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                       no-lock:
                       assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                   end.
                end.

                if mla-param-aprov.compl-email <> "":U then do:
                    assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
                end.
                
                for each tt-envio:
                    delete tt-envio.
                end.
                
                for each tt-erros:
                    delete tt-erros.
                end.
                
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = b-mla-usuar-aprov.e-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = c-anexo.
                if mla-usuar-aprov.e-mail <> "":U then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                IF NOT l-exchange THEN 
                     ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                            tt-envio.porta    = mla-param-aprov.porta-email.

                   
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.
                
                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
                
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio no-error.                    
                {lap/mlaapi001.i02 "mlaapi001.p (01)" tt-envio.destino tt-envio.remetente}                                    
                                    
                /**  Envia E-mail para os Alternativos
                **/ 
                if mla-param-aprov.log-aprov-altern then do:
                   
                    ASSIGN c-alternativo = "":U
                           c-mail = "":U.
                    for each mla-usuar-aprov-altern where
                        mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                        mla-usuar-aprov-altern.validade-ini <= b-mla-doc-pend-aprov.dt-geracao and
                        mla-usuar-aprov-altern.validade-fim >= b-mla-doc-pend-aprov.dt-geracao no-lock:

                        find first b-mla-usuar-aprov where
                            b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                            no-lock no-error.
                        IF NOT b-mla-usuar-aprov.recebe-email OR b-mla-usuar-aprov.e-mail = "" THEN
                            NEXT.

                        ASSIGN c-alternativo = c-alternativo + ",":U WHEN c-alternativo <> "":U
                               c-alternativo = c-alternativo + "":U + mla-usuar-aprov-altern.cod-usuar-altern
                               c-mail = c-mail + ",":U WHEN c-mail <> "":U
                               c-mail = c-mail + "":U + b-mla-usuar-aprov.e-mail.
                    END.
                    IF c-mail <> "" THEN DO:
                        find first moeda
                             where moeda.mo-codigo = b-mla-doc-pend-aprov.mo-codigo no-lock no-error.

                        assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave).
                
                        assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                         mla-tipo-doc-aprov.des-tip-doc,
                                                         c-chave,
                                                         moeda.sigla + " " + trim(string(b-mla-doc-pend-aprov.valor-doc,"->>>,>>>,>>>,>>>,>>9.99")),
                                                         c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10).

                        if b-mla-doc-pend-aprov.cod-tip-doc = 2 
                        or b-mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                           for each it-requisicao
                               where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.
                        if b-mla-doc-pend-aprov.cod-tip-doc = 1 
                        or b-mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                           for each it-requisicao
                              where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                                and   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                                and   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                               no-lock:
                               assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                           end.
                        end.

                        if mla-param-aprov.compl-email <> "":U then 
                            assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
                        for each tt-envio:
                            delete tt-envio.
                        end.
                        
                        for each tt-erros:
                            delete tt-erros.
                        end.

                        create tt-envio.
                        assign tt-envio.versao-integracao = 1
                               tt-envio.exchange    = l-exchange
                               tt-envio.destino     = c-mail
                               tt-envio.assunto     = c-ass-e-mail
                               tt-envio.mensagem    = c-men-e-mail
                               tt-envio.importancia = 2
                               tt-envio.log-enviada = no
                               tt-envio.log-lida    = no
                               tt-envio.acomp       = no
                               tt-envio.arq-anexo   = c-anexo.
                        if mla-usuar-aprov.e-mail <> "":U then
                           assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                        IF NOT l-exchange THEN 
                        ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                               tt-envio.porta    = mla-param-aprov.porta-email.
                           
                        FOR EACH tt-erros :
                            DELETE tt-erros.
                        END.


                        run utp/utapi009.p (input  table tt-envio,
                                            output table tt-erros).
                                            
                        /**  Output do erro (e-mail)
                        **/               
                        find first tt-envio no-error.                    
                        {lap/mlaapi001.i02 "mlaapi001.p (02)" tt-envio.destino tt-envio.remetente}
                    END.
                end.

                if gi-prox-prior >= 20 then do: /*Alterado para gerar HTML qdo aprovado pelo client e existe mais um tipo de aprova‡Æo*/
                    assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).

                    run pi-gera-html (input p-usuar-destino).

                end.
 
            end.
            else do:
                /**  E-mail de Usu rio para Aprovador
                **/
                find mla-usuar-aprov 
                     where mla-usuar-aprov.cod-usuar = p-usuar-trans
                     no-lock no-error.

                if  available mla-usuar-aprov THEN
                    ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.

                

               
                assign c-ass-e-mail = SUBSTITUTE(c-msgs-26593,
                                                 mla-tipo-doc-aprov.des-tip-doc,
                                                 c-chave).
                
                run pi-gera-html (input p-usuar-destino).
                
            end.                
        end.
        RETURN "OK":U.
    end procedure.
    
PROCEDURE pi-envia-e-mail-aprova-auto:
    DEF INPUT PARAMETER p-usuar-destino AS CHAR NO-UNDO.
    
    /*************************************************************************/
    /*** INÖCIO CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168         ***/
    /*************************************************************************/
    /*** Prop¢sito: Interferir no envio do e-mail de pendˆncia, permitindo ***/
    /***            ou nÆo o envio do e-mail ao usu rio aprovador.         ***/
    /*** Parametros:                                                       ***/
    /***    -> ROWID-mla-DOC-PEND-APROV: rowid da tabela mla-DOC-PEND-APROV***/
    /***                                 para que a partir deste seja      ***/
    /***                                 poss¡vel identificar o documento  ***/
    /***                                 e permitir ou nÆo o envio do      ***/
    /***                                 e-mail de pendˆncia.              ***/
    /*************************************************************************/

    if  c-nom-prog-upc-mg97 <> "":U then do:

        for each tt-epc
            where tt-epc.cod-event = "SEND-EMAIL-APROV-AUTO":U.
            delete tt-epc.
        end.

        /*rowid mla-doc-pend-aprov */
        {include/i-epc200.i2 &CodEvent='"SEND-EMAIL-APROV-AUTO"'
                             &CodParameter='"ROWID-mla-DOC-PEND-APROV"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}

        {include/i-epc201.i "SEND-EMAIL-APROV-AUTO"}

        if  return-value = "NOK":U then
            return "NOK":U.

    end.

    /*************************************************************************/
    /*** FIM CHAMADA EPC - Cliente: RIO-POLIMERO / FO: 1293.168            ***/
    /*************************************************************************/
    
    CREATE tt-mla-chave. 
    ASSIGN p-chave-doc = mla-doc-pend-aprov.chave-doc.
    assign i-posicao = 0.
    for each mla-chave-doc-aprov no-lock
        where mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc:
        assign i-posicao = i-posicao + 1.
        assign tt-mla-chave.valor[i-posicao] = trim(substring(p-chave-doc,
                                                              mla-chave-doc-aprov.posicao-ini,
                                                              (mla-chave-doc-aprov.posicao-fim + 1 - 
                                                              mla-chave-doc-aprov.posicao-ini))).
    END.

    RUN gera-mensagens. /* carrega as vari veis com as mensagens */

    IF mla-doc-pend-aprov.cod-tip-doc = 7
    OR mla-doc-pend-aprov.cod-tip-doc = 8 THEN
       find b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov.cod-usuar
            no-lock no-error.
    ELSE
       find b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = p-usuar-destino
            no-lock no-error.

        find mla-param-aprov where
            mla-param-aprov.ep-codigo   = p-ep-codigo and
            mla-param-aprov.cod-estabel = p-cod-estabel
            no-lock no-error.

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:
            
            assign l-aprov-auto-doc = b-mla-usuar-aprov.aprova-auto.   /* Para identificar se o usuario documento ‚ aprovador automatico*/

        if available mla-doc-pend-aprov then do:
            /**  E-mail de Aprovador para Aprovador
            **/
            IF mla-doc-pend-aprov.cod-usuar-alter <> "" THEN DO:
                FIND mla-usuar-aprov WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-alter NO-LOCK NO-ERROR.
                IF  AVAIL mla-usuar-aprov THEN
                    assign c-aprovador = mla-usuar-aprov.cod-usuar.
            END.
            ELSE DO: 
                FIND mla-usuar-aprov WHERE mla-usuar-aprov.cod-usuar =  mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.
                IF AVAIL mla-usuar-aprov THEN
                   assign c-aprovador = mla-usuar-aprov.cod-usuar.
            END.
            
            assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                             mla-tipo-doc-aprov.des-tip-doc,
                                             c-chave).

            if avail mla-usuar-aprov then do:
                IF NOT VALID-HANDLE(h-mlaapi019) THEN DO:
                    RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.
                END.
                
                RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT c-aprovador,
                                                                      OUTPUT l-necessita-conversao,
                                                                      OUTPUT i-tipo-conversao,
                                                                      OUTPUT i-moeda-conversao).               

                IF l-necessita-conversao THEN DO:
                    RUN pi-retorna-valor-convertido IN h-mlaapi019 (INPUT i-moeda-conversao,
                                                                    INPUT IF i-tipo-conversao = 2 AND AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.dt-geracao ELSE TODAY,
                                                                    INPUT mla-doc-pend-aprov.valor-doc,
                                                                    OUTPUT de-vl-doc-conv).                                                              
                END.
                ELSE 
                    ASSIGN de-vl-doc-conv = mla-doc-pend-aprov.valor-doc.

                find first moeda
                     where moeda.mo-codigo = i-moeda-conversao no-lock no-error.

               if l-aprov-auto-doc then
                  assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                   mla-tipo-doc-aprov.des-tip-doc,
                                                   c-chave,
                                                   moeda.sigla + " " + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                                   c-aprovador + " - " + mla-usuar-aprov.nome-usuar + " - Aprova‡Æo Autom tica") + CHR(10).
               else
                  assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                   mla-tipo-doc-aprov.des-tip-doc,
                                                   c-chave,
                                                   moeda.sigla + " " + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                                   c-aprovador + " - " + mla-usuar-aprov.nome-usuar) + CHR(10). /*teste eduardo*/
            end.

            if mla-doc-pend-aprov.cod-tip-doc = 2 
            or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
               for each it-requisicao
                   where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                   no-lock:
                   assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
               end.
            end.
            if mla-doc-pend-aprov.cod-tip-doc = 1 
            or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
               for each it-requisicao
                   where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                   AND   it-requisicao.sequencia     = int(tt-mla-chave.valor[2]) 
                   AND   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                   no-lock:
                   assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
               end.
            end.

            if mla-param-aprov.compl-email <> "" then 
                assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
            
            for each tt-envio:
                delete tt-envio.
            end.
            create tt-envio.
            assign tt-envio.versao-integracao = 1
                   tt-envio.exchange    = l-exchange
                   tt-envio.destino     = b-mla-usuar-aprov.e-mail
                   tt-envio.assunto     = c-ass-e-mail
                   tt-envio.mensagem    = c-men-e-mail
                   tt-envio.importancia = 2
                   tt-envio.log-enviada = no
                   tt-envio.log-lida    = no
                   tt-envio.acomp       = no
                   tt-envio.arq-anexo   = c-anexo.

            if mla-usuar-aprov.e-mail <> "" then
               assign tt-envio.remetente = mla-usuar-aprov.e-mail.

            IF NOT l-exchange THEN 
               ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                      tt-envio.porta    = mla-param-aprov.porta-email.
               
            FOR EACH tt-erros :
                DELETE tt-erros.
            END.

            run utp/utapi009.p (input  table tt-envio,
                                output table tt-erros).
                                
            /**  Output do erro (e-mail)
            **/               
            find first tt-envio no-error.                    
            {lap/mlaapi001.i02 "mlaapi001.p (01)" tt-envio.destino tt-envio.remetente}                                    
                                
            /**  Envia E-mail para os Alternativos
            **/                    
            if mla-param-aprov.log-aprov-altern then do:
                for each mla-usuar-aprov-altern where
                    mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                    mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                    mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:

                    find first b-mla-usuar-aprov where
                        b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                        no-lock no-error.
                    IF NOT b-mla-usuar-aprov.recebe-email OR b-mla-usuar-aprov.e-mail = "" THEN 
                        NEXT.

                    assign c-alternativo = c-alternativo + ",":U WHEN c-alternativo <> "":U
                           c-alternativo = c-alternativo + mla-usuar-aprov-altern.cod-usuar-altern
                           c-mail = c-mail + ",":U WHEN c-mail <> "":U
                           c-mail = c-mail + "":U + b-mla-usuar-aprov.e-mail.
                END.
                IF c-mail <> "":U THEN DO:
                    find first moeda
                         where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.

                    assign c-ass-e-mail = SUBSTITUTE(c-msgs-26652,
                                                     mla-tipo-doc-aprov.des-tip-doc,
                                                     c-chave).

                    assign c-men-e-mail = SUBSTITUTE(c-help-26652,
                                                     mla-tipo-doc-aprov.des-tip-doc,
                                                     c-chave,
                                                     moeda.sigla + " ":U + trim(string(mla-doc-pend-aprov.valor-doc,"->>>,>>>,>>>,>>>,>>9.99")),
                                                     c-aprovador + " - ":U + mla-usuar-aprov.nome-usuar) + CHR(10).

                    if mla-doc-pend-aprov.cod-tip-doc = 2 
                    or mla-doc-pend-aprov.cod-tip-doc = 4 then do:
                       for each it-requisicao
                           where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                           no-lock:
                           assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - ":U + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                       end.
                    end.
                    if mla-doc-pend-aprov.cod-tip-doc = 1 
                    or mla-doc-pend-aprov.cod-tip-doc = 3 then do:
                       for each it-requisicao
                           where it-requisicao.nr-requisicao = int(tt-mla-chave.valor[1])
                           AND   it-requisicao.sequencia     = int(tt-mla-chave.valor[2])
                           AND   it-requisicao.it-codigo     = tt-mla-chave.valor[3]
                           no-lock:
                           assign c-men-e-mail = c-men-e-mail + "Item: " + it-requisicao.it-codigo + " - " + string(it-requisicao.qt-requis,'>>>>>,>>>,>>9.9999') + CHR(10).
                       end.
                    end.

                    if mla-param-aprov.compl-email <> "":U then 
                        assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).

                    EMPTY TEMP-TABLE tt-envio.
                    EMPTY TEMP-TABLE tt-erros.

                    create tt-envio.
                    assign tt-envio.versao-integracao = 1
                           tt-envio.exchange    = l-exchange
                           tt-envio.destino     = c-mail
                           tt-envio.assunto     = c-ass-e-mail
                           tt-envio.mensagem    = c-men-e-mail
                           tt-envio.importancia = 2
                           tt-envio.log-enviada = no
                           tt-envio.log-lida    = no
                           tt-envio.acomp       = no
                           tt-envio.arq-anexo   = c-anexo.

                    IF mla-usuar-aprov.e-mail <> "":U then
                       assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                    IF NOT l-exchange THEN 
                       ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                              tt-envio.porta    = mla-param-aprov.porta-email.
                       
                    EMPTY TEMP-TABLE tt-erros.

                    RUN utp/utapi009.p (INPUT TABLE tt-envio, OUTPUT TABLE tt-erros).
                                        
                    /**  Output do erro (e-mail) **/               
                    FIND FIRST tt-envio NO-ERROR.
                    {lap/mlaapi001.i02 "mlaapi001.p (02)" tt-envio.destino tt-envio.remetente}
                    
                END.
            END.

            IF mla-doc-pend-aprov.cod-tip-doc = 7 THEN
                RUN pi-notificaSolicitante.

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* fim */

PROCEDURE pi-gera-pend-faixa:
    DEFINE INPUT PARAMETER p-limite AS DECIMAL NO-UNDO.

    RUN gera-mensagens. /* carrega as vari veis com as mensagens */

    FIND FIRST mla-usuar-aprov 
         WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK NO-ERROR.

    IF mla-usuar-aprov.destino-lotacao = 1 THEN DO:
        ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
        IF c-lotacao = "":U THEN
            ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
    END.
    ELSE DO:
        ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "":U THEN
            ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
    END.
 

    FIND FIRST mla-hierarquia-faixa  
         WHERE mla-hierarquia-faixa.ep-codigo   = p-ep-codigo 
         AND   mla-hierarquia-faixa.cod-estabel = p-cod-estabel 
         AND   mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
         AND   mla-hierarquia-faixa.cod-lotacao = c-lotacao 
         AND   mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
         AND   mla-hierarquia-faixa.seq-aprov   = mla-doc-pend-aprov.seq-aprov NO-LOCK NO-ERROR.

    IF  AVAILABLE mla-hierarquia-faixa
    AND (mla-hierarquia-faixa.log-depend = YES OR (mla-hierarquia-faixa.log-depend = NO  AND p-limite < mla-doc-pend-aprov.valor-doc)) THEN DO:
        
        FIND NEXT mla-hierarquia-faixa  
            WHERE mla-hierarquia-faixa.ep-codigo   = p-ep-codigo 
            AND   mla-hierarquia-faixa.cod-estabel = p-cod-estabel 
            AND   mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
            AND   mla-hierarquia-faixa.cod-lotacao = c-lotacao 
            AND   mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa NO-LOCK NO-ERROR.

        IF AVAILABLE mla-hierarquia-faixa THEN DO:

            CREATE b-mla-doc-pend-aprov.
            ASSIGN b-mla-doc-pend-aprov.ep-codigo            = mla-doc-pend-aprov.ep-codigo
                   b-mla-doc-pend-aprov.cod-estabel          = mla-doc-pend-aprov.cod-estabel
                   b-mla-doc-pend-aprov.chave-doc            = mla-doc-pend-aprov.chave-doc
                   b-mla-doc-pend-aprov.cod-lotacao-doc      = mla-doc-pend-aprov.cod-lotacao-doc
                   b-mla-doc-pend-aprov.cod-lotacao-trans    = mla-doc-pend-aprov.cod-lotacao-trans
                   b-mla-doc-pend-aprov.cod-tip-aprov        = mla-doc-pend-aprov.cod-tip-aprov
                   b-mla-doc-pend-aprov.cod-tip-doc          = mla-doc-pend-aprov.cod-tip-doc
                   b-mla-doc-pend-aprov.cod-usuar            = mla-hierarquia-faixa.cod-usuar
                   b-mla-doc-pend-aprov.cod-usuar-doc        = mla-doc-pend-aprov.cod-usuar-doc
                   b-mla-doc-pend-aprov.cod-usuar-trans      = mla-doc-pend-aprov.cod-usuar-trans
                   b-mla-doc-pend-aprov.dt-geracao           = TODAY
                   b-mla-doc-pend-aprov.ind-situacao         = 1
                   b-mla-doc-pend-aprov.ind-tip-aprov        = mla-doc-pend-aprov.ind-tip-aprov
                   b-mla-doc-pend-aprov.it-codigo            = mla-doc-pend-aprov.it-codigo
                   b-mla-doc-pend-aprov.mo-codigo            = mla-doc-pend-aprov.mo-codigo
                   b-mla-doc-pend-aprov.motivo-doc           = mla-doc-pend-aprov.motivo-doc
                   b-mla-doc-pend-aprov.num-faixa            = mla-doc-pend-aprov.num-faixa
                   b-mla-doc-pend-aprov.seq-aprov            = mla-hierarquia-faixa.seq-aprov
                   b-mla-doc-pend-aprov.valor-doc            = mla-doc-pend-aprov.valor-doc
                   b-mla-doc-pend-aprov.prioridade-aprov     = mla-doc-pend-aprov.prioridade-aprov
                   b-mla-doc-pend-aprov.hora-geracao         = STRING(TIME,"HH:MM:SS":U)
                   b-mla-doc-pend-aprov.cod-referencia       = mla-doc-pend-aprov.cod-referencia
                   OVERLAY(b-mla-doc-pend-aprov.char-1,25,4) = TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)). /*condi‡Æo de pagamento*/

            ASSIGN l-aprovado         = NO
                   l-aprovado-auto    = NO
                   l-envia-email-auto = NO.

            /**  Para nÆo gera pendˆncia para o pr¢ximo tipo de aprova‡Æo **/
            ASSIGN gi-prox-prior = 990.

            FIND FIRST bb-mla-usuar-aprov
                 WHERE bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar NO-LOCK NO-ERROR.
           
            /* Aprova‡Æo Autom tica para Aprovador */
            ASSIGN de-valor-convert = p-valor.
			   
            IF  AVAIL bb-mla-usuar-aprov
            AND bb-mla-usuar-aprov.perm-aprov
            AND bb-mla-usuar-aprov.aprova-auto-aprov
            AND mla-hierarquia-faixa.cod-usuar = p-usuar-doc
            AND de-limite-auto                 > de-valor-convert
            AND l-existe-perm-aprov   THEN DO:

                ASSIGN l-aprovado         = YES
                       l-envia-email-auto = YES
                       c-desc-aprov-auto  = "Aprova‡Æo Autom tica - Usu rio".
                
                ASSIGN mla-doc-pend-aprov.aprov-auto          = YES
                       mla-doc-pend-aprov.dt-aprova           = TODAY
                       mla-doc-pend-aprov.ind-situacao        = 2
                       mla-doc-pend-aprov.narrativa-apr       = c-desc-aprov-auto 
                                                              + STRING(mla-hierarquia-faixa.cod-usuar) 
                                                              + " parametrizado no MLA0103 como Aprova‡Æo Autom tica para Aprovadores"
                       OVERLAY(mla-doc-pend-aprov.char-1,1,8) = string(time,"hh:mm:ss":U).
                
                RUN pi-envia-e-mail-aprova-auto (mla-doc-pend-aprov.cod-usuar-doc).

                IF mla-doc-pend-aprov.ind-tip-aprov = 1 THEN DO:
                    ASSIGN l-aprovado = NO.
                    RUN pi-gera-pend-hierarquia (de-limite-auto).
                END.

                IF mla-doc-pend-aprov.ind-tip-aprov = 5 THEN DO:
                    ASSIGN l-aprovado = NO.
                    RUN pi-gera-pend-faixa (de-limite-auto).
                END.

                /**  Executa programa parametrizado para Aprovacao Automatica **/
                ASSIGN l-executa-pi-aprova-auto = YES.
            END.
            ELSE DO:
                
                IF AVAILABLE mla-param-aprov AND NOT l-aprovado-auto THEN DO:

                    IF mla-param-aprov.log-email THEN
                        ASSIGN l-envia-email-auto = NO.

                    ASSIGN l-proces-compl = YES.

                    /* Verificar se o documento gerou de forma correta, sem interrup‡Æo */
                    IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
                       p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
                       p-cod-tip-doc = 2 /* Solicita‡Æo de Compra Total */ OR
                       p-cod-tip-doc = 4 /* Requisi‡Æo de Estoque Total */ THEN DO:
                        
                        RUN pi-valida-docto (OUTPUT l-proces-compl).
                    END.
                END.
            END.

            /* Se a pendˆncia nÆo for aprovada automaticamente */
            IF b-mla-doc-pend-aprov.aprov-auto = NO THEN DO:
                
                RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(b-mla-doc-pend-aprov)).
                
                ASSIGN r-rowid-aux-include = ROWID(b-mla-doc-pend-aprov)
                       i-nr-trans-include  = b-mla-doc-pend-aprov.nr-trans.

                IF l-fluig-integrated THEN DO:
                    {lap/mlaapi001.i03} /* Criar solicita‡Æo no Fluig (integra‡Æo com o fluig) */
                END.
            END.

            IF AVAILABLE mla-param-aprov AND mla-param-aprov.log-email AND NOT l-envia-email-auto THEN  DO:
                
                /**  E-mail de Usu rio para Aprovador **/
                
                FIND FIRST mla-usuar-aprov 
                     WHERE mla-usuar-aprov.cod-usuar = mla-hierarquia-faixa.cod-usuar NO-LOCK NO-ERROR.

                IF AVAILABLE mla-usuar-aprov THEN
                    ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.

                ASSIGN c-ass-e-mail = SUBSTITUTE(c-msgs-26593, mla-tipo-doc-aprov.des-tip-doc, c-chave).

                IF mla-tipo-doc-aprov.log-html AND bb-mla-usuar-aprov.log-html THEN DO:

                    /**  HTML **/
                    EMPTY TEMP-TABLE tt-mensagem.

                    FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                    IF p-cod-tip-doc < 10 THEN
                        RUN VALUE("laphtml/mlahtml00":U + STRING(p-cod-tip-doc) + "e.p":U) (INPUT  p-cod-tip-doc,
                                                                                            INPUT  mla-hierarquia-faixa.cod-usuar,
                                                                                            INPUT  TABLE tt-mla-chave,
                                                                                            OUTPUT TABLE tt-mensagem).
                    ELSE
                        RUN VALUE("laphtml/mlahtml0":U + STRING(p-cod-tip-doc) + "e.p":U) (INPUT  p-cod-tip-doc,
                                                                                           INPUT  mla-hierarquia-faixa.cod-usuar,
                                                                                           INPUT  TABLE tt-mla-chave,
                                                                                           OUTPUT TABLE tt-mensagem).
                    
                    /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serÿ enviado como anexo */
                    RUN verificaTamanhoEmail.

                    IF l-anexar-conteudo THEN DO:

                        ASSIGN c-chave-doc = REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_")
                               c-chave-doc = REPLACE(c-chave-doc,"/","_")
                               c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                            + "_":U + STRING(mla-doc-pend-aprov.nr-trans) + "_" + STRING(TIME) + ".htm".

                        OUTPUT TO VALUE(c-arq-email) CONVERT TARGET "UTF-8":U.
                            FOR EACH tt-mensagem:
                                PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                            END.
                        OUTPUT CLOSE.
                    END.

                    EMPTY TEMP-TABLE tt-envio2.

                    CREATE tt-envio2.
                    ASSIGN tt-envio2.versao-integracao = 1
                           tt-envio2.exchange    = l-exchange
                           tt-envio2.destino     = mla-usuar-aprov.e-mail
                           tt-envio2.assunto     = c-ass-e-mail
                           tt-envio2.importancia = 2
                           tt-envio2.log-enviada = NO
                           tt-envio2.log-lida    = NO
                           tt-envio2.acomp       = NO
                           tt-envio2.formato     = "HTML":U
                           c-mensagem = c-lit-gerada-pend-aprov.

                    IF l-anexar-conteudo THEN
                        ASSIGN tt-envio2.mensagem    = c-mensagem + CHR(10) + c-lit-verif-arq-atachado
                               tt-envio2.arq-anexo   = IF c-anexo > "":U THEN c-arq-email + ",":U + c-anexo ELSE c-arq-email.
                    ELSE
                        ASSIGN tt-envio2.mensagem    = c-men-e-mail
                               tt-envio2.arq-anexo   = c-anexo.

                    IF mla-usuar-aprov.e-mail <> "":U THEN
                        ASSIGN tt-envio2.remetente = bb-mla-usuar-aprov.e-mail.

                    IF NOT l-exchange THEN
                        ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                               tt-envio2.porta    = mla-param-aprov.porta-email.

                    /* Html para Palm */
                    RUN lap/mlaapi012.p (INPUT p-ep-codigo,
                                         INPUT p-cod-estabel,
                                         INPUT p-cod-tip-doc,
                                         INPUT mla-hierarquia-faixa.cod-usuar,
                                         INPUT TABLE tt-mla-chave,
                                         OUTPUT c-arquivo-anexo).

                    IF RETURN-VALUE = "OK":U THEN DO:
                        IF tt-envio2.arq-anexo = "":U THEN
                            ASSIGN tt-envio2.arq-anexo = c-arquivo-anexo.
                        ELSE
                            ASSIGN tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";":U + c-arquivo-anexo.
                    END.
                    /*Fim Html para Palm*/

                    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

                    EMPTY TEMP-TABLE tt-erros.

                    IF l-anexar-conteudo THEN
                        RUN pi-execute  IN h-utapi019 (INPUT TABLE tt-envio2, OUTPUT TABLE tt-erros).
                    ELSE
                        RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

                    /**  Output do erro (e-mail) **/
                    FIND FIRST tt-envio2 no-error.
                    {lap/mlaapi001.i02 "mlaapi001.p (07)" tt-envio2.destino tt-envio2.remetente}

                    DELETE PROCEDURE h-utapi019.

                    IF l-anexar-conteudo THEN
                        OS-DELETE VALUE(c-arq-email).
                    
                    OS-DELETE VALUE(c-arquivo-anexo).
                END.
                ELSE DO:
                    /**  Texto **/
                    FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                    IF NOT VALID-HANDLE(h-mlaapi019) THEN DO:
                        RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.
                    END.

                    RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT mla-doc-pend-aprov.cod-usuar,
                                                                          OUTPUT l-necessita-conversao,
                                                                          OUTPUT i-tipo-conversao,
                                                                          OUTPUT i-moeda-conversao).

                    IF l-necessita-conversao THEN DO:
                        
                        RUN pi-retorna-valor-convertido IN h-mlaapi019 (INPUT i-moeda-conversao,
                                                                        INPUT IF i-tipo-conversao = 2 AND AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.dt-geracao ELSE TODAY,
                                                                        INPUT mla-doc-pend-aprov.valor-doc,
                                                                        OUTPUT de-vl-doc-conv).
                    END.
                    ELSE
                        ASSIGN de-vl-doc-conv = mla-doc-pend-aprov.valor-doc.

                    FIND FIRST moeda
                         WHERE moeda.mo-codigo = i-moeda-conversao NO-LOCK NO-ERROR.

                    ASSIGN c-men-e-mail = SUBSTITUTE(c-help-26593,
                                                     mla-tipo-doc-aprov.des-tip-doc,
                                                     c-chave,
                                                     moeda.sigla + " " + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                                     p-usuar-trans) + CHR(10).

                    IF mla-param-aprov.compl-email <> "":U THEN
                        ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + TRIM(mla-param-aprov.compl-email).

                    EMPTY TEMP-TABLE tt-envio.

                    CREATE tt-envio.
                    ASSIGN tt-envio.versao-integracao = 1
                           tt-envio.exchange    = l-exchange
                           tt-envio.destino     = mla-usuar-aprov.e-mail
                           tt-envio.assunto     = c-ass-e-mail
                           tt-envio.mensagem    = c-men-e-mail
                           tt-envio.importancia = 2
                           tt-envio.log-enviada = NO
                           tt-envio.log-lida    = NO
                           tt-envio.acomp       = NO
                           tt-envio.arq-anexo   = c-anexo.

                    IF mla-usuar-aprov.e-mail <> "":U THEN
                        ASSIGN tt-envio.remetente = bb-mla-usuar-aprov.e-mail.

                    IF NOT l-exchange THEN 
                        ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                               tt-envio.porta    = mla-param-aprov.porta-email.

                    EMPTY TEMP-TABLE tt-erros.

                    RUN utp/utapi009.p (INPUT TABLE tt-envio, OUTPUT TABLE tt-erros).

                    /**  Output do erro (e-mail) **/
                    FIND FIRST tt-envio NO-ERROR.
                    {lap/mlaapi001.i02 "mlaapi001.p (08)" tt-envio.destino tt-envio.remetente}
                END.
            END.                
        END.
    END.

    /* Se a api estiver sendo rodada persistente e dentro de um outro bloco de transacao Ex.:  DO TRANS: ... END.
       Força a liberacao do registro para execucao das triggers de tabela. */
    IF THIS-PROCEDURE:PERSISTENT AND AVAIL b-mla-doc-pend-aprov THEN
        RELEASE b-mla-doc-pend-aprov.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-gera-pend-hierarquia:
    DEFINE INPUT PARAMETER p-limite AS DECIMAL NO-UNDO.
    
    RUN gera-mensagens. /* carrega as vari veis com as mensagens */

    FIND FIRST mla-usuar-aprov 
         WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK NO-ERROR.

    IF mla-usuar-aprov.destino-lotacao = 1 THEN DO: /* Lotacao */
        ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
        IF c-lotacao = "":U THEN
            ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
    END.
    ELSE DO: /* Centro Custo */
        ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.
        IF c-lotacao = "":U THEN
            ASSIGN c-lotacao = mla-usuar-aprov.cod-lotacao.
    END.

    FIND FIRST mla-hierarquia-aprov  
         WHERE mla-hierarquia-aprov.ep-codigo   = p-ep-codigo 
         AND   mla-hierarquia-aprov.cod-estabel = p-cod-estabel 
         AND   mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
         AND   mla-hierarquia-aprov.cod-lotacao = c-lotacao 
         AND   mla-hierarquia-aprov.seq-aprov   = mla-doc-pend-aprov.seq-aprov NO-LOCK NO-ERROR.

    IF  AVAILABLE mla-hierarquia-aprov 
    AND (mla-hierarquia-aprov.log-depend = YES OR (mla-hierarquia-aprov.log-depend = NO  AND p-limite < mla-doc-pend-aprov.valor-doc)) THEN DO:
        
        FIND NEXT mla-hierarquia-aprov  
            WHERE mla-hierarquia-aprov.ep-codigo   = p-ep-codigo 
            AND   mla-hierarquia-aprov.cod-estabel = p-cod-estabel 
            AND   mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
            AND   mla-hierarquia-aprov.cod-lotacao = c-lotacao NO-LOCK NO-ERROR.
        
        IF AVAIL mla-hierarquia-aprov THEN DO:
            
            CREATE b-mla-doc-pend-aprov.
            ASSIGN b-mla-doc-pend-aprov.ep-codigo            = mla-doc-pend-aprov.ep-codigo
                   b-mla-doc-pend-aprov.cod-estabel          = mla-doc-pend-aprov.cod-estabel
                   b-mla-doc-pend-aprov.chave-doc            = mla-doc-pend-aprov.chave-doc
                   b-mla-doc-pend-aprov.cod-lotacao-doc      = mla-doc-pend-aprov.cod-lotacao-doc
                   b-mla-doc-pend-aprov.cod-lotacao-trans    = mla-doc-pend-aprov.cod-lotacao-trans
                   b-mla-doc-pend-aprov.cod-tip-aprov        = mla-doc-pend-aprov.cod-tip-aprov
                   b-mla-doc-pend-aprov.cod-tip-doc          = mla-doc-pend-aprov.cod-tip-doc
                   b-mla-doc-pend-aprov.cod-usuar            = mla-hierarquia-aprov.cod-usuar
                   b-mla-doc-pend-aprov.cod-usuar-doc        = mla-doc-pend-aprov.cod-usuar-doc
                   b-mla-doc-pend-aprov.cod-usuar-trans      = mla-doc-pend-aprov.cod-usuar-trans
                   b-mla-doc-pend-aprov.dt-geracao           = TODAY
                   b-mla-doc-pend-aprov.ind-situacao         = 1
                   b-mla-doc-pend-aprov.ind-tip-aprov        = mla-doc-pend-aprov.ind-tip-aprov
                   b-mla-doc-pend-aprov.it-codigo            = mla-doc-pend-aprov.it-codigo
                   b-mla-doc-pend-aprov.mo-codigo            = mla-doc-pend-aprov.mo-codigo
                   b-mla-doc-pend-aprov.motivo-doc           = mla-doc-pend-aprov.motivo-doc
                   b-mla-doc-pend-aprov.num-faixa            = mla-doc-pend-aprov.num-faixa
                   b-mla-doc-pend-aprov.seq-aprov            = mla-hierarquia-aprov.seq-aprov
                   b-mla-doc-pend-aprov.valor-doc            = mla-doc-pend-aprov.valor-doc
                   b-mla-doc-pend-aprov.prioridade-aprov     = mla-doc-pend-aprov.prioridade-aprov
                   b-mla-doc-pend-aprov.hora-geracao         = STRING(TIME,"HH:MM:SS":U)
                   b-mla-doc-pend-aprov.cod-referencia       = mla-doc-pend-aprov.cod-referencia
                   OVERLAY(b-mla-doc-pend-aprov.char-1,25,4) = TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)). /*condi‡Æo de pagamento*/
            
            ASSIGN l-aprovado         = NO
                   l-aprovado-auto    = NO
                   l-envia-email-auto = NO.

            /**  Para nÆo gera pendˆncia para o pr¢ximo tipo de aprova‡Æo **/
            ASSIGN gi-prox-prior     = 990.

            FIND FIRST bb-mla-usuar-aprov
                 WHERE bb-mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar NO-LOCK NO-ERROR.
            /*
            ** Aprova‡Æo Autom tica para Aprovador
            */

		    ASSIGN de-valor-convert = p-valor.
		   
            IF  AVAIL bb-mla-usuar-aprov
            AND bb-mla-usuar-aprov.perm-aprov
            AND bb-mla-usuar-aprov.aprova-auto-aprov
            AND mla-hierarquia-aprov.cod-usuar = p-usuar-doc
            AND de-limite-auto > de-valor-convert
            AND l-existe-perm-aprov   THEN DO:
                
                ASSIGN l-aprovado         = YES
                       l-envia-email-auto = YES
                       c-desc-aprov-auto  = "Aprova‡Æo Autom tica - Usu rio ".
                
                ASSIGN b-mla-doc-pend-aprov.aprov-auto          = YES
                       b-mla-doc-pend-aprov.dt-aprova           = TODAY
                       b-mla-doc-pend-aprov.ind-situacao        = 2
                       b-mla-doc-pend-aprov.narrativa-apr       = c-desc-aprov-auto 
                                                                + STRING(mla-hierarquia-aprov.cod-usuar) 
                                                                + " parametrizado no MLA0103 como Aprova‡Æo Autom tica para Aprovadores"
                       OVERLAY(b-mla-doc-pend-aprov.char-1,1,8) = STRING(TIME,"hh:mm:ss":U). 

                RUN pi-envia-e-mail-aprova-auto (b-mla-doc-pend-aprov.cod-usuar-doc).

                IF b-mla-doc-pend-aprov.ind-tip-aprov = 1 THEN DO:
                    ASSIGN l-aprovado = NO.
                    RUN pi-gera-pend-hierarquia (de-limite-auto).
                END.
                
                IF b-mla-doc-pend-aprov.ind-tip-aprov = 5 THEN DO:
                    ASSIGN l-aprovado = NO.
                    RUN pi-gera-pend-faixa (de-limite-auto).
                END.

                /**  Executa programa parametrizado para Aprovacao Automatica **/
                ASSIGN l-executa-pi-aprova-auto = YES.
            END.
            ELSE DO:
                
                IF AVAILABLE mla-param-aprov AND NOT l-aprovado-auto THEN DO:
                    
                    IF mla-param-aprov.log-email THEN
                        ASSIGN l-envia-email-auto = NO.
                    
                    ASSIGN l-proces-compl = YES.
                    
                    /* Verificar se o documento gerou de forma correta, sem interrup‡Æo */
                    IF p-cod-tip-doc = 8 /* Pedido Emergencial Total */    OR
                       p-cod-tip-doc = 7 /* Pedido Normal Total      */    OR
                       p-cod-tip-doc = 2 /* Solicita‡Æo de Compra Total */ OR
                       p-cod-tip-doc = 4 /* Requisi‡Æo de Estoque Total */ THEN DO:
                        
                        RUN pi-valida-docto (OUTPUT l-proces-compl).
                    END.
                END.
            END.

            /* Se a pendˆncia nÆo for aprovada automaticamente */
            IF b-mla-doc-pend-aprov.aprov-auto = NO THEN DO:
                
                RUN pi-chama-epc-geracao-pendencia (INPUT ROWID(b-mla-doc-pend-aprov)).

                ASSIGN r-rowid-aux-include = ROWID(b-mla-doc-pend-aprov)
                       i-nr-trans-include  = b-mla-doc-pend-aprov.nr-trans.

                IF l-fluig-integrated THEN DO:
                    {lap/mlaapi001.i03} /* Criar solicita‡Æo no Fluig (integra‡Æo com o fluig) */
                END.
            END.

            IF  AVAILABLE mla-param-aprov
            AND mla-param-aprov.log-email
            AND NOT l-envia-email-auto    THEN  DO:
                
                /**  E-mail de Usu rio para Aprovador **/
                FIND FIRST mla-usuar-aprov 
                     WHERE mla-usuar-aprov.cod-usuar = mla-hierarquia-aprov.cod-usuar NO-LOCK NO-ERROR.

                IF AVAILABLE mla-usuar-aprov THEN
                    ASSIGN c-nom-aprov = mla-usuar-aprov.nome-usuar.
               
                ASSIGN c-ass-e-mail = SUBSTITUTE(c-msgs-26593, mla-tipo-doc-aprov.des-tip-doc, c-chave).

                IF mla-tipo-doc-aprov.log-html AND bb-mla-usuar-aprov.log-html THEN DO:
                    
                    /**  HTML **/
                    EMPTY TEMP-TABLE tt-mensagem.
                    
                    FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                    IF p-cod-tip-doc < 10 THEN
                        RUN VALUE("laphtml/mlahtml00":U + STRING(p-cod-tip-doc) + "e.p":U) (INPUT  p-cod-tip-doc,
                                                                                            INPUT  mla-hierarquia-aprov.cod-usuar,
                                                                                            INPUT  TABLE tt-mla-chave,
                                                                                            OUTPUT TABLE tt-mensagem).
                    ELSE
                        RUN VALUE("laphtml/mlahtml0" + STRING(p-cod-tip-doc) + "e.p":U) (INPUT  p-cod-tip-doc,
                                                                                         INPUT  mla-hierarquia-aprov.cod-usuar,
                                                                                         INPUT  TABLE tt-mla-chave,
                                                                                         OUTPUT TABLE tt-mensagem).

                    /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serÿ enviado como anexo */
                    RUN verificaTamanhoEmail.

                    IF l-anexar-conteudo THEN DO:
                        
                        ASSIGN c-chave-doc = REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_")
                               c-chave-doc = REPLACE(c-chave-doc,"/","_")
                               c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                           + "_" + STRING(mla-doc-pend-aprov.nr-trans) + "_" + STRING(TIME) + ".htm".

                        OUTPUT TO VALUE(c-arq-email) CONVERT TARGET "UTF-8":U.
                            FOR EACH tt-mensagem :
                                PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                        END.
                        OUTPUT CLOSE.
                    END.

                    EMPTY TEMP-TABLE tt-envio2.

                    CREATE tt-envio2.
                    ASSIGN tt-envio2.versao-integracao = 1
                           tt-envio2.exchange          = l-exchange
                           tt-envio2.destino           = mla-usuar-aprov.e-mail
                           tt-envio2.assunto           = c-ass-e-mail
                           tt-envio2.importancia       = 2
                           tt-envio2.log-enviada       = NO
                           tt-envio2.log-lida          = NO
                           tt-envio2.acomp             = NO
                           tt-envio2.formato           = "HTML":U
                           c-mensagem                  = c-lit-gerada-pend-aprov.
                   
                    IF l-anexar-conteudo THEN
                        ASSIGN tt-envio2.mensagem    = c-mensagem + CHR(10) + c-lit-verif-arq-atachado
                               tt-envio2.arq-anexo   = c-arq-email.
                    ELSE
                        ASSIGN tt-envio2.mensagem    = c-men-e-mail
                               tt-envio2.arq-anexo   = "":U.

                    IF mla-usuar-aprov.e-mail <> "":U THEN
                        ASSIGN tt-envio2.remetente = bb-mla-usuar-aprov.e-mail.

                    IF NOT l-exchange THEN
                        ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                               tt-envio2.porta    = mla-param-aprov.porta-email.
                     
                    /* Html para Palm */
                    RUN lap/mlaapi012.p (INPUT p-ep-codigo,   
                                         INPUT p-cod-estabel, 
                                         INPUT p-cod-tip-doc,
                                         INPUT mla-hierarquia-aprov.cod-usuar,
                                         INPUT table tt-mla-chave,
                                         OUTPUT c-arquivo-anexo).

                    IF RETURN-VALUE = "OK":U THEN DO:
                        IF tt-envio2.arq-anexo = "":U THEN
                            ASSIGN tt-envio2.arq-anexo = c-arquivo-anexo.
                        ELSE
                            ASSIGN tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";":U + c-arquivo-anexo.
                    END.
                    /*Fim Html para Palm*/

                    IF tt-envio2.arq-anexo = "":U THEN
                        ASSIGN tt-envio2.arq-anexo = c-anexo.
                    ELSE
                        ASSIGN tt-envio2.arq-anexo = tt-envio2.arq-anexo + "," + c-anexo.

                    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

                    EMPTY TEMP-TABLE tt-erros.

                    IF l-anexar-conteudo THEN
                        RUN pi-execute IN h-utapi019 (INPUT TABLE tt-envio2, OUTPUT TABLE tt-erros).
                    ELSE
                        RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).
    
                    /**  Output do erro (e-mail) **/               
                    FIND FIRST tt-envio2 NO-ERROR.
                    {lap/mlaapi001.i02 "mlaapi001.p (09)" tt-envio2.destino tt-envio2.remetente}
                    
                    DELETE PROCEDURE h-utapi019.

                    IF l-anexar-conteudo THEN
                      OS-DELETE VALUE(c-arq-email).
                      
                    OS-DELETE VALUE(c-arquivo-anexo).
                END.
                ELSE DO:
                    /**  Texto **/
                    FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
                    
                    IF NOT VALID-HANDLE(h-mlaapi019) THEN DO:
                        RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.
                    END.

                    RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT mla-usuar-aprov.cod-usuar,
                                                                          OUTPUT l-necessita-conversao,
                                                                          OUTPUT i-tipo-conversao,
                                                                          OUTPUT i-moeda-conversao).
                    
                    IF l-necessita-conversao THEN DO:
                        RUN pi-retorna-valor-convertido IN h-mlaapi019 (INPUT i-moeda-conversao,
                                                                        INPUT IF i-tipo-conversao = 2 AND AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.dt-geracao ELSE TODAY,
                                                                        INPUT mla-doc-pend-aprov.valor-doc,
                                                                        OUTPUT de-vl-doc-conv).                                                              
                    END.
                    ELSE
                        ASSIGN de-vl-doc-conv = mla-doc-pend-aprov.valor-doc.

                    FIND FIRST moeda
                         WHERE moeda.mo-codigo = i-moeda-conversao NO-LOCK NO-ERROR.

                    ASSIGN c-men-e-mail = SUBSTITUTE(c-help-26593,
                                                     mla-tipo-doc-aprov.des-tip-doc,
                                                     c-chave,
                                                     moeda.sigla + " ":U + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                                     p-usuar-trans) + CHR(10).
               
                    IF mla-param-aprov.compl-email <> "":U THEN 
                        ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + TRIM(mla-param-aprov.compl-email).
                    
                    EMPTY TEMP-TABLE tt-envio.
                    
                    CREATE tt-envio.
                    ASSIGN tt-envio.versao-integracao = 1
                           tt-envio.exchange    = l-exchange
                           tt-envio.destino     = mla-usuar-aprov.e-mail
                           tt-envio.assunto     = c-ass-e-mail
                           tt-envio.mensagem    = c-men-e-mail
                           tt-envio.importancia = 2
                           tt-envio.log-enviada = NO
                           tt-envio.log-lida    = NO
                           tt-envio.acomp       = NO
                           tt-envio.arq-anexo   = c-anexo.

                    IF mla-usuar-aprov.e-mail <> "":U THEN
                        ASSIGN tt-envio.remetente = bb-mla-usuar-aprov.e-mail.

                    IF NOT l-exchange THEN
                        ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                               tt-envio.porta    = mla-param-aprov.porta-email.
                    
                    EMPTY TEMP-TABLE tt-erros.

                    RUN utp/utapi009.p (INPUT  TABLE tt-envio, OUTPUT TABLE tt-erros).
                    
                    /**  Output do erro (e-mail) **/
                    FIND FIRST tt-envio NO-ERROR.
                    {lap/mlaapi001.i02 "mlaapi001.p (10)" tt-envio.destino tt-envio.remetente}
                END.
            END.                
        END.
    END.

    /* Se a api estiver sendo rodada persistente e dentro de um outro bloco de transacao Ex.:  DO TRANS: ... END.
       Força a liberacao do registro para execucao das triggers de tabela. */
    IF THIS-PROCEDURE:PERSISTENT AND AVAIL b-mla-doc-pend-aprov THEN
        RELEASE b-mla-doc-pend-aprov.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE gera-mensagens:

    /********ALTERADO PARA RODAR A UT-MSGS APENAS UMA VEZ PARA CADA MENSAGEM**********/
    IF NOT l-mensagens-geradas THEN DO:
        
        run utp/ut-msgs.p (input "msg":U, input 26593, input "&1" + "~~" +
                                                           "&2").
        ASSIGN c-msgs-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help":U, input 26593, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26593 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "msg":U, input 26652, input "&1" + "~~" +
                                                           "&2").
    
        ASSIGN c-msgs-26652 = RETURN-VALUE.
    
        run utp/ut-msgs.p (input "help":U, input 26652, input "&1" + "~~" +
                                                            "&2" + "~~" +
                                                            "&3" + "~~" +
                                                            "&4").
        ASSIGN c-help-26652 = RETURN-VALUE.

        ASSIGN l-mensagens-geradas = YES.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* Procedures internas */
procedure pi-verifica-tipo-aprov-ref:

   find first mla-tipo-aprov-ref 
       where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
       and   mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc
       and   mla-tipo-aprov-ref.codigo           = p-referencia 
       and   mla-tipo-aprov-ref.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-ref then 
       find first mla-tipo-aprov-ref 
           where mla-tipo-aprov-ref.ep-codigo        = p-ep-codigo 
           and   mla-tipo-aprov-ref.cod-tip-doc      = p-cod-tip-doc 
           and   mla-tipo-aprov-ref.codigo           = p-referencia 
           and   mla-tipo-aprov-ref.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-ref then
       assign i-cod-aprov  = mla-tipo-aprov-ref.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-ref.prioridade-aprov
              l-avail-ref  = yes
              l-lim-lista  = mla-tipo-aprov-ref.log-limite
              i-tip-aprov  = 4.
    RETURN "OK":U.
end procedure.

procedure pi-verifica-tipo-aprov-item :

   find first mla-tipo-aprov-item 
       where  mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
       and    mla-tipo-aprov-item.it-codigo        = p-item 
       and    mla-tipo-aprov-item.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-item then 
       find first mla-tipo-aprov-item 
            where mla-tipo-aprov-item.ep-codigo        = p-ep-codigo 
            and   mla-tipo-aprov-item.it-codigo        = p-item 
            and   mla-tipo-aprov-item.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-item then 
       assign i-cod-aprov  = mla-tipo-aprov-item.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-item.prioridade-aprov
              l-avail-item = yes
              l-lim-lista  = mla-tipo-aprov-item.log-limite   
              i-tip-aprov   = 2.
    RETURN "OK":U.
end procedure.

procedure pi-verifica-tipo-aprov-fam:

   find first mla-tipo-aprov-fam 
       where mla-tipo-aprov-fam.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
       and mla-tipo-aprov-fam.prioridade-aprov = gi-prox-prior no-lock  no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-fam then            
       find first mla-tipo-aprov-fam 
            where mla-tipo-aprov-fam.ep-codigo        = p-ep-codigo 
            and   mla-tipo-aprov-fam.fm-codigo        = item.fm-codigo 
            and   mla-tipo-aprov-fam.prioridade-aprov = 10 no-lock  no-error.

   if available mla-tipo-aprov-fam then 
       assign i-cod-aprov  = mla-tipo-aprov-fam.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-fam.prioridade-aprov
              l-avail-fam  = yes
              l-lim-lista  = mla-tipo-aprov-fam.log-limite   
              i-tip-aprov  = 3  .
    RETURN "OK":U.
end procedure.

procedure pi-verifica-tipo-aprov-doc:

   find first mla-tipo-aprov-doc 
       where mla-tipo-aprov-doc.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
       and mla-tipo-aprov-doc.prioridade-aprov = gi-prox-prior no-lock no-error.

   if  gi-prox-prior = 0
   and not available mla-tipo-aprov-doc then
       find first mla-tipo-aprov-doc 
       where mla-tipo-aprov-doc.ep-codigo      = p-ep-codigo 
       and mla-tipo-aprov-doc.cod-tip-doc      = p-cod-tip-doc 
       and mla-tipo-aprov-doc.prioridade-aprov = 10 no-lock no-error.

   if available mla-tipo-aprov-doc then 
       assign i-cod-aprov  = mla-tipo-aprov-doc.cod-tip-aprov
              i-prioridade = mla-tipo-aprov-doc.prioridade-aprov
              l-avail-doc  = yes
              l-lim-lista  = mla-tipo-aprov-doc.log-limite
              i-tip-aprov  = 1.
    RETURN "OK":U.
end procedure.


procedure pi-gera-html:
    def input param p-usuar-destino as char no-undo.

    if  mla-tipo-doc-aprov.log-html and
        b-mla-usuar-aprov.log-html then do:
        
        IF b-mla-usuar-aprov.recebe-email AND b-mla-usuar-aprov.e-mail <> "" THEN DO:         
            /**  HTML
            **/
            for each tt-mensagem:
                delete tt-mensagem.
            end.
    
            FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.
    
            IF p-cod-tip-doc < 10 THEN
            RUN VALUE("laphtml/mlahtml00":U + STRING(p-cod-tip-doc) + "e.p":U) 
                                      (input  p-cod-tip-doc,
                                       input  p-usuar-destino,
                                       input  table tt-mla-chave,
                                       output TABLE tt-mensagem).
            ELSE 
                RUN VALUE("laphtml/mlahtml0":U + STRING(p-cod-tip-doc) + "e.p":U) 
                                                          (input  p-cod-tip-doc,
                                                           input  p-usuar-destino,
                                                           input  table tt-mla-chave,
                                                           output TABLE tt-mensagem).

            /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serÿ enviado como anexo */
            RUN verificaTamanhoEmail.
    
            IF l-anexar-conteudo then do:
               
                ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                       c-chave-doc = replace(c-chave-doc,"/","_")
                       c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                     + "_" + STRING(mla-doc-pend-aprov.nr-trans) + "_" + string(time) + ".htm".
               
                OUTPUT TO VALUE(c-arq-email) CONVERT TARGET "UTF-8":U.
               
                FOR EACH tt-mensagem:
                        PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                END.
                OUTPUT CLOSE.
            END.
    
            FOR EACH tt-envio2:
                DELETE tt-envio2.
            END.      
    
            create tt-envio2.
            assign tt-envio2.versao-integracao = 1
                   tt-envio2.exchange    = l-exchange
                   tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                   tt-envio2.assunto     = c-ass-e-mail
                   tt-envio2.importancia = 2
                   tt-envio2.log-enviada = no
                   tt-envio2.log-lida    = no
                   tt-envio2.acomp       = no
                   tt-envio2.formato     = "HTML"
                   c-mensagem = c-lit-gerada-pend-aprov.
                          
            if l-anexar-conteudo then 
                assign tt-envio2.mensagem    = c-mensagem + CHR(10) + c-lit-verif-arq-atachado
                       tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                               ELSE c-arq-email.
            else
                assign tt-envio2.mensagem    = c-men-e-mail
                       tt-envio2.arq-anexo   = c-anexo.
    
            if mla-usuar-aprov.e-mail <> "" then
               assign tt-envio2.remetente = mla-usuar-aprov.e-mail.
    
            IF NOT l-exchange THEN 
               ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                      tt-envio2.porta    = mla-param-aprov.porta-email.
    
            OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "mlaLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") APPEND.
            PUT SKIP(1).
            PUT UNFORMATTED "    " + c-lit-envia-email-aprov + " "  SKIP.
            PUT UNFORMATTED "    " + c-lit-aprovador + "                                  = " b-mla-usuar-aprov.cod-usuar    SKIP.
            PUT UNFORMATTED "    " + c-lit-email + "                                      = " b-mla-usuar-aprov.e-mail       SKIP.
            PUT UNFORMATTED "    " + c-lit-servidor + "                                   = " mla-param-aprov.servidor-email SKIP.
            PUT UNFORMATTED "    " + c-lit-porta + "                                      = " mla-param-aprov.porta-email    SKIP.
            OUTPUT CLOSE.
    
            /* Html para Palm */
            run lap/mlaapi012.p (input p-ep-codigo,   
                                  input p-cod-estabel, 
                                  input p-cod-tip-doc,
                                  input p-usuar-destino,
                                  input table tt-mla-chave,
                                  output c-arquivo-anexo). 
            if  return-value = "OK":U then do:
                if  tt-envio2.arq-anexo = "" then
                    assign tt-envio2.arq-anexo = c-arquivo-anexo.
                else 
                    assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                               + c-arquivo-anexo.
            end.
            /*Fim Html para Palm*/
            
            /* Ponto UPC */
            IF c-nom-prog-upc-mg97 <> "" THEN DO:    
        
                FOR EACH tt-epc
                   WHERE tt-epc.cod-event = "beforeEnviaEmailHTML":U:
                    DELETE tt-epc.
                END.
            
                {include/i-epc200.i2 &CodEvent='"beforeEnviaEmailHTML"'
                                     &CodParameter='"handle_tt-envio2"'
                                     &ValueParameter="string(temp-table tt-envio2:handle)"}
                                     
                {include/i-epc201.i "beforeEnviaEmailHTML"}
            END.
    
            run utp/utapi019.p persistent set h-utapi019.
            
            for each tt-erros :
                delete tt-erros.
            end.
            
            if l-anexar-conteudo then
                run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                               output table tt-erros).                                                                           
            else
                run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                               INPUT TABLE tt-mensagem,
                                               output table tt-erros).
            
            /**  Output do erro (e-mail)
            **/               
            find first tt-envio2 no-error.                    
            {lap/mlaapi001.i02 "mlaapi001.p (03)" tt-envio2.destino tt-envio2.remetente}                                    
            
            delete procedure h-utapi019.
            
            if  l-anexar-conteudo then
                os-delete value(c-arq-email).
                
            os-delete value(c-arquivo-anexo).
            
            /**  Envia E-mail para os Alternativos
            **/                    
        END.

        if mla-param-aprov.log-aprov-altern then do:
            
            ASSIGN c-alternativo = "":U
                   c-mail = "":U.
            for each  mla-usuar-aprov-altern 
                where mla-usuar-aprov-altern.cod-usuar = p-usuar-destino 
                  and mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao 
                  and mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
         
                find first b-mla-usuar-aprov where
                    b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                    no-lock no-error.
                IF NOT b-mla-usuar-aprov.recebe-email OR b-mla-usuar-aprov.e-mail = "":U THEN NEXT.

                assign c-alternativo = c-alternativo + ",":U WHEN c-alternativo <> "":U
                       c-alternativo = c-alternativo + "":U + mla-usuar-aprov-altern.cod-usuar-altern
                       c-mail = c-mail + ",":U WHEN c-mail <> "":U
                       c-mail = c-mail + "":U + b-mla-usuar-aprov.e-mail.
            END.
            IF c-mail <> "" THEN DO:
                for each tt-mensagem:
                    delete tt-mensagem.
                end.

                for each tt-erros:
                    delete tt-erros.
                end.

                FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

                IF p-cod-tip-doc < 10 THEN
                    RUN VALUE("laphtml/mlahtml00":U + STRING(p-cod-tip-doc) + "e.p":U) 
                                                              (input  p-cod-tip-doc,
                                                               input  p-usuar-destino,
                                                               input  table tt-mla-chave,
                                                               output TABLE tt-mensagem).
                ELSE 
                    RUN VALUE("laphtml/mlahtml0":U + STRING(p-cod-tip-doc) + "e.p":U) 
                                                              (input  p-cod-tip-doc,
                                                               input  p-usuar-destino,
                                                               input  table tt-mla-chave,
                                                               output TABLE tt-mensagem).
                /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serÿ enviado como anexo */
                RUN verificaTamanhoEmail.

                if l-anexar-conteudo then do:
                    ASSIGN c-chave-doc = replace(trim(mla-doc-pend-aprov.chave-doc)," ","_")
                           c-chave-doc = replace(c-chave-doc,"/","_") 
                           c-arq-email = SESSION:TEMP-DIRECTORY + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") 
                                         + "_" + STRING(mla-doc-pend-aprov.nr-trans) + "_" + STRING(TIME) + ".htm".
                    OUTPUT TO VALUE(c-arq-email) CONVERT TARGET "UTF-8":U.
                        FOR EACH tt-mensagem :
                            PUT UNFORMATTED tt-mensagem.mensagem SKIP.
                    END.
                    OUTPUT CLOSE.
                end.
                
                FOR EACH tt-envio2:
                    DELETE tt-envio2.
                END.      

                create tt-envio2.
                assign tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = l-exchange
                       tt-envio2.destino     = c-mail
                       tt-envio2.assunto     = c-ass-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = "HTML":U
                       c-mensagem = c-lit-gerada-pend-aprov.
                
                if l-anexar-conteudo then
                    assign tt-envio2.mensagem    = c-mensagem + CHR(10) + c-lit-verif-arq-atachado
                           tt-envio2.arq-anexo   = IF c-anexo > "" THEN c-arq-email + "," + c-anexo
                                                   ELSE c-arq-email.
                else
                    assign tt-envio2.mensagem    = c-men-e-mail
                           tt-envio2.arq-anexo   = c-anexo.
                       
                if mla-usuar-aprov.e-mail <> "":U then
                    assign tt-envio2.remetente = mla-usuar-aprov.e-mail.

                /* Html para Palm */
                run lap/mlaapi012.p (input p-ep-codigo,   
                                      input p-cod-estabel,  
                                      input p-cod-tip-doc,
                                      input c-alternativo,
                                      input table tt-mla-chave,
                                      output c-arquivo-anexo).

                if  return-value = "OK":U then do:
                    if  tt-envio2.arq-anexo = "":U then
                        assign tt-envio2.arq-anexo = c-arquivo-anexo.
                    else 
                        assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ";":U
                                                   + c-arquivo-anexo.
                end.
                /*Fim Html para Palm*/

                run utp/utapi019.p persistent set h-utapi019.

                IF NOT l-exchange THEN 
                   ASSIGN tt-envio2.servidor = mla-param-aprov.servidor-email
                          tt-envio2.porta    = mla-param-aprov.porta-email.
                
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.

                /* Ponto UPC */
                IF c-nom-prog-upc-mg97 <> "" THEN DO:    
            
                    FOR EACH tt-epc
                       WHERE tt-epc.cod-event = "beforeEnviaEmailHTMLAltern":U:
                        DELETE tt-epc.
                    END.
                
                    {include/i-epc200.i2 &CodEvent='"beforeEnviaEmailHTMLAltern"'
                                         &CodParameter='"handle_tt-envio2"'
                                         &ValueParameter="string(temp-table tt-envio2:handle)"}
                                         
                    {include/i-epc201.i "beforeEnviaEmailHTMLAltern"}
                END.

                if l-anexar-conteudo then
                    run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                   output table tt-erros).
                else                            
                    run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                   INPUT TABLE tt-mensagem,
                                                   output table tt-erros).
                    
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio2 no-error.                    
                {lap/mlaapi001.i02 "mlaapi001.p (04)" tt-envio2.destino tt-envio2.remetente}                                    
                                                   
                delete procedure h-utapi019.

                if  l-anexar-conteudo then
                    os-delete value(c-arq-email).
                    
                os-delete value(c-arquivo-anexo).
            END.
        end.                    
    end.
    else do:
        /**  Texto
        **/
        FIND CURRENT mla-doc-pend-aprov NO-LOCK NO-ERROR.

        IF NOT VALID-HANDLE(h-mlaapi019) THEN DO:
            RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.
        END.
        
        RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT b-mla-usuar-aprov.cod-usuar,
                                                              OUTPUT l-necessita-conversao,
                                                              OUTPUT i-tipo-conversao,
                                                              OUTPUT i-moeda-conversao).               

        IF l-necessita-conversao THEN DO:
            RUN pi-retorna-valor-convertido IN h-mlaapi019 (INPUT i-moeda-conversao,
                                                            INPUT IF i-tipo-conversao = 2 AND AVAIL mla-doc-pend-aprov THEN mla-doc-pend-aprov.dt-geracao ELSE TODAY,
                                                            INPUT mla-doc-pend-aprov.valor-doc,
                                                            OUTPUT de-vl-doc-conv).                                                              
        END.
        ELSE 
            ASSIGN de-vl-doc-conv = mla-doc-pend-aprov.valor-doc.


        FIND FIRST moeda
             WHERE moeda.mo-codigo = i-moeda-conversao NO-LOCK NO-ERROR.
        
		assign c-men-e-mail = SUBSTITUTE(c-help-26593,
                                         mla-tipo-doc-aprov.des-tip-doc,
                                         c-chave,
                                         moeda.sigla + " " + trim(string(de-vl-doc-conv,">>>,>>>,>>>,>>>,>>9.99")),
                                         p-usuar-trans) + CHR(10).

        
        if mla-param-aprov.compl-email <> "":U then 
            assign c-men-e-mail = c-men-e-mail + chr(10) + trim(mla-param-aprov.compl-email).
        
        for each tt-envio:
            delete tt-envio.
        end.
        
        create tt-envio.
        assign tt-envio.versao-integracao = 1
               tt-envio.exchange    = l-exchange
               tt-envio.destino     = b-mla-usuar-aprov.e-mail
               tt-envio.assunto     = c-ass-e-mail
               tt-envio.mensagem    = c-men-e-mail
               tt-envio.importancia = 2
               tt-envio.log-enviada = no
               tt-envio.log-lida    = no
               tt-envio.acomp       = no
               tt-envio.arq-anexo   = c-anexo.
        IF mla-usuar-aprov.e-mail <> "":U then
           assign tt-envio.remetente = mla-usuar-aprov.e-mail.

        IF NOT l-exchange THEN 
           ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                  tt-envio.porta    = mla-param-aprov.porta-email.
           
        FOR EACH tt-erros :
            DELETE tt-erros.
        END.
        run utp/utapi009.p (input  table tt-envio,
                            output table tt-erros).
                            
        /**  Output do erro (e-mail)
        **/               
        find first tt-envio no-error.                    
        {lap/mlaapi001.i02 "mlaapi001.p (05)" tt-envio.destino tt-envio.remetente}                                    
                            
        /**  Envia E-mail para os Alternativos
        **/                    
        if mla-param-aprov.log-aprov-altern then do:
            ASSIGN c-alternativo = "":U
                   c-mail = "":U.
            for each mla-usuar-aprov-altern where
                mla-usuar-aprov-altern.cod-usuar = p-usuar-destino and
                mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao no-lock:
                

                find b-mla-usuar-aprov where
                     b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                     no-lock no-error.

                IF NOT b-mla-usuar-aprov.recebe-email OR b-mla-usuar-aprov.e-mail = "" THEN 
                    NEXT.
                assign c-alternativo = c-alternativo + "," WHEN c-alternativo <> ""
                       c-alternativo = c-alternativo + mla-usuar-aprov-altern.cod-usuar-altern
                       c-mail = c-mail + "," WHEN c-mail <> ""
                       c-mail = c-mail + "" + b-mla-usuar-aprov.e-mail.
            END.
            IF c-mail <> "" THEN DO:
                for each tt-envio:
                    delete tt-envio.
                end.
                for each tt-erros:
                    delete tt-erros.
                end.
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = c-mail
                       tt-envio.assunto     = c-ass-e-mail
                       tt-envio.mensagem    = c-men-e-mail
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = c-anexo.

                IF mla-usuar-aprov.e-mail <> "":U then
                   assign tt-envio.remetente = mla-usuar-aprov.e-mail.

                IF NOT l-exchange THEN 
                   ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                          tt-envio.porta    = mla-param-aprov.porta-email.
                   
                FOR EACH tt-erros :
                    DELETE tt-erros.
                END.

                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
                                    
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio no-error.                    
                {lap/mlaapi001.i02 "mlaapi001.p (06)" tt-envio.destino tt-envio.remetente}
            END.
        end.
    end.

    RETURN "OK":U.
end procedure.
/** FIM **/

/**  Programa parametrizado para Aprovacao Automatica
***
***  Inicialmente, funcionarÿ apenas para o tipo de documento 21 (Aprovacao do Credito do Pedido de Vendas)
***  Apos, terÿ que funcionar com qualquer outro tipo de documento, principalmente solicitacao/requisicao e cotacao  
**/
PROCEDURE pi-aprova-auto.

    IF  p-cod-tip-doc = 21 THEN DO:

        RUN lap/mlaapi002.p (INPUT 21,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro 
            NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:
		
		    EMPTY TEMP-TABLE tt-mla014e.
			
            RUN lapepc/mla021e.p (INPUT ROWID(mla-doc-pend-aprov),
                                  INPUT mla-doc-pend-aprov.cod-usuar,
                                  INPUT NO,
								  OUTPUT TABLE tt-mla014e).
								  
			FOR EACH tt-mla014e NO-LOCK:
				CREATE tt-erro.
				ASSIGN tt-erro.i-sequen = tt-mla014e.ErrorSequence
					   tt-erro.cd-erro  = tt-mla014e.ErrorNumber
					   tt-erro.mensagem = tt-mla014e.ErrorDescription.

                IF CAN-FIND(LAST RowErrors) THEN DO:
                    FIND LAST RowErrors NO-ERROR.
                    ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
                END.
                ELSE
                    ASSIGN iErrorSequence = iErrorSequence + 1.

                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                       RowErrors.ErrorNumber      = tt-mla014e.ErrorNumber
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "ERROR":U
                       RowErrors.ErrorDescription = tt-mla014e.ErrorDescription
                       RowErrors.ErrorHelp        = tt-mla014e.ErrorDescription
                       RowErrors.ErrorParameters  = "":U.
			END.					  
        END.
    END.

    IF  p-cod-tip-doc = 14 THEN DO:

        RUN lap/mlaapi002.p (INPUT 14,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        
        FIND FIRST tt-erro NO-ERROR.

        IF  NOT AVAIL tt-erro AND c-tipo-doc-prog-aprova <> "":U THEN DO:

            /*Executa o programa sem a nossa temp-table como parƒmetro (programa especifico do cliente)*/
            RUN VALUE(c-tipo-doc-prog-aprova) (ROWID(mla-doc-pend-aprov),
                                               INPUT mla-doc-pend-aprov.cod-usuar,
                                               NO) NO-ERROR.
            
            /*Se ocorrer erro na execu‡Æo chama a mla014e para realizar a liberacao da medicao na aprovacao automatica */
            IF ERROR-STATUS:ERROR AND c-tipo-doc-prog-aprova MATCHES "*mla014e.*":U THEN DO:

                EMPTY TEMP-TABLE tt-mla014e.

                RUN VALUE(c-tipo-doc-prog-aprova) (ROWID(mla-doc-pend-aprov),
                                                   INPUT mla-doc-pend-aprov.cod-usuar,
                                                   NO,
                                                   OUTPUT TABLE tt-mla014e).
            
                FOR EACH tt-mla014e NO-LOCK:
                    CREATE tt-erro.
                    ASSIGN tt-erro.i-sequen = tt-mla014e.ErrorSequence
                           tt-erro.cd-erro  = tt-mla014e.ErrorNumber
                           tt-erro.mensagem = tt-mla014e.ErrorDescription.

                    IF CAN-FIND(LAST RowErrors) THEN DO:
                        FIND LAST RowErrors NO-ERROR.
                        ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
                    END.
                    ELSE
                        ASSIGN iErrorSequence = iErrorSequence + 1.
    
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = iErrorSequence
                           RowErrors.ErrorNumber      = tt-mla014e.ErrorNumber
                           RowErrors.ErrorType        = "EMS":U
                           RowErrors.ErrorSubType     = "ERROR":U
                           RowErrors.ErrorDescription = tt-mla014e.ErrorDescription
                           RowErrors.ErrorHelp        = tt-mla014e.ErrorDescription
                           RowErrors.ErrorParameters  = "":U.
                END.
            END.
        END.
    END.

    IF  p-cod-tip-doc = 29 THEN DO:
        
        RUN pi-gerar-dados-extrato (INPUT "boin767a: procedure pi-aprova-auto " + STRING(p-cod-tip-doc)).

        RUN lap/mlaapi002.p (INPUT 29,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro 
            NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:
        

            RUN lapepc/mla029e.p (INPUT ROWID(mla-doc-pend-aprov),
                                  INPUT mla-doc-pend-aprov.cod-usuar,
                                  INPUT NO).
        END.
    END.

    IF  p-cod-tip-doc = 30 THEN DO:

        RUN pi-gerar-dados-extrato (INPUT "boin767a: procedure pi-aprova-auto " + STRING(p-cod-tip-doc)).

        RUN lap/mlaapi002.p (INPUT 30,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro 
            NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:

            RUN lapepc/mla030.p (INPUT ROWID(mla-doc-pend-aprov),
                                  INPUT mla-doc-pend-aprov.cod-usuar,
                                  INPUT NO).
        END.
    END.

    IF  p-cod-tip-doc = 31 THEN DO:

        RUN pi-gerar-dados-extrato (INPUT "boin767a: procedure pi-aprova-auto " + STRING(p-cod-tip-doc)).

        RUN lap/mlaapi002.p (INPUT 31,
                             INPUT TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).
        FIND FIRST tt-erro 
            NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:

            RUN lapepc/mla031.p (INPUT ROWID(mla-doc-pend-aprov),
                                  INPUT mla-doc-pend-aprov.cod-usuar,
                                  INPUT NO).
        END.
    END.

    IF  p-cod-tip-doc = 32 /* Origina‡Æo - Adiantamento Valor */ THEN DO:

        RUN pi-gerar-dados-extrato (INPUT "boin767a: procedure pi-aprova-auto " + STRING(p-cod-tip-doc)).

        RUN lap/mlaapi002.p (INPUT  32,
                             INPUT  TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).

        FIND FIRST tt-erro NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:
            RUN lapepc/mla032.p (INPUT  ROWID(mla-doc-pend-aprov),
                                 INPUT  mla-doc-pend-aprov.cod-usuar,
                                 INPUT  NO,
                                 OUTPUT TABLE RowErrors APPEND).
        END.
    END.

    IF  p-cod-tip-doc = 33 /* Origina‡Æo - Fechamento Financeiro */ THEN DO:

        RUN pi-gerar-dados-extrato (INPUT "boin767a: procedure pi-aprova-auto " + STRING(p-cod-tip-doc)).

        RUN lap/mlaapi002.p (INPUT  33,
                             INPUT  TABLE tt-mla-chave,
                             OUTPUT TABLE tt-erro).

        FIND FIRST tt-erro NO-ERROR.
        IF  NOT AVAIL tt-erro THEN DO:
            RUN lapepc/mla033.p (INPUT  ROWID(mla-doc-pend-aprov),
                                 INPUT  mla-doc-pend-aprov.cod-usuar,
                                 INPUT  NO,
                                 OUTPUT TABLE RowErrors APPEND).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-valida-docto:
/*------------------------------------------------------------------------------
  Purpose: Procedure para verificação de encerramento correto da pendencia dos 
			documentos gerados.     
  Parameters:  output: p-proces-compl /*Parametro de indicação de processo
						completo ou não.*/
  Notes:       
------------------------------------------------------------------------------*/


    DEF OUTPUT PARAM p-proces-compl AS LOG NO-UNDO.

    IF p-cod-tip-doc = 7 /* Pedido Normal Total */       OR 
       p-cod-tip-doc = 8 /* Pedido Emergencial Total */  THEN DO:

        FIND FIRST pedido-compr NO-LOCK
             WHERE pedido-compr.num-pedido = INT(SUBSTRING(c-chave,1,8)) NO-ERROR.

        IF  AVAIL pedido-compr 
        AND SUBSTRING(pedido-compr.char-1,58,1) = "S":U THEN
            ASSIGN p-proces-compl = YES.
        ELSE
            ASSIGN p-proces-compl = NO.
    END.
    ELSE DO:
        IF p-cod-tip-doc = 2 /* Solicitação de Compra Total */ THEN DO:
            FIND FIRST requisicao NO-LOCK
                 WHERE requisicao.nr-requisicao = INT(SUBSTRING(c-chave,1,9)) NO-ERROR.
            IF AVAIL requisicao AND ( SUBSTRING(requisicao.char-1,1,1) = "S":U  OR
                                      SUBSTRING(requisicao.char-1,1,1) = "":U ) THEN
                ASSIGN p-proces-compl = YES.
            ELSE
                ASSIGN p-proces-compl = NO.
        END.
        ELSE DO:
            IF p-cod-tip-doc = 4 /* Requisição de Estoque Total */ THEN DO:
                FIND FIRST requisicao NO-LOCK
                     WHERE requisicao.nr-requisicao = INT(SUBSTRING(c-chave,1,9)) NO-ERROR.
                IF AVAIL requisicao AND ( SUBSTRING(requisicao.char-1,1,1) = "S":U OR
                                          SUBSTRING(requisicao.char-1,1,1) = "":U) THEN
                    ASSIGN p-proces-compl = YES.
                ELSE
                    ASSIGN p-proces-compl = NO.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-verifica-priorid-aprovacao:
    /*
    ** Grava na tabela mla-doc-pend-aprov a prioridade do documento de acordo com o que 
    ** o usuario seleciona na prioridade para aprovacao: muito alta, alta, media, baixa
    */

    /*Inicio Melhorias MLA IRM001425 Item 4*/
    FOR FIRST item-mat FIELDS(prioridade-aprov)
        WHERE item-mat.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK:
    END.

    CASE mla-doc-pend-aprov.cod-tip-doc:
        WHEN 1  OR /*solicitacao de compras por item*/
        WHEN 3  OR /*requisicao de estoque por item */
        WHEN 18 THEN DO: /*solicitacao de cotacao por item*/
            FIND FIRST it-requisicao 
                 WHERE it-requisicao.nr-requisicao = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,9)) 
                   AND it-requisicao.sequencia     = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,10,3)) 
                   AND it-requisicao.it-codigo     = SUBSTRING(mla-doc-pend-aprov.chave-doc,13,16)   NO-LOCK NO-ERROR.
            IF AVAIL it-requisicao THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = it-requisicao.prioridade-aprov.
            ELSE
                IF AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
                ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.

        END.
        WHEN 5 THEN DO: /* cotacao de materiais*/
            FIND FIRST cotacao-item no-lock
                 WHERE cotacao-item.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND cotacao-item.cod-emitente = int(substring(mla-doc-pend-aprov.chave-doc,9,8))
                   AND cotacao-item.it-codigo    = substring(mla-doc-pend-aprov.chave-doc,18,16)
                   AND cotacao-item.seq-cotac    = int(substring(mla-doc-pend-aprov.chave-doc,34,3)) NO-ERROR.
            IF AVAIL cotacao-item THEN DO:
                FIND FIRST ordem-compra
                     WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK NO-ERROR.
                IF  AVAIL ordem-compra THEN
                    ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
                   ELSE
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
            END.

        END.
        WHEN 6  OR /*pedido de compra por item*/
        WHEN 19 THEN DO: /*pedido emergencial por item*/
            FIND FIRST ordem-compra
                 WHERE ordem-compra.num-pedido   = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8)) 
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,9,16)) NO-LOCK NO-ERROR.
            IF  AVAIL ordem-compra THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
               ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        END.
        WHEN 9 THEN DO: /*processo de compras por item*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.nr-processo  = int(substring(mla-doc-pend-aprov.chave-doc,1,6))
                   AND ordem-compra.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,7,8)) NO-ERROR.
            IF  AVAIL ordem-compra THEN
                ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
               ELSE
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        END.
        WHEN 11 THEN DO: /*contrato de compras por item*/
            FIND FIRST ordem-compra NO-LOCK
                 WHERE ordem-compra.nr-contrato  = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8))
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,9,8)) NO-ERROR.
            IF AVAIL ordem-compra THEN 
                 ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
            ELSE 
               IF  AVAIL item-mat THEN
                   ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
        END.
        WHEN 14 THEN DO: /*medicao contrato*/
            FIND FIRST medicao-contrat no-lock
                 WHERE medicao-contrat.nr-contrato     = int(substring(mla-doc-pend-aprov.chave-doc,1,9))
                   AND medicao-contrat.num-seq-item    = int(substring(mla-doc-pend-aprov.chave-doc,9,4))
                   AND medicao-contrat.numero-ordem    = int(substring(mla-doc-pend-aprov.chave-doc,14,8))
                   AND medicao-contrat.num-seq-event   = int(substring(mla-doc-pend-aprov.chave-doc,22,4))
                   AND medicao-contrat.num-seq-medicao = int(substring(mla-doc-pend-aprov.chave-doc,26,4)) NO-ERROR.
            IF AVAIL medicao-contrat THEN DO:
                FIND FIRST ordem-compra
                    WHERE ordem-compra.numero-ordem = medicao-contrat.numero-ordem NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN 
                     ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
            END.
        END.
        WHEN 16 THEN DO: /*evento do contrato*/
            FIND FIRST evento-ped no-lock
                 WHERE evento-ped.numero-ordem  = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND evento-ped.dt-evento     = date(substring(mla-doc-pend-aprov.chave-doc,9,9))
                   AND evento-ped.seq-evento    = int(substring(mla-doc-pend-aprov.chave-doc,19,2)) NO-ERROR.
            IF AVAIL evento-ped THEN DO:
                FIND FIRST ordem-compra
                    WHERE ordem-compra.numero-ordem = evento-ped.numero-ordem NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN 
                     ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = ordem-compra.prioridade-aprov.
                ELSE 
                   IF  AVAIL item-mat THEN
                       ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = item-mat.prioridade-aprov.
            END.
        END.
        OTHERWISE /*documentos por total recebem prioridade zero*/
            ASSIGN mla-doc-pend-aprov.num-priorid-aprova-docto = 0.
        /*Fim Melhorias MLA IRM001425 Item 4*/

    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-busca-cond-pagto:
    /*
    ** Retorna a condicao de pagamento no documento que sera gerada a pendencia
    ** para comparacao se houve alteracao na condicao de pagamento.
    ** Se o parametro para geracao da pendencia considerar somente alteracao
    ** de valor ou de condicao de pagamento (MLA0000) gera pendencia
    */

    DEFINE OUTPUT PARAMETER pi-cond-pagto-nova LIKE cond-pagto.cod-cond-pag NO-UNDO.

    CASE mla-doc-pend-aprov.cod-tip-doc:

        WHEN 5 /*Cota‡Æo de materiais*/ THEN DO:
            FIND FIRST cotacao-item NO-LOCK
                 WHERE cotacao-item.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND cotacao-item.cod-emitente = int(substring(mla-doc-pend-aprov.chave-doc,9,8))
                   AND cotacao-item.it-codigo    = substring(mla-doc-pend-aprov.chave-doc,18,16)
                   AND cotacao-item.seq-cotac    = int(substring(mla-doc-pend-aprov.chave-doc,34,3)) NO-ERROR.
            IF AVAIL cotacao-item THEN DO:
                ASSIGN pi-cond-pagto-nova        = cotacao-item.cod-cond-pag.
            END.
        END.
        WHEN 6 /*Pedido de compra - item*/    OR
        WHEN 7 /*Pedido de compra - total*/   OR
        WHEN 8 /*Pedido emergencial - total*/ OR
        WHEN 19 /*Pedido emergencial - item*/ THEN DO:
            FIND FIRST pedido-compr NO-LOCK
                 WHERE pedido-compr.num-pedido = INT(SUBSTRING(mla-doc-pend-aprov.chave-doc,1,8)) NO-ERROR.
            IF AVAIL pedido-compr THEN
        	    ASSIGN pi-cond-pagto-nova = pedido-compr.cod-cond-pag.
        END.
        WHEN 13 /*Contrato de compras*/ OR
        WHEN 14 /*Medicao - item*/      THEN DO:
            FIND FIRST contrato-for NO-LOCK
                 WHERE contrato-for.nr-contrato = int(substring(mla-doc-pend-aprov.chave-doc,1,9)) NO-ERROR.
            IF AVAIL contrato-for THEN DO:
                FIND FIRST hist-alter WHERE hist-alter.nr-contrato    = contrato-for.nr-contrato
                  AND hist-alter.num-seq-item   = 0
                  AND hist-alter.num-seq-adit   = 0
                  AND hist-alter.des-tipo-alter = "contrato-for.cod-cond-pag":U NO-LOCK NO-ERROR.
                IF AVAIL hist-alter THEN DO:
                    ASSIGN pi-cond-pagto-nova = int(hist-alter.alter-destino).
                END.
                ELSE DO:
                    ASSIGN pi-cond-pagto-nova = contrato-for.cod-cond-pag.
                END.

            END.
        END.
        WHEN 16 THEN DO: /*Evento do Contrato*/
            FIND FIRST evento-ped NO-LOCK
                 WHERE evento-ped.numero-ordem  = int(substring(mla-doc-pend-aprov.chave-doc,1,8))
                   AND evento-ped.dt-evento     = date(substring(mla-doc-pend-aprov.chave-doc,9,9))
                   AND evento-ped.seq-evento    = int(substring(mla-doc-pend-aprov.chave-doc,19,2)) NO-ERROR.
            IF AVAIL evento-ped THEN DO:
                FIND FIRST contrato-for NO-LOCK 
                     WHERE contrato-for.nr-contrato = evento-ped.nr-contrato NO-ERROR.
                IF AVAIL contrato-for THEN
                    ASSIGN pi-cond-pagto-nova = contrato-for.cod-cond-pag.
            END.
        END.
        WHEN 21 /* Avalia‡Æo de Credito (Ped.Venda) */ then do:
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedido = int(substring(mla-doc-pend-aprov.chave-doc,1,11)) NO-ERROR.
            IF AVAIL ped-venda THEN
        	    ASSIGN pi-cond-pagto-nova = ped-venda.cod-cond-pag.
        END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-elimina-documentos-pendentes:
    
    IF  AVAIL mla-doc-pend-aprov
    AND mla-doc-pend-aprov.historico = NO THEN DO:

        RUN pi-chama-epc-eliminacao.

        OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "AEDLog-gera-pend_" + string(p-cod-tip-doc) + "_" + string(today,"99-99-99") + ".txt") append.
        put unformatted skip
                        c-lbl-liter-elimina-documentos-pendentes + ".     " skip
                        c-lbl-liter-modificacao-2-eliminacao-3 + "             = " p-tipo-trans                   skip
                        c-lbl-liter-empresa + "                                      = " mla-doc-pend-aprov.ep-codigo   skip
                        c-lbl-liter-estabelecimento + "                              = " mla-doc-pend-aprov.cod-estabel skip
                        c-lbl-liter-documento + "                                    = " mla-doc-pend-aprov.cod-tip-doc skip
                        c-lbl-liter-chave + "                                        = " mla-doc-pend-aprov.chave-doc   skip
                        c-lbl-liter-historico + "                                    = " mla-doc-pend-aprov.historico   skip.     
        FOR EACH tt-erro:
            PUT UNFORMATTED tt-erro.mensagem.
        END.
        output close.

        /* Integra‡Æo com o Fluig */
        IF l-fluig-integrated AND mla-doc-pend-aprov.cdn-workflow-fluig > 0 AND mla-doc-pend-aprov.ind-situacao = 1 THEN DO:
            RUN cancelProcessFluig IN h-mlaapi014(INPUT mla-doc-pend-aprov.nr-trans,
                                                  INPUT iTipoCancelamento,
                                                  OUTPUT TABLE RowErrorsAux).
            IF RETURN-VALUE <> "OK":U THEN DO:
                /* Erro na integracao, favor olhar monitor de integra‡Æo*/
                RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "":U).
                ASSIGN cErrorDescription = return-value.
                RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "":U).
                ASSIGN cErrorHelp = return-value.

                IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                    CREATE tt-erro.
                    ASSIGN tt-erro.mensagem = cErrorDescription + " - ":U + cErrorHelp.
                           tt-erro.cd-erro  = 54790.
                END.

                IF NOT CAN-FIND(FIRST RowErrorsAux WHERE RowErrorsAux.ErrorNumber = 54790) THEN DO:
                    RUN insertError IN THIS-PROCEDURE (INPUT 54790,
                                                       INPUT "EMS":U,
                                                       INPUT "WARNING":U,
                                                       INPUT "":U).
                END.
            END.
        END.

        delete mla-doc-pend-aprov.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-verifica-sit-ordem:
    /*
    ** Verifica situacao da ordem do documento que esta sofrendo aprovacao eletronica
    ** para que se o parametro de gerar ou nao gerar pendencia para saldos zerados:
    ** Ordem Confirmada e/ou Ordem Recebida
    */

    DEFINE INPUT PARAMETER pi-cod-tip-doc LIKE mla-doc-pend-aprov.cod-tip-doc NO-UNDO.

    CASE pi-cod-tip-doc:
        WHEN 6  OR       /*pedido de compra por item*/
        WHEN 19 THEN DO: /*pedido emergencial por item*/
            FIND FIRST ordem-compra
                 WHERE ordem-compra.num-pedido   = INT(SUBSTRING(c-chave,1,8)) 
                   AND ordem-compra.numero-ordem = INT(SUBSTRING(c-chave,9,16)) NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                IF p-valor = 0 THEN DO:
                    /*nao gerar pendencia para saldo zerado, ordens confirmadas e recebidas*/
                    IF (mla-param-aprov.log-ord-confda AND ordem-compra.situacao = 2)
                    OR (mla-param-aprov.log-ord-recbda AND ordem-compra.situacao = 6) THEN
                        RETURN "NOK":U.
                END.
                ELSE
                    RETURN "OK":U.
                
            END.
        END.
        WHEN 7  OR       /* pedido de compra - total*/
        WHEN 8  THEN DO: /* pedido emergencial - total*/    
            FIND FIRST pedido-compr
                 WHERE pedido-compr.num-pedido = INT(SUBSTRING(c-chave,1,8)) NO-LOCK NO-ERROR.
            IF AVAIL pedido-compr THEN DO:
                IF p-valor = 0 THEN DO:
                    IF CAN-FIND(FIRST ordem-compra
                                WHERE ordem-compra.num-pedido  = pedido-compr.num-pedido
                                  AND ( (ordem-compra.situacao = 2 AND mla-param-aprov.log-ord-confda) /*Confirmada*/
                                    OR  (ordem-compra.situacao = 6 AND mla-param-aprov.log-ord-recbda)))   /*Recebida*/ THEN DO:
                        RETURN "NOK":U.
                    END.
                END.
            END.

        END.
        WHEN 14 THEN DO: /* medi‡Æo */
            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = INT(SUBSTRING(c-chave,15,8)) NO-LOCK NO-ERROR.

            IF AVAIL ordem-compra THEN DO:
                IF AVAIL ordem-compra THEN DO:
                    IF p-valor = 0 THEN DO:
                        /*nao gerar pendencia para saldo zerado, ordens confirmadas e recebidas*/
                        IF (mla-param-aprov.log-ord-confda AND ordem-compra.situacao = 2)
                        OR (mla-param-aprov.log-ord-recbda AND ordem-compra.situacao = 6) THEN
                            RETURN "NOK":U.
                    END.
                    ELSE
                        RETURN "OK":U.
                    
                END.
            END.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-chama-epc-eliminacao:
/*------------------------------------------------------------------------------
  Purpose: Chamada EPC para elimina‡Æo de documento    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    /*************************************************************************/
    /*** INÖCIO CHAMADA EPC - Cliente: Grendene                            ***/
    /*************************************************************************/
    /*** Prop¢sito: Identificar os pontos de elimina‡Æo de pendˆncia       ***/
    /*************************************************************************/
    
    if  c-nom-prog-upc-mg97 <> "":U then do:    
        for each tt-epc
            where tt-epc.cod-event = "elimina-pendencia-doc":U.
            delete tt-epc.
        end.
    
        /*rowid da tabela mla-doc-pend-aprov*/
        {include/i-epc200.i2 &CodEvent='"elimina-pendencia-doc"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                             
        {include/i-epc200.i2 &CodEvent='"elimina-pendencia-doc"'
                             &CodParameter='"p-tipo-trans"'
                             &ValueParameter="string(p-tipo-trans)"}
                             
        {include/i-epc201.i "elimina-pendencia-doc"}
    END.
    /*************************************************************************/
    /*** FIM CHAMADA EPC - Grendene                                        ***/
    /*************************************************************************/ 

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-chama-epc-geracao-pendencia:
/*------------------------------------------------------------------------------
  Purpose: Chamada EPC para indicar gera‡Æo de pendˆncia
  Parameters: r-rowid: Rowid da tabela 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowid AS ROWID NO-UNDO.

    /*************************************************************************/
    /*** INÖCIO CHAMADA EPC - Cliente: Grendene                            ***/
    /*************************************************************************/
    /*** Prop¢sito: Identificar os pontos onde sÆo geradas pendˆncias que  ***/
    /***            ainda dependerÆo de aprova‡Æo, ou seja, nÆo aprovadas  ***/
    /***            automaticamente                                        ***/
    /*************************************************************************/
    
    if  c-nom-prog-upc-mg97 <> "":U then do:    
        for each tt-epc
            where tt-epc.cod-event = "aprovacao-pendente":U.
            delete tt-epc.
        end.

        /*rowid da tabela mla-doc-pend-aprov*/
        {include/i-epc200.i2 &CodEvent='"aprovacao-pendente"'
                             &CodParameter='"TABLE-ROWID"'
                             &ValueParameter="string(r-rowid)"}
                             
        {include/i-epc201.i "aprovacao-pendente"}
    END.
    /*************************************************************************/
    /*** FIM CHAMADA EPC - Grendene                                        ***/
    /*************************************************************************/

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE verificaTamanhoEmail:
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT mla-param-aprov.log-atachado  THEN DO:
        FOR EACH tt-mensagem:
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-mensagem.mensagem).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.
    ELSE DO:
        ASSIGN l-anexar-conteudo = mla-param-aprov.log-atachado.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE setLotacao:
/* -----------------------------------------------------------
  Purpose: Seta lota‡Æo a ser usada na aprova‡Æo
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE h-boin772 AS HANDLE NO-UNDO.
    DEFINE VARIABLE c-lotacao-trad AS CHARACTER   NO-UNDO.

    IF AVAIL mla-usuar-aprov THEN DO:
        if  mla-usuar-aprov.destino-lotacao = 1 THEN DO:
            IF AVAIL mla-tipo-doc-aprov THEN DO:
                if mla-tipo-doc-aprov.cod-tip-doc = 5 OR /*Cota‡Æo*/
                   mla-tipo-doc-aprov.cod-tip-doc = 6 OR /*Pedido de Compra - Item*/
                   mla-tipo-doc-aprov.cod-tip-doc = 19 /*Pedido de Compra Emergencial - Item*/
                then do:
                    IF mla-tipo-doc-aprov.cod-tip-doc = 5 THEN DO:
                        /*Cota‡Æo*/
                        FOR FIRST ordem-compra FIELDS(nr-requisicao)
                            WHERE ordem-compra.numero-ordem = int(substring(c-chave,1,8)) NO-LOCK: END.
                    END.
                    ELSE DO: /*Pedido de compra e Pedido Emergencial - Item*/
                        FOR FIRST ordem-compra FIELDS(nr-requisicao)
                            WHERE ordem-compra.numero-ordem = INT(SUBSTRING(c-chave,9,16)) NO-LOCK: END.
                    END.
                    RUN inbo/boin772.p PERSISTENT SET h-boin772.
                    RUN buscaLotacaoUsuarOrig IN h-boin772(INPUT mla-tipo-doc-aprov.cod-tip-doc,
                                                           INPUT ordem-compra.nr-requisicao,
                                                           INPUT mla-usuar-aprov.cod-usuar,
                                                           OUTPUT c-lotacao).
                    /*BO mla-lotacao*/
                    IF VALID-HANDLE(h-boin772) THEN DO:
                        DELETE PROCEDURE h-boin772.
                        ASSIGN h-boin772 = ?.
                    END.
                end.
            END.
            
            IF c-lotacao = "":U THEN
                assign c-lotacao = mla-usuar-aprov.cod-lotacao.
    
            IF c-lotacao = "":U THEN
                assign c-lotacao = p-lotacao-doc.
    
        END.
        
        ELSE DO:
            assign c-lotacao = p-lotacao-doc.
            IF  c-lotacao = "":U THEN
                assign c-lotacao = mla-usuar-aprov.cod-lotacao.
        END.
    END.

    FIND FIRST mla-lotacao WHERE mla-lotacao.ep-codigo   = p-ep-codigo
                             AND mla-lotacao.cod-lotacao = c-lotacao NO-LOCK NO-ERROR.

    IF NOT AVAIL mla-lotacao AND p-tipo-trans <> 3 /* Elimina‡Æo */ THEN DO:
        /* NÆo encontrado(a) Lota‡Æo para chave informada */  
        {utp/ut-liter.i "Lota‡Æo" *}
        ASSIGN c-lotacao-trad = RETURN-VALUE.

        RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 2, INPUT c-lotacao-trad).
        ASSIGN cErrorDescription = return-value.
        
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro + 1
               tt-erro.mensagem = cErrorDescription.
               tt-erro.cd-erro  = 2.

        RUN insertError IN THIS-PROCEDURE (INPUT 2,
                                           INPUT "EMS":U,
                                           INPUT "ERROR":U,
                                           INPUT c-lotacao-trad).

        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE insertError :
/*------------------------------------------------------------------------------------------------------------------------------------------------------------**
**  Purpose:    Insere erro na temp-table RowErrors                                                                                                           **
**  Parameters: Input - pErrorNumber: N£mero do erro                                                                                                          **
                Input - pErrorType: tipo do erro                                                                                                              **
                Input - pErrorSubType: subtipo do erro                                                                                                        **
                Input - pErrorParameters: parƒmetros da mensagem de erro                                                                                      **
**  Notes:                                                                                                                                                    **
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pErrorNumber     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pErrorType       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorSubType    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pErrorParameters AS CHARACTER NO-UNDO.

    /*--- Atualiza vari vel de seqñ¬ncia de erros ---*/
    IF CAN-FIND(LAST RowErrors) THEN DO:
        FIND LAST RowErrors NO-ERROR.
        ASSIGN iErrorSequence = RowErrors.ErrorSequence + 1.
    END.
    ELSE
        ASSIGN iErrorSequence = iErrorSequence + 1.

    run utp/ut-msgs.p(input "msg":U, input pErrorNumber, input pErrorParameters).
    assign cErrorDescription = return-value.
    run utp/ut-msgs.p(input "help":U, input pErrorNumber, input pErrorParameters).
    assign cErrorHelp = return-value.

    CREATE RowErrors.
    ASSIGN RowErrors.ErrorSequence    = iErrorSequence
           RowErrors.ErrorNumber      = pErrorNumber
           RowErrors.ErrorType        = pErrorType
           RowErrors.ErrorSubType     = pErrorSubType
           RowErrors.ErrorDescription = cErrorDescription
           RowErrors.ErrorHelp        = cErrorHelp
           RowErrors.ErrorParameters  = pErrorParameters.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getRowErrors :
/*---------------------------------------------------------------------------------------------------------------**
**  Purpose:    Retorna a temp-table RowErrors                                                                   **
**  Parameters: Output - RowErrors (temp-table)                                                                  **
                Input - pErrorType: tipo do erro                                                                 **
------------------------------------------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-notificaSolicitante:
/*-------------------------------------------------------------------------------------------------------------------**
**  Purpose:    Envia e-mail para o usuario da solicitacao de compra relacionada ao pedido que esta sendo aprovado  
**  Parameters: 
**  Notes:                                                                                                                                                    
----------------------------------------------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-msg-email          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-usuar-email-requis AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-solic    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-valor    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE de-total-requis      AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-solic-ant          AS INTEGER     NO-UNDO.
    

    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido = INTEGER(mla-doc-pend-aprov.chave-doc) NO-LOCK NO-ERROR.

    IF AVAIL pedido-compr THEN DO:

        {utp/ut-liter.i Referente_a_Solicita‡Æo_de_Compra}
        ASSIGN c-lbl-liter-solic = RETURN-VALUE.

        {utp/ut-liter.i Valor}
        ASSIGN c-lbl-liter-valor = RETURN-VALUE.

        FOR EACH ordem-compra
            WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:
            
            IF i-solic-ant <> ordem-compra.nr-requisicao THEN DO:
                
                ASSIGN i-solic-ant = ordem-compra.nr-requisicao
                       c-msg-email = c-men-e-mail.
                
                FIND FIRST requisicao 
                     WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK NO-ERROR.

                IF AVAIL requisicao THEN DO:
                    
                    ASSIGN de-total-requis = 0.
                    FOR EACH it-requisicao WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                        ASSIGN de-total-requis = de-total-requis + it-requisicao.val-item.
                    END.

                    ASSIGN c-msg-email = c-msg-email 
                                       + CHR(10) 
                                       + c-lbl-liter-solic + ":  ":U 
                                       + STRING(requisicao.nr-requisicao) 
                                       + c-lbl-liter-valor + ":":U 
                                       + TRIM(STRING(de-total-requis,">>>,>>>,>>>,>>>,>>9.9999":U)).
                    
    
                    FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                        WHERE b-mla-usuar-aprov.cod-usuar = requisicao.nome-abrev NO-LOCK: END.

                    ASSIGN c-usuar-email-requis = IF AVAIL b-mla-usuar-aprov AND b-mla-usuar-aprov.recebe-email THEN b-mla-usuar-aprov.e-mail ELSE "".

                    IF c-usuar-email-requis <> "" THEN DO:
                        EMPTY TEMP-TABLE tt-envio.

                        CREATE tt-envio.
                        ASSIGN tt-envio.versao-integracao = 1
                               tt-envio.exchange          = l-exchange
                               tt-envio.destino           = c-usuar-email-requis
                               tt-envio.assunto           = c-ass-e-mail
                               tt-envio.mensagem          = c-msg-email
                               tt-envio.importancia       = 2
                               tt-envio.log-enviada       = NO
                               tt-envio.log-lida          = NO
                               tt-envio.acomp             = NO
                               tt-envio.arq-anexo         = "".

                        IF NOT l-exchange AND AVAIL mla-param-aprov THEN 
                            ASSIGN tt-envio.servidor = mla-param-aprov.servidor-email
                                   tt-envio.porta    = mla-param-aprov.porta-email.  

                        IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.e-mail <> "" THEN
                           ASSIGN tt-envio.remetente = mla-usuar-aprov.e-mail.

                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : ":U + STRING(tt-envio2.exchange) ) NO-ERROR.
                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : ":U + STRING(tt-envio2.servidor) ) NO-ERROR.
                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : ":U + STRING(tt-envio2.porta)    ) NO-ERROR.
                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: ":U + STRING(tt-envio2.remetente)) NO-ERROR.
                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : ":U + STRING(tt-envio2.destino)  ) NO-ERROR.
                        LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : ":U + STRING(tt-envio2.assunto)  ) NO-ERROR.

                        RUN utp/utapi009.p (INPUT TABLE tt-envio, OUTPUT TABLE tt-erros).

                    END.
                END.
            END. 
        END. 
    END. 
    
    RETURN "OK":U.
END PROCEDURE.
