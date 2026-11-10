/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0329RP 2.00.00.001 } /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0329RP MAQ}
&ENDIF

/*******************************************************************************
**
**   Programa: AQ0329
**
**   Data....: Maio 2018
**
**   Objetivo: Gera formul rio de coleta listando produtores por rota
**
*******************************************************************************/

/* Parameters Definitions ---                                           */
{aqp/aq0329.i} /*temp-tables*/
{utp/ut-glob.i}

DEFINE VARIABLE h-acomp          AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE c-lb-impr        AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lb-dest        AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lb-usuar       AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lb-estabel     AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lb-dt-coleta   AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-lb-motorista   AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-cod-propried   LIKE propried-rural.cod-propried NO-UNDO.
DEFINE VARIABLE c-estabelec      AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-rota           AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-fill           AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-linha          AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-volume         AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-amost          AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-temp           AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-volume-coleta  AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-faltas         AS   CHARACTER                   NO-UNDO.

{include/i-rpvar.i}

{utp/ut-liter.i Produtores_Ponto_de_Coleta *}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i Gerando_Relat¢rio *}
RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

ASSIGN c-empresa   = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa  = "AQ0329".

{include/i-rpcb80.i}
{include/i-rpout.i}

VIEW FRAME f-cabec-80.
VIEW FRAME f-rodape-80.

FORM c-estabelec          FORMAT "X(60)":U   
     tt-param.dt-coleta   FORMAT "99/99/9999"
     tt-param.c-motorista FORMAT "X(60)":U   
     c-rota               FORMAT "X(60)":U   
     WITH 1 COL NO-BOX WIDTH 85 STREAM-IO FRAME f-rota.

FORM tt-digita.cod-pto-coleta
     tt-digita.cdn-produt-rural
     tt-digita.nome-emit FORMAT "X(27)":U
     c-volume            FORMAT "X(08)":U
     c-amost             FORMAT "X(08)":U
     c-temp              FORMAT "X(06)":U
     WITH DOWN NO-BOX WIDTH 85 STREAM-IO FRAME f-importadas.

FORM c-volume-coleta FORMAT "X(15)":U AT 5
     c-faltas        FORMAT "X(15)":U AT 45
     WITH 2 COL NO-BOX WIDTH 85 STREAM-IO FRAME f-total.

{utp/ut-liter.i "Estabelecimento"}
ASSIGN c-estabelec:LABEL IN FRAME f-rota = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Data"}
ASSIGN tt-param.dt-coleta:LABEL IN FRAME f-rota = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Motorista"}
ASSIGN tt-param.c-motorista:LABEL IN FRAME f-rota = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Rota"}
ASSIGN c-rota:LABEL IN FRAME f-rota = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Volume"}
ASSIGN c-volume:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Amostra"}
ASSIGN c-amost:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Temp."}
ASSIGN c-temp:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Produtor"}
ASSIGN tt-digita.cdn-produt-rural:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Nome_Produtor"}
ASSIGN tt-digita.nome-emit:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Pto_Coleta"}
ASSIGN tt-digita.cod-pto-coleta:LABEL IN FRAME f-importadas = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Volume_Coleta"}
ASSIGN c-volume-coleta:LABEL IN FRAME f-total = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Faltas"}
ASSIGN c-faltas:LABEL IN FRAME f-total = TRIM(RETURN-VALUE).

FIND FIRST estabelec NO-LOCK
     WHERE estabelec.cod-estabel = tt-param.cod-estabel NO-ERROR.

IF AVAIL estabelec THEN
    ASSIGN c-estabelec = estabelec.cod-estabel + " - " + estabelec.nome.

ASSIGN c-linha         = FILL("-",12) + " " +
                         FILL("-",14) + " " +
                         FILL("-",27) + "|" +
                         FILL("-",08) + "|" +
                         FILL("-",08) + "|" +
                         FILL("-",06)
       c-volume-coleta = FILL("_",15)
       c-faltas        = FILL("_",15).

FOR EACH tt-digita
BREAK BY tt-digita.cod-rota
      BY tt-digita.cdn-seq
      BY tt-digita.cod-pto-coleta
      BY tt-digita.cdn-produt-rural:

    IF FIRST-OF(tt-digita.cod-rota) THEN DO:

        FIND FIRST rota-coleta NO-LOCK
             WHERE rota-coleta.cod-rota = tt-digita.cod-rota NO-ERROR.

        IF AVAIL rota-coleta THEN
            ASSIGN c-rota = rota-coleta.cod-rota + " - " + rota-coleta.des-rota.
        ELSE
            ASSIGN c-rota = "".

        DISP c-estabelec
             tt-param.dt-coleta
             tt-param.c-motorista
             c-rota
             WITH STREAM-IO FRAME f-rota.

        PUT UNFORMATTED FILL("-",80) SKIP.
    END.

    DISP tt-digita.cod-pto-coleta
         tt-digita.cdn-produt-rural
         tt-digita.nome-emit
              WITH STREAM-IO FRAME f-importadas.
         DOWN WITH STREAM-IO FRAME f-importadas.

    PUT UNFORMATTED c-linha SKIP.

    IF LAST-OF(tt-digita.cod-rota) THEN DO:

        PUT UNFORMATTED SKIP(2).

        DISP c-volume-coleta
             c-faltas
             WITH STREAM-IO FRAME f-total.

        PAGE.
    END.
END.

{utp/ut-liter.i IMPRESSÇO * r}
assign c-lb-impr = trim(return-value).
{utp/ut-liter.i Destino * r}
assign c-lb-dest = trim(return-value).
{utp/ut-liter.i Usu rio * r}
assign c-lb-usuar = trim(return-value).
{utp/ut-liter.i Estabelecimento * r}
assign c-lb-estabel = trim(return-value).
{utp/ut-liter.i Data * r}
assign c-lb-dt-coleta = trim(return-value).
{utp/ut-liter.i Motorista * r}
assign c-lb-motorista = trim(return-value).

PUT UNFORMATTED SKIP(3)
    c-lb-impr               SKIP(1)
    c-lb-dest               AT 5  ": "  AT 21  tt-param.destino " - " tt-param.arquivo
    c-lb-usuar              AT 5  ": "  AT 21  tt-param.usuario 
    c-lb-estabel            AT 5  ": "  AT 21  tt-param.cod-estabel       
    c-lb-dt-coleta          AT 5  ": "  AT 21  tt-param.dt-coleta        
    c-lb-motorista          AT 5  ": "  AT 21  tt-param.c-motorista.

{include/i-rpclo.i}

IF  h-acomp <> ? THEN DO:
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    
END.

RETURN "OK":U.
