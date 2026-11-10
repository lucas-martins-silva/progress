/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0311RP 2.00.00.005 } /*** 010005 ***/
{include/i_fnctrad.i}
/******************************************************************************
**   Programa: af0311rp.p
**   Data....: 05/06/2006
**   Autor...: Fabiane Schulze.
**   Objetivo: Importar os °ndices referentes a um ponto de controle manual.
******************************************************************************/
{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD execucao         AS INTEGER
    FIELD todos            AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(60)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD arq-entrada      AS CHAR FORMAT "x(60)":U
    FIELD arq-destino      AS CHAR FORMAT "x(60)":U
    FIELD arq-erro         AS CHAR FORMAT "x(60)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD i-periodo        AS INTEGER.

DEF TEMP-TABLE tt-af-contr-indice NO-UNDO LIKE af-contr-indice
    FIELD r-rowid        AS ROWID.

DEF TEMP-TABLE tt-af-contr-indice-erro NO-UNDO
   FIELD ep-codigo      LIKE af-contr-indice.ep-codigo
   FIELD cod-estabel    LIKE af-contr-indice.cod-estabel    
   FIELD cod-emitente   LIKE af-contr-indice.cod-emitente
   FIELD nr-versao      LIKE af-contr-indice.nr-versao
   FIELD nr-controle    LIKE af-contr-indice.nr-controle    
   FIELD it-codigo      LIKE af-contr-indice.it-codigo      
   FIELD dt-indice      LIKE af-contr-indice.dt-indice      
   FIELD indice         LIKE af-contr-indice.indice         
   FIELD seq-resultado  LIKE af-contr-indice.seq-resultado  
   FIELD usuar-alter    LIKE af-contr-indice.usuar-alter
   FIELD narrativa      LIKE af-contr-indice.narrativa  
   FIELD num-erro       AS INTEGER
   FIELD desc-erro      AS CHAR
   FIELD l-erro         AS LOGICAL
   FIELD r-rowid        AS ROWID.

DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO LIKE tt-versao-data.

DEF TEMP-TABLE tt-af-contr-indice-nova NO-UNDO LIKE af-contr-indice
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-af-contr-indice-atualiza NO-UNDO LIKE af-contr-indice
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-af-contr-indice-aux NO-UNDO LIKE af-contr-indice
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-af-contr-indice-periodo NO-UNDO LIKE af-contr-indice
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

/* recebimento de parÉmetros */
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE BUFFER btt-af-contr-indice FOR tt-af-contr-indice.
                 
DEF STREAM s-imp.
DEF STREAM s-erros.

DEF VAR h-acomp        AS HANDLE  NO-UNDO.
DEF VAR h-boaf008      AS HANDLE  NO-UNDO.
DEF VAR h-boaf023      AS HANDLE  NO-UNDO.
DEF VAR h-boaf006      AS HANDLE  NO-UNDO.
DEF VAR c-linha        AS CHAR    NO-UNDO.
DEF VAR c-periodo      AS CHAR    NO-UNDO FORMAT "x(7)".
DEF VAR i-cont         AS INTEGER NO-UNDO.
DEF VAR d-dt-indice     LIKE af-contr-indice.dt-indice NO-UNDO.
DEF VAR d-dt-indice-aux LIKE af-contr-indice.dt-indice NO-UNDO.
DEF VAR c-des-controle  LIKE af-controle.descricao     NO-UNDO.
DEF VAR c-imprime       AS CHAR FORMAT "x(15)"  NO-UNDO.
DEF VAR c-destino       AS CHAR FORMAT "x(15)"  NO-UNDO.
DEF VAR c-execucao      AS CHAR FORMAT "x(15)"  NO-UNDO.
DEF VAR c-label         AS CHAR FORMAT "x(132)" NO-UNDO.
DEF VAR c-label-erro    AS CHAR FORMAT "x(80)"  NO-UNDO.
DEF VAR c-titulo        AS CHAR FORMAT "x(80)"  NO-UNDO.
DEF VAR c-titulo-erro   AS CHAR FORMAT "x(80)"  NO-UNDO.
DEF VAR c-traco         AS CHAR FORMAT "x(132)" NO-UNDO.
DEF VAR l-cabec         AS LOG                  NO-UNDO.
DEF VAR l-imp           AS LOG                  NO-UNDO.
DEF VAR i-nr-versao     AS INT                  NO-UNDO.
DEF VAR c-periodo-aux   AS CHAR                 NO-UNDO.

DEFINE VARIABLE i-cont2 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont3 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont4 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont5 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont6 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont7 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont8 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont9 AS INTEGER NO-UNDO.

DEFINE VARIABLE i-contcria2 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria3 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria4 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria5 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria6 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria7 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria8 AS INTEGER NO-UNDO.
DEFINE VARIABLE i-contcria9 AS INTEGER NO-UNDO.

DEFINE VARIABLE d-data-aux AS DATE NO-UNDO.

{include/i-rpvar.i}

/* Definiá∆o de frames de relat¢rio */

/* Itens importados com sucesso */
FORM tt-af-contr-indice.cod-estabel     AT 01
     tt-af-contr-indice.cod-emitente    AT 5
     tt-af-contr-indice.nr-controle     AT 17
     " - "                              
     c-des-controle                     FORMAT "x(30)" AT 27
     c-periodo                          FORMAT "x(7)"  AT 57
     tt-af-contr-indice.it-codigo       AT 65
     tt-af-contr-indice.indice          AT 82
     tt-af-contr-indice.usuar-alter     AT 99
     WITH NO-LABELS STREAM-IO NO-BOX WIDTH 132 DOWN FRAME f-relat.

/* Itens com problemas */
FORM tt-af-contr-indice-aux.cod-estabel    AT 01
     tt-af-contr-indice-aux.cod-emitente   AT 5
     tt-af-contr-indice-aux.nr-controle    AT 17
     " - "
     c-des-controle                    FORMAT "x(30)" AT 27
     c-periodo                         FORMAT "x(7)" AT 57
     tt-af-contr-indice-aux.it-codigo      COLUMN-LABEL "Item" AT 65
     WITH NO-LABELS STREAM-IO NO-BOX WIDTH 132 DOWN FRAME  f-relat-erro.

FORM tt-af-contr-indice-erro.num-erro NO-LABEL AT 02
     " - "
     tt-af-contr-indice-erro.desc-erro NO-LABEL FORMAT "x(110)"
     WITH NO-LABELS STREAM-IO NO-BOX WIDTH 132 DOWN FRAME  f-relat-erro-2.

FORM "PAR∂METROS"                        AT 05 SKIP(1)
     tt-param.arq-entrada                AT 25 LABEL "Arquivo de Entrada"
     tt-param.arq-erro                   AT 8 LABEL "Arquivo de Registros Inconsistentes"
     tt-param.i-periodo                  AT 32 LABEL "Nr Per°odos" SKIP(3)
     WITH SIDE-LABELS DOWN WIDTH 132 NO-BOX STREAM-IO FRAME f-param.

FORM "LOG"                AT 05 SKIP(1)
      c-imprime           COLON  43 LABEL "Imprime"
      c-destino           COLON  43 LABEL "Destino"
      tt-param.arquivo    COLON  60 NO-LABEL
      c-execucao          COLON  43 LABEL "Execuá∆o"
      tt-param.usuario    COLON  43 LABEL "Usu†rio"
      WITH SIDE-LABELS DOWN WIDTH 132 NO-BOX STREAM-IO FRAME f-impressao.

FOR FIRST empresa FIELDS (ep-codigo razao-social) WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK:
    ASSIGN c-empresa = empresa.razao-social.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Importac∆o ÷ndices Manuais").

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Importando" *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + "...").

{utp/ut-liter.i Importaá∆o_÷ndices_Manuais MAF *}

ASSIGN c-titulo-relat = RETURN-VALUE
       c-programa     = 'AF0311'
       c-versao       = '2.02'
       c-revisao      = '000'
       c-sistema      = "MAF".

{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

ASSIGN c-imprime  = IF tt-param.todos    = 1 THEN "Todos":U   ELSE "Rejeitados":U
       c-execucao = IF tt-param.execucao = 1 THEN "On-Line":U ELSE "Batch":U
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-impressao:HANDLE).

EMPTY TEMP-TABLE tt-af-contr-indice.              
EMPTY TEMP-TABLE tt-af-contr-indice-nova. 
EMPTY TEMP-TABLE tt-af-contr-indice-atualiza.              
EMPTY TEMP-TABLE tt-af-contr-indice-erro. 
EMPTY TEMP-TABLE tt-af-contr-indice-periodo.  
EMPTY TEMP-TABLE tt-af-contr-indice-aux.

RUN afbo/boaf008.p PERSISTENT SET h-boaf008.
RUN OpenqueryStatic IN h-boaf008 (INPUT "Main").

FIND FIRST param-af NO-LOCK
    WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.

IF NOT VALID-HANDLE(h-boaf023) THEN
    RUN afbo/boaf023.p PERSISTENT SET h-boaf023.

IF NOT VALID-HANDLE(h-boaf006) THEN
    RUN afbo/boaf006.p PERSISTENT SET h-boaf006.

IF param-af.log-usa-versao THEN DO:
    RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                          OUTPUT TABLE tt-versao-data).
END.


INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).
REPEAT:
    IMPORT STREAM s-imp UNFORMATTED c-linha.
    
    IF SUBSTR(c-linha,1,1) <> "" THEN DO:
           
       ASSIGN d-dt-indice-aux = date("01" + replace(ENTRY(4,c-linha,";"),"/",""))
              d-dt-indice-aux = date(STRING(DAY(d-dt-indice-aux))   + "/" + 
                                     STRING(MONTH(d-dt-indice-aux)) + "/" + 
                                     STRING(YEAR(d-dt-indice-aux))).
       IF NOT CAN-FIND (FIRST btt-af-contr-indice 
                        WHERE btt-af-contr-indice.ep-codigo    = i-ep-codigo-usuario  
                          AND btt-af-contr-indice.nr-controle  = INT(ENTRY(3,c-linha,";")) 
                          AND btt-af-contr-indice.dt-indice    = d-dt-indice-aux
                          AND btt-af-contr-indice.it-codigo    = ENTRY(5,c-linha,";") 
                          AND btt-af-contr-indice.cod-estabel  = ENTRY(1,c-linha,";") 
                          AND btt-af-contr-indice.cod-emitente = INT(ENTRY(2,c-linha,";"))) THEN DO:
               
           IF param-af.log-usa-versao THEN DO:
               IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
                    ASSIGN d-data-aux = date(string("01" + ENTRY(4,c-linha,";"),"xx/xx/xxxx")).
                    FOR EACH tt-item-data:
                        DELETE tt-item-data.
                    END.
                
                    RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                          INPUT ENTRY(5,c-linha,";"),
                                                          INPUT INT(ENTRY(2,c-linha,";")),
                                                          INPUT ENTRY(1,c-linha,";"),
                                                          INPUT TABLE tt-versao-data,
                                                          OUTPUT TABLE tt-item-data).
                    FOR EACH tt-item-data NO-LOCK:
                       IF d-data-aux >= tt-item-data.data-ini AND
                          d-data-aux <= tt-item-data.data-fim THEN DO:
                
                           ASSIGN i-nr-versao = tt-item-data.nr-versao.
                       END.
                    END.
               END.
               ELSE DO: /* controle de validade conforme cadastro de versoes */
                  ASSIGN c-periodo-aux = string(month(d-dt-indice-aux)) + "/" + STRING(year(d-dt-indice-aux)).
                  RUN piRetornaVersaoPeriodo IN h-boaf023(INPUT c-periodo-aux,
                                                          INPUT i-ep-codigo-usuario,
                                                          OUTPUT i-nr-versao).
               END.
           END.
           ELSE DO:
               RUN pi-retorna-menor-versao IN h-boaf023 (OUTPUT i-nr-versao).
           END.

          CREATE tt-af-contr-indice.
          ASSIGN tt-af-contr-indice.cod-estabel   = ENTRY(1,c-linha,";")
                 tt-af-contr-indice.cod-emitente  = INT(ENTRY(2,c-linha,";"))
                 tt-af-contr-indice.nr-controle   = INT(ENTRY(3,c-linha,";")) 
                 tt-af-contr-indice.dt-indice     = d-dt-indice-aux
                 tt-af-contr-indice.it-codigo     = ENTRY(5,c-linha,";")
                 tt-af-contr-indice.indice        = DEC(ENTRY(6,c-linha,";"))
                 tt-af-contr-indice.seq-resultado = INT(ENTRY(7,c-linha,";"))  
                 tt-af-contr-indice.usuar-alter   = ENTRY(8,c-linha,";")
                 tt-af-contr-indice.narrativa     = ENTRY(9,c-linha,";")
                 tt-af-contr-indice.ep-codigo     = i-ep-codigo-usuario
                 tt-af-contr-indice.nr-versao     = i-nr-versao.

    
          IF tt-af-contr-indice.usuar-alter = "" THEN ASSIGN tt-af-contr-indice.usuar-alter = c-seg-usuario.
          IF tt-af-contr-indice.indice = 0 THEN DO:
             FIND FIRST af-controle-result WHERE af-controle-result.seq-resultado = tt-af-contr-indice.seq-resultado NO-LOCK NO-ERROR.
             IF AVAIL af-controle-result THEN ASSIGN tt-af-contr-indice.indice = af-controle-result.indice.
          END.
          
         
              
         FIND FIRST af-contr-indice NO-LOCK
              WHERE af-contr-indice.ep-codigo    = tt-af-contr-indice.ep-codigo
                AND af-contr-indice.nr-controle  = tt-af-contr-indice.nr-controle
                AND af-contr-indice.dt-indice    = tt-af-contr-indice.dt-indice
                AND af-contr-indice.it-codigo    = tt-af-contr-indice.it-codigo
                AND af-contr-indice.cod-estabel  = tt-af-contr-indice.cod-estabel
                AND af-contr-indice.cod-emitente = tt-af-contr-indice.cod-emitente NO-ERROR.
          IF AVAIL af-contr-indice THEN DO:
              
             CREATE tt-af-contr-indice-atualiza.
             BUFFER-COPY af-contr-indice TO tt-af-contr-indice-atualiza.
             ASSIGN tt-af-contr-indice-atualiza.indice         = tt-af-contr-indice.indice
                    tt-af-contr-indice-atualiza.usuar-alter    = tt-af-contr-indice.usuar-alter
                    tt-af-contr-indice-atualiza.seq-resultado  = tt-af-contr-indice.seq-resultado
                    tt-af-contr-indice-atualiza.narrativa      = tt-af-contr-indice.narrativa.
          END.
          ELSE DO:
             CREATE tt-af-contr-indice-nova.
             BUFFER-COPY tt-af-contr-indice TO tt-af-contr-indice-nova.
          END.
          
       END.
    END.
END.
INPUT STREAM s-imp CLOSE.

IF VALID-HANDLE(h-boaf008) THEN DO:

    /*atualizaá∆o*/
    FOR EACH tt-af-contr-indice-atualiza:
       EMPTY TEMP-TABLE RowErrors.
       EMPTY TEMP-TABLE tt-af-contr-indice-aux.
       RUN emptyRowErrors IN h-boaf008.
       RUN emptyRowObject IN h-boaf008.
       CREATE tt-af-contr-indice-aux.
       BUFFER-COPY tt-af-contr-indice-atualiza TO tt-af-contr-indice-aux.
       RUN goToKey  IN h-boaf008 (INPUT tt-af-contr-indice-aux.cod-estabel,
                                  INPUT tt-af-contr-indice-aux.cod-emitente,
                                  INPUT tt-af-contr-indice-aux.it-codigo,
                                  INPUT tt-af-contr-indice-aux.nr-controle,
                                  INPUT tt-af-contr-indice-aux.dt-indice).
       IF RETURN-VALUE = "OK":U THEN DO:
           RUN setRecord    IN h-boaf008 (INPUT TABLE tt-af-contr-indice-aux).
           RUN updateRecord IN h-boaf008.
           RUN getRowErrors IN h-boaf008 (OUTPUT TABLE RowErrors).
    
           ASSIGN d-dt-indice = tt-af-contr-indice-atualiza.dt-indice.

           IF CAN-FIND(FIRST RowErrors WHERE 
                             RowErrors.ErrorType    <> "INTERNAL":U AND
                             RowErrors.ErrorSubType =  "ERROR":U) THEN
              RUN pi-cria-erros (INPUT TABLE tt-af-contr-indice-aux).    
           ELSE IF tt-param.i-periodo > 1 THEN DO i-cont = 1 TO (tt-param.i-periodo - 1):
               IF MONTH(d-dt-indice) <= 11 THEN
                  ASSIGN d-dt-indice = DATE("01/" + STRING(MONTH(d-dt-indice) + 1) + "/" + STRING(YEAR(d-dt-indice))).
               ELSE 
                  ASSIGN d-dt-indice = DATE("01/" + "01/" + STRING(YEAR(d-dt-indice) + 1 )).

               IF NOT CAN-FIND (FIRST tt-af-contr-indice WHERE
                                      tt-af-contr-indice.ep-codigo    = tt-af-contr-indice-atualiza.ep-codigo
                                  AND tt-af-contr-indice.nr-controle  = tt-af-contr-indice-atualiza.nr-controle
                                  AND tt-af-contr-indice.dt-indice    = d-dt-indice
                                  AND tt-af-contr-indice.it-codigo    = tt-af-contr-indice-atualiza.it-codigo
                                  AND tt-af-contr-indice.cod-estabel  = tt-af-contr-indice-atualiza.cod-estabel
                                  AND tt-af-contr-indice.cod-emitente = tt-af-contr-indice-atualiza.cod-emitente) THEN DO:
                     EMPTY TEMP-TABLE RowErrors.
                     EMPTY TEMP-TABLE tt-af-contr-indice-aux.
                     RUN emptyRowErrors IN h-boaf008.
                     RUN emptyRowObject IN h-boaf008.
                     CREATE tt-af-contr-indice-aux.
                     BUFFER-COPY tt-af-contr-indice-atualiza EXCEPT dt-indice TO tt-af-contr-indice-aux.
                     ASSIGN tt-af-contr-indice-aux.dt-indice = d-dt-indice. 
                     RUN goToKey  IN h-boaf008 (INPUT tt-af-contr-indice-aux.cod-estabel,
                                                INPUT tt-af-contr-indice-aux.cod-emitente,
                                                INPUT tt-af-contr-indice-aux.it-codigo,
                                                INPUT tt-af-contr-indice-aux.nr-controle,
                                                INPUT tt-af-contr-indice-aux.dt-indice).
                     IF RETURN-VALUE = "OK":U THEN DO:
                         RUN setRecord    IN h-boaf008 (INPUT TABLE tt-af-contr-indice-aux).
                         RUN updateRecord IN h-boaf008.
                         RUN getRowErrors IN h-boaf008 (OUTPUT TABLE RowErrors).
                         IF CAN-FIND(FIRST RowErrors WHERE 
                                           RowErrors.ErrorType    <> "INTERNAL":U AND
                                           RowErrors.ErrorSubType =  "ERROR":U) THEN DO:
                                RUN pi-cria-erros (INPUT TABLE tt-af-contr-indice-aux).
                                CREATE tt-af-contr-indice-periodo.
                                BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice-periodo.
                         END.
                         ELSE DO: 
                             CREATE tt-af-contr-indice.
                             BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice.
                         END.
                     END.
                     ELSE DO:
                         EMPTY TEMP-TABLE RowErrors.
                         EMPTY TEMP-TABLE tt-af-contr-indice-aux.
                         RUN emptyRowErrors IN h-boaf008.
                         RUN emptyRowObject IN h-boaf008.
                         CREATE tt-af-contr-indice-aux.
                         BUFFER-COPY tt-af-contr-indice-atualiza EXCEPT dt-indice TO tt-af-contr-indice-aux.
                         ASSIGN tt-af-contr-indice-aux.dt-indice = d-dt-indice. 
                         RUN setRecord    IN h-boaf008 (INPUT TABLE tt-af-contr-indice-aux).
                         RUN createRecord IN h-boaf008.
                         RUN getRowErrors IN h-boaf008 (OUTPUT TABLE RowErrors).
                         IF CAN-FIND(FIRST RowErrors WHERE 
                                           RowErrors.ErrorType    <> "INTERNAL":U AND
                                           RowErrors.ErrorSubType =  "ERROR":U) THEN DO:
                                RUN pi-cria-erros (INPUT TABLE tt-af-contr-indice-aux).
                                CREATE tt-af-contr-indice-periodo.
                                BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice-periodo.
                         END.
                         ELSE DO: 
                             CREATE tt-af-contr-indice.
                             BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice.
                         END.
                     END.
               END.
    
           END.
    
       END.
    END.
    
    /*criaá∆o*/
    FOR EACH tt-af-contr-indice-nova:
       EMPTY TEMP-TABLE RowErrors.
       EMPTY TEMP-TABLE tt-af-contr-indice-aux.
       RUN emptyRowErrors IN h-boaf008.
       RUN emptyRowObject IN h-boaf008.
       CREATE tt-af-contr-indice-aux.
       BUFFER-COPY tt-af-contr-indice-nova TO tt-af-contr-indice-aux.
       RUN setRecord    IN h-boaf008 (INPUT TABLE tt-af-contr-indice-aux).
       RUN createRecord IN h-boaf008.
       RUN getRowErrors IN h-boaf008 (OUTPUT TABLE RowErrors).
       ASSIGN d-dt-indice = tt-af-contr-indice-nova.dt-indice.
       IF CAN-FIND(FIRST RowErrors WHERE 
                         RowErrors.ErrorType    <> "INTERNAL":U AND
                         RowErrors.ErrorSubType =  "ERROR":U) THEN RUN pi-cria-erros (INPUT TABLE tt-af-contr-indice-aux).
    
       ELSE IF tt-param.i-periodo > 1 THEN DO i-cont = 1 TO (tt-param.i-periodo - 1):

          IF MONTH(d-dt-indice) <= 11 THEN
             ASSIGN d-dt-indice = DATE("01/" + STRING(MONTH(d-dt-indice) + 1) + "/" + STRING(YEAR(d-dt-indice))).
          ELSE 
             ASSIGN d-dt-indice = DATE("01/" + "01/" + STRING(YEAR(d-dt-indice) + 1 )).
          IF NOT CAN-FIND (FIRST tt-af-contr-indice 
                           WHERE tt-af-contr-indice.ep-codigo    = tt-af-contr-indice-nova.ep-codigo
                             AND tt-af-contr-indice.nr-controle  = tt-af-contr-indice-nova.nr-controle
                             AND tt-af-contr-indice.dt-indice    = d-dt-indice
                             AND tt-af-contr-indice.it-codigo    = tt-af-contr-indice-nova.it-codigo
                             AND tt-af-contr-indice.cod-estabel  = tt-af-contr-indice-nova.cod-estabel
                             AND tt-af-contr-indice.cod-emitente = tt-af-contr-indice-nova.cod-emitente) THEN DO:
                 EMPTY TEMP-TABLE RowErrors.
                 EMPTY TEMP-TABLE tt-af-contr-indice-aux.
                 RUN emptyRowErrors IN h-boaf008.
                 RUN emptyRowObject IN h-boaf008.
                 CREATE tt-af-contr-indice-aux.
                 BUFFER-COPY tt-af-contr-indice-nova EXCEPT dt-indice TO tt-af-contr-indice-aux.
                 ASSIGN tt-af-contr-indice-aux.dt-indice = d-dt-indice. 
                 RUN setRecord    IN h-boaf008 (INPUT TABLE tt-af-contr-indice-aux).
                 RUN createRecord IN h-boaf008.
                 RUN getRowErrors IN h-boaf008 (OUTPUT TABLE RowErrors).
                 IF CAN-FIND(FIRST RowErrors WHERE 
                                   RowErrors.ErrorType    <> "INTERNAL":U AND
                                   RowErrors.ErrorSubType =  "ERROR":U) THEN DO:
                        RUN pi-cria-erros (INPUT TABLE tt-af-contr-indice-aux).
                        CREATE tt-af-contr-indice-periodo.
                        BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice-periodo.
                 END.
                 ELSE DO: 
                     CREATE tt-af-contr-indice.
                     BUFFER-COPY tt-af-contr-indice-aux TO tt-af-contr-indice.
                 END.
            END.
       END.
    END.
    
END. /* valid-handle */

/* Impress∆o */
IF todos = 1 THEN DO:
        
        FOR EACH tt-af-contr-indice NO-LOCK:

            IF NOT CAN-FIND(FIRST tt-af-contr-indice-erro  WHERE
                              tt-af-contr-indice-erro.ep-codigo    = tt-af-contr-indice.ep-codigo    
                          AND tt-af-contr-indice-erro.nr-controle  = tt-af-contr-indice.nr-controle  
                          AND tt-af-contr-indice-erro.dt-indice    = tt-af-contr-indice.dt-indice                     
                          AND tt-af-contr-indice-erro.it-codigo    = tt-af-contr-indice.it-codigo    
                          AND tt-af-contr-indice-erro.cod-estabel  = tt-af-contr-indice.cod-estabel  
                          AND tt-af-contr-indice-erro.cod-emitente = tt-af-contr-indice.cod-emitente) THEN DO:

                IF NOT l-cabec THEN DO:
                    ASSIGN l-imp = YES.
                    {utp/ut-liter.i "Itens Importados com Sucesso" *}
                    ASSIGN c-titulo = RETURN-VALUE.
                    {utp/ut-liter.i "Est Fornecedor  Ponto de Controle                       Per°odo Item                ÷ndice        Respons†vel" *}
                    ASSIGN c-label = RETURN-VALUE
                           c-traco = FILL("-",110).
        
                    PUT  c-titulo SKIP
                         c-traco  SKIP(1)
                         c-label  SKIP.
                    ASSIGN l-cabec = YES.
                END.
                
                ASSIGN c-des-controle = "".
                IF VALID-HANDLE(h-boaf008) THEN DO:
                   RUN goToKey  IN h-boaf008 (INPUT tt-af-contr-indice.cod-estabel,
                                              INPUT tt-af-contr-indice.cod-emitente,
                                              INPUT tt-af-contr-indice.it-codigo,
                                              INPUT tt-af-contr-indice.nr-controle,
                                              INPUT tt-af-contr-indice.dt-indice).

                   RUN getDesControle IN h-boaf008 (INPUT  tt-af-contr-indice.nr-controle,
                                                    OUTPUT c-des-controle).
                END.
                   
                ASSIGN c-periodo = STRING(MONTH(tt-af-contr-indice.dt-indice),"99") + "/" + STRING(YEAR(tt-af-contr-indice.dt-indice),"9999").

                DISP tt-af-contr-indice.cod-estabel 
                     tt-af-contr-indice.cod-emitente
                     tt-af-contr-indice.nr-controle 
                     c-des-controle 
                     c-periodo  
                     tt-af-contr-indice.it-codigo
                     tt-af-contr-indice.indice      
                     tt-af-contr-indice.usuar-alter WITH FRAME f-relat.
                     DOWN WITH FRAME f-relat.
            END.
        END.
    
        IF CAN-FIND(FIRST tt-af-contr-indice-erro) THEN DO:
                ASSIGN l-imp = YES.
                PUT SKIP(1).
                {utp/ut-liter.i "Itens com problemas" *}
                ASSIGN c-titulo-erro = RETURN-VALUE.
                {utp/ut-liter.i "Est Fornecedor  Ponto de Controle                       Per°odo Item" *}
                ASSIGN c-label-erro = RETURN-VALUE
                       c-traco = FILL("-",110).
    
                PUT  c-titulo-erro SKIP
                     c-traco       SKIP(1)
                     c-label-erro  SKIP  .

                FOR EACH tt-af-contr-indice-erro NO-LOCK 
                    WHERE tt-af-contr-indice-erro.l-erro = YES:
                    RUN pi-erro.
                END.

                FOR EACH tt-af-contr-indice NO-LOCK:
                    EMPTY TEMP-TABLE tt-af-contr-indice-aux.
                    RUN pi-imprime-erro (INPUT TABLE tt-af-contr-indice).
                    DELETE tt-af-contr-indice.
                END.
                FOR EACH tt-af-contr-indice-periodo NO-LOCK:
                    EMPTY TEMP-TABLE tt-af-contr-indice-aux.
                    RUN pi-imprime-erro (INPUT TABLE tt-af-contr-indice-periodo).
                    DELETE tt-af-contr-indice-periodo.
                END.
        END.
END.

ELSE DO:
    IF CAN-FIND(FIRST tt-af-contr-indice-erro) THEN DO:
            ASSIGN l-imp = YES.
            {utp/ut-liter.i "Itens com problemas" *}
            ASSIGN c-titulo-erro = RETURN-VALUE.
            {utp/ut-liter.i "Est Fornecedor  Ponto de Controle                       Per°odo Item" *}
            ASSIGN c-label-erro = RETURN-VALUE
                   c-traco = FILL("-",110).

            PUT  c-titulo-erro SKIP
                 c-traco       SKIP(1)
                 c-label-erro  SKIP.
    END.

    FOR EACH tt-af-contr-indice-erro NO-LOCK 
        WHERE tt-af-contr-indice-erro.l-erro = YES:
        RUN pi-erro.
    END.
    FOR EACH tt-af-contr-indice NO-LOCK:
        EMPTY TEMP-TABLE tt-af-contr-indice-aux.
        RUN pi-imprime-erro (INPUT TABLE tt-af-contr-indice).
        DELETE tt-af-contr-indice.
    END.
    FOR EACH tt-af-contr-indice-periodo NO-LOCK:
        EMPTY TEMP-TABLE tt-af-contr-indice-aux.
        RUN pi-imprime-erro (INPUT TABLE tt-af-contr-indice-periodo).
        DELETE tt-af-contr-indice-periodo.
    END.
END.

/*--- Arquivo de Registros Inconsistentes ---*/
IF CAN-FIND(FIRST tt-af-contr-indice-erro) THEN DO:
   OUTPUT STREAM s-erros TO VALUE(tt-param.arq-erro).
        FOR EACH tt-af-contr-indice-erro:
    
            PUT STREAM s-erros UNFORMATTED
                tt-af-contr-indice-erro.cod-estabel      ";"
                tt-af-contr-indice-erro.cod-emitente     ";"
                tt-af-contr-indice-erro.nr-controle      ";"
                tt-af-contr-indice-erro.dt-indice FORMAT "99/99/9999" ";"
                tt-af-contr-indice-erro.it-codigo        ";"
                tt-af-contr-indice-erro.indice           ";"
                tt-af-contr-indice-erro.seq-resultado    ";"
                tt-af-contr-indice-erro.usuar-alter      ";"
                tt-af-contr-indice-erro.narrativa        ";" SKIP.
        END.
   OUTPUT STREAM s-erros CLOSE.
END.

IF VALID-HANDLE(h-boaf006) THEN DO:
    DELETE PROCEDURE h-boaf006.
    ASSIGN h-boaf006 = ?.
END.

IF VALID-HANDLE(h-boaf008) THEN DO:
    DELETE PROCEDURE h-boaf008.
    ASSIGN h-boaf008 = ?.
END.

IF VALID-HANDLE(h-boaf023) THEN DO:
    DELETE PROCEDURE h-boaf023.
    ASSIGN h-boaf023 = ?.
END.

RUN pi-finalizar IN h-acomp.

IF l-imp THEN PAGE.

/* Folder ParÉmetros */
 DISP tt-param.arq-entrada 
      tt-param.arq-erro 
      tt-param.i-periodo
      WITH FRAME f-param. 

/* Folder Impress∆o */
 DISP c-imprime
      c-destino
      tt-param.arquivo
      tt-param.usuario     
      c-execucao WITH FRAME f-impressao.

{include/i-rpclo.i}

RETURN "OK":U.


/* Procedure cria erros */
PROCEDURE pi-cria-erros:

   DEF INPUT PARAM TABLE FOR tt-af-contr-indice-aux.
   FIND FIRST tt-af-contr-indice-aux NO-ERROR.

   FOR EACH RowErrors WHERE 
            RowErrors.ErrorType    <> "INTERNAL":U AND
            RowErrors.ErrorSubType =  "ERROR":U :

       CREATE tt-af-contr-indice-erro.
       ASSIGN tt-af-contr-indice-erro.num-erro      = RowErrors.ErrorNumber
              tt-af-contr-indice-erro.desc-erro     = RowErrors.ErrorDescription
              tt-af-contr-indice-erro.ep-codigo     = tt-af-contr-indice-aux.ep-codigo
              tt-af-contr-indice-erro.cod-estabel   = tt-af-contr-indice-aux.cod-estabel 
              tt-af-contr-indice-erro.cod-emitente  = tt-af-contr-indice-aux.cod-emitente
              tt-af-contr-indice-erro.nr-controle   = tt-af-contr-indice-aux.nr-controle 
              tt-af-contr-indice-erro.it-codigo     = tt-af-contr-indice-aux.it-codigo
              tt-af-contr-indice-erro.dt-indice     = tt-af-contr-indice-aux.dt-indice   
              tt-af-contr-indice-erro.indice        = tt-af-contr-indice-aux.indice      
              tt-af-contr-indice-erro.seq-resultado = tt-af-contr-indice-aux.seq-resultado
              tt-af-contr-indice-erro.usuar-alter   = tt-af-contr-indice-aux.usuar-alter 
              tt-af-contr-indice-erro.narrativa     = tt-af-contr-indice-aux.narrativa.
   END.
   
   RETURN "OK":U.

END PROCEDURE.

/* Procedure Imprime erro */
PROCEDURE pi-imprime-erro:

    DEF INPUT PARAM TABLE FOR tt-af-contr-indice-aux.

    FIND FIRST tt-af-contr-indice-aux NO-LOCK NO-ERROR.

     IF CAN-FIND(FIRST tt-af-contr-indice-erro  WHERE
                       tt-af-contr-indice-erro.ep-codigo    = tt-af-contr-indice-aux.ep-codigo    
                   AND tt-af-contr-indice-erro.nr-controle  = tt-af-contr-indice-aux.nr-controle  
                   AND tt-af-contr-indice-erro.dt-indice    = tt-af-contr-indice-aux.dt-indice                     
                   AND tt-af-contr-indice-erro.it-codigo    = tt-af-contr-indice-aux.it-codigo    
                   AND tt-af-contr-indice-erro.cod-estabel  = tt-af-contr-indice-aux.cod-estabel  
                   AND tt-af-contr-indice-erro.cod-emitente = tt-af-contr-indice-aux.cod-emitente) THEN DO:

         ASSIGN c-des-controle = "".
         IF VALID-HANDLE(h-boaf008) THEN DO:
            RUN goToKey  IN h-boaf008 (INPUT tt-af-contr-indice-aux.cod-estabel,
                                       INPUT tt-af-contr-indice-aux.cod-emitente,
                                       INPUT tt-af-contr-indice-aux.it-codigo,
                                       INPUT tt-af-contr-indice-aux.nr-controle,
                                       INPUT tt-af-contr-indice-aux.dt-indice).

            RUN getDesControle IN h-boaf008 (INPUT  tt-af-contr-indice-aux.nr-controle,
                                             OUTPUT c-des-controle).
         END.

         ASSIGN c-periodo = STRING(MONTH(tt-af-contr-indice-aux.dt-indice),"99") + "/" + STRING(YEAR(tt-af-contr-indice-aux.dt-indice),"9999").

         DISP tt-af-contr-indice-aux.cod-estabel AT 1
              tt-af-contr-indice-aux.cod-emitente
              tt-af-contr-indice-aux.nr-controle 
              c-des-controle 
              c-periodo      
              tt-af-contr-indice-aux.it-codigo WITH FRAME f-relat-erro.
         DOWN WITH FRAME f-relat-erro.
     END.

     FOR EACH tt-af-contr-indice-erro  WHERE
              tt-af-contr-indice-erro.ep-codigo    = tt-af-contr-indice-aux.ep-codigo
          AND tt-af-contr-indice-erro.nr-controle  = tt-af-contr-indice-aux.nr-controle
          AND tt-af-contr-indice-erro.dt-indice    = tt-af-contr-indice-aux.dt-indice
          AND tt-af-contr-indice-erro.it-codigo    = tt-af-contr-indice-aux.it-codigo
          AND tt-af-contr-indice-erro.cod-estabel  = tt-af-contr-indice-aux.cod-estabel
          AND tt-af-contr-indice-erro.cod-emitente = tt-af-contr-indice-aux.cod-emitente :

         DISP tt-af-contr-indice-erro.num-erro
              tt-af-contr-indice-erro.desc-erro WITH FRAME f-relat-erro-2.
              DOWN WITH FRAME f-relat-erro-2.
     END.
     PUT SKIP (1).

   RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-erro:

     IF CAN-FIND(FIRST tt-af-contr-indice  WHERE
                       tt-af-contr-indice.ep-codigo    = tt-af-contr-indice-erro.ep-codigo    
                   AND tt-af-contr-indice.nr-controle  = tt-af-contr-indice-erro.nr-controle  
                   AND tt-af-contr-indice.dt-indice    = tt-af-contr-indice-erro.dt-indice                     
                   AND tt-af-contr-indice.it-codigo    = tt-af-contr-indice-erro.it-codigo    
                   AND tt-af-contr-indice.cod-estabel  = tt-af-contr-indice-erro.cod-estabel  
                   AND tt-af-contr-indice.cod-emitente = tt-af-contr-indice-erro.cod-emitente) THEN DO:

         ASSIGN c-des-controle = "".
         IF VALID-HANDLE(h-boaf008) THEN DO:
            RUN goToKey  IN h-boaf008 (INPUT tt-af-contr-indice-erro.cod-estabel,
                                       INPUT tt-af-contr-indice-erro.cod-emitente,
                                       INPUT tt-af-contr-indice-erro.it-codigo,
                                       INPUT tt-af-contr-indice-erro.nr-controle,
                                       INPUT tt-af-contr-indice-erro.dt-indice).
    
            RUN getDesControle IN h-boaf008 (INPUT  tt-af-contr-indice-erro.nr-controle,
                                             OUTPUT c-des-controle).
         END.
    
         ASSIGN c-periodo = STRING(MONTH(tt-af-contr-indice-erro.dt-indice),"99") + "/" + STRING(YEAR(tt-af-contr-indice-erro.dt-indice),"9999").
    
         DISP tt-af-contr-indice-erro.cod-estabel AT 1
              tt-af-contr-indice-erro.cod-emitente
              tt-af-contr-indice-erro.nr-controle 
              c-des-controle 
              c-periodo      
              tt-af-contr-indice-erro.it-codigo WITH FRAME f-relat-erro.
         DOWN WITH FRAME f-relat-erro.
    
         DISP tt-af-contr-indice-erro.num-erro
              tt-af-contr-indice-erro.desc-erro WITH FRAME f-relat-erro-2.
              DOWN WITH FRAME f-relat-erro-2.
     END.
     PUT SKIP (1).

   RETURN "OK":U.
END PROCEDURE.


