/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i BC0110E 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC0110E MBC}
&ENDIF

/*------------------------------------------------------------------------
    File        : bc0110e.p
    Purpose     : Adapater para API de entrada de documento do EMS

    Syntax      : run bc0110e.p (cod-layout, log-datasul, num-versao,
                                 tt-campos, tt-erro)

    Description : Transforma os dados recebidos em tt-campos para 
                  temp-table de entrada da API do MAGNUS I00. Executa a API 
                  e retorna os erros em tt-erro.
    Author(s)   : Denis Roberto Eloterio
    Created     : Janeiro/2001
    Notes       : Para ler os dados de tt-campos usa as informa‡äes
                  que estÆo em bc-tipo-layout e bc-tipo-layout-registro.
                  Este programa est  preparado para tratar o tipo de layout
                  2 - Entrada de Documentos 
----------------------------------------------------------------------*/

{bcp/bccfgpro.i}
&IF '{&DCMagnus}'= 'YES'
&THEN
/**********************  Variaveis do Data Collection****************/

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
DEF VAR v-valor-campo       AS CHARACTER NO-UNDO.
DEF VAR v-decimal           AS CHARACTER NO-UNDO.
DEF VAR v-quant-registro    AS INTEGER   NO-UNDO.
DEF VAR v-cont-registro     AS INTEGER   NO-UNDO.
DEF VAR v-cont              AS INTEGER   NO-UNDO.
DEF VAR v-logical           AS LOGICAL   NO-UNDO.
/* DEF VAR h-field-tabela      AS HANDLE    NO-UNDO. */
DEF VAR h-buffer            AS HANDLE NO-UNDO.
/* DEF VAR h-buffer-tabela     AS HANDLE    NO-UNDO.  */
DEF VAR h-field             AS HANDLE NO-UNDO.
DEF VAR h-query             AS HANDLE NO-UNDO.
DEF VAR v-campo             AS CHARACTER NO-UNDO.
DEF VAR h-bocl023           AS HANDLE    NO-UNDO.
DEF VAR h-bocl024           AS HANDLE    NO-UNDO.

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

RUN utp/ut-liter.p ("NÆo":U ,"*":U, "R":U).
ASSIGN c-nao = TRIM(RETURN-VALUE).

{cdp/cd0666.i}
{bcp/bcapi019.i}                /* tt-campos */
{bcp/bc1000.i &local=BC0110D}   /* procedure geraTTErro */
{bcp/bc1002.i}                  /* leitura de dados do tt-campos */
{bcp/bc1003.i}                  /* fun‡Æo formataCodLayout */

DEFINE TEMP-TABLE tt-bc-layout NO-UNDO
    field cod-layout as integer format ">>>9"
    field descricao as character format "X(50)"
    field num-versao as integer format ">>>9"
    field log-datasul as logical format "Sim/NÆo"
    field cod-tipo-layout as integer format ">>>9"
    field char-1 as character format "x(100)"
    field char-2 as character format "x(100)"
    field dec-1 as decimal format "->>>>>>>>>>>9.99999999"
    field dec-2 as decimal format "->>>>>>>>>>>9.99999999"
    field int-1 as integer format "->>>>>>>>>9"
    field int-2 as integer format "->>>>>>>>>9"
    field log-1 as logical format "Sim/NÆo"
    field log-2 as logical format "Sim/NÆo"
    field data-1 as date format "99/99/9999"
    field data-2 as date format "99/99/9999"
    field check-sum as character format "x(20)"
    field cod-aux as character format "X(32)"  extent 5
    field ind-leitura-campo as integer format "9"
    field separador-campos as character format "X(8)"
    FIELD RowNum AS INTEGER INIT 1
    FIELD r-Rowid AS ROWID.
             
DEFINE TEMP-TABLE tt-bc-layout-registro NO-UNDO 
    field cod-layout as integer format ">>>9"
    field log-datasul as logical format "Sim/NÆo"
    field num-versao as integer format ">>>9"
    field sequencia as integer format ">>>>9"
    field num-layout-registro as integer format ">>>,>>9"
    field cod-tipo-layout-registro as integer format ">>9"
    field char-1 as character format "x(100)"
    field char-2 as character format "x(100)"
    field dec-1 as decimal format "->>>>>>>>>>>9.99999999"
    field dec-2 as decimal format "->>>>>>>>>>>9.99999999"
    field int-1 as integer format "->>>>>>>>>9"
    field int-2 as integer format "->>>>>>>>>9"
    field log-1 as logical format "Sim/NÆo"
    field log-2 as logical format "Sim/NÆo"
    field data-1 as date format "99/99/9999"
    field data-2 as date format "99/99/9999"
    field check-sum as character format "x(20)"
    field cod-aux as character format "X(32)"  extent 5
    field ind-ocorrencia as integer format "9"
    FIELD RowNum AS INTEGER INIT 1
    FIELD r-Rowid AS ROWID.

DEF INPUT PARAM p-cod-layout    AS INTEGER NO-UNDO.
DEF INPUT PARAM p-log-datasul   AS LOGICAL NO-UNDO.
DEF INPUT PARAM p-num-versao    AS INTEGER NO-UNDO.
DEF INPUT PARAM TABLE           FOR tt-campos.
DEF INPUT-OUTPUT PARAM TABLE    FOR tt-erro.

/**********************  Variaveis do Recebimento ****************/
{bcp/bc0110e.i} /* temp-table tt-docum-est tt-item-doc-est tt-dupli-apagar */

DEF TEMP-TABLE tt1-docum-est    NO-UNDO LIKE TT-DOCUM-EST    .
DEF TEMP-TABLE tt1-item-doc-est NO-UNDO LIKE TT-ITEM-DOC-EST .
DEF TEMP-TABLE tt1-dupli-apagar NO-UNDO LIKE TT-DUPLI-APAGAR .
DEF TEMP-TABLE tt-erro-campo    NO-UNDO LIKE tt-erro.

/********************** INICIO DO PROGRAMA ***************************/

/* verifica se o layout recebido ‚ do tipo 2 */

RUN clbo/bocl023.p PERSISTENT SET h-bocl023.
RUN clbo/bocl024.p PERSISTENT SET h-bocl024.

RUN openquerystatic IN h-bocl023 ("main").
RUN GoToKey         IN h-bocl023 (p-cod-layout, p-log-datasul,  p-num-versao).
RUN getrecord       IN h-bocl023 (OUTPUT TABLE tt-bc-layout).

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

EMPTY TEMP-TABLE tt-docum-est.

EMPTY TEMP-TABLE tt-item-doc-est.

EMPTY TEMP-TABLE tt-dupli-apagar.
                         
DO:
    find first param-global no-lock no-error.
    find first param-estoq  no-lock no-error.

    /* DOCUM-EST */

    FIND FIRST tt-bc-layout-registro
        WHERE  tt-bc-layout-registro.cod-layout = tt-bc-layout.cod-layout
          AND  tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
          AND  tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
          AND  tt-bc-layout-registro.cod-tipo-layout-registro = 1 /* cabe‡alho do documento */
        NO-LOCK NO-ERROR.

    IF  AVAIL tt-bc-layout-registro THEN DO:

        EMPTY TEMP-TABLE tt1-docum-est.

        CREATE tt1-docum-est.

        FIND FIRST tt1-docum-est NO-ERROR.

        CREATE BUFFER h-buffer FOR TABLE "tt1-docum-est":U.

        CREATE QUERY h-query.

        h-query:SET-BUFFERS(h-buffer).
        h-query:query-prepare("for each tt1-docum-est":U).
        h-query:query-open().
        h-query:get-first().

        ASSIGN h-buffer        = h-query:get-buffer-handle(1)
               v-cont-registro = 1.

        RUN pi-busca-campo ("docum-est":U).

        h-query:QUERY-CLOSE().

        FIND FIRST tt1-docum-est NO-ERROR.
        CREATE tt-docum-est.

        BUFFER-COPY tt1-docum-est TO tt-docum-est.
          
        EMPTY TEMP-TABLE tt1-docum-est.

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

        ASSIGN
               tt-docum-est.dt-trans       = tt-docum-est.dt-emissao
               tt-docum-est.dt-venc-ipi    = tt-docum-est.dt-emissao
               tt-docum-est.dt-venc-icm    = tt-docum-est.dt-emissao
               tt-docum-est.usuario        = USERID("mgadm")
               tt-docum-est.cod-estabel    = (if  avail estabelec
                                              then estabelec.cod-estabel
                                              else param-estoq.estabel-pad)
               tt-docum-est.cod-emitente   = i-cod-emitente               
               tt-docum-est.rec-fisico     = no
               tt-docum-est.origem         = "I":U
               tt-docum-est.pais-origem    = "RE1001":U.


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

        EMPTY TEMP-TABLE tt1-item-doc-est.

        CREATE tt1-item-doc-est.

        FIND FIRST tt1-item-doc-est NO-ERROR.

        CREATE BUFFER h-buffer FOR TABLE "tt1-item-doc-est":U.

        CREATE QUERY h-query.
        h-query:SET-BUFFERS(h-buffer).
        h-query:query-prepare("for each tt1-item-doc-est":U).
        h-query:query-open().
        h-query:GET-FIRST().
        
        REPEAT v-cont-registro = 1 TO v-quant-registro:

            RUN pi-busca-campo ("item-doc-est":U).

            FIND FIRST tt1-item-doc-est NO-ERROR.

            CREATE tt-item-doc-est.

            BUFFER-COPY tt1-item-doc-est /* EXCEPT serie-docto nro-docto cod-emitente nat-operacao sequencia */
                        TO tt-item-doc-est
                        NO-ERROR.

            assign tt-item-doc-est.serie-docto    = tt-docum-est.serie-docto
                   tt-item-doc-est.nro-docto      = tt-docum-est.nro-docto
                   tt-item-doc-est.cod-emitente   = tt-docum-est.cod-emitente
                   tt-item-doc-est.nat-operacao   = tt-docum-est.nat-operacao
                   tt-item-doc-est.sequencia      = (IF  tt1-item-doc-est.sequencia = 0
                                                     THEN v-cont-registro * 10
                                                     ELSE tt1-item-doc-est.sequencia)
                   NO-ERROR.
        END.

        h-query:QUERY-CLOSE().

        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.

        EMPTY TEMP-TABLE tt1-item-doc-est.

    END.


    FIND FIRST tt-bc-layout-registro
    WHERE tt-bc-layout-registro.cod-layout  = tt-bc-layout.cod-layout
      AND tt-bc-layout-registro.log-datasul = tt-bc-layout.log-datasul
      AND tt-bc-layout-registro.num-versao  = tt-bc-layout.num-versao
      AND tt-bc-layout-registro.cod-tipo-layout-registro = 3 /* duplicata do documento */
      NO-LOCK NO-ERROR.

    IF  AVAIL tt-bc-layout-registro THEN DO:

        RUN obtemQuantRegistro (tt-bc-layout-registro.num-layout-registro, OUTPUT v-quant-registro).

        EMPTY TEMP-TABLE tt1-dupli-apagar.

        create tt1-dupli-apagar.

        FIND FIRST tt1-dupli-apagar NO-ERROR.

        CREATE BUFFER h-buffer FOR TABLE "tt1-dupli-apagar":U.

        CREATE QUERY h-query.

        h-query:SET-BUFFERS(h-buffer).
        h-query:query-prepare("for each tt1-dupli-apagar":U).
        h-query:query-open().
        h-query:get-first().

        REPEAT v-cont-registro = 1 TO v-quant-registro:

            RUN pi-busca-campo ("dupli-apagar":U).

            FIND FIRST tt1-dupli-apagar NO-ERROR.

            CREATE tt-dupli-apagar.

            BUFFER-COPY tt1-dupli-apagar /*EXCEPT serie-docto nro-docto cod-emitente nat-operacao parcela */
                        TO tt-dupli-apagar
                        NO-ERROR.

            assign tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                   tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                   tt-dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                   tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                   tt-dupli-apagar.dt-emissao   = tt-docum-est.dt-emissao
                   tt-dupli-apagar.parcela      = (IF  tt1-dupli-apagar.parcela = ""
                                                   THEN string(v-cont-registro)
                                                   ELSE tt1-dupli-apagar.parcela)

                   tt-dupli-apagar.nr-duplic    = (IF  tt1-dupli-apagar.nr-duplic = 0
                                                   THEN tt-docum-est.nro-docto
                                                   ELSE tt1-dupli-apagar.nr-duplic)
                   NO-ERROR.

        END.

        h-query:QUERY-CLOSE().

        DELETE OBJECT h-buffer NO-ERROR.
        DELETE OBJECT h-query  NO-ERROR.
        DELETE OBJECT h-field  NO-ERROR.

        EMPTY TEMP-TABLE tt1-dupli-apagar.

    END.
    
    /**** programa de criacao de documento para magnus i00 ****/
    
    DO TRANS:
    
       RUN bcp/bc0110e1.p (INPUT TABLE  tt-docum-est,
                           INPUT TABLE  tt-item-doc-est,
                           INPUT TABLE  tt-dupli-apagar,
                           OUTPUT TABLE tt-erro).
    END.

    
    EMPTY TEMP-TABLE TT-DOCUM-EST.
    EMPTY TEMP-TABLE TT-ITEM-DOC-EST.
    EMPTY TEMP-TABLE TT-DUPLI-APAGAR.

    FOR EACH tt-erro-campo:
        CREATE tt-erro.
        BUFFER-COPY tt-erro-campo TO tt-erro.
    END.
    
    DELETE OBJECT h-buffer NO-ERROR.
    DELETE OBJECT h-query  NO-ERROR.
    DELETE OBJECT h-field  NO-ERROR.                  
   
    FIND FIRST tt-erro NO-ERROR.
 
    IF AVAIL tt-erro THEN RETURN "NOK".
END.

PROCEDURE pi-busca-campo:

DEF INPUT PARAM c-tabela        AS CHAR.
DEF VAR         v-cont-extent   AS INT NO-UNDO. 
DEF VAR         v-cont-field    AS INT NO-UNDO.
DEF VAR         v-extent        AS INT NO-UNDO.
DEF VAR         l-extent        AS LOG NO-UNDO.

REPEAT v-cont-field = 1 TO h-buffer:NUM-FIELDS:

   h-field = h-buffer:BUFFER-FIELD(v-cont-field).

   DO v-cont-extent = 1  TO  (IF h-field:EXTENT = 0 THEN 1 ELSE h-field:EXTENT):

      ASSIGN v-extent = (IF h-field:EXTENT = 0 THEN 0 ELSE v-cont-extent)
             l-extent = (IF v-extent = 0 THEN NO ELSE YES)
             v-campo  = c-tabela + ".":U + trim(h-field:NAME)
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

PROCEDURE pi-procura-emitente:

    def input param p-cgc            like emitente.cgc           no-undo.
    def input param pi-nome-abrev    like emitente.nome-abrev    no-undo.
    def output param pi-cod-emitente like emitente.cod-emitente  no-undo.    
    
    IF  p-cgc <> "" 
    THEN
        RUN pi-cgc (p-cgc,OUTPUT p-cgc).

    for first emitente
       fields ( cod-emitente )
        where emitente.cgc = p-cgc no-lock:
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

PROCEDURE pi-cgc:

DEF INPUT PARAM c-cgc-aux AS CHAR.
DEF OUTPUT PARAM c-cgc    AS CHAR.

def var i-cont            as integer                                    no-undo.
def var i-cont-i          as integer                                    no-undo.
def var i-cont-obs        as integer                                    no-undo.
DEF VAR de-cgc            AS DEC                                        NO-UNDO.
def var c-cgc-novo        as character format "x(18)".
def var c-campo           as character format "x".

do:
    
    IF INDEX(c-cgc-aux,".") > 0
    OR INDEX(c-cgc-aux,"/") > 0
    OR INDEX(c-cgc-aux,"-") > 0
    THEN DO:

        ASSIGN c-cgc = c-cgc-aux.

        RETURN.
    END.
        
    assign c-cgc-novo = ""
           c-cgc      = " "
           i-cont     = 0
           de-cgc  = DEC(c-cgc-aux) NO-ERROR.

    do  i-cont = 1 to 14:
        assign c-campo = substring(string(c-cgc-aux,"99999999999999"),i-cont,1).
        if  lookup (c-campo,"0,1,2,3,4,5,6,7,8,9") <> 0 then
            assign c-cgc-novo = c-cgc-novo + c-campo.
        if  i-cont = 2 or
            i-cont = 5 then
            assign c-cgc-novo = c-cgc-novo + ".".
        if  i-cont = 8 then
            assign c-cgc-novo = c-cgc-novo + "/".
        if  i-cont = 12 then
            assign c-cgc-novo = c-cgc-novo + "-".

    end.

    assign c-cgc = c-cgc-novo.
end.

END.
&ENDIF
