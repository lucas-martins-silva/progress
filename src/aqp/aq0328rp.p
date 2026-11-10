/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0328RP 2.00.00.011 } /*** "010011" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0328RP MAQ}
&ENDIF

{include/i_fnctrad.i}
/*****************************************************************************
* Programa: AQ0328RP.P                                                       *
* Data....: 03.10.2013                                                       *
* Autor...: Cristiano                                                        *
* Objetivo: Importaá∆o de Preáo Final                                        *
*****************************************************************************/

{include/i-rpvar.i}
{method/dbotterr.i}
{cdp/cdcfgmat.i}

/* Definicao Temp-Table's tt-param */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)":U
    FIELD modelo           AS CHAR FORMAT "x(35)":U
    FIELD arq-entrada      AS CHAR FORMAT "x(200)":U
    FIELD l-habilitaRtf    as LOG.

DEF TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem             AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo           AS CHARACTER FORMAT "x(30)":U
    INDEX id ordem.

/* Definicao de Parametros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/*Excel*/
DEFINE VARIABLE ch-excel             AS office.iface.excel.ExcelWrapper NO-UNDO.
DEFINE VARIABLE ch-arquivo           AS office.iface.excel.Workbook     NO-UNDO.
DEFINE VARIABLE ch-planilha          AS office.iface.excel.WorkSheet    NO-UNDO.
DEFINE VARIABLE i-cont               AS INTEGER                         NO-UNDO.
DEFINE VARIABLE cod-item             AS CHAR                            NO-UNDO.
DEFINE VARIABLE cod-periodo          AS CHAR                            NO-UNDO.
DEFINE VARIABLE cdn-produt-rural     AS INTEGER                         NO-UNDO.
DEFINE VARIABLE cdn-produt-rural-aux AS INTEGER                         NO-UNDO.
DEFINE VARIABLE cod-propried         AS CHAR                            NO-UNDO.
DEFINE VARIABLE cod-estabel          AS CHAR                            NO-UNDO.
DEFINE VARIABLE cod-estabel-aux      AS CHAR                            NO-UNDO.
DEFINE VARIABLE val-preco-final      AS DECIMAL                         NO-UNDO.
DEFINE VARIABLE celulaExcelAux       AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-message            AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE c-fill               AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE i-val-ajuste         AS DECIMAL                         NO-UNDO.
DEFINE VARIABLE i-val-incentivo      AS DECIMAL                         NO-UNDO.
DEFINE VARIABLE i-val-imp-retido     AS DECIMAL                         NO-UNDO.

DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172na AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00962 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00980 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107na AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00999 AS HANDLE NO-UNDO.


DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD val-preco-final  AS DECIMAL
    FIELD cod-propried     AS CHARACTER
    FIELD cod-estabel      AS CHARACTER
    FIELD cdn-produt-rural AS INTEGER
    FIELD nr-linha         AS INTEGER.

DEF TEMP-TABLE tt-erros NO-UNDO
    FIELD celula-excel      AS CHARACTER
    FIELD cod-periodo       AS CHARACTER
    FIELD cod-item          AS CHARACTER
    FIELD cdn-seq-regra     AS INTEGER
    FIELD error-number      AS INTEGER
    FIELD error-description AS CHARACTER
    FIELD tp-erro           AS INTEGER  /* 1 - Impeditivo / 2 - N∆o Impeditivo */
    FIELD nr-linha          AS INTEGER
    INDEX idx01 nr-linha
    INDEX idx02 tp-erro.

DEFINE TEMP-TABLE tt-concluidos NO-UNDO
    FIELD cdn-produt-rural AS INTEGER
    FIELD cod-propried     AS CHARACTER
    FIELD estab            AS CHARACTER
    FIELD nr-linha         AS INTEGER
    FIELD preco-final-old  AS DECIMAL
    FIELD preco-final-new  AS DECIMAL.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.


FORM c-message FORMAT "x(30)":U SKIP
     c-fill    FORMAT "x(128)":U
     WITH WIDTH 132 STREAM-IO FRAME f-message-128. 
     /* Inicio -- Projeto Internacional */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-message-128:HANDLE).

FORM c-message FORMAT "x(30)":U SKIP
     c-fill    FORMAT "x(100)":U
     WITH WIDTH 132 STREAM-IO FRAME f-message-100. 
     /* Inicio -- Projeto Internacional */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-message-100:HANDLE).

FORM tt-erros.nr-linha          FORMAT "ZZZZ9":U
     tt-erros.celula-excel      FORMAT "x(17)":U
     tt-erros.cod-periodo
     tt-erros.cod-item          FORMAT "X(16)":U
     tt-erros.error-number      
     tt-erros.error-description FORMAT "X(59)":U
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-erro-cabec. 
     /* Inicio -- Projeto Internacional */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-erro-cabec:HANDLE).

{utp/ut-liter.i "Campo Planilha"}
ASSIGN tt-erros.celula-excel:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Per°odo"}
ASSIGN tt-erros.cod-periodo:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Item"}
ASSIGN tt-erros.cod-item:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Erro"}
ASSIGN tt-erros.error-number:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Descriá∆o"}
ASSIGN tt-erros.error-description:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Linha"}
ASSIGN tt-erros.nr-linha:LABEL IN FRAME f-erro-cabec = TRIM(RETURN-VALUE).

FORM tt-concluidos.nr-linha         FORMAT "ZZZZ9":U
     tt-concluidos.estab            FORMAT "x(5)":U
     tt-concluidos.cdn-produt-rural FORMAT ">>>,>>>,>>9":U
     tt-concluidos.cod-propried     FORMAT "x(30)":U
     tt-concluidos.preco-final-old  FORMAT ">>>>>,>>>,>>9.9999":U
     tt-concluidos.preco-final-new  FORMAT ">>>>>,>>>,>>9.9999":U
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-concluidos. 
     /* Inicio -- Projeto Internacional */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-concluidos:HANDLE).

{utp/ut-liter.i "Linha"}
ASSIGN tt-concluidos.nr-linha:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Produtor_Rural"}
ASSIGN tt-concluidos.cdn-produt-rural:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Propriedade"}
ASSIGN tt-concluidos.cod-propried:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Estab"}
ASSIGN tt-concluidos.estab:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Preáo_->_De"}
ASSIGN tt-concluidos.preco-final-old:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).

{utp/ut-liter.i "Para"}
ASSIGN tt-concluidos.preco-final-new:LABEL IN FRAME f-concluidos = TRIM(RETURN-VALUE).


FOR EACH tt-raw-digita:
  CREATE tt-digita.
  RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

{utp/ut-liter.i AQ0328_-_Importaá∆o_Preáo_Final *}
ASSIGN c-programa     = "AQ0328":U
       c-titulo-relat = RETURN-VALUE
       c-sistema      = "AQP":U
       c-rodape       = "DATASUL - ":U + c-sistema + " - ":U + c-programa + " - V:":U + c-versao + ".":U + c-revisao
       c-rodape       = FILL("-":U, 132 - LENGTH(c-rodape))  + c-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
{utp/ut-liter.i Importaá∆o *}

RUN pi-inicializar IN h-acomp(INPUT RETURN-VALUE).   

/* Impressao dos Parametros */
{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

FIND FIRST tt-param.
IF AVAIL tt-param THEN DO:

    EMPTY TEMP-TABLE tt-erros.
    EMPTY TEMP-TABLE tt-concluidos.

    RUN initializeDBOs.

    RUN pi-importa-arquivo.

    RUN pi-executar.

    IF CAN-FIND(FIRST tt-erros
                WHERE tt-erros.tp-erro = 1 /* Impeditivo */) THEN DO:
      {utp/ut-liter.i Processo_cancelado. *}
      ASSIGN c-message = RETURN-VALUE
             c-fill    = FILL("-",128).

      DISP c-message
           c-fill FORMAT "x(128)"
           WITH FRAME f-message-128 NO-LABEL.

      FOR EACH tt-erros
         WHERE tt-erros.tp-erro = 1:
          DISP tt-erros.nr-linha
               tt-erros.celula-excel
               tt-erros.cod-periodo
               tt-erros.cod-item      
               tt-erros.error-number
               tt-erros.error-description 
               WITH FRAME f-erro-cabec.
               DOWN WITH FRAME f-erro-cabec.
      END.

    END.
    ELSE DO:

      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.tp-erro = 2 /* N∆o Impeditivo */) THEN DO:
        {utp/ut-liter.i Registros_n∆o_alterados: *}
        ASSIGN c-message = RETURN-VALUE
               c-fill    = FILL("-",128).
      
        DISP c-message 
             c-fill 
             WITH FRAME f-message-128 NO-LABEL.
        
        FOR EACH tt-erros
           WHERE tt-erros.tp-erro = 2:
            DISP tt-erros.nr-linha
                 tt-erros.celula-excel
                 tt-erros.cod-periodo
                 tt-erros.cod-item      
                 tt-erros.error-number
                 tt-erros.error-description 
                 WITH FRAME f-erro-cabec.
                 DOWN WITH FRAME f-erro-cabec.
        END.

        DISP SKIP.

      END.

      {utp/ut-liter.i Registros_alterados: *}
      ASSIGN c-message = RETURN-VALUE
             c-fill    = FILL("-",100).

      IF CAN-FIND(FIRST tt-concluidos) THEN
        DISP c-message 
             c-fill 
             WITH FRAME f-message-100 NO-LABEL.
      
      FOR EACH tt-concluidos:
          DISP tt-concluidos.nr-linha
               tt-concluidos.estab
               tt-concluidos.cdn-produt-rural
               tt-concluidos.cod-propried
               tt-concluidos.preco-final-old
               tt-concluidos.preco-final-new
               WITH FRAME f-concluidos.
               DOWN WITH FRAME f-concluidos.
      END.
    END.

END.
    
IF VALID-HANDLE(h-acomp) THEN
   RUN pi-finalizar IN h-acomp.

RUN deleteDBOs.

{include/i-rpclo.i}

RETURN "OK":U.

PROCEDURE initializeDBOs:

  IF NOT VALID-HANDLE(h-boin172na) THEN DO: 
    RUN inbo/boin172na.p PERSISTENT SET h-boin172na.
    RUN openQueryStatic IN h-boin172na (INPUT "Main":U).
  END.

  IF NOT VALID-HANDLE(h-boin00962) THEN DO:
    RUN inbo/boin00962.p PERSISTENT SET h-boin00962.
    RUN OpenQueryStatic IN h-boin00962 (INPUT "Main":U) NO-ERROR.
  END.

  IF NOT VALID-HANDLE(h-boin00980) THEN DO:
    RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
    RUN openqueryStatic IN h-boin00980 (INPUT "Main") NO-ERROR.
  END.

  IF NOT VALID-HANDLE(h-boad107na) THEN DO:
    RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
    RUN openqueryStatic IN h-boad107na (INPUT "Main") NO-ERROR.
  END.

  IF NOT VALID-HANDLE(h-boin00999) THEN DO:
    RUN inbo/boin00999.p PERSISTENT SET h-boin00999.
    RUN openQueryStatic IN h-boin00999 (INPUT "Main":U).
  END.


END PROCEDURE.

PROCEDURE deleteDBOs:

  IF VALID-HANDLE (h-boin172na) THEN DO: 
    DELETE PROCEDURE h-boin172na.
    ASSIGN h-boin172na = ?.
  END.

  IF VALID-HANDLE (h-boin00962) THEN DO: 
    DELETE PROCEDURE h-boin00962.
    ASSIGN h-boin00962 = ?.
  END.

  IF VALID-HANDLE (h-boin00980) THEN DO: 
    DELETE PROCEDURE h-boin00980.
    ASSIGN h-boin00980 = ?.
  END.

  IF VALID-HANDLE (h-boad107na) THEN DO: 
    DELETE PROCEDURE h-boad107na.
    ASSIGN h-boad107na = ?.
  END.

  IF VALID-HANDLE(h-boin00999) THEN DO:
    DELETE PROCEDURE h-boin00999.
    ASSIGN h-boin00999 = ?.
  END.

END PROCEDURE.

PROCEDURE pi-valida-cabecalho:

  /* Caso valor importado seja 01129999 (dia_mes_ano) */
  IF LENGTH(cod-periodo) = 8 THEN
    ASSIGN cod-periodo = SUBSTRING(cod-periodo, 3, 6).

  /* Per°odo n∆o Informado */
  IF cod-periodo = "" OR cod-periodo = ? THEN DO:
    {utp/ut-liter.i Per°odo: *}
    ASSIGN celulaExcelAux = RETURN-VALUE.

    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 5663,
                      INPUT "").
    CREATE tt-erros.
    ASSIGN tt-erros.celula-excel      = celulaExcelAux
           tt-erros.cod-periodo       = cod-periodo
           tt-erros.cod-item          = cod-item
           tt-erros.error-number      = 5663
           tt-erros.error-description = RETURN-VALUE
           tt-erros.tp-erro           = 1 /* Impeditivo */
           tt-erros.nr-linha          = 1.
  END.


  /* Màs superior a 12 */
  IF INT(SUBSTRING(cod-periodo, 1, 2)) > 12 OR 
     INT(SUBSTRING(cod-periodo, 1, 2)) < 1  THEN DO:
    {utp/ut-liter.i Per°odo: *}
    ASSIGN celulaExcelAux = RETURN-VALUE.

    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 7985,
                      INPUT "").
    CREATE tt-erros.
    ASSIGN tt-erros.celula-excel      = celulaExcelAux
           tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
           tt-erros.cod-item          = cod-item
           tt-erros.error-number      = 7985
           tt-erros.error-description = RETURN-VALUE
           tt-erros.tp-erro           = 1 /* Impeditivo */
           tt-erros.nr-linha          = 1.
  END.

  IF cod-item = "" OR cod-item = ? THEN DO:
    {utp/ut-liter.i Item *}
    ASSIGN celulaExcelAux = RETURN-VALUE.

    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 247,
                      INPUT celulaExcelAux).
    CREATE tt-erros.
    ASSIGN tt-erros.celula-excel      = celulaExcelAux + ":":U
           tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
           tt-erros.cod-item          = ""
           tt-erros.error-number      = 247
           tt-erros.error-description = RETURN-VALUE
           tt-erros.tp-erro           = 1 /* Impeditivo */
           tt-erros.nr-linha          = 2.
  END.
  ELSE DO:
    /* Confirma se Item informado existe */
    RUN goToKey IN h-boin172na (INPUT cod-item) NO-ERROR.
    IF RETURN-VALUE = "NOK":U THEN DO:
      {utp/ut-liter.i Item: *}
      ASSIGN celulaExcelAux = RETURN-VALUE.
    
      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 90,
                        INPUT cod-item).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 90
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 1 /* Impeditivo */
             tt-erros.nr-linha          = 2.
    END.
  END.

END PROCEDURE.

PROCEDURE pi-importa-arquivo:

    DEFINE VARIABLE l-cabecalho AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE i-cabecalho AS INTEGER NO-UNDO.

    ASSIGN cod-item        = ""
           cod-periodo     = "".

    {utp/ut-liter.i Carregando_dados_da_Planilha *}
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).

    IF INDEX(tt-param.arq-entrada, ".xls") > 0 THEN DO:

      /* Carrega planilha */
      {office/office.i Excel ch-excel}
      ch-arquivo  = ch-excel:workBooks:OPEN(tt-param.arq-entrada, TRUE).
      ch-arquivo:Sheets("AQ0512"):VISIBLE = TRUE.

      ch-planilha = ch-arquivo:Sheets("AQ0512").
      ch-planilha:SELECT().
      ch-excel:DisplayAlerts = FALSE.
      
      blk_cabec:
      REPEAT:

        ASSIGN i-cabecalho = i-cabecalho + 1.

        IF STRING(ch-excel:Range("AS":U + STRING(i-cabecalho)):VALUE) = ? AND 
           STRING(ch-excel:Range("AT":U + STRING(i-cabecalho)):VALUE) = ? THEN
          NEXT blk_cabec.

        IF STRING(ch-excel:Range("AS":U + STRING(i-cabecalho)):VALUE) = "Per°odo" AND 
           STRING(ch-excel:Range("AT":U + STRING(i-cabecalho)):VALUE) = "Item" THEN DO:
          ASSIGN l-cabecalho = YES.
          NEXT blk_cabec.
        END.

        IF l-cabecalho THEN DO:
          /* Faz a leitura da aba operaá‰es */
          ASSIGN cod-periodo = STRING(ch-excel:Range("AS":U + STRING(i-cabecalho)):VALUE)
                 cod-periodo = REPLACE(REPLACE(cod-periodo, "~/", ""), "~\", "")
                 cod-item    = STRING(ch-excel:Range("AT":U + STRING(i-cabecalho)):VALUE).
          LEAVE blk_cabec.
        END.

      END.

      RUN pi-valida-cabecalho.
      IF CAN-FIND(FIRST tt-erros WHERE tt-erros.tp-erro = 1 /* Impeditivo */) THEN 
        LEAVE.

      ASSIGN i-cont = i-cabecalho.

      blk_dados:
      REPEAT:

        /* Garantir que ainda existe dados na planilha */
        IF STRING(ch-excel:Range("A":U + STRING(i-cont)):VALUE) <> ? OR
           STRING(ch-excel:Range("E":U + STRING(i-cont)):VALUE) <> ? OR
           STRING(ch-excel:Range("G":U + STRING(i-cont)):VALUE) <> ? THEN DO:

           RUN pi-create-tt-planilha(INPUT STRING(ch-excel:Range("X":U  + STRING(i-cont)):VALUE),  /* Preáo Final        */
                                     INPUT STRING(ch-excel:Range("G":U  + STRING(i-cont)):VALUE),  /* Codigo Propriedade */
                                     INPUT STRING(ch-excel:Range("AV":U + STRING(i-cont)):VALUE),  /* Estabelecimento    */
                                     INPUT    INT(ch-excel:Range("A":U  + STRING(i-cont)):VALUE)). /* Produtor Rural     */

           ASSIGN i-cont = i-cont + 1.

           IF RETURN-VALUE = "NOK":U THEN
             NEXT blk_dados.
        END.
        ELSE LEAVE blk_dados.

      END.

      ch-Excel:QUIT().        
      DELETE OBJECT ch-Excel.

    END.
    ELSE DO:

      DEF VAR c-linha AS CHAR NO-UNDO.

      ASSIGN i-cont = 0.
      INPUT FROM VALUE(tt-param.arq-entrada) CONVERT TARGET "ibm850":U.
      
      blk:
      REPEAT:

        IMPORT UNFORMATTED c-linha.

        ASSIGN i-cont = i-cont + 1.

        IF ENTRY(1,c-linha, ";":U) = ""  AND
           ENTRY(5,c-linha, ";":U) = ""  AND
           ENTRY(7,c-linha, ";":U) = ""  THEN
           LEAVE blk.

        IF i-cont < 3 THEN   
          NEXT blk.

        IF i-cont = 3 THEN DO: /*Linha da Planilha*/

          ASSIGN cod-periodo = ENTRY(44, c-linha, ";":U)
                 cod-item    = ENTRY(45, c-linha, ";":U).
          
          RUN pi-retorna-mes(INPUT cod-periodo).

          RUN pi-valida-cabecalho.

          IF CAN-FIND(FIRST tt-erros WHERE tt-erros.tp-erro = 1 /* Impeditivo */) THEN 
            LEAVE blk.

        END.

        RUN pi-create-tt-planilha(INPUT STRING(ENTRY(24, c-linha, ";":U)), /* Preáo Final        */
                                  INPUT STRING(ENTRY(7 , c-linha, ";":U)), /* Codigo Propriedade */
                                  INPUT STRING(ENTRY(47, c-linha, ";":U)), /* Estabelecimento    */
                                  INPUT    INT(ENTRY(1 , c-linha, ";":U))). /* Produtor Rural     */
        
        IF RETURN-VALUE = "NOK":U THEN
          NEXT blk.

      END.
    END.

END PROCEDURE.

PROCEDURE pi-create-tt-planilha:

    DEFINE INPUT PARAM pr-preco-final    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pr-propriedade    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pr-estabelec      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pr-produtor-rural AS CHARACTER NO-UNDO.

    ASSIGN val-preco-final  = DEC(pr-preco-final) NO-ERROR.
    IF ERROR-STATUS:ERROR             OR 
       INDEX(pr-preco-final, ".") > 0 THEN DO:
      {utp/ut-liter.i Preáo_Final *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 55175,
                        INPUT pr-preco-final).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 55175
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha        = i-cont.
    END.
    ELSE 
    IF pr-preco-final = "" OR val-preco-final = ? THEN DO:
      {utp/ut-liter.i Preáo_Final *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 247,
                        INPUT celulaExcelAux).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 247
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha        = i-cont.
    END.
    ELSE
    IF val-preco-final <= 0 THEN DO:
      {utp/ut-liter.i Preáo_Final *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 36,
                        INPUT celulaExcelAux).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 36
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha        = i-cont.
    END.
    ELSE
    IF LENGTH(STRING(INT64(val-preco-final))) > 11 THEN DO:
      {utp/ut-liter.i Preáo_Final *}
      ASSIGN celulaExcelAux = RETURN-VALUE.
    
      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 16401,
                        INPUT ">>>>>,>>>,>>9.9999":U).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 16401
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha        = i-cont.
    END.

    ASSIGN cod-estabel-aux = STRING(pr-estabelec).
    IF cod-estabel-aux = "" OR cod-estabel-aux = ? THEN DO:
      {utp/ut-liter.i Est *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 53326,
                        INPUT "").
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 53326
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha        = i-cont.
    END.
    ELSE DO:

      ASSIGN cod-estabel = STRING(INT(cod-estabel-aux)) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
         ASSIGN cod-estabel = cod-estabel-aux.
      
      /* Estabelecimento */
      RUN goToKey IN h-boad107na (INPUT cod-estabel).
      IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-liter.i Est *}
        ASSIGN celulaExcelAux = RETURN-VALUE.
      
        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 13,
                          INPUT cod-estabel).
        CREATE tt-erros.
        ASSIGN tt-erros.celula-excel      = celulaExcelAux
               tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
               tt-erros.cod-item          = cod-item
               tt-erros.error-number      = 13
               tt-erros.error-description = RETURN-VALUE
               tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
               tt-erros.nr-linha        = i-cont.
      END.
    END.

    ASSIGN cdn-produt-rural = INT(pr-produtor-rural) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      {utp/ut-liter.i Produtor_Rural *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 55160,
                        INPUT STRING(pr-produtor-rural)).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 55160
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha          = i-cont.
    END.
    ELSE
    IF pr-produtor-rural = "" OR pr-produtor-rural = ? THEN DO:

      {utp/ut-liter.i Produtor_Rural *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 247,
                        INPUT celulaExcelAux).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 247
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha          = i-cont.
    END.
    ELSE DO:
      /* Produtor Rural */
      RUN goToKey IN h-boin00962(INPUT cdn-produt-rural).
      IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-liter.i Produtor_Rural *}
        ASSIGN celulaExcelAux = RETURN-VALUE.

        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 55160,
                          INPUT cdn-produt-rural).
        CREATE tt-erros.
        ASSIGN tt-erros.celula-excel      = celulaExcelAux
               tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
               tt-erros.cod-item          = cod-item
               tt-erros.error-number      = 55160
               tt-erros.error-description = RETURN-VALUE
               tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
               tt-erros.nr-linha          = i-cont.
      END.
    END.

    /*Ao importar do excel um campo numÇrico, o valor (exemplo) 100 Ç alterado para 100,0000 */
    IF INDEX(pr-propriedade, ",") > 0 THEN
      ASSIGN cod-propried = SUBSTRING(pr-propriedade, 1, R-INDEX(pr-propriedade, ",") - 1).
    ELSE 
      ASSIGN cod-propried = STRING(pr-propriedade).

    IF cod-propried = "" OR cod-propried = ? THEN DO:
      {utp/ut-liter.i Propriedade *}
      ASSIGN celulaExcelAux = RETURN-VALUE.

      RUN utp/ut-msgs.p(INPUT "msg":U,
                        INPUT 247,
                        INPUT celulaExcelAux).
      CREATE tt-erros.
      ASSIGN tt-erros.celula-excel      = celulaExcelAux
             tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
             tt-erros.cod-item          = cod-item
             tt-erros.error-number      = 247
             tt-erros.error-description = RETURN-VALUE
             tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
             tt-erros.nr-linha          = i-cont.
    END.
    ELSE DO:
      /* Propried Rural */
      RUN goToKey IN h-boin00980(INPUT cod-propried).
      IF RETURN-VALUE = "NOK":U THEN DO:
        {utp/ut-liter.i Propriedade *}
        ASSIGN celulaExcelAux = RETURN-VALUE.
      
        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 55161,
                          INPUT cod-propried).
        CREATE tt-erros.
        ASSIGN tt-erros.celula-excel      = celulaExcelAux
               tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
               tt-erros.cod-item          = cod-item
               tt-erros.error-number      = 55161
               tt-erros.error-description = RETURN-VALUE
               tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
               tt-erros.nr-linha        = i-cont.
      END.
    END.

    IF CAN-FIND(FIRST tt-erros WHERE tt-erros.nr-linha = i-cont) THEN 
       RETURN "NOK":U.
    
    CREATE tt-planilha.
    ASSIGN tt-planilha.val-preco-final  = ROUND(val-preco-final,8) /* Ajuste devido ao progress transformar 1,23 em 1,22999999 no momento do importaá∆o */
           tt-planilha.cod-propried     = cod-propried
           tt-planilha.cod-estabel      = cod-estabel
           tt-planilha.cdn-produt-rural = cdn-produt-rural
           tt-planilha.nr-linha         = i-cont.
END.

PROCEDURE pi-executar:

    DEFINE VARIABLE situacao      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE precoFinalAux AS DECIMAL   NO-UNDO.

    blk_planilha:
    FOR EACH tt-planilha:

      {utp/ut-liter.i Efetuando_a_alteraá∆o_do_Preáo_Final *}
      RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).
      
      FIND fechto-produt-period EXCLUSIVE-LOCK
        WHERE fechto-produt-period.cod-period       = cod-periodo
          AND fechto-produt-period.cdn-produt-rural = tt-planilha.cdn-produt-rural
          AND fechto-produt-period.cod-propried     = tt-planilha.cod-propried
          AND fechto-produt-period.it-codigo        = cod-item
          AND fechto-produt-period.cod-estabel      = tt-planilha.cod-estabel NO-ERROR.
      IF AVAIL fechto-produt-period THEN DO:

        /*NF_Gerada */
        IF fechto-produt-period.idi-situacao = 3 THEN DO:

           {utp/ut-liter.i NF_Gerada *}
           ASSIGN situacao = RETURN-VALUE.

           {utp/ut-liter.i Preáo_Final *}
           ASSIGN celulaExcelAux = RETURN-VALUE.

           RUN utp/ut-msgs.p(INPUT "msg":U,
                             INPUT 15239,
                             INPUT situacao).
           CREATE tt-erros.
           ASSIGN tt-erros.celula-excel      = celulaExcelAux
                  tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
                  tt-erros.cod-item          = cod-item
                  tt-erros.error-number      = 15239
                  tt-erros.error-description = RETURN-VALUE
                  tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
                  tt-erros.nr-linha        = tt-planilha.nr-linha.


           NEXT blk_planilha.
        END.

        ASSIGN precoFinalAux = fechto-produt-period.val-preco-final-inf.

        IF precoFinalAux <> tt-planilha.val-preco-final THEN DO:

          ASSIGN i-val-ajuste = 0
                 fechto-produt-period.val-preco-final-inf = tt-planilha.val-preco-final
                 fechto-produt-period.val-bonus-fix-inf = fechto-produt-period.val-preco-final-inf - (fechto-produt-period.val-bonus-fix  + fechto-produt-period.val-preco-base + 
                                                                                                      fechto-produt-period.val-var-qualid + fechto-produt-period.val-var-volum).
          /*Busca valor do ajuste no engine de regras*/
          IF VALID-HANDLE(h-boin00999) THEN DO:
            RUN retornaIncentivo IN h-boin00999(INPUT fechto-produt-period.cod-period,
                                                INPUT fechto-produt-period.cdn-produt-rural,
                                                INPUT fechto-produt-period.it-codigo,
                                                INPUT fechto-produt-period.cod-estabel,
                                                INPUT fechto-produt-period.qtd-period,
                                                INPUT fechto-produt-period.val-preco-base,
                                                INPUT fechto-produt-period.val-var-volum,
                                                INPUT fechto-produt-period.val-bonus-fix-inf,
                                                INPUT fechto-produt-period.val-var-qualid,
                                                INPUT fechto-produt-period.val-preco-final-inf,
                                               OUTPUT i-val-ajuste,
                                               OUTPUT i-val-incentivo,
                                               OUTPUT i-val-imp-retido).

            ASSIGN fechto-produt-period.val-livre-1 = i-val-ajuste.

          END.
          
          CREATE tt-concluidos.
          ASSIGN tt-concluidos.cdn-produt-rural = fechto-produt-period.cdn-produt-rural
                 tt-concluidos.cod-propried     = fechto-produt-period.cod-propried
                 tt-concluidos.estab            = fechto-produt-period.cod-estabel
                 tt-concluidos.nr-linha         = tt-planilha.nr-linha
                 tt-concluidos.preco-final-old  = precoFinalAux
                 tt-concluidos.preco-final-new  = fechto-produt-period.val-preco-final-inf.
        END.
        ELSE DO:

            /* Preáo final n∆o alterado na planilha */
            RUN utp/ut-msgs.p(INPUT "msg":U,
                              INPUT 55188,
                              INPUT situacao).
            CREATE tt-erros.
            ASSIGN tt-erros.celula-excel      = ""
                   tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
                   tt-erros.cod-item          = cod-item
                   tt-erros.error-number      = 55188
                   tt-erros.error-description = RETURN-VALUE
                   tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
                   tt-erros.nr-linha        = tt-planilha.nr-linha.


            NEXT blk_planilha.

        END.
      END.
      ELSE DO:
        {utp/ut-liter.i informado_na_linha_ *}
        ASSIGN celulaExcelAux = RETURN-VALUE.
      
        RUN utp/ut-msgs.p(INPUT "msg":U,
                          INPUT 55182,
                          INPUT celulaExcelAux + STRING(tt-planilha.nr-linha)).
        CREATE tt-erros.
        ASSIGN tt-erros.celula-excel      = ""
               tt-erros.cod-periodo       = SUBSTRING(cod-periodo,1,2) + "/" + SUBSTRING(cod-periodo,3,4)
               tt-erros.cod-item          = cod-item
               tt-erros.error-number      = 55182
               tt-erros.error-description = RETURN-VALUE
               tt-erros.tp-erro           = 2 /* N∆o Impeditivo */
               tt-erros.nr-linha        = tt-planilha.nr-linha.
      END.
    END.

END PROCEDURE.

PROCEDURE pi-retorna-mes:
    DEFINE INPUT PARAM pr-periodo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ano AS CHARACTER NO-UNDO.

    ASSIGN pr-periodo = ENTRY(1,cod-periodo, "/":U).

    /* Caso o ANO importado possua apenas os 2 £ltimos digitos Ex. Mar/17 */
    IF LENGTH(ENTRY(2,cod-periodo, "/":U)) = 2 THEN
      ASSIGN ano = SUBSTRING(STRING(YEAR(TODAY),"9999"),1,2) + ENTRY(2,cod-periodo, "/":U).
    ELSE 
      ASSIGN ano = ENTRY(2,cod-periodo, "/":U).

    /* POR/ING/ESP */
    CASE pr-periodo:
      WHEN "Jan":U OR WHEN "ene":U THEN 
         ASSIGN cod-periodo = "01":U + ano.
      WHEN "Fev":U OR WHEN "feb":U THEN 
         ASSIGN cod-periodo = "02":U + ano.
      WHEN "Mar":U THEN 
         ASSIGN cod-periodo = "03":U + ano.
      WHEN "Abr":U OR WHEN "apr":U THEN 
         ASSIGN cod-periodo = "04":U + ano.
      WHEN "Mai":U OR WHEN "may":U THEN 
         ASSIGN cod-periodo = "05":U + ano.
      WHEN "Jun":U THEN 
         ASSIGN cod-periodo = "06":U + ano.
      WHEN "Jul":U THEN 
         ASSIGN cod-periodo = "07":U + ano.
      WHEN "Ago":U OR WHEN "aug":U THEN 
         ASSIGN cod-periodo = "08":U + ano.
      WHEN "Set":U OR WHEN "sep":U THEN 
         ASSIGN cod-periodo = "09":U + ano.
      WHEN "Out":U OR WHEN "oct":U THEN 
         ASSIGN cod-periodo = "10":U + ano.
      WHEN "Nov":U THEN 
         ASSIGN cod-periodo = "11":U + ano.
      WHEN "Dez":U OR WHEN "dec":U OR WHEN "dic":U THEN 
         ASSIGN cod-periodo = "12":U + ano.
    END CASE.

    ASSIGN cod-periodo = REPLACE(REPLACE(cod-periodo, "~/", ""), "~\", "").

END PROCEDURE.
