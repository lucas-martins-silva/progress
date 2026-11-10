&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN092 2.00.00.072 } /*** "010072" 10/09/2026 09:01:16 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin092 MUT}
&ENDIF


{utp/ut-glob.i}
/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName    BOIN092
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  dupli-apagar
&GLOBAL-DEFINE TableLabel Duplicatas
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin092.i RowObject}
{include/i-epc200.i boin092}     /* Upc */

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf-docum-est   FOR docum-est.

def var i-cod-emitente      like docum-est.cod-emitente    no-undo.
def var c-serie-docto       like docum-est.serie-docto     no-undo.
def var c-nro-docto         like docum-est.nro-docto       no-undo.
def var c-nat-operacao      like docum-est.nat-operacao    no-undo.
def var i-empresa           like param-global.empresa-prin no-undo.
def var h-boin060           as handle                      no-undo.
def var i-nr-horas          as decimal no-undo.
def var i-periodo           as INTEGER no-undo.
DEF VAR i-cont-prog         AS INTEGER INITIAL 1         NO-UNDO.
DEFINE VARIABLE l-importacao-di AS LOGICAL  INITIAL NO   NO-UNDO.
DEF VAR l-imp               AS LOGICAL INITIAL NO        NO-UNDO.
DEF VAR l-im0100            AS LOGICAL INITIAL NO        NO-UNDO.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

{cdp/cd9700.i} /* variaveis ent futura / fat antecipado */
DEF BUFFER b-natur-oper-ent-fut FOR natur-oper.
DEF VAR l-soma-ipi              AS LOG NO-UNDO INIT YES.

{cdp/cd4300.i3} /*definicao das variaveis utilizadas no cd4300.i4*/

{cdp/cd8889.i} /* definicao tt-cod-ir */
RUN cdp/cd8889.p (OUTPUT TABLE tt-cod-ir).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.5
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

for first param-global
    fields ( empresa-prin  ind-venc-dom
             ind-venc-sab  ind-venc-fer 
             modulo-07) no-lock :
end.    

/******* BETE - VERIFICAR TRATAMENTO COM IMPORTAÄ«O ******/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterNewRecord DBOProgram 
PROCEDURE afterNewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var de-tot-dupli      as decimal  no-undo.
    def var de-tot-dupli-me   as decimal  no-undo.
    def var i-num-parc        as int      no-undo.
    DEF VAR de-tot-dupli-orig AS DEC      NO-UNDO.
    DEF VAR l-fatura-ipi      AS LOG      NO-UNDO.
    DEF VAR l-remessa-ipi     AS LOG      NO-UNDO.

    if  not avail docum-est then 
        return "NOK".
        
    run findUsuario ( input docum-est.usuario ).
            
    /***** Atualiza Informaá‰es Chaves da Duplicata *****/
    assign RowObject.cod-emitente = docum-est.cod-emitente
           RowObject.serie-docto  = docum-est.serie-docto
           RowObject.nro-docto    = docum-est.nro-docto
           RowObject.nat-operacao = docum-est.nat-operacao.
           
    /***** Calcula Total da Duplicata *****/
    run calculateTotalDuplicata ( input "":U,
                                  output de-tot-dupli,
                                  OUTPUT de-tot-dupli-me ).

    assign de-tot-dupli-orig = de-tot-dupli
           de-tot-dupli      = docum-est.tot-valor - de-tot-dupli.

    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN de-tot-dupli = de-tot-dupli + docum-est.tot-taxa
               de-tot-dupli-me = docum-est.tot-valor-me - de-tot-dupli-me + docum-est.tot-taxa-me.

        IF de-tot-dupli-me < 0 THEN ASSIGN de-tot-dupli-me = 0.
        ASSIGN RowObject.valor-a-pagar-me = de-tot-dupli-me.

    END.

    if  de-tot-dupli < 0 then 
        assign de-tot-dupli = 0.     
    assign RowObject.vl-a-pagar = de-tot-dupli.                                     

    /*--- ent futura/fat antecip: verifica se o valor do IPI foi incluido no valor da duplicata.
          se a natur oper estiver parametrizada para incluir o IPI na fatura e nota for remessa, entao
          nao soma o valor do IPI na duplicata ---*/
    FOR FIRST b-natur-oper-ent-fut FIELDS(ind-entfut ind-est-qtd char-1)
        WHERE b-natur-oper-ent-fut.nat-operacao = docum-est.nat-operacao NO-LOCK: END.

    IF  AVAIL b-natur-oper-ent-fut THEN DO:
        {cdp/cd9700.i1 b-natur-oper-ent-fut} /* seta variaveis que identificam o tipo de nota */
    END.

    /* se for nota de fatura, carrega a variavel c-nat-operacao-fatura com a natureza do docum-est */
    IF  l-fatura-fat-antecip
    OR  l-fatura-ent-futura THEN DO:
        ASSIGN c-nat-operacao-fatura = docum-est.nat-operacao
               l-fatura-ipi          = YES.
    END.

    /* se for nota de remessa, carrega a variabel c-nat-operacao-fatura com a natureza da nota de fatura*/
    IF  l-remessa-fat-antecip
    OR  l-remessa-ent-futura THEN DO:
        FOR FIRST item-doc-est OF docum-est NO-LOCK:
            {cdp/cd9700.i2 item-doc-est} /* carrega a variabel c-nat-operacao-fatura */
        END.
        ASSIGN l-remessa-ipi = YES.
    END. 

    IF  l-fatura-ipi
    OR  l-remessa-ipi THEN DO:
        /*--- ent futura/fat antecip: verifica se o valor do IPI sera incluido no valor da duplicata.
              se a natur oper estiver parametrizada para incluir o IPI na fatura e nota for remessa, entao
              nao soma o valor do IPI na duplicata ---*/
        FOR FIRST b-natur-oper-ent-fut FIELDS(ind-entfut ind-est-qtd char-1 log-livre-1)
            WHERE b-natur-oper-ent-fut.nat-operacao = c-nat-operacao-fatura NO-LOCK: END.
    
        IF  AVAIL b-natur-oper-ent-fut THEN DO:
            {cdp/cd9700.i1 b-natur-oper-ent-fut} /* seta variaveis que identificam o tipo de nota */
        END.

        ASSIGN l-soma-ipi = YES.
    
        /* se eh nota de fatura, verifica se o ipi sera cobrado na fatura */
        IF  l-fatura-ipi THEN 
            ASSIGN l-soma-ipi = AVAIL b-natur-oper-ent-fut AND b-natur-oper-ent-fut.log-livre-1.
    
        /* se eh nota de remessa, verifica se o ipi sera cobrado na remessa */
        IF  l-remessa-ipi THEN
            ASSIGN l-soma-ipi = AVAIL b-natur-oper-ent-fut AND NOT b-natur-oper-ent-fut.log-livre-1.
    
        /* se for fatura e o ipi eh cobrado na remessa, retira o valor do IPI da fatura */
        IF  l-fatura-ipi 
        AND NOT l-soma-ipi THEN
            ASSIGN RowObject.vl-a-pagar = RowObject.vl-a-pagar - docum-est.ipi-deb-cre. 
    
        IF  l-remessa-ipi THEN DO:
            /* se for remessa e o ipi foi cobrado na fatura, entao a duplicata nao deve conter nenhum valor */
            IF  NOT l-soma-ipi THEN
                ASSIGN RowObject.vl-a-pagar = 0.
            /* se for remessa e o ipi nao foi cobrado na fatura, entao gera duplicata com o valor do ipi */
            ELSE
                ASSIGN rowObject.vl-a-pagar = IF  (docum-est.ipi-deb-cre - de-tot-dupli-orig) > 0 THEN
                                                  (docum-est.ipi-deb-cre - de-tot-dupli-orig)
                                              ELSE 0.
        END.
    END.

    /***** Determina Pr¢xima Parcela Dispon°vel *****/
    run findNextParc (output i-num-parc).
    assign RowObject.parcela = string(i-num-parc,"99").
                           
    /***** Determina Default Tipo Despesa *****/
    run setDefaultTpDespesa.


    /***** Determina Default Data Emiss∆o e Data Transaá∆o *****/
    assign RowObject.dt-emissao = docum-est.dt-emissao
           RowObject.dt-trans   = docum-est.dt-trans.
           
    /***** Determina Default Nro Dupli *****/
    assign RowObject.nr-duplic = docum-est.nro-docto.


    /***** Determina Default EspÇcie Documento *****/
    run setDefaultCodEsp.
    
    /***** Determina Default Data Vencimento  *****/
    run calculateDtVenc ( output RowObject.dt-vencim ).                
    
    run findEstabelec ( input docum-est.cod-estabel ).

    if c-nom-prog-dpc-mg97  <> "" 
    or c-nom-prog-appc-mg97 <> "" 
    or c-nom-prog-upc-mg97  <> "" then do:
        for each  tt-epc 
            where tt-epc.cod-event = "calculaValorDuplicata":U: 
            delete tt-epc. 
        end.
        
        /*** Criacao do registro para temp-table tt-epc ***/
        {include/i-epc200.i2 &CodEvent='"calculaValorDuplicata"'
                             &CodParameter='"RowidDocumEst"'
                             &ValueParameter=string(rowid(docum-est))}
        
        /*** Chamada do programa EPC ***/
        {include/i-epc201.i "calculaValorDuplicata"}

        find first tt-epc
            where tt-epc.cod-event     = "calculaValorDuplicata":U
              and tt-epc.cod-parameter = "valorDuplicata":U no-error.
        if avail tt-epc then
            assign RowObject.vl-a-pagar = dec(tt-epc.val-parameter).
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle (h-boin060) then do:
        delete procedure h-boin060.
        assign h-boin060 = ?.
    end.    
        

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateDtVenc DBOProgram 
PROCEDURE calculateDtVenc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piDtVencim     like dupli-apagar.dt-vencim.
    
    def var c-numeros  as character         no-undo initial "1,2,3,4,5,6,7,8,9,0".
    def var de-perc    as decimal extent 6  no-undo.  
    def var da-data    as date    extent 99 no-undo.
    def var da-partida as date              no-undo.
    def var i-parcela  as integer           no-undo.
    def var i-num-parc as integer           no-undo.
    def var i-ind      as integer           no-undo.
    def var i-avanco   as integer           no-undo.
    DEF VAR da-partida-prevista LIKE docum-est.dt-emissao     NO-UNDO.
    DEF VAR h-bocx230  AS HANDLE NO-UNDO.
 
    run findFirstItemDocEst.
    
    /***** Acessa Condiá∆o Pagamento de Acordo com Primeiro Pedido de Compra *****/
    if  avail item-doc-est then do:
        for first pedido-compr
            fields ( cod-cond-pag )
            where pedido-compr.num-pedido = item-doc-est.num-pedido no-lock:
        end.
        run findCondPagto ( input pedido-compr.cod-cond-pag ).
        
        if  not avail cond-pagto then do:
            for first cond-especif
               fields ( data-pagto perc-pagto ) 
                where cond-especif.num-pedido = item-doc-est.num-pedido no-lock:
            end.
            assign i-num-parc = 0.
            if  not avail cond-especif then 
                assign da-data = today.
            else do i-ind = 1 to 6:
                 if  cond-especif.data-pagto[i-ind] <> ? then
                     assign da-data[i-ind] = cond-especif.data-pagto[i-ind]
                            de-perc[i-ind] = cond-especif.perc-pagto[i-ind]
                            i-num-parc     = i-num-parc + 1.
            end.
        end.
    end.
    else do:
    
        for first rat-ordem
            fields ( cod-emitente serie-docto nro-docto nat-operacao num-pedido )
            where rat-ordem.cod-emitente  = RowObject.cod-emitente
              and rat-ordem.serie-docto   = RowObject.serie-docto
              and rat-ordem.nro-docto     = RowObject.nro-docto
              and rat-ordem.nat-operacao  = RowObject.nat-operacao no-lock:
        end.
        
        if  avail rat-ordem then do:
            
            for first pedido-compr
                fields ( cod-cond-pag )
                where pedido-compr.num-pedido = rat-ordem.num-pedido no-lock:
            end.

            run findCondPagto ( input pedido-compr.cod-cond-pag ).

            if  not avail cond-pagto then do:
            
                for first cond-especif
                   fields ( data-pagto perc-pagto ) 
                    where cond-especif.num-pedido = rat-ordem.num-pedido no-lock:
                end.
                assign i-num-parc = 0.
                if  not avail cond-especif then 
                    assign da-data = today.
                else do i-ind = 1 to 6:
                     if  cond-especif.data-pagto[i-ind] <> ? then
                         assign da-data[i-ind] = cond-especif.data-pagto[i-ind]
                                de-perc[i-ind] = cond-especif.perc-pagto[i-ind]
                                i-num-parc     = i-num-parc + 1.
                end.
            end.
        end.     
        else do:
            
            /***** Acessa Condiá∆o Pagamento de Acordo com Emitente *****/
            run findEmitente ( input RowObject.cod-emitente ).
            run findCondPagto ( input ( if  avail emitente 
                                        then emitente.cod-cond-pag
                                        else 0 ) ).
        end.
    end.
            
    if  avail cond-pagto then do:
        /**/
        assign da-data    = today
               da-partida = docum-est.dt-emissao
               i-num-parc = cond-pagto.num-parcelas.
        
        run findEmitente ( input RowObject.cod-emitente ).
        
        ASSIGN l-imp = NO.
        IF avail param-global 
            and param-global.modulo-07 
            and avail emitente 
            and (emitente.natureza = 3 or
                 emitente.natureza = 4) THEN DO:

            IF AVAIL docum-est THEN DO:
                {rep/re1001a.i50}
                {cdp/cd4300.i4   "yes" docum-est.char-1}
                {rep/re1001a.i51 "yes"}
                 IF c-embarque <> "" THEN 
                     ASSIGN l-imp = YES.
            END.
        END.

        IF l-imp THEN DO:
            IF NOT VALID-HANDLE(h-bocx230) THEN
                RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.
            RUN retornadatapartida IN h-bocx230 (INPUT docum-est.cod-estabel,
                                                 INPUT c-embarque,
                                                 OUTPUT da-partida,
                                                 OUTPUT da-partida-prevista).

            IF VALID-HANDLE(h-bocx230) THEN
                DELETE PROCEDURE h-bocx230.

            IF da-partida = ? THEN
                ASSIGN da-partida = docum-est.dt-emissao.
        END.

        {cdp/cd9020.i7 docum-est.cod-estabel}

            
        /** INICIO Chamada EPC - TURN07 - FERBASA - Alterar Vencimento Duplicata para dias 08/18/28 **/
        if c-nom-prog-dpc-mg97  <> "" 
        or c-nom-prog-appc-mg97 <> "" 
        or c-nom-prog-upc-mg97  <> "" then do:

            for each tt-epc 
                 where tt-epc.cod-event = "Alterar-Vencto-Dupli" :
                delete tt-epc.
            end. 
    
            create tt-epc.
            assign tt-epc.cod-event     = "Alterar-Vencto-Dupli"
                   tt-epc.cod-parameter = "cod-cond-pag"
                   tt-epc.val-parameter = STRING(cond-pagto.cod-cond-pag).
    
            create tt-epc.
            assign tt-epc.cod-event     = "Alterar-Vencto-Dupli"
                   tt-epc.cod-parameter = "Data-Vencto"
                   tt-epc.val-parameter = IF RowObject.parcela <= "12" THEN /*Informado numeros na parcela*/
                                            STRING(da-data[int(RowObject.parcela)])
                                          ELSE IF i-num-parc > 0 THEN      /*Informado letra na parcela*/
                                               STRING(da-data[int(i-num-parc)])
                                               ELSE STRING(da-data[int(1)]).
    				   
            create tt-epc.
            assign tt-epc.cod-event     = "Alterar-Vencto-Dupli"
                   tt-epc.cod-parameter = "i-num-parc"
                   tt-epc.val-parameter = IF RowObject.parcela <= "12" THEN /*Informado numeros na parcela*/
                                            STRING(RowObject.parcela)
                                          ELSE IF i-num-parc > 0 THEN      /*Informado letra na parcela*/
                                               STRING(i-num-parc)
                                               ELSE STRING(1).
            
            create tt-epc.
            assign tt-epc.cod-event     = "Alterar-Vencto-Dupli"
                   tt-epc.cod-parameter = "rowid-docum-est"
                   tt-epc.val-parameter = STRING(ROWID(docum-est)).
    
            {include/i-epc201.i "Alterar-Vencto-Dupli"}
    
             FIND FIRST tt-epc
                  WHERE tt-epc.cod-event     = "Alterar-Vencto-Dupli"
                    AND tt-epc.cod-parameter = "dt-vencim" NO-LOCK NO-ERROR.
             IF AVAIL tt-epc THEN
                ASSIGN da-data = date(tt-epc.val-parameter).
        END.
        /** FIM Chamada EPC - TURN07 - FERBASA - Alterar Vencimento Duplicata para dias 08/18/28 **/


    end.
            

    if  can-do(c-numeros,substring(RowObject.parcela,1,1)) then
        assign i-parcela = int(substring(RowObject.parcela,1,1)).
    if  can-do(c-numeros,substring(RowObject.parcela,2,1)) then
        assign i-parcela = i-parcela * 10
                         + int(substring(RowObject.parcela,2,1)).
 
    if  i-parcela > i-num-parc or i-parcela = 0 then do:
        run findLastDupliApagar.
        assign piDtVencim = if  avail bfDupli-apagar then 
                                bfDupli-apagar.dt-vencim
                            else 
                                if avail cond-pagto then 
                                    da-data[i-num-parc]
                                ELSE TODAY. 
    end.    
    else
        assign piDtVencim = da-data[i-parcela].
    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaMultiplasCondPagto DBOProgram 
PROCEDURE verificaMultiplasCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param l-mult-cond-pag as logical init false no-undo.
    
    def var i-cond-pag as integer  init ?   no-undo. // Condiá∆o pagto 0 Ç a espec°fica
 
    if not avail RowObject then
        return "NOK":U.

    for each item-doc-est no-lock
       where item-doc-est.cod-emitente = RowObject.cod-emitente
         and item-doc-est.serie-docto  = RowObject.serie-docto
         and item-doc-est.nro-docto    = RowObject.nro-docto
         and item-doc-est.nat-operacao = RowObject.nat-operacao:

        IF item-doc-est.num-pedido > 0 THEN DO:
            FIND FIRST pedido-compr
                 WHERE pedido-compr.num-pedido = item-doc-est.num-pedido NO-LOCK NO-ERROR.

            if i-cond-pag <> ?    and 
               avail pedido-compr and 
               pedido-compr.cod-cond-pag <> i-cond-pag then do:
                assign l-mult-cond-pag = true.
                RETURN "OK":U.
            end.

            ASSIGN i-cond-pag = pedido-compr.cod-cond-pag.
        END.
        ELSE DO:
            FOR EACH rat-ordem NO-LOCK
               WHERE rat-ordem.cod-emitente  = item-doc-est.cod-emitente
                 AND rat-ordem.serie-docto   = item-doc-est.serie-docto
                 AND rat-ordem.nro-docto     = item-doc-est.nro-docto
                 AND rat-ordem.nat-operacao  = item-doc-est.nat-operacao
                 AND rat-ordem.sequencia     = item-doc-est.sequencia:

                FIND FIRST pedido-compr
                     WHERE pedido-compr.num-pedido = rat-ordem.num-pedido NO-LOCK NO-ERROR.

                if i-cond-pag <> ?    and 
                   avail pedido-compr and 
                   pedido-compr.cod-cond-pag <> i-cond-pag then do:
                    assign l-mult-cond-pag = true.
                    RETURN "OK":U.
                end.

                ASSIGN i-cond-pag = pedido-compr.cod-cond-pag.
            END.
        END.
    end.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculateTotalDuplicata DBOProgram 
PROCEDURE calculateTotalDuplicata :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piParcela       like dupli-apagar.parcela no-undo.
    def output param piTotalDupli   as   decimal              no-undo.
    def output param piTotalDupliMe as   decimal              no-undo.
    
    if  not avail RowObject then 
        return "NOK":U.
        
    for each bfDupli-apagar 
      fields ( vl-a-pagar valor-a-pagar-me ) 
       where bfDupli-apagar.cod-emitente = RowObject.cod-emitente 
         and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
         and bfDupli-apagar.serie-docto  = RowObject.serie-docto
         and bfDupli-apagar.nro-docto    = RowObject.nro-docto 
         and bfDupli-apagar.parcela     <> RowObject.parcela no-lock:
         
         assign piTotalDupli   = piTotalDupli   + bfDupli-apagar.vl-a-pagar
                piTotalDupliMe = piTotalDupliMe + bfDupli-apagar.valor-a-pagar-me.
    end.         

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateWarningComex DBOProgram 
PROCEDURE CreateWarningComex :
/*------------------------------------------------------------------------------
Purpose: Mensagem de warning, para nota de comex, quando acessado o botao de Geracao de duplicatas
Parameters: 
Notes:       
------------------------------------------------------------------------------*/
    {method/svc/errors/inserr.i
                        &ErrorNumber="30543"
                        &ErrorType="EMS"
                        &ErrorSubType="WARNING" }

    RETURN "OK":U.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.
    
    IF  NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
        
    run findEmitente  (RowObject.cod-emitente ).
    run findEstabelec (input docum-est.cod-estabel).
        
    CASE pFieldName:
        WHEN "dt-venc-desc":U      THEN ASSIGN pFieldEnable = ( RowObject.vl-desconto > 0 ).
        WHEN "cod-ret-irf":U       THEN ASSIGN pFieldEnable = ( avail emitente and emitente.ind-rendiment ).
        WHEN "i-mo-codigo-aux":U   THEN ASSIGN pFieldEnable = ( avail param-global 
                                                            and param-global.modulo-07 
                                                            and avail emitente 
                                                            and (emitente.natureza = 3 or
                                                                 emitente.natureza = 4)
                                                            and avail estabelec      
                                                            and emitente.pais <> estabelec.pais).
        
        OTHERWISE ASSIGN pFieldEnable = yes.
        
    END CASE.
    

    RETURN "OK":U.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCondPagto DBOProgram 
PROCEDURE findCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*** Esta procedure n∆o usa "for first" pois a condiá∆o de pagamento Ç utilizada 
     na include re9999.i4.
****/     

    def input param piCodCondPag like emitente.cod-cond-pag no-undo.
    
    if  not avail cond-pagto
    or  cond-pagto.cod-cond-pag <> piCodCondPag then 
    
        find cond-pagto
            where cond-pagto.cod-cond-pag = piCodCondPag no-lock no-error.
        
    if  not avail cond-pagto then 
        RETURN "NOK":U.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumEst DBOProgram 
PROCEDURE findDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.
    def input param piSerieDocto    like docum-est.serie-docto  no-undo.
    def input param piNroDocto      like docum-est.nro-docto    no-undo.
    def input param piNatOperacao   like docum-est.nat-operacao no-undo.
    
    if  not avail docum-est
    or  docum-est.cod-emitente <> piCodEmitente
    or  docum-est.serie-docto  <> piSerieDocto
    or  docum-est.nro-docto    <> piNroDocto
    or  docum-est.nat-operacao <> piNatOperacao then 
    
        for first docum-est
            fields ( cod-emitente    serie-docto     
                     nro-docto       nat-operacao
                     cod-estabel     usuario
                     dt-emissao      tot-valor 
                     ce-atual        nff 
                     char-1          cotacao-dia)
            where docum-est.cod-emitente = piCodEmitente
              and docum-est.serie-docto  = piSerieDocto
              and docum-est.nro-docto    = piNroDocto
              and docum-est.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail docum-est then do:
        DEFINE VARIABLE c-lbl-liter-documento-do-estoque AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento_do_Estoque" *}
        ASSIGN c-lbl-liter-documento-do-estoque = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-documento-do-estoque"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOProgram 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.
    
    if  not avail emitente
    or  emitente.cod-emitente <> piCodEmitente then 
    
        for first emitente
            fields ( cod-emitente       cod-cond-pag 
                     tp-desp-padrao     ind-rendiment
                     ven-domingo        ven-sabado
                     ven-feriado        natureza
                     pais)
            where emitente.cod-emitente = piCodEmitente no-lock.
        end.

    if  not avail emitente then do:
        DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Emitente" *}
        ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-emitente"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstabelec DBOProgram 
PROCEDURE findEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel no-undo.
    
    assign i-empresa = param-global.empresa-prin.
    
    if  not avail estabelec
    or  estabelec.cod-estabel <> piEstab then 
    
        for first estabelec
            fields ( cod-estabel  cod-emitente
                     estado       deposito-cq
                     cidade       pais )
                     
            where estabelec.cod-estabel = piEstab no-lock.
        end.
        
    if  not avail estabelec then do:
        DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-estabelecimento"}
        RETURN "NOK":U.
    end.
    else do:
        
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).

        RETURN "OK":U.        
    end.        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstItemDocEst DBOProgram 
PROCEDURE findFirstItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for first item-doc-est
       fields ( num-pedido numero-ordem ) 
        where item-doc-est.cod-emitente = RowObject.cod-emitente
          and item-doc-est.serie-docto  = RowObject.serie-docto
          and item-doc-est.nro-docto    = RowObject.nro-docto
          and item-doc-est.nat-operacao = RowObject.nat-operacao
          and item-doc-est.num-pedido   > 0 no-lock:
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastDupliApagar DBOProgram 
PROCEDURE findLastDupliApagar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for last bfDupli-apagar 
      fields ( dt-vencim parcela )
       where bfDupli-apagar.cod-emitente = RowObject.cod-emitente
         and bfDupli-apagar.serie-docto  = RowObject.serie-docto
         and bfDupli-apagar.nro-docto    = RowObject.nro-docto
         and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
       no-lock:
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMoeda DBOProgram 
PROCEDURE findMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piMoeda   like moeda.mo-codigo no-undo.
    
    if  not avail moeda
    or  moeda.mo-codigo <> piMoeda then 

        for first moeda
            fields ( mo-codigo descricao)
            where moeda.mo-codigo = piMoeda no-lock.
        end.
        
    if  not avail moeda then do:
        DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Moeda" *}
        ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-moeda"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNotaComex DBOProgram 
PROCEDURE FindNotaComex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR l-nota-rateio  LIKE natur-oper.nota-rateio NO-UNDO.
    DEF VAR l-emit-estrang AS LOG NO-UNDO.

    DEFINE INPUT  PARAMETER p-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.
    
    {cdp/cd4300.i3} /*definicao das variaveis utilizadas no cd4300.i4*/
     
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FIND natur-oper WHERE
         natur-oper.nat-operacao = p-nat-operacao NO-LOCK NO-ERROR.

    ASSIGN l-nota-rateio = IF AVAIL natur-oper THEN natur-oper.nota-rateio
                           ELSE NO.

    IF AVAIL param-global AND param-global.modulo-07 THEN DO:
        IF l-nota-rateio THEN DO:
            FOR FIRST rat-docum fields(nf-serie nf-nro nf-emitente nf-nat-oper) WHERE
                      rat-docum.serie-docto  = p-serie-docto    AND     
                      rat-docum.nro-docto    = p-nro-docto  AND     
                      rat-docum.cod-emitente = p-cod-emitente AND
                      rat-docum.nat-operacao = p-nat-operacao NO-LOCK:
        
            END.
            IF AVAIL rat-docum THEN
                ASSIGN p-serie-docto  = rat-docum.nf-serie
                       p-nro-docto    = rat-docum.nf-nro
                       p-cod-emitente = rat-docum.nf-emitente
                       p-nat-operacao = rat-docum.nf-nat-oper.
        END.

        /*run findDocumEst ( input p-cod-emitente,
                           input p-serie-docto,
                           input p-nro-docto,
                           input p-nat-operacao ).*/

        FOR FIRST bf-docum-est fields(char-1) WHERE
                  bf-docum-est.serie-docto  = p-serie-docto  AND
                  bf-docum-est.nro-docto    = p-nro-docto    AND
                  bf-docum-est.cod-emitente = p-cod-emitente AND
                  bf-docum-est.nat-operacao = p-nat-operacao NO-LOCK:
        END.

        IF CAN-FIND(FIRST funcao NO-LOCK
                    WHERE funcao.cd-funcao = "spp-habilita-import"
                    AND funcao.ativo     = YES) OR
           (AVAIL emitente AND
            (emitente.natureza = 3 or
             emitente.natureza = 4)) THEN
           ASSIGN l-emit-estrang = YES.
        
        IF l-emit-estrang AND AVAIL bf-docum-est THEN DO:
            {rep/re1001a.i50}
            {cdp/cd4300.i4 "yes" bf-docum-est.char-1}
            {rep/re1001a.i51 "yes"}
            if c-embarque <> "":U THEN
                ASSIGN pFieldEnable = YES.
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findUsuario DBOProgram 
PROCEDURE findUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piUsuario   like docum-est.usuario no-undo.
    
    if  not avail param-re
    or  param-re.usuario <> piUsuario then 
    
        for first param-re
            fields ( usuario var-emis esp-def-nff esp-def-dup )
            where param-re.usuario = piUsuario no-lock.
        end.
        
    if  not avail param-re then do:
        DEFINE VARIABLE c-lbl-liter-usuario-do-recebimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio_do_Recebimento" *}
        ASSIGN c-lbl-liter-usuario-do-recebimento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-usuario-do-recebimento"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imp-irf":U THEN ASSIGN pFieldValue = RowObject.cod-imp-irf.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "esp-irf":U THEN ASSIGN pFieldValue = RowObject.esp-irf.
        WHEN "historico":U THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-duplic":U THEN ASSIGN pFieldValue = RowObject.nr-duplic.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
        WHEN "dt-venc-desc":U THEN ASSIGN pFieldValue = RowObject.dt-venc-desc.
        WHEN "dt-vencim":U THEN ASSIGN pFieldValue = RowObject.dt-vencim.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliq-irf":U THEN ASSIGN pFieldValue = RowObject.aliq-irf.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desconto":U THEN ASSIGN pFieldValue = RowObject.desconto.
        WHEN "imposto-inss":U THEN ASSIGN pFieldValue = RowObject.imposto-inss.
        WHEN "imposto-ir":U THEN ASSIGN pFieldValue = RowObject.imposto-ir.
        WHEN "imposto-iss":U THEN ASSIGN pFieldValue = RowObject.imposto-iss.
        WHEN "perc-juros":U THEN ASSIGN pFieldValue = RowObject.perc-juros.
        WHEN "perc-mora":U THEN ASSIGN pFieldValue = RowObject.perc-mora.
        WHEN "Valor-a-pagar-me":U THEN ASSIGN pFieldValue = RowObject.Valor-a-pagar-me.
        WHEN "vl-a-pagar":U THEN ASSIGN pFieldValue = RowObject.vl-a-pagar.
        WHEN "vl-ap-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[1].
        WHEN "vl-ap-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ap-fasb[2].
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-frete":U THEN ASSIGN pFieldValue = RowObject.vl-frete.
        WHEN "vl-outros":U THEN ASSIGN pFieldValue = RowObject.vl-outros.
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescriptionFields DBOProgram 
PROCEDURE getDescriptionFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pFieldName        as char no-undo.
    def output param pDescription      as char no-undo.
    
    
    CASE pFieldName:
        WHEN "nome-emit":U      THEN ASSIGN pDescription = if  avail emitente then 
                                                               emitente.nome-emit
                                                           else "".
        WHEN "desc-natur":U     THEN ASSIGN pDescription = if  avail natur-oper then 
                                                               natur-oper.denominacao
                                                           else "".
                                                           
        WHEN "desc-moeda":U     THEN ASSIGN pDescription = if  avail moeda then 
                                                               moeda.descricao
                                                           else "".                                                                 
                                                                   
        OTHERWISE RETURN "NOK":U.
        
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-ret-irf":U THEN ASSIGN pFieldValue = RowObject.cod-ret-irf.
        WHEN "dia-util-irf":U THEN ASSIGN pFieldValue = RowObject.dia-util-irf.
        WHEN "dias-atraso":U THEN ASSIGN pFieldValue = RowObject.dias-atraso.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "esp-movto":U THEN ASSIGN pFieldValue = RowObject.esp-movto.
        WHEN "estado-cq":U THEN ASSIGN pFieldValue = RowObject.estado-cq.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.

        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE dupli-apagar.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE dupli-apagar.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE dupli-apagar.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE dupli-apagar.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE dupli-apagar.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pparcela = RowObject.parcela.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE dupli-apagar.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE dupli-apagar.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE dupli-apagar.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE dupli-apagar.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE dupli-apagar.parcela NO-UNDO.

    FIND FIRST bfdupli-apagar WHERE 
        bfdupli-apagar.serie-docto = pserie-docto AND 
        bfdupli-apagar.nro-docto = pnro-docto AND 
        bfdupli-apagar.cod-emitente = pcod-emitente AND 
        bfdupli-apagar.nat-operacao = pnat-operacao AND 
        bfdupli-apagar.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdupli-apagar THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdupli-apagar)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram 
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.
    
    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao ).
                            
                            
    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMovtoPend DBOProgram 
PROCEDURE linkToMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pHandle as handle no-undo.
    
    run getKey1 in pHandle ( output i-cod-emitente,
                             output c-serie-docto,
                             output c-nro-docto,
                             output c-nat-operacao ).
                            
                            
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       no-lock
       indexed-reposition.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         no-lock
         indexed-reposition.
         
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfMovtoPend DBOProgram 
PROCEDURE openQueryOfMovtoPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         no-lock
         indexed-reposition.
         
  return "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est.cod-emitente no-undo.
    def input param piSerieDocto    like docum-est.serie-docto  no-undo.
    def input param piNroDocto      like docum-est.nro-docto    no-undo.
    def input param piNatOperacao   like docum-est.nat-operacao no-undo.

    assign i-cod-emitente = piCodEmitente
           c-serie-docto  = piSerieDocto
           c-nro-docto    = piNroDocto
           c-nat-operacao = piNatOperacao.
       
       
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultCodEsp DBOProgram 
PROCEDURE setDefaultCodEsp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign RowObject.cod-esp   = if  avail param-re then  
                                     if  docum-est.nff 
                                     then param-re.esp-def-nff
                                     else param-re.esp-def-dup
                                 else " ":U.                                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultTpDespesa DBOProgram 
PROCEDURE setDefaultTpDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run findFirstItemDocEst.
    if  avail item-doc-est then do:
        for first ordem-compra 
           fields ( tp-despesa )
            where ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock:
        end.
        if  avail ordem-compra then             
            assign RowObject.tp-despesa = ordem-compra.tp-despesa.
            
    end.
    else do:
        
        for first rat-ordem
            fields ( cod-emitente serie-docto nro-docto nat-operacao numero-ordem )
            where rat-ordem.cod-emitente = RowObject.cod-emitente
              and rat-ordem.serie-docto  = RowObject.serie-docto
              and rat-ordem.nro-docto    = RowObject.nro-docto
              and rat-ordem.nat-operacao = RowObject.nat-operacao 
              and rat-ordem.numero-ordem <> 0 no-lock : end.

        if  avail rat-ordem then do:              
            for first ordem-compra 
               fields ( tp-despesa )
                where ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock:
            end.
            if  avail ordem-compra then             
                assign RowObject.tp-despesa = ordem-compra.tp-despesa.
        end.
        else do:                
            run findEmitente ( input RowObject.cod-emitente ).
            if  avail emitente then
                assign RowObject.tp-despesa = emitente.tp-desp-padrao.
        end.                
    end.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setImportacao DBOProgram 
PROCEDURE setImportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    ASSIGN l-importacao-di = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidDocumEst DBOProgram 
PROCEDURE setRowidDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param rwDocumEst  as rowid no-undo.

    for first docum-est
        fields ( cod-emitente    serie-docto     
                 nro-docto       nat-operacao
                 cod-estabel     usuario
                 dt-emissao      tot-valor  )
        where rowid(docum-est) = rwDocumEst no-lock:
    end.

   /* find docum-est where rowid(docum-est) = rwDocumEst no-lock no-error.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateRecord DBOProgram 
PROCEDURE validateCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var h-adbo      as handle   no-undo.
    def var c-retorno   as char     no-undo.

    /***** Verifica se duplicata j† est† cadastrada *****/
    if  can-find(bfDupli-apagar 
                    where bfDupli-apagar.cod-emitente = RowObject.cod-emitente
                      and bfDupli-apagar.serie-docto  = RowObject.serie-docto
                      and bfDupli-apagar.nro-docto    = RowObject.nro-docto
                      and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
                      and bfDupli-apagar.parcela      = RowObject.parcela ) then do:
        DEFINE VARIABLE c-lbl-liter-duplicata AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Duplicata" *}
        ASSIGN c-lbl-liter-duplicata = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-duplicata"}
    end.
                                

    /***** Verifica se n∆o existe outra duplicata com mesmo emitente/serie/nro/parcela/esp *****/
    /***** Esta validaá∆o Ç necess†ria, porque a natureza n∆o Ç chave no Contas a Pagar    */
    for first bfDupli-apagar
       fields ()
        where bfDupli-apagar.cod-emitente = RowObject.cod-emitente
          and bfDupli-apagar.serie-docto  = RowObject.serie-docto
          and bfDupli-apagar.nro-docto    = RowObject.nro-docto
          and bfDupli-apagar.parcela      = RowObject.parcela
          and bfDupli-apagar.cod-esp      = RowObject.cod-esp
          and NOT l-importacao-di
        no-lock:        
    end.
    if  avail bfDupli-apagar then do:
        DEFINE VARIABLE c-lbl-liter-duplicata-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Duplicata" *}
        ASSIGN c-lbl-liter-duplicata-2 = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-duplicata-2"}
    end.          


    /***** Executa BO TIT-AP ( AD260 ) para verificar se o t°tulo j† est† cadastrado no AP *****/
    run adbo/boad260.p persistent set h-adbo.
    run findCodigo in h-adbo ( input i-empresa,
                               input RowObject.cod-emitente,
                               input ( if  avail docum-est 
                                       then docum-est.cod-estabel
                                       else " " ),
                               input RowObject.cod-esp,
                               input RowObject.serie-docto,
                               input RowObject.nr-duplic,
                               input RowObject.parcela,
                               output c-retorno ).

    /***** Quando o documento j† existe no AP, o retorno Ç igual a Branco *****/                               
    if  c-retorno = " ":U then do:                                     
        DEFINE VARIABLE c-lbl-liter-titulo-contas-a-pagar AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "T°tulo_Contas_a_Pagar" *}
        ASSIGN c-lbl-liter-titulo-contas-a-pagar = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-titulo-contas-a-pagar"}
    end.                                 
    delete procedure h-adbo.
    assign h-adbo = ?.
    /***** Executa BO LIN-I-AP ( AD170 ) para verificar se o t°tulo j† est† pendente no AP *****/
    run adbo/boad170.p persistent set h-adbo.
    run findDocumento in h-adbo ( input i-empresa,
                                  input ( if  avail docum-est 
                                          then docum-est.cod-estabel
                                          else " " ),
                                  input RowObject.cod-esp,
                                  input RowObject.serie-docto,
                                  input RowObject.nr-duplic,
                                  input RowObject.parcela,
                                  input RowObject.cod-emitente,
                                  output c-retorno ).

    /***** Quando o documento j† existe no AP, o retorno Ç igual a Branco *****/                               
    if  c-retorno = " ":U then do:                                     
        DEFINE VARIABLE c-lbl-liter-titulo-pendente-ap AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "T°tulo_Pendente_AP" *}
        ASSIGN c-lbl-liter-titulo-pendente-ap = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-titulo-pendente-ap"}
    end.                                 
    delete procedure h-adbo.
    assign h-adbo = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    def var de-tot-dupli        as decimal      no-undo.
    def var da-dt-venc-aux      as date         no-undo.    
    def var c-lista-retencao    as char         no-undo.
    def var l-erro-dt-venc      as logical      no-undo.
    def var l-erro-cod-retencao as logical      no-undo.
    DEF VAR l-nota-importacao   AS LOGICAL      NO-UNDO.
    def var l-mult-cond-pagto   AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE l_erro_27563 AS LOGICAL    NO-UNDO.


    ASSIGN l_erro_27563 = NO.
            
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    run emptyRowErrors.
    run findDocumEst ( input RowObject.cod-emitente,
                       input RowObject.serie-docto,
                       input RowObject.nro-docto,
                       input RowObject.nat-operacao ).

    if  return-value <> "OK":U then
        return "NOK":U.        
    
    if  docum-est.ce-atual then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="19515" /*Nota fiscal j† atualizada*/
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.        
    
    if  pType <> "delete" then do:
    
        IF INDEX(RowObject.parcela,"'") <> 0  THEN DO :

               DEFINE VARIABLE c-lbl-liter-o-campo-parcela-possui-caracte AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "O_campo_parcela_possui_caractere_inv†lido" *}
               ASSIGN c-lbl-liter-o-campo-parcela-possui-caracte = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                &ErrorNumber="17006"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-o-campo-parcela-possui-caracte + ' '"}
        END.

        run findUsuario ( input docum-est.usuario ).
        
        run findEstabelec ( input docum-est.cod-estabel ).
    
        if  RowObject.desconto > 0
        and RowObject.vl-desconto = 0 then
            assign RowObject.vl-desconto = round((RowObject.vl-a-pagar * RowObject.desconto) / 100,2).

        RUN FindNotaComex (INPUT RowObject.nro-docto,
                           INPUT RowObject.serie-docto,
                           INPUT RowObject.cod-emitente,
                           INPUT RowObject.nat-operacao,
                           OUTPUT l-nota-importacao).
        IF NOT l-nota-importacao THEN
            if  RowObject.vl-desconto = 0 then
                assign RowObject.dt-venc-desc = ?.
        
        /***** Valida Informaá‰es Referentes a Inclus∆o *****/
        if  pType = "Create":U then 
            run validateCreateRecord.
    
                
        /***** Valida Tipo de Receita/Despesa *****/
        for first tipo-rec-desp
           fields ( tipo )
            where tipo-rec-desp.tp-codigo = RowObject.tp-despesa no-lock:
        end.
        if  not avail tipo-rec-desp then do:
            DEFINE VARIABLE c-lbl-liter-tipo-receitadespesa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Tipo_Receita/Despesa" *}
            ASSIGN c-lbl-liter-tipo-receitadespesa = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-tipo-receitadespesa"}
        end.
        else 
            if  tipo-rec-desp.tipo = 1 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="4995"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
    
        /* ****** In°cio EPC Crefisa ******** */
        for each tt-epc 
            where tt-epc.cod-event = "nao-valida-dt-trans":U:
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "nao-valida-dt-trans":U
               tt-epc.cod-parameter = "dt-emissao":U
               tt-epc.val-parameter = string(RowObject.dt-emissao).

        create tt-epc.
        assign tt-epc.cod-event     = "nao-valida-dt-trans":U
               tt-epc.cod-parameter = "dt-trans":U
               tt-epc.val-parameter = string(RowObject.dt-trans).

        {include/i-epc201.i nao-valida-dt-trans}
        /* ***** Fim EPC Crefisa ***** */
        if not can-find(first tt-epc 
                        where tt-epc.cod-event     = "nao-valida-dt-trans":U
                        and   tt-epc.cod-parameter = "nao-valida":U
                        and   tt-epc.val-parameter = "NAO-VALIDA":U) then do:
            
            /***** Valida Data de Emiss∆o em Relaá∆o ao ParÉmetro do Usu†rio *****/
            if  not avail param-re
            or  RowObject.dt-emissao < ( today - param-re.var-emis ) 
            or  RowObject.dt-emissao > today then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="614"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
        

            /***** Valida Data de Emiss∆o em Relaá∆o a Data de Vencimento *****/
            if  RowObject.dt-emissao > RowObject.dt-vencim then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="1031"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.
    
        
            /***** Valida Data de Transaá∆o *****/
            if  RowObject.dt-trans > today
            or  RowObject.dt-trans < RowObject.dt-emissao then do:
                {method/svc/errors/inserr.i
                                &ErrorNumber="1788"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
            end.
        end.
        
        
        IF l-nota-importacao THEN DO:
             {rep/re1001c.i50} /* vari†veis e informaá‰es utilizadas pelo re1001c.i51 */
             {cdp/cd4300.i4 "yes" RowObject.char-1}

             if  not can-find(moeda where moeda.mo-codigo = int(aux-c-char[1])) 
             then do:
                {method/svc/errors/inserr.i
                          &ErrorNumber="4929"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR" }
             end.  
             if  dec(aux-c-char[2]) = 0 or
                    (aux-c-char[2]) = " " then do:  
                IF docum-est.origem = "I":U THEN DO:
                    {method/svc/errors/inserr.i
                              &ErrorNumber="17527"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR" }
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "MSG":U, INPUT 30543, INPUT "").
                    FIND LAST RowErrors NO-ERROR.
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = IF AVAIL RowErrors THEN (RowErrors.ErrorSequence + 1) ELSE 1
                           RowErrors.ErrorNumber      = 30543
                           RowErrors.ErrorType        = "EMS"
                           RowErrors.ErrorSubType     = "WARNING"
                           RowErrors.ErrorDescription = RETURN-VALUE.
                END.
             end.

             if  RowObject.vl-desconto = 0 and
                 DEC(aux-c-char[3])    = 0 then
                assign RowObject.dt-venc-desc = ?.

             IF  DEC(aux-c-char[3]) <> 0 AND
                 RowObject.dt-venc-desc = ? THEN DO:
                 ASSIGN l_erro_27563 = YES.
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="27563"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
             END.
             IF  DEC(aux-c-char[3])   <> 0 AND /*vl de desconto na moeda original*/
                 RowObject.vl-desconto = 0 THEN DO:
                  {method/svc/errors/inserr.i
                                     &ErrorNumber="31754"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" }
             END.

        END.
        
        
        /**** Valida Moeda ***
        if avail param-global 
           and param-global.modulo-07 
           and avail emitente 
           and (emitente.natureza = 3 or
                emitente.natureza = 4)
           and avail estabelec      
           and emitente.pais <> estabelec.pais then do:
            {rep/re1001c.i50} /* vari†veis e informaá‰es utilizadas pelo re1001c.i51 */
            {cdp/cd4300.i4 "yes" RowObject.char-1}
            
             
            if  not can-find(moeda where moeda.mo-codigo = int(aux-c-char[1])) 
            then do:
               {method/svc/errors/inserr.i
                         &ErrorNumber="4929"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" }
            end.  
            if  dec(aux-c-char[2]) = 0 or
                   (aux-c-char[2]) = " " then do:      
               {method/svc/errors/inserr.i
                         &ErrorNumber="17527"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" }
            end.
        end. 
        ***************/
        /***** Valida Valor a Pagar *****/
        if  RowObject.vl-a-pagar <= 0 then do:
            {method/svc/errors/inserr.i
                            &ErrorNumber="309"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
        end.            
    
        /***** Valida EspÇcie do Documento *****/
        for first espec-ap
           fields ( tipo ) 
            where espec-ap.cod-esp = RowObject.cod-esp no-lock:
        end.
        if  not avail espec-ap then do:        
            DEFINE VARIABLE c-lbl-liter-especie-titulo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "EspÇcie_T°tulo" *}
            ASSIGN c-lbl-liter-especie-titulo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-especie-titulo"}
        end.
        else                             
            if  espec-ap.tipo = 2 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="625"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            end.
        

        if  (RowObject.desconto    <> 0 or
             RowObject.vl-desconto <> 0) and
             RowObject.dt-venc-desc = ? and
            NOT l_erro_27563 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="27563"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" }
        end.
        
        run findEmitente ( input RowObject.cod-emitente ).
        
        /***** Atualiza Atributos para Criaá∆o/Modificaá∆o Duplicatas *****/
        assign RowObject.ep-codigo        = i-empresa
               RowObject.cod-estabel      = if  avail docum-est 
                                            then docum-est.cod-estabel
                                            else " ".              
        
        if  avail param-global and param-global.modulo-07
        AND TRIM(SUBSTR(docum-est.char-1,1,20)) <> "" THEN
            ASSIGN RowObject.valor-a-pagar-me = RowObject.vl-a-pagar-mo.
        ELSE 
            if  docum-est.mo-codigo <> 0 then              
                assign RowObject.valor-a-pagar-me = RowObject.vl-a-pagar / docum-est.cotacao-dia.
            else                                                  
                assign RowObject.valor-a-pagar-me = RowObject.vl-a-pagar.   

        assign l-erro-dt-venc = no
               l-erro-cod-retencao = no.

        run verificaMultiplasCondPagto (OUTPUT l-mult-cond-pagto).
        IF NOT l-mult-cond-pagto THEN DO:
            /***** Determina Default Data Vencimento  *****/
            run calculateDtVenc ( output da-dt-venc-aux ).

		    DO  WHILE PROGRAM-NAME(i-cont-prog) <> ?:
                IF PROGRAM-NAME(i-cont-prog) = "pi-executar imp/im0100.w" THEN
                    ASSIGN l-im0100 = YES.
                ASSIGN i-cont-prog = i-cont-prog + 1.
            END.

            if  RowObject.dt-vencim = ? OR l-im0100 then
                assign RowObject.dt-vencim = da-dt-venc-aux.

            if  da-dt-venc-aux <> RowObject.dt-vencim AND
                ((l-imp AND RowObject.dt-vencim <> docum-est.dt-emissao) OR (NOT l-imp)) then do:
                assign l-erro-dt-venc = yes.
                {method/svc/errors/inserr.i
                                    &ErrorNumber="6252"
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING" }
            end.
        END.
        
         /***** Valida Parcela Anterior com Data de Vencimento Superior *****/
        for first bfDupli-apagar
           fields ()
            where bfDupli-apagar.cod-emitente = RowObject.cod-emitente
              and bfDupli-apagar.serie-docto  = RowObject.serie-docto
              and bfDupli-apagar.nro-docto    = RowObject.nro-docto
              and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
              and ( (     bfDupli-apagar.dt-vencim  = RowObject.dt-vencim
                      and bfDupli-apagar.parcela   <> RowObject.parcela ) 
                 or (     bfDupli-apagar.dt-vencim  > RowObject.dt-vencim 
                      and bfDupli-apagar.parcela    < RowObject.parcela ) ) 
            no-lock :
        end.
        if  avail bfDupli-apagar then do:
            {method/svc/errors/inserr.i
                            &ErrorNumber="26217"
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING" }
        end.             
        
        if  avail emitente 
        and emitente.ind-rendiment then do:

            FIND FIRST tt-cod-ir NO-LOCK
                 WHERE tt-cod-ir.c-cod = STRING(rowObject.cod-ret-irf,"9999") NO-ERROR.
            
            IF  NOT AVAIL tt-cod-ir THEN DO:

                ASSIGN l-erro-cod-retencao = YES.
                {method/svc/errors/inserr.i
                                   &ErrorNumber="843"
                                   &ErrorType="EMS"
                                   &ErrorSubType="WARNING":U
                                   &ErrorParameters="STRING(rowObject.cod-ret-irf)"}
            END.
        END.

        IF  (param-global.modulo-ap = YES) AND NOT CAN-FIND(funcao WHERE funcao.cd-funcao = "adm-apb-ems-5.00"
                                                                     AND funcao.ativo = YES
                                                                     AND funcao.log-1 = YES) THEN DO:
            ASSIGN i-periodo = RowObject.dt-vencim - TODAY.
            FIND param-ap WHERE
                 param-ap.ep-codigo = i-empresa NO-LOCK NO-ERROR. 
            IF  AVAIL param-ap THEN DO:
                IF  param-ap.prazo-implantacao THEN DO:
                    FOR EACH calen-coml
                       WHERE calen-coml.ep-codigo   = i-empresa
                         AND calen-coml.cod-estabel = docum-est.cod-estabel
                         AND calen-coml.data       >= TODAY
                         AND calen-coml.data       <= RowObject.dt-vencim
                         AND calen-coml.tipo-dia    > 1 NO-LOCK:
                        ASSIGN i-periodo = i-periodo - 1.
                    END.
                    ASSIGN i-nr-horas = i-periodo * 24.
                    IF  i-nr-horas < param-ap.nr-horas THEN DO:
                        FIND FIRST usuar-permissao-ap
                             WHERE usuar-permissao-ap.ep-codigo = i-empresa
                               AND usuar-permissao-ap.usuario = c-seg-usuario NO-LOCK NO-ERROR.
                        IF  AVAIL usuar-permissao-ap AND usuar-permissao-ap.liberar THEN DO:
                            {method/svc/errors/inserr.i
                                            &ErrorNumber="30452"
                                            &ErrorType="EMS"
                                            &ErrorSubType="WARNING" }
                        END.
                        ELSE DO:
                              {method/svc/errors/inserr.i
                                              &ErrorNumber="8232"
                                              &ErrorType="EMS"
                                              &ErrorSubType="ERROR" }
                        END.
                    END.
                END.
            END.
        END.
                
        /* EPC utilizada pela Grendene para validar a Data de Transaá∆o */
        {method/svc/custom/custom.i &Event = "ValidateRecord"} 
    end. /**** PTYPE <> "DELETE" ****/

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    /***** Gera Consist-Nota *****/
    /** Esta l¢gica est† sendo colocada somente ap¢s a verificaá∆o de erros, 
        para evitar a criaá∆o de consist-nota sem dupli-apagar **/

    run inbo/boin060.p persistent set h-boin060.
        
    /*** Cria/Elimina Mensagem de Erro na Data de Vencimento ***/        
    run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,                         /* Sequencia */
                                         not l-erro-dt-venc,        /* Elimina   */
                                         int(da-dt-venc-aux),       /* Calculado */
                                         int(RowObject.dt-vencim),  /* Informado */
                                         6252,                      /* Mensagem  */
                                         2 ).                      /* Erro/Adv  */
    
    
    /*** Cria/Elimina Mensagem de Erro no C¢digo de Retená∆o ***/
    run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                         RowObject.serie-docto,
                                         RowObject.nro-docto,
                                         RowObject.nat-operacao,
                                         0,                         /* Sequencia */
                                         not l-erro-cod-retencao,   /* Elimina   */
                                         0,                         /* Calculado */
                                         0,                         /* Informado */
                                         843,                      /* Mensagem  */
                                         2 ).                      /* Erro/Adv  */



    delete procedure h-boin060.
    assign h-boin060 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTotalDuplicata DBOProgram 
PROCEDURE validateTotalDuplicata :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var de-tot-dupli    like docum-est.tot-valor no-undo.
    
    if  avail docum-est then do:
        ASSIGN de-tot-dupli = 0.

        for each bfDupli-apagar 
          fields ( vl-a-pagar ) 
           where bfDupli-apagar.cod-emitente = RowObject.cod-emitente 
             and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
             and bfDupli-apagar.serie-docto  = RowObject.serie-docto
             and bfDupli-apagar.nro-docto    = RowObject.nro-docto no-lock:
             
             assign de-tot-dupli = de-tot-dupli + bfDupli-apagar.vl-a-pagar.
        end.
                                      
        run inbo/boin060.p persistent set h-boin060.
        
        /*** Cria/Elimina Mensagem de Erro na Data de Vencimento ***/        
        run updateConsistNota in h-boin060 ( docum-est.cod-emitente,
                                             docum-est.serie-docto,
                                             docum-est.nro-docto,
                                             docum-est.nat-operacao,
                                             0,                                             /* Sequencia */
                                             (de-tot-dupli = docum-est.tot-valor),          /* Elimina / Cria */
                                             docum-est.tot-valor,                           /* Calculado */
                                             de-tot-dupli,                                  /* Informado */
                                             15228,                                         /* Mensagem  */
                                             1 ).                                         /* Erro/Adv  */

        delete procedure h-boin060.
        assign h-boin060 = ?.
        return "OK":U.
        
    end.
    else 
        return "NOK":U.

END PROCEDURE.

procedure findNextParc:
/*------------------------------------------------------------------------------
Purpose: Retorna numero da proxima parcela a ser incluida.
Parameters: 
Notes:       
------------------------------------------------------------------------------*/
    def output param p-num-parc as int.

    for each bfDupli-apagar 
      fields ( )
       where bfDupli-apagar.cod-emitente = RowObject.cod-emitente
         and bfDupli-apagar.serie-docto  = RowObject.serie-docto
         and bfDupli-apagar.nro-docto    = RowObject.nro-docto
         and bfDupli-apagar.nat-operacao = RowObject.nat-operacao
       no-lock:
        assign p-num-parc = p-num-parc + 1.
    end.
    assign p-num-parc = p-num-parc + 1.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

