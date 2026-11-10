/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0110D 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0110D MBC}
&ENDIF


&if '{&mgcld_version}' >= '2.04' &then
/*------------------------------------------------------------------------
    File        : bc0110d.p
    Purpose     : Adapater para API de entrada de documento do EMS

    Syntax      : run bc0110d.p (cod-layout, log-datasul, num-versao,
                                 tt-campos, tt-erro)

    Description : Transforma os dados recebidos em tt-campos para 
                  temp-table de entrada da API do EMS. Executa a API 
                  e retorna os erros em tt-erro.
    Author(s)   : Denis Roberto Eloterio
    Created     : Janeiro/2001
    Notes       : Para ler os dados de tt-campos usa as informaá‰es
                  que est∆o em bc-tipo-layout e bc-tipo-layout-registro.
                  Este programa est† preparado para tratar o tipo de layout
                  2 - Entrada de Documentos 
----------------------------------------------------------------------*/
/**************************Variavieis Recebimento *******************/

{utp/ut-glob.i}
{cdp/cdcfgdis.i}   /* Preprocessadores funá‰es distribuiá∆o             */
{rep/reapi190.i}
{cdp/cd4305.i1}    /* Definicao TT-DOCTO, TT-IT-DOCTO        */
{cdp/cd4300.i3}    /* vari†veis utilizadas pelo cd4300.i4 */
       

DEF TEMP-TABLE TT1-DOCUM-EST    NO-UNDO LIKE docum-est.
DEF TEMP-TABLE TT1-ITEM-DOC-EST NO-UNDO LIKE ITEM-DOC-EST.
DEF TEMP-TABLE TT1-DUPLI-APAGAR NO-UNDO LIKE DUPLI-APAGAR.
DEF TEMP-TABLE TT1-DUPLI-IMP    NO-UNDO LIKE DUPLI-IMP.

DEF TEMP-TABLE TT2-DOCUM-EST    NO-UNDO LIKE docum-est
FIELD calcula-imposto           AS INT.

DEF TEMP-TABLE TT2-ITEM-DOC-EST NO-UNDO LIKE ITEM-DOC-EST.
DEF TEMP-TABLE TT2-DUPLI-APAGAR NO-UNDO LIKE DUPLI-APAGAR.
DEF TEMP-TABLE TT2-DUPLI-IMP    NO-UNDO LIKE DUPLI-IMP
FIELD cod-imp AS INT.

DEF TEMP-TABLE tt-erro-campo    NO-UNDO LIKE tt-erro.

DEF VAR i-sequencia          AS INT                      NO-UNDO.
DEF var i-cod-emitente       like emitente.cod-emitente  no-undo.
def var i-cod-emitente-estab like emitente.cod-emitente  no-undo.
def var c-nome-abrev         like emitente.nome-abrev    no-undo.
def var c-cgc                like emitente.cgc           no-undo.
DEF VAR c-sim                AS CHAR                     NO-UNDO.
DEF VAR c-nao                AS CHAR                     NO-UNDO.
DEF VAR c-campo              AS CHAR                     NO-UNDO.
DEF VAR c-tipo-dado          AS CHAR                     NO-UNDO.
DEF VAR c-valor              AS CHAR                     NO-UNDO.
DEF VAR c-registro           AS CHAR                     NO-UNDO.
DEF VAR v-date               AS DATE                     NO-UNDO.
DEF VAR v-integer            AS INT                      NO-UNDO.
DEF VAR v-decimal-aux        AS DEC DECIMALS 10          NO-UNDO.
DEF VAR v-character          AS CHAR                     NO-UNDO.

RUN utp/ut-liter.p ("Campo":U ,"*":U, "R":U).
ASSIGN c-campo = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p ("Tipo Dado":U ,"*":U, "R":U).
ASSIGN c-tipo-dado = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p ("Valor":U ,"*":U, "R":U).
ASSIGN c-valor = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p ("Registro":U ,"*":U, "R":U).
ASSIGN c-registro = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p ("Sim":U ,"*":U, "R":U).
ASSIGN c-sim = TRIM(RETURN-VALUE).

RUN utp/ut-liter.p ("N∆o":U ,"*":U, "R":U).
ASSIGN c-nao = TRIM(RETURN-VALUE).

/**********************  Variaveis do Data Collection****************/
{bcp/bcapi019.i}                /* tt-campos */
{bcp/bc1000.i &local=BC0110D}   /* procedure geraTTErro */
{bcp/bc1002.i}                  /* leitura de dados do tt-campos */
{bcp/bc1003.i}                  /* funá∆o formataCodLayout */
{clbo/bocl023.i tt-bc-layout}
{clbo/bocl024.i tt-bc-layout-registro}

DEF INPUT PARAM p-cod-layout    AS INTEGER NO-UNDO.
DEF INPUT PARAM p-log-datasul   AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-num-versao    AS INTEGER NO-UNDO.
DEF INPUT PARAM TABLE           FOR tt-campos.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

DEF VAR v-valor-campo       AS CHARACTER NO-UNDO.
DEF VAR v-decimal           AS CHARACTER NO-UNDO.
DEF VAR v-quant-registro    AS INTEGER   NO-UNDO.
DEF VAR v-cont-registro     AS INTEGER   NO-UNDO.
DEF VAR v-cont              AS INTEGER.
DEF VAR v-logical           AS LOGICAL.

DEF VAR h-buffer            AS HANDLE.
DEF VAR h-field             AS HANDLE.

DEF VAR h-query             AS HANDLE.

DEF VAR v-campo             AS CHARACTER.
DEF VAR h-bocl023           AS HANDLE.
DEF VAR h-bocl024           AS HANDLE.

/* verifica se o layout recebido Ç do tipo 2 */

RUN clbo/bocl023.p PERSISTENT SET h-bocl023.
RUN clbo/bocl024.p PERSISTENT SET h-bocl024.

RUN openquerystatic IN h-bocl023 ("main").
RUN GoToKey IN h-bocl023 (p-cod-layout, p-log-datasul,  p-num-versao).
RUN getrecord IN h-bocl023 (OUTPUT TABLE tt-bc-layout).

FIND FIRST tt-bc-layout NO-LOCK NO-ERROR.

IF  NOT AVAIL tt-bc-layout THEN DO:
    {utp/ut-table.i mgcld bc-layout 1}
    RUN geraTTErro (2, TRIM(RETURN-VALUE), 
                       formataCodLayout(p-cod-layout, p-log-datasul, p-num-versao)).
    RETURN "NOK":U.
END.
 
IF  tt-bc-layout.cod-tipo-layout <> 2 /* documento de entrada */ THEN DO:
    RUN geraTTErro (25977, "2~~":U + formataCodLayout(p-cod-layout, p-log-datasul, p-num-versao), "":U).
    RETURN "NOK":U.
END.

RUN setConstraintLayout IN h-bocl024 (p-cod-layout, p-log-datasul,  p-num-versao).
RUN openquerystatic     IN h-bocl024 ("Layout").
RUN getbatchrecords     IN h-bocl024 (?, NO, 9999, OUTPUT v-cont, OUTPUT TABLE tt-bc-layout-registro).

RUN destroy IN h-bocl023.
RUN destroy IN h-bocl024.

/**************************** INICIO PROGRAMA *****************************/
                       
EMPTY TEMP-TABLE tt-versao-integr.

EMPTY TEMP-TABLE tt2-docum-est.

EMPTY TEMP-TABLE tt2-item-doc-est.

EMPTY TEMP-TABLE tt2-dupli-apagar.

EMPTY TEMP-TABLE tt2-dupli-imp.


DO:
    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.

    /* DOCUM-EST */
    
    FIND FIRST tt-bc-layout-registro
        WHERE tt-bc-layout-registro.cod-layout = tt-bc-layout.cod-layout
          AND tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
          AND tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
          AND tt-bc-layout-registro.cod-tipo-layout-registro = 1 /* cabeáalho do documento */
        NO-LOCK NO-ERROR.
    
   IF  AVAIL tt-bc-layout-registro THEN DO:            

        EMPTY TEMP-TABLE TT1-DOCUM-EST.

        CREATE TT1-DOCUM-EST.
        
        FIND FIRST TT1-DOCUM-EST NO-ERROR.
                      
        CREATE BUFFER h-buffer FOR TABLE "TT1-DOCUM-EST":U.

        CREATE QUERY h-query.          
        
        h-query:SET-BUFFERS(h-buffer).                     
        h-query:query-prepare("for each TT1-DOCUM-EST":U).
        h-query:query-open().
        h-query:get-first().
        
        ASSIGN h-buffer        = h-query:get-buffer-handle(1)
               v-cont-registro = 1.
              
        RUN pi-busca-campo ("docum-est":U).              
        
        h-query:QUERY-CLOSE().

        FIND FIRST TT1-DOCUM-EST NO-ERROR.
        
        CREATE tt2-docum-est.

        BUFFER-COPY TT1-DOCUM-EST TO tt2-docum-est.
        
        EMPTY TEMP-TABLE TT1-DOCUM-EST.

        /* Procura Emitente Emissor da Nota Fiscal */   

        RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, 1, "RECEPTOR-NOTA-CGC":U, OUTPUT c-cgc, OUTPUT v-decimal).
        
        find first estabelec
             where estabelec.cgc = c-cgc no-lock no-error.                                          

       /****************************************/                          
        
        /* Procura Emitente Emissor da Nota Fiscal */                                          
        
        RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, 1, "EMISSOR-NOTA-CGC":U, OUTPUT c-cgc, OUTPUT v-decimal).    
                
        run pi-procura-emitente ( c-cgc,
                                  c-nome-abrev,
                                  output i-cod-emitente).

        IF  RETURN-VALUE = "NOK" 
        THEN DO:
        
            RUN utp/ut-liter.p ("Emitente","*","R").
        
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input trim(RETURN-VALUE)).
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = 56
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
        
            RUN utp/ut-liter.p ("CGC: ","*","R").
            ASSIGN tt-erro.mensagem =  tt-erro.mensagem 
                                       + " (":U 
                                       + TRIM(RETURN-VALUE) 
                                       + c-cgc
                                       + ")":U.
            RETURN "NOK".
        END.


        /****************************************/
        
        RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, 1, "EFETUA-CALCULO-IMPOSTO":U, OUTPUT c-campo, OUTPUT v-decimal).
        
        ASSIGN tt2-docum-est.calcula-imposto = INT(c-campo) NO-ERROR.

        /****************************************/                          
        
        ASSIGN                
               tt2-docum-est.dt-trans       = tt2-docum-est.dt-emissao
               tt2-docum-est.dt-venc-ipi    = tt2-docum-est.dt-emissao
               tt2-docum-est.dt-venc-icm    = tt2-docum-est.dt-emissao
               tt2-docum-est.usuario        = c-seg-usuario
               tt2-docum-est.cod-estabel    = (if  avail estabelec 
                                               then estabelec.cod-estabel
                                               else param-estoq.estabel-pad)
               tt2-docum-est.cod-emitente   = i-cod-emitente
               tt2-docum-est.rec-fisico     = no
               tt2-docum-est.origem         = "I":U
               tt2-docum-est.pais-origem    = "RE1001":U.                                          

        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.    
                                               
    END.
    
    /**** ITENS DA NOTA FISCAL ****/ 

    FIND FIRST tt-bc-layout-registro
    WHERE tt-bc-layout-registro.cod-layout  = tt-bc-layout.cod-layout
      AND tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
      AND tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
      AND tt-bc-layout-registro.cod-tipo-layout-registro = 2 /* itens do documento */
    NO-LOCK NO-ERROR.

    ASSIGN i-sequencia = 0.

    IF  AVAIL tt-bc-layout-registro THEN DO:
        
        RUN obtemQuantRegistro (tt-bc-layout-registro.num-layout-registro, OUTPUT v-quant-registro).
                                 
        EMPTY TEMP-TABLE TT1-ITEM-DOC-EST.

        CREATE TT1-ITEM-DOC-EST.
        
        FIND FIRST TT1-ITEM-DOC-EST NO-ERROR.
        
        CREATE BUFFER h-buffer FOR TABLE "TT1-ITEM-DOC-EST":U.
        
        CREATE QUERY h-query.          
        h-query:SET-BUFFERS(h-buffer).                   
        h-query:query-prepare("for each TT1-ITEM-DOC-EST":U).
        h-query:query-open().
        h-query:GET-FIRST().                                 
        
        REPEAT v-cont-registro = 1 TO v-quant-registro:
        
            RUN pi-busca-campo ("item-doc-est":U).            

            FIND FIRST TT1-ITEM-DOC-EST NO-ERROR.
            
            CREATE tt2-item-doc-est.            
            
            BUFFER-COPY TT1-ITEM-DOC-EST TO tt2-item-doc-est
                        NO-ERROR.
            assign tt2-item-doc-est.serie-docto    = tt2-docum-est.serie-docto
                   tt2-item-doc-est.nro-docto      = tt2-docum-est.nro-docto
                   tt2-item-doc-est.cod-emitente   = tt2-docum-est.cod-emitente
                   tt2-item-doc-est.nat-operacao   = tt2-docum-est.nat-operacao
                   tt2-item-doc-est.sequencia      = int (v-valor-campo)
                   tt2-item-doc-est.sequencia      = (IF  tt2-item-doc-est.sequencia = 0 
                                                      THEN v-cont-registro * 10
                                                      ELSE tt2-item-doc-est.sequencia)
                   NO-ERROR.                      

            FIND ITEM WHERE ITEM.it-codigo = tt2-item-doc-est.it-codigo 
                 NO-LOCK NO-ERROR.

            IF  AVAIL ITEM 
            AND AVAIL ESTABELEC THEN DO:

                ASSIGN tt2-item-doc-est.cod-depos = (IF tt2-item-doc-est.cod-depos <> ""
                                                     THEN 
                                                         tt2-item-doc-est.cod-depos
                                                     ELSE 
                                                         IF  item.contr-qualid 
                                                         THEN 
                                                             estabelec.deposito-cq
                                                         ELSE  
                                                             item.deposito-pad)
                      tt2-item-doc-est.cod-localiz  = (IF tt2-item-doc-est.cod-localiz <> "" 
                                                       THEN 
                                                           tt2-item-doc-est.cod-depos
                                                       ELSE 
                                                           item.cod-localiz).
            END.
            

        END.

        h-query:QUERY-CLOSE().

        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.     

        EMPTY TEMP-TABLE TT1-ITEM-DOC-EST.
    END.

    FIND FIRST tt-bc-layout-registro
    WHERE tt-bc-layout-registro.cod-layout  = tt-bc-layout.cod-layout
      AND tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
      AND tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
      AND tt-bc-layout-registro.cod-tipo-layout-registro = 3 /* duplicata do documento */
    NO-LOCK NO-ERROR.

    IF  AVAIL tt-bc-layout-registro THEN DO:
        
        RUN obtemQuantRegistro (tt-bc-layout-registro.num-layout-registro, OUTPUT v-quant-registro).
        
        EMPTY TEMP-TABLE TT1-DUPLI-APAGAR. 

        create TT1-DUPLI-APAGAR.
        
        FIND FIRST TT1-DUPLI-APAGAR NO-ERROR.
        
        CREATE BUFFER h-buffer        FOR TABLE "TT1-DUPLI-APAGAR":U.
        
        CREATE QUERY h-query.          
        h-query:SET-BUFFERS(h-buffer).                     
        h-query:query-prepare("for each TT1-DUPLI-APAGAR":U).
        h-query:query-open().
        h-query:get-first().
        
        REPEAT v-cont-registro = 1 TO v-quant-registro:
           
            RUN pi-busca-campo ("dupli-apagar":U).                

            FIND FIRST TT1-DUPLI-APAGAR NO-ERROR.

            CREATE tt2-dupli-apagar.

            BUFFER-COPY TT1-DUPLI-APAGAR TO tt2-dupli-apagar
                        NO-ERROR.
            
            assign tt2-dupli-apagar.serie-docto  = tt2-docum-est.serie-docto
                   tt2-dupli-apagar.nro-docto    = tt2-docum-est.nro-docto
                   tt2-dupli-apagar.cod-emitente = tt2-docum-est.cod-emitente
                   tt2-dupli-apagar.nat-operacao = tt2-docum-est.nat-operacao
                   tt2-dupli-apagar.parcela      = (IF  trim(tt2-dupli-apagar.parcela) = "" 
                                                   THEN STRING(v-cont-registro)
                                                   ELSE tt2-dupli-apagar.parcela)
                   
                   tt2-dupli-apagar.nr-duplic    = (IF  trim(tt2-dupli-apagar.nr-duplic) = "" 
                                                   THEN STRING(tt2-docum-est.nro-docto)
                                                   ELSE tt2-dupli-apagar.nr-duplic)

                   NO-ERROR.          
            
        END.

        h-query:QUERY-CLOSE().
        
        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.     
        
        EMPTY TEMP-TABLE TT1-DUPLI-APAGAR.

    END.    

    FIND FIRST tt-bc-layout-registro
    WHERE tt-bc-layout-registro.cod-layout  = tt-bc-layout.cod-layout
      AND tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
      AND tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
      AND tt-bc-layout-registro.cod-tipo-layout-registro = 4 /* imposto das duplicatas do documento */
    NO-LOCK NO-ERROR.
    
    IF  AVAIL tt-bc-layout-registro THEN DO:    
        
        RUN obtemQuantRegistro (tt-bc-layout-registro.num-layout-registro, OUTPUT v-quant-registro).
    
        EMPTY TEMP-TABLE TT1-DUPLI-IMP.

        CREATE TT1-DUPLI-IMP.
        
        FIND FIRST TT1-DUPLI-IMP NO-ERROR.
        
        CREATE BUFFER h-buffer FOR TABLE "TT1-DUPLI-IMP":U.

        CREATE QUERY h-query.          
        h-query:SET-BUFFERS(h-buffer).                     
        h-query:query-prepare("for each TT1-DUPLI-IMP":U).
        h-query:query-open().
        h-query:get-first().

        REPEAT v-cont-registro = 1 TO v-quant-registro:      

            RUN pi-busca-campo ("dupli-imp":U).                                   

            FIND FIRST TT1-DUPLI-IMP NO-ERROR.    

            CREATE tt2-dupli-imp.
    
            BUFFER-COPY TT1-DUPLI-IMP TO tt2-dupli-imp
                        NO-ERROR.
    
            RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, V-CONT-REGISTRO, "CODIGO-IMPOSTO":U, OUTPUT c-campo, OUTPUT v-decimal).
                                       
            ASSIGN tt2-dupli-imp.cod-imp = INT(c-campo) NO-ERROR.
                                         
            assign tt2-dupli-imp.serie-docto  = tt2-docum-est.serie-docto
                   tt2-dupli-imp.nro-docto    = tt2-docum-est.nro-docto
                   tt2-dupli-imp.cod-emitente = tt2-docum-est.cod-emitente
                   tt2-dupli-imp.nat-operacao = tt2-docum-est.nat-operacao
                   
                   tt2-dupli-imp.parcela      = (IF  trim(tt2-dupli-imp.parcela) = "" 
                                                 THEN string(v-cont-registro)
                                                 ELSE tt2-dupli-imp.parcela)
                   NO-ERROR.          
        END.

        h-query:QUERY-CLOSE().

        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.     

        EMPTY TEMP-TABLE TT1-DUPLI-IMP.
        
    END.    
    
    /* ATUALIZANDO AS TEMP-TABLE DE NEGOCIO */

    RUN pi-atualiza-tabelas.

    /****************************************/
    
    DO TRANS:
    
        create tt-versao-integr.        
        assign tt-versao-integr.registro              = 0
               tt-versao-integr.cod-versao-integracao = 004.
        &IF '{&mgadm_version}' >= '2.04' &THEN
            run rep/reapi190.p (INPUT  TABLE tt-versao-integr,
                                INPUT  TABLE tt-docum-est,
                                INPUT  TABLE tt-item-doc-est,
                                INPUT  TABLE tt-dupli-apagar, 
                                INPUT  TABLE tt-dupli-imp,
                                INPUT  TABLE tt-unid-neg-nota,
                                OUTPUT TABLE tt-erro).
        &else
            run rep/reapi190.p (INPUT  TABLE tt-versao-integr,
                                INPUT  TABLE tt-docum-est,
                                INPUT  TABLE tt-item-doc-est,
                                INPUT  TABLE tt-dupli-apagar, 
                                INPUT  TABLE tt-dupli-imp,
                                OUTPUT TABLE tt-erro).
        
        &endif

    END.

    FOR EACH tt-erro-campo:
        CREATE tt-erro.
        BUFFER-COPY tt-erro-campo TO tt-erro.
    END.
    
    FIND FIRST tt-erro NO-ERROR.
     IF AVAIL tt-erro THEN RETURN "NOK".
    
END.
 
PROCEDURE pi-procura-emitente:

    def input param pi-cgc           like emitente.cgc           no-undo.
    def input param pi-nome-abrev    like emitente.nome-abrev    no-undo.
    def output param pi-cod-emitente like emitente.cod-emitente  no-undo.    
    
    
    for first emitente
       fields ( cod-emitente )
        where emitente.cgc = pi-cgc no-lock:
    end.
    
    if  not avail emitente then 
        for first emitente
           fields ( cod-emitente )
            where emitente.nome-abrev = pi-nome-abrev no-lock:
        end.                
            
    if  avail emitente then 
        assign pi-cod-emitente = emitente.cod-emitente.
    else 
        return "NOK":U.
        
    return "OK":U.
        
END PROCEDURE.                             

PROCEDURE pi-busca-campo:

DEF INPUT PARAM c-tabela        AS CHAR.
DEF VAR         v-cont-extent   AS INT NO-UNDO.
DEF VAR         v-cont-field    AS INT NO-UNDO.
DEF VAR         v-extent        AS INT NO-UNDO.

DEF VAR l-extent                AS LOG NO-UNDO.

REPEAT v-cont-field = 1 TO h-buffer:NUM-FIELDS:

   h-field = h-buffer:BUFFER-FIELD(v-cont-field).

   DO v-cont-extent = 1  TO  (IF h-field:EXTENT = 0 THEN 1 ELSE h-field:EXTENT):

      ASSIGN v-extent = IF h-field:EXTENT = 0 THEN 0 ELSE v-cont-extent

             l-extent = (IF v-extent = 0 THEN NO ELSE YES)

             v-campo = c-tabela + ".":U + trim(h-field:NAME)
                       + (IF  v-extent = 0
                          THEN "":U
                          ELSE "[":U + TRIM(STRING(v-extent)) + "]":U
                         ).

      IF  h-field:DATA-TYPE = "INTEGER":U THEN DO:

          RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, v-cont-registro,v-campo, OUTPUT v-valor-campo, OUTPUT v-decimal).

          ASSIGN ERROR-STATUS:ERROR = NO.

          ASSIGN v-integer = INT(v-valor-campo) NO-ERROR.

          IF ERROR-STATUS:ERROR
          THEN DO:
              RUN pi-erro-campo (" ", v-campo, "INTEGER":U, v-valor-campo, v-cont-registro).
              ASSIGN v-integer = 0.
          END.

          IF  l-extent = NO THEN
              ASSIGN  h-field:BUFFER-VALUE() = v-integer.
          ELSE
              ASSIGN  h-field:BUFFER-VALUE(v-extent) = v-integer.

      END.

      IF  h-field:DATA-TYPE = "DECIMAL":U THEN DO:

          RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, v-cont-registro, v-campo, OUTPUT v-valor-campo, OUTPUT v-decimal).

          ASSIGN ERROR-STATUS:ERROR = NO.

          ASSIGN v-decimal-aux = DEC(v-valor-campo) NO-ERROR.

          IF ERROR-STATUS:ERROR
          THEN DO:
              RUN pi-erro-campo (" ", v-campo, "DECIMAL":U, v-valor-campo, v-cont-registro) .
              ASSIGN v-decimal-aux = 0.
          END.

          IF  l-extent = NO THEN
              ASSIGN  h-field:BUFFER-VALUE() = v-decimal-aux.
          ELSE
              ASSIGN  h-field:BUFFER-VALUE(v-extent) = v-decimal-aux.

      END.

      IF  h-field:DATA-TYPE = "LOGICAL":U THEN DO:

          RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, v-cont-registro, v-campo, OUTPUT v-valor-campo, OUTPUT v-decimal).
          
          ASSIGN ERROR-STATUS:ERROR = NO.

          ASSIGN v-logical = IF v-valor-campo        = "yes" 
                             OR v-valor-campo        = c-sim 
                             OR INDEX(v-valor-campo,"1") > 0
                             THEN YES 
                             ELSE
                             IF v-valor-campo = "no" 
                             OR v-valor-campo = c-nao
                             OR v-valor-campo = "nao" 
                             OR INDEX(v-valor-campo,"0") > 0
                             THEN NO 
                             ELSE    
                             IF v-valor-campo <> "" 
                             THEN YES 
                             ELSE NO 
                             NO-ERROR.

          IF ERROR-STATUS:ERROR
          THEN DO:
              RUN pi-erro-campo (" ", v-campo, "LOGICAL":U, v-valor-campo, v-cont-registro).
              ASSIGN v-logical = NO.
          END.

          IF  l-extent = NO THEN
              ASSIGN h-field:BUFFER-VALUE() = v-logical.
          ELSE
              ASSIGN h-field:BUFFER-VALUE(v-extent) = v-logical.

      END.

      IF  h-field:DATA-TYPE = "CHARACTER":U THEN DO:

          RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, v-cont-registro, v-campo, OUTPUT v-valor-campo, OUTPUT v-decimal).

          ASSIGN ERROR-STATUS:ERROR = NO.

          ASSIGN v-character = v-valor-campo NO-ERROR.

          IF ERROR-STATUS:ERROR
          THEN DO:
             RUN pi-erro-campo (" ", v-campo, "CHARACTER":U, v-valor-campo, v-cont-registro).
             ASSIGN v-character = "".
          END.

          IF  l-extent = NO THEN
              ASSIGN h-field:BUFFER-VALUE() = v-character.
          ELSE
              ASSIGN h-field:BUFFER-VALUE(v-extent) = v-character.

      END.

      IF  h-field:DATA-TYPE = "DATE":U THEN DO:

          RUN obtemValorCampo (tt-bc-layout-registro.num-layout-registro, v-cont-registro, v-campo, OUTPUT v-valor-campo, OUTPUT v-decimal).

          ASSIGN ERROR-STATUS:ERROR = NO.

          ASSIGN v-date = date(v-valor-campo) NO-ERROR.

          IF  ERROR-STATUS:ERROR
          THEN DO:
              RUN pi-erro-campo (" ", v-campo, "DATE":U, v-valor-campo, v-cont-registro).
              ASSIGN v-date = ?.
          END.

          IF  l-extent = NO THEN
              ASSIGN h-field:BUFFER-VALUE() = v-date .
          ELSE
              ASSIGN h-field:BUFFER-VALUE(v-extent) =  v-date.

      END.
   END.
END.

END PROCEDURE.

PROCEDURE pi-erro-campo:
DEF INPUT PARAM p-msg AS CHAR NO-UNDO.
DEF INPUT PARAM p-campo AS CHAR NO-UNDO.
DEF INPUT PARAM p-tipo-dado AS CHAR NO-UNDO.
DEF INPUT PARAM p-valor    AS CHAR NO-UNDO.
DEF INPUT PARAM p-registro AS INT NO-UNDO.

run utp/ut-msgs.p (input "msg",
                   input 15967,
                   input "").

IF  p-valor = ?
THEN
    ASSIGN p-valor = "?".

CREATE tt-erro-campo.
ASSIGN tt-erro-campo.cd-erro  = 15967
       tt-erro-campo.mensagem =  TRIM(RETURN-VALUE)
                         + "( "
                         + c-campo
                         + ": "
                         + caps(p-campo)
                         + "  "
                         + c-tipo-dado
                         + ": "
                         + caps(p-tipo-dado)
                         + "  "
                         + c-valor
                         + ": "
                         + p-valor
                         + "  "
                         + c-registro
                         + ": "
                         + STRING(p-registro)
                         + " )".

END PROCEDURE.

PROCEDURE pi-atualiza-tabelas:

DEF VAR v-cont AS INT NO-UNDO.

FOR EACH tt2-docum-est:

    CREATE tt-docum-est.
    ASSIGN     
            tt-docum-est.serie-docto           = tt2-docum-est.serie-docto 
            tt-docum-est.nro-docto             = tt2-docum-est.nro-docto 
            tt-docum-est.cod-emitente          = tt2-docum-est.cod-emitente 
            tt-docum-est.nat-operacao          = tt2-docum-est.nat-operacao 
            tt-docum-est.cod-observa           = tt2-docum-est.cod-observa 
            tt-docum-est.cod-estabel           = tt2-docum-est.cod-estabel 
            tt-docum-est.estab-fisc            = tt2-docum-est.estab-fisc
            tt-docum-est.ct-transit            = tt2-docum-est.ct-transit 
            tt-docum-est.sc-transit            = tt2-docum-est.sc-transit 
            tt-docum-est.dt-emissao            = tt2-docum-est.dt-emissao 
            tt-docum-est.dt-trans              = tt2-docum-est.dt-trans 
            tt-docum-est.usuario               = tt2-docum-est.usuario 
            tt-docum-est.uf                    = tt2-docum-est.uf 
            tt-docum-est.via-transp            = tt2-docum-est.via-transp
            tt-docum-est.mod-frete             = tt2-docum-est.mod-frete 
            tt-docum-est.nff                   = tt2-docum-est.nff 
            tt-docum-est.tot-peso              = tt2-docum-est.tot-peso 
            tt-docum-est.tot-desconto          = tt2-docum-est.tot-desconto 
            tt-docum-est.valor-frete           = tt2-docum-est.valor-frete 
            tt-docum-est.valor-seguro          = tt2-docum-est.valor-seguro 
            tt-docum-est.valor-embal           = tt2-docum-est.valor-embal 
            tt-docum-est.valor-outras          = tt2-docum-est.valor-outras 
            tt-docum-est.valor-mercad          = tt2-docum-est.valor-mercad 
            tt-docum-est.dt-venc-ipi           = tt2-docum-est.dt-venc-ipi 
            tt-docum-est.dt-venc-icm           = tt2-docum-est.dt-venc-icm 
            tt-docum-est.tot-valor             = tt2-docum-est.tot-valor
            tt-docum-est.efetua-calculo        = tt2-docum-est.calcula-imposto
            tt-docum-est.observacao            = tt2-docum-est.observacao
            tt-docum-est.cotacao-dia           = tt2-docum-est.cotacao-dia  
            &IF '{&mgadm_version}' >= '2.04' &THEN
            tt-docum-est.embarque              = tt2-docum-est.embarque
            &endif
            tt-docum-est.sequencia             = 1
            tt-docum-est.esp-docto             = tt2-docum-est.esp-docto   
            tt-docum-est.rec-fisico            = tt2-docum-est.rec-fisico   
            tt-docum-est.origem                = tt2-docum-est.origem       
            tt-docum-est.pais-origem           = tt2-docum-est.pais-origem  
            tt-docum-est.ct-transit            = tt2-docum-est.ct-transit 
            tt-docum-est.sc-transit            = tt2-docum-est.sc-transit. 

END.

EMPTY TEMP-TABLE tt2-docum-est.

FOR EACH tt2-item-doc-est:

    CREATE tt-item-doc-est.
    ASSIGN  v-cont                                = v-cont + 1
            tt-item-doc-est.registro              = v-cont
            tt-item-doc-est.it-codigo             = tt2-item-doc-est.it-codigo 
            tt-item-doc-est.cod-refer             = tt2-item-doc-est.cod-refer 
            tt-item-doc-est.numero-ordem          = tt2-item-doc-est.numero-ordem 
            tt-item-doc-est.parcela               = tt2-item-doc-est.parcela
            tt-item-doc-est.encerra-pa            = tt2-item-doc-est.encerra-pa 
            tt-item-doc-est.nr-ord-prod           = tt2-item-doc-est.nr-ord-prod 
            tt-item-doc-est.cod-roteiro           = tt2-item-doc-est.cod-roteiro 
            tt-item-doc-est.op-codigo             = tt2-item-doc-est.op-codigo 
            tt-item-doc-est.item-pai              = tt2-item-doc-est.item-pai 
            tt-item-doc-est.ct-codigo             = tt2-item-doc-est.ct-codigo
            tt-item-doc-est.sc-codigo             = tt2-item-doc-est.sc-codigo
            tt-item-doc-est.baixa-ce              = tt2-item-doc-est.baixa-ce 
            tt-item-doc-est.etiquetas             = tt2-item-doc-est.etiquetas 
            tt-item-doc-est.qt-do-forn            = tt2-item-doc-est.qt-do-forn 
            tt-item-doc-est.quantidade            = tt2-item-doc-est.quantidade
            tt-item-doc-est.preco-total           = tt2-item-doc-est.preco-total[1]
            tt-item-doc-est.desconto              = tt2-item-doc-est.desconto[1]
            tt-item-doc-est.vl-frete-cons         = tt2-item-doc-est.pr-total-cmi
            tt-item-doc-est.despesas              = tt2-item-doc-est.despesas[1]
            tt-item-doc-est.peso-liquido          = tt2-item-doc-est.peso-liquido 
            tt-item-doc-est.cod-depos             = tt2-item-doc-est.cod-depos
            tt-item-doc-est.cod-localiz           = tt2-item-doc-est.cod-localiz
            tt-item-doc-est.lote                  = tt2-item-doc-est.lote
            tt-item-doc-est.dt-vali-lote          = tt2-item-doc-est.dt-vali-lote
            tt-item-doc-est.class-fiscal          = tt2-item-doc-est.class-fiscal 
            tt-item-doc-est.aliquota-ipi          = tt2-item-doc-est.aliquota-ipi 
            tt-item-doc-est.cd-trib-ipi           = tt2-item-doc-est.cd-trib-ipi 
            tt-item-doc-est.base-ipi              = tt2-item-doc-est.base-ipi[1]
            tt-item-doc-est.valor-ipi             = tt2-item-doc-est.valor-ipi[1]
            tt-item-doc-est.aliquota-iss          = tt2-item-doc-est.aliquota-iss 
            tt-item-doc-est.cd-trib-iss           = tt2-item-doc-est.cd-trib-iss 
            tt-item-doc-est.base-iss              = tt2-item-doc-est.base-iss[1]
            tt-item-doc-est.valor-iss             = tt2-item-doc-est.valor-iss[1]
            tt-item-doc-est.aliquota-icm          = tt2-item-doc-est.aliquota-icm 
            tt-item-doc-est.cd-trib-icm           = tt2-item-doc-est.cd-trib-icm 
            tt-item-doc-est.base-icm              = tt2-item-doc-est.base-icm[1]
            tt-item-doc-est.valor-icm             = tt2-item-doc-est.valor-icm[1]
            tt-item-doc-est.base-subs             = tt2-item-doc-est.base-subs[1]
            tt-item-doc-est.valor-subs            = tt2-item-doc-est.vl-subs[1]
            tt-item-doc-est.icm-complem           = tt2-item-doc-est.icm-complem[1]
            tt-item-doc-est.ind-icm-ret           = tt2-item-doc-est.baixa-ce
            tt-item-doc-est.narrativa             = tt2-item-doc-est.narrativa
            tt-item-doc-est.serie-comp            = tt2-item-doc-est.serie-comp
            tt-item-doc-est.nro-comp              = tt2-item-doc-est.nro-comp
            tt-item-doc-est.nat-comp              = tt2-item-doc-est.nat-comp
            tt-item-doc-est.seq-comp              = tt2-item-doc-est.seq-comp
            tt-item-doc-est.data-comp             = tt2-item-doc-est.data-comp
            tt-item-doc-est.icm-outras            = tt2-item-doc-est.icm-outras[1]
            tt-item-doc-est.ipi-outras            = tt2-item-doc-est.ipi-outras[1]
            tt-item-doc-est.iss-outras            = tt2-item-doc-est.iss-outras[1]    
            tt-item-doc-est.icm-ntrib             = tt2-item-doc-est.icm-ntrib[1]
            tt-item-doc-est.ipi-ntrib             = tt2-item-doc-est.ipi-ntrib[1]
            tt-item-doc-est.iss-ntrib             = tt2-item-doc-est.iss-ntrib[1]
            tt-item-doc-est.serie-docto           = tt2-item-doc-est.serie-docto       
            tt-item-doc-est.nro-docto             = tt2-item-doc-est.nro-docto         
            tt-item-doc-est.cod-emitente          = tt2-item-doc-est.cod-emitente      
            tt-item-doc-est.nat-operacao          = tt2-item-doc-est.nat-operacao      
            tt-item-doc-est.sequencia             = tt2-item-doc-est.sequencia
            NO-ERROR.

END.

EMPTY TEMP-TABLE tt2-item-doc-est.

ASSIGN v-cont = 0.

FOR EACH tt2-dupli-apagar:

    CREATE tt-dupli-apagar.
    ASSIGN 
            v-cont                                = v-cont + 1
            tt-dupli-apagar.registro              = v-cont 
            tt-dupli-apagar.parcela               = tt2-dupli-apagar.parcela
            tt-dupli-apagar.nr-duplic             = tt2-dupli-apagar.nr-duplic 
            tt-dupli-apagar.cod-esp               = tt2-dupli-apagar.cod-esp
            tt-dupli-apagar.tp-despesa            = tt2-dupli-apagar.tp-despesa 
            tt-dupli-apagar.dt-vencim             = tt2-dupli-apagar.dt-vencim 
            tt-dupli-apagar.vl-a-pagar            = tt2-dupli-apagar.vl-a-pagar
            tt-dupli-apagar.vl-desconto           = tt2-dupli-apagar.vl-desconto 
            tt-dupli-apagar.dt-venc-desc          = tt2-dupli-apagar.dt-venc-desc 
            tt-dupli-apagar.cod-ret-irf           = tt2-dupli-apagar.cod-ret-irf
            &IF '{&mgadm_version}' >= '2.04' &THEN
            tt-dupli-apagar.mo-codigo             = tt2-dupli-apagar.mo-codigo         
            &ENDIF
            tt-dupli-apagar.vl-a-pagar-mo         = tt2-dupli-apagar.vl-a-pagar        
            tt-dupli-apagar.serie-docto           = tt2-dupli-apagar.serie-docto       
            tt-dupli-apagar.nro-docto             = tt2-dupli-apagar.nro-docto         
            tt-dupli-apagar.cod-emitente          = tt2-dupli-apagar.cod-emitente      
            tt-dupli-apagar.nat-operacao          = tt2-dupli-apagar.nat-operacao
            NO-ERROR.      
END.

EMPTY TEMP-TABLE tt2-dupli-apagar.

ASSIGN v-cont = 0.

FOR EACH tt2-dupli-imp:

    CREATE tt-dupli-imp.
    ASSIGN 
        v-cont                             = v-cont + 1 
        tt-dupli-imp.registro              = v-cont 
        tt-dupli-imp.cod-imp               = tt2-dupli-imp.cod-imp    
        tt-dupli-imp.cod-esp               = tt2-dupli-imp.cod-esp    
        tt-dupli-imp.dt-venc-imp           = tt2-dupli-imp.dt-venc-imp     
        tt-dupli-imp.rend-trib             = tt2-dupli-imp.rend-trib     
        tt-dupli-imp.aliquota              = tt2-dupli-imp.aliquota 
        tt-dupli-imp.vl-imposto            = tt2-dupli-imp.vl-imposto 
        tt-dupli-imp.tp-codigo             = tt2-dupli-imp.tp-codigo
        tt-dupli-imp.cod-retencao          = tt2-dupli-imp.cod-retencao
        tt-dupli-imp.serie-docto           = tt2-dupli-imp.serie-docto 
        tt-dupli-imp.nro-docto             = tt2-dupli-imp.nro-docto   
        tt-dupli-imp.cod-emitente          = tt2-dupli-imp.cod-emitente
        tt-dupli-imp.nat-operacao          = tt2-dupli-imp.nat-operacao
        tt-dupli-imp.parcela               = tt2-dupli-imp.parcela
        NO-ERROR.
    
END.

EMPTY TEMP-TABLE tt2-dupli-imp.

END PROCEDURE.
&endif
