/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0507RP 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0507RP MAQ}
&ENDIF

/******************************************************************************
**  Programa: AQ0507RP
**  Data....: MAIO de 2016
**  Objetivo: - Eliminaá∆o Cargas e Resumos
**  Versao..:  2.00.00.001
******************************************************************************/
{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{method/dbotterr.i}

/** DEFINIÄ«O DE BOÔs UTILIZADAS NO PROGRAMA **/
{cdp/cd9701.i}

/** DEFINIÄ«O DE TEMP-TABLES LOCAIS **/
DEF TEMP-TABLE tt-param  NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHAR FORMAT "x(35)":U
    FIELD usuario           AS CHAR FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD classifica        AS INTEGER
    FIELD desc-classifica   AS CHAR FORMAT "x(40)":U
    FIELD modelo            AS CHAR FORMAT "x(35)":U
    FIELD l-habilitaRtf     AS LOG
    FIELD cod-estab-ini     AS CHAR FORMAT "x(5)":U
    FIELD cod-estab-fim     AS CHAR FORMAT "x(5)":U
    FIELD dt-periodo-ini    AS DATE FORMAT "99/99/9999":U
    FIELD dt-periodo-fim    AS DATE FORMAT "99/99/9999":U
    FIELD tg-elimina-resumo AS LOGICAL.

DEF TEMP-TABLE tt-naoEliminados NO-UNDO
    FIELD cd-estabel AS CHAR FORMAT "x(05)"
    FIELD ds-estabel AS CHAR FORMAT "x(40)"
    FIELD dt-fechto  AS DATE FORMAT "99/99/9999"
    INDEX idx cd-estabel dt-fechto.

DEF TEMP-TABLE tt-raw-digita                   
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-carg-rural-del NO-UNDO
    FIELD num-carga   LIKE carg-rural.num-carg
    FIELD cod-carga   LIKE carg-rural.cod-carga
    FIELD cod-estabel LIKE carg-rural.cod-estabel
    FIELD dat-trans   LIKE carg-rural.dat-trans
    FIELD it-codigo   LIKE carg-rural.it-codigo
    FIELD cod-placa   LIKE carg-rural.cod-placa
    FIELD cod-rota    LIKE carg-rural.cod-rota
    FIELD cod-transp  LIKE carg-rural.cod-transp
    FIELD nom-transp  AS CHARACTER.

DEF TEMP-TABLE tt-fechto-produt-period-del NO-UNDO
    FIELD cod-estabel      LIKE fechto-produt-period.cod-estabel
    FIELD cod-period       LIKE fechto-produt-period.cod-period
    FIELD it-codigo        LIKE fechto-produt-period.it-codigo
    FIELD cdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural
    FIELD nome-produtor    AS CHARACTER
    FIELD cod-propried     LIKE fechto-produt-period.cod-propried
    FIELD qtd-period       LIKE fechto-produt-period.qtd-period.


/** DEFINIÄ«O DE BUFFERS LOCAIS **/


/** DEFINIÄ«O DE VARIµVEIS LOCAIS **/
DEFINE VARIABLE c-titulo-p    AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE c-destino     AS CHARACTER FORMAT "x(20)" NO-UNDO.             
DEFINE VARIABLE cMsg          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-return      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE dataAux       AS DATE                     NO-UNDO.
DEFINE VARIABLE periodoAux    AS CHAR                     NO-UNDO.
DEFINE VARIABLE nome-produtor AS CHARACTER                NO-UNDO.
DEFINE VARIABLE nome-transp   AS CHARACTER                NO-UNDO.

DEFINE VARIABLE h-acomp               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin00961           AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin287             AS HANDLE                           NO-UNDO.

/** IMPRESS«O DE PARAMETROS EM TELA **/
DEFINE VARIABLE c-lb-impr        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-dest        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-usuar       AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-sel         AS CHAR NO-UNDO.
DEFINE VARIABLE c-msg            AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-par         AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-estabel     AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-period      AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-resumo      AS CHAR NO-UNDO.

/** DEFINIÄ«O DE VARIµVEIS LOCAIS **/
DEFINE VARIABLE da-ult-fech-dia AS DATE FORMAT "99/99/9999" NO-UNDO.

RUN utp/ut-acomp.p   PERSISTENT SET h-acomp.
RUN inbo/boin00961.p PERSISTENT SET h-boin00961.
RUN inbo/boin287.p   PERSISTENT SET h-boin287.

FORM tt-carg-rural-del.num-carga        COLUMN-LABEL "Carga" 
     tt-carg-rural-del.cod-carga        COLUMN-LABEL "C¢digo" FORMAT "x(15)"
     tt-carg-rural-del.cod-estabel      COLUMN-LABEL "Estab"  FORMAT "x(05)"
     tt-carg-rural-del.dat-trans        COLUMN-LABEL "Data"   FORMAT 99/99/9999
     tt-carg-rural-del.it-codigo        COLUMN-LABEL "Item"   FORMAT "x(16)"
     tt-carg-rural-del.cod-placa        COLUMN-LABEL "Placa"  FORMAT "x(10)"
     tt-carg-rural-del.cod-rota         COLUMN-LABEL "Rota"   FORMAT "x(12)"
     tt-carg-rural-del.cod-transp       COLUMN-LABEL "Transp" 
     tt-carg-rural-del.nom-transp       COLUMN-LABEL "Nome Transp" FORMAT "x(36)"
     WITH WIDTH 132 FRAME f-concluidos-a STREAM-IO.
     RUN utp/ut-trfrrp.p (INPUT FRAME f-concluidos-a:HANDLE).

FORM tt-fechto-produt-period-del.cod-estabel      COLUMN-LABEL "Estab"
     tt-fechto-produt-period-del.cod-period       COLUMN-LABEL "Per°odo"
     tt-fechto-produt-period-del.it-codigo        COLUMN-LABEL "Item"          FORMAT "x(16)"
     tt-fechto-produt-period-del.cdn-produt-rural COLUMN-LABEL "Produtor"
     tt-fechto-produt-period-del.nome-produtor    COLUMN-LABEL "Nome Produtor" FORMAT "x(36)"
     tt-fechto-produt-period-del.cod-propried     COLUMN-LABEL "Propriedade"   FORMAT "x(30)"
     tt-fechto-produt-period-del.qtd-period       COLUMN-LABEL "Quantidade" 
     WITH WIDTH 132 FRAME f-concluidos-b STREAM-IO.
     RUN utp/ut-trfrrp.p (INPUT FRAME f-concluidos-b:HANDLE).

FORM tt-naoEliminados.cd-estab      COLUMN-LABEL "Estab"
     tt-naoEliminados.ds-estab      COLUMN-LABEL "Nome"
     tt-naoEliminados.dt-fechto     COLUMN-LABEL "Èltimo dia fechado"
     WITH WIDTH 132 FRAME f-naoEliminados STREAM-IO.
     RUN utp/ut-trfrrp.p (INPUT FRAME f-naoEliminados:HANDLE).

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FORM SKIP(2)
     c-titulo-p       NO-LABEL COLON 14 SKIP(1)
     c-destino                 COLON 20
     tt-param.arquivo NO-LABEL          SKIP(1)
     tt-param.usuario          COLON 20 SKIP(1)
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao. 
     RUN utp/ut-trfrrp.p (INPUT FRAME f-impressao:HANDLE).

{include/i-rpvar.i}

{utp/ut-liter.i Impress∆o_: *}
ASSIGN c-titulo-p = RETURN-VALUE.
{utp/ut-liter.i Destino *}
ASSIGN c-destino:LABEL IN FRAME f-impressao = RETURN-VALUE.
{utp/ut-liter.i Usu†rio *}
ASSIGN tt-param.usuario:LABEL IN FRAME f-impressao = RETURN-VALUE.          

FIND FIRST param-global NO-LOCK NO-ERROR.
  IF AVAIL param-global THEN
    ASSIGN c-empresa  = param-global.grupo.
    
{utp/ut-liter.i Eliminaá∆o_de_Cargas AQR}
ASSIGN c-titulo-relat = RETURN-VALUE.

{utp/ut-liter.i MATERIAIS aqr}  
ASSIGN c-programa     = "aqr0325"
       c-versao       = "I.00"
       c-revisao      = "002"
       c-sistema      = RETURN-VALUE.

{include/i-rpcab.i}
{include/i-rpout.i}

RUN pi-inicializar IN h-acomp (INPUT "").

FIND FIRST tt-param NO-LOCK NO-ERROR.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

EMPTY TEMP-TABLE tt-carg-rural-del.
EMPTY TEMP-TABLE tt-fechto-produt-period-del.
EMPTY TEMP-TABLE tt-naoEliminados.

/************** Regras **************/
blk_carga:
FOR EACH estabelec NO-LOCK
   WHERE estabelec.cod-estabel >= tt-param.cod-estab-ini
     AND estabelec.cod-estabel <= tt-param.cod-estab-fim:

  ASSIGN dataAux = tt-param.dt-periodo-ini.

  RUN returnDataFechto IN h-boin287 (INPUT estabelec.cod-estabel,
                                    OUTPUT da-ult-fech-dia).
  blk_data:
  DO dataAux = tt-param.dt-periodo-ini TO tt-param.dt-periodo-fim:

    IF dataAux > da-ult-fech-dia THEN DO:
      FIND FIRST tt-naoEliminados
           WHERE tt-naoEliminados.cd-estabel = estabelec.cod-estabel
             AND tt-naoEliminados.dt-fechto  = da-ult-fech-dia NO-ERROR.
      IF NOT AVAIL tt-naoEliminados THEN DO:
        CREATE tt-naoEliminados.
        ASSIGN tt-naoEliminados.cd-estabel = estabelec.cod-estabel
               tt-naoEliminados.ds-estabel = estabelec.nome WHEN AVAIL estabelec
               tt-naoEliminados.dt-fechto  = da-ult-fech-dia.
      END.
      NEXT blk_data.
    END.

    FOR EACH carg-rural EXCLUSIVE-LOCK
       WHERE carg-rural.cod-estabel = estabelec.cod-estabel
         AND carg-rural.dat-trans   = dataAux:

       /* Pesagem */    
       FOR EACH pesagem FIELDS(num-carg) EXCLUSIVE-LOCK
          WHERE pesagem.num-carg = carg-rural.num-carg.
         DELETE pesagem.
       END.
       
       /* liber-carg */
       FOR EACH liber-carg FIELDS(num-carg) EXCLUSIVE-LOCK
          WHERE liber-carg.num-carg = carg-rural.num-carg.
         DELETE liber-carg.
       END.
       
       /* produt-carg*/
       FOR EACH produt-carg FIELDS(num-carg) EXCLUSIVE-LOCK
          WHERE produt-carg.num-carg = carg-rural.num-carg.
         DELETE produt-carg.
       END.
       
       /* alter-produt-carg */
       FOR EACH alter-produt-carg FIELDS(num-carg) EXCLUSIVE-LOCK
          WHERE alter-produt-carg.num-carg = carg-rural.num-carg.
         DELETE alter-produt-carg.
       END.
       
       FOR EACH naocfedade-carg FIELDS (num-carg) EXCLUSIVE-LOCK
          WHERE naocfedade-carg.num-carg = carg-rural.num-carg:
         FOR EACH histor-naocfedade OF naocfedade-carg EXCLUSIVE-LOCK:
             DELETE histor-naocfedade.
         END.
         FOR EACH dest-cust-naocfedade OF naocfedade-carg EXCLUSIVE-LOCK:
             DELETE dest-cust-naocfedade.
         END.
         DELETE naocfedade-carg.
       END.
       ASSIGN nome-transp = "".
       FOR FIRST transporte FIELDS(nome) NO-LOCK
           WHERE transporte.cod-transp = carg-rural.cod-transp:
          ASSIGN nome-transp = transporte.nome.
       END.

       CREATE tt-carg-rural-del.
       ASSIGN tt-carg-rural-del.num-carga   = carg-rural.num-carg
              tt-carg-rural-del.cod-carga   = carg-rural.cod-carga
              tt-carg-rural-del.cod-estabel = carg-rural.cod-estabel
              tt-carg-rural-del.dat-trans   = carg-rural.dat-trans
              tt-carg-rural-del.it-codigo   = carg-rural.it-codigo
              tt-carg-rural-del.cod-placa   = carg-rural.cod-placa
              tt-carg-rural-del.cod-rota    = carg-rural.cod-rota
              tt-carg-rural-del.cod-transp  = carg-rural.cod-transp
              tt-carg-rural-del.nom-transp  = nome-transp.

       DELETE carg-rural.

    END.

    IF tt-param.tg-elimina-resumo THEN DO:

      ASSIGN periodoAux = STRING(MONTH(dataAux), "99") + STRING(YEAR(dataAux)).

      FOR EACH fechto-qualid EXCLUSIVE-LOCK
         WHERE fechto-qualid.cod-estabel = estabelec.cod-estabel
           AND fechto-qualid.cod-period  = periodoAux:
        DELETE fechto-qualid.
      END.

      FOR EACH fechto-produt-period EXCLUSIVE-LOCK
         WHERE fechto-produt-period.cod-estabel = estabelec.cod-estabel
           AND fechto-produt-period.cod-period  = periodoAux:


          ASSIGN nome-produtor = "".
          FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
              WHERE emitente.cod-emitente = fechto-produt-period.cdn-produt-rural:
             ASSIGN nome-produtor = emitente.nome-emit.
          END.

        CREATE tt-fechto-produt-period-del.
        ASSIGN tt-fechto-produt-period-del.cod-estabel      = fechto-produt-period.cod-estabel
               tt-fechto-produt-period-del.cod-period       = fechto-produt-period.cod-period
               tt-fechto-produt-period-del.it-codigo        = fechto-produt-period.it-codigo
               tt-fechto-produt-period-del.cdn-produt-rural = fechto-produt-period.cdn-produt-rural
               tt-fechto-produt-period-del.nome-produtor    = nome-produtor
               tt-fechto-produt-period-del.cod-propried     = fechto-produt-period.cod-propried
               tt-fechto-produt-period-del.qtd-period       = fechto-produt-period.qtd-period.
        DELETE fechto-produt-period.
      END.

      FOR EACH nf-produt-propried EXCLUSIVE-LOCK
         WHERE nf-produt-propried.cod-estabel = estabelec.cod-estabel
           AND nf-produt-propried.cod-period  = periodoAux:
        DELETE nf-produt-propried.
      END.

    END.
  END.
END.

/************** Imprime Resultado  **************/
FOR FIRST tt-carg-rural-del:
  {utp/ut-liter.i Cargas * r}
  ASSIGN cMsg = TRIM(RETURN-VALUE).
  PUT UNFORM "*** " + cMsg + " ***".
END.

FOR EACH tt-carg-rural-del:
  DISP tt-carg-rural-del.num-carga  
       tt-carg-rural-del.cod-carga  
       tt-carg-rural-del.cod-estabel
       tt-carg-rural-del.dat-trans  
       tt-carg-rural-del.it-codigo  
       tt-carg-rural-del.cod-placa  
       tt-carg-rural-del.cod-rota   
       tt-carg-rural-del.cod-transp 
       tt-carg-rural-del.nom-transp 
       WITH DOWN FRAME f-concluidos-a.
       DOWN WITH FRAME f-concluidos-a.
END.

FOR FIRST tt-fechto-produt-period-del:
  PUT SKIP(1).
  {utp/ut-liter.i Resumos * r}
  ASSIGN cMsg = TRIM(RETURN-VALUE).
  PUT UNFORM "*** " + cMsg + " ***".
END.

FOR EACH tt-fechto-produt-period-del:
  DISP tt-fechto-produt-period-del.cod-estabel
       tt-fechto-produt-period-del.cod-period
       tt-fechto-produt-period-del.it-codigo
       tt-fechto-produt-period-del.cdn-produt-rural
       tt-fechto-produt-period-del.nome-produtor
       tt-fechto-produt-period-del.cod-propried
       tt-fechto-produt-period-del.qtd-period
       WITH DOWN FRAME f-concluidos-b.
       DOWN WITH FRAME f-concluidos-b.
END.

FOR FIRST tt-naoEliminados:
  PUT SKIP(3).
  {utp/ut-liter.i Data_de_Fechamento_do_Estoque_por_Estabelecimento * r}
  ASSIGN cMsg = TRIM(RETURN-VALUE).
  PUT UNFORM "*** " + cMsg + " ***".
END.

FOR EACH tt-naoEliminados:
  DISP tt-naoEliminados.cd-estabel
       tt-naoEliminados.ds-estabel
       tt-naoEliminados.dt-fechto
       WITH DOWN FRAME f-naoEliminados.
       DOWN WITH FRAME f-naoEliminados.
END.

PUT SKIP(1).
{utp/ut-liter.i Importante:_Cargas_e_Resumos_com_Data_de_transaá∆o_acima_do_Èltimo_dia_fechado_do_estoque_n∆o_foram_eliminadas. * r}
ASSIGN cMsg = TRIM(RETURN-VALUE).
PUT UNFORM cMsg.

/************** Imprime Parametros **************/
{utp/ut-liter.i SELEÄ«O: * r}
ASSIGN c-lb-sel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento * r}
ASSIGN c-lb-estabel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Per°odo * r}
ASSIGN c-lb-period = TRIM(RETURN-VALUE).

{utp/ut-liter.i PAR∂METROS: * r}
ASSIGN c-lb-par = TRIM(RETURN-VALUE).
{utp/ut-liter.i Elimina_Resumos * r}
ASSIGN c-lb-resumo = TRIM(RETURN-VALUE).

{utp/ut-liter.i IMPRESS«O: * r}
ASSIGN c-lb-impr = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * r}
ASSIGN c-lb-dest = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu†rio * r}
ASSIGN c-lb-usuar = TRIM(RETURN-VALUE).

PUT UNFORMATTED SKIP(3)
    c-lb-sel                SKIP(1)
    c-lb-estabel            AT 5  ": " tt-param.cod-estab-ini     AT 24 "|<  >| " AT 32 tt-param.cod-estab-fim
    c-lb-period             AT 5  ": " STRING(MONTH(tt-param.dt-periodo-ini), "99") + "/" + STRING(YEAR(tt-param.dt-periodo-ini), "9999")    AT 24 "|<  >| " AT 32
                                       STRING(MONTH(tt-param.dt-periodo-fim), "99") + "/" + STRING(YEAR(tt-param.dt-periodo-fim), "9999").

PUT UNFORMATTED SKIP(1)
    c-lb-par                SKIP(1)
    c-lb-resumo             AT 5  ": " STRING(tt-param.tg-elimina-resumo, "Sim/N∆o") AT 24.

PUT UNFORMATTED SKIP(1)
    c-lb-impr               SKIP(1)
    c-lb-dest               AT 5  ": " tt-param.destino " - " tt-param.arquivo
    c-lb-usuar              AT 5  ": " tt-param.usuario SKIP(1).

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-boin00961) THEN
  DELETE PROCEDURE h-boin00961.

RETURN "OK".
