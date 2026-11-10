/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0325RP 2.00.00.019 } /*** "010019" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0325RP MAQ}
&ENDIF

/******************************************************************************
**
**  Programa: AQ0325RP
**
**  Data....: MAIO de 2016
**
**  Objetivo: Eliminaá∆o de Notas Fiscais
**
**  Versao..:  2.00.00.001
**         
******************************************************************************/

{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{method/dbotterr.i}

/** DEFINIÄ«O DE BOÔs UTILIZADAS NO PROGRAMA **/
{inbo/boin176.i   tt-item-doc-est}    
{cdp/cd9701.i}

/** DEFINIÄ«O DE TEMP-TABLES LOCAIS **/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHAR FORMAT "x(35)":U
    FIELD usuario            AS CHAR FORMAT "x(12)":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD classifica         AS INTEGER
    FIELD desc-classifica    AS CHAR FORMAT "x(40)":U
    FIELD modelo             AS CHAR FORMAT "x(35)":U
    FIELD l-habilitaRtf      as LOG
    FIELD regiao-ini         as char format "x(12)":U
    FIELD regiao-fim         as char format "x(12)":U
    FIELD rota-ini           as char format "x(12)":U
    FIELD rota-fim           as char format "x(12)":U
    FIELD grp-prod-ini       AS INTEGER
    FIELD grp-prod-fim       AS INTEGER
    FIELD propried-ini       AS CHARACTER
    FIELD propried-fim       AS CHARACTER
    FIELD prod-rural-ini     AS INTEGER
    FIELD prod-rural-fim     AS INTEGER
    FIELD cod-estabel        AS CHAR FORMAT "x(5)":U
    FIELD cod-periodo        AS CHAR FORMAT "99/9999"
    FIELD cod-serie          AS CHAR FORMAT "x(5)":U
    FIELD dt-emissao         AS DATE FORMAT "99/99/9999"
    FIELD it-codigo          AS CHAR FORMAT "X(16)":U
    FIELD nat-operacao       AS CHAR FORMAT "X(6)":U
    FIELD elimina-nota       AS LOG
    FIELD elimina-nota-compl AS LOG.
/*Fim alteracao 15/02/2005*/

DEF TEMP-TABLE tt-digita NO-UNDO
    FIELD cdn-produt   AS INTEGER FORMAT ">>>,>>>,>>9"      
    FIELD nom-produt   AS CHARACTER                              
    FIELD cod-propried AS CHARACTER FORMAT "X(16)"
    FIELD des-propried AS CHARACTER FORMAT "X(60)"
    INDEX id cdn-produt.
 
DEF TEMP-TABLE tt-raw-digita                   
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-erro-elimina NO-UNDO
    FIELD cod-period       LIKE nf-produt-propried.cod-period
    FIELD nro-docto        LIKE nf-produt-propried.nro-docto
    FIELD serie-docto      LIKE nf-produt-propried.serie-docto
    FIELD nat-operacao     LIKE nf-produt-propried.nat-operacao
    FIELD cdn-produt-rural LIKE nf-produt-propried.cdn-produt-rural
    FIELD cod-propried     LIKE nf-produt-propried.cod-propried
    FIELD motivo           AS CHARACTER.

DEF TEMP-TABLE tt-concluidos NO-UNDO
    FIELD cod-period       LIKE nf-produt-propried.cod-period
    FIELD nro-docto        LIKE nf-produt-propried.nro-docto
    FIELD serie-docto      LIKE nf-produt-propried.serie-docto
    FIELD nat-operacao     LIKE nf-produt-propried.nat-operacao
    FIELD cdn-produt-rural LIKE nf-produt-propried.cdn-produt-rural
    FIELD nome-produtor    AS CHARACTER.

DEF TEMP-TABLE tt-fechto-produt-period NO-UNDO 
    LIKE fechto-produt-period.

DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-docum-est-aux NO-UNDO LIKE docum-est
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt_row_errors5 no-undo
    FIELD ttv_num_seq_erro    AS INTEGER   FORMAT ">>>>,>>9" INITIAL 0
    FIELD ttv_num_erro        AS INTEGER   FORMAT ">>>>,>>9"
    FIELD ttv_des_erro        AS CHARACTER FORMAT "x(50)" LABEL "Inconsistància" COLUMN-LABEL "Inconsistància"
    FIELD ttv_des_param       AS CHARACTER FORMAT "x(50)" LABEL "Param" COLUMN-LABEL "Param"
    FIELD ttv_des_type        AS CHARACTER FORMAT "x(10)"
    FIELD ttv_des_help        AS CHARACTER FORMAT "x(40)" LABEL "Ajuda" COLUMN-LABEL "Ajuda"
    FIELD ttv_des_sub_type    AS CHARACTER FORMAT "x(40)"
    INDEX tt_indice_errors    
          ttv_num_seq_erro    ascending.


DEFINE BUFFER bf-produt-propried      FOR nf-produt-propried.
DEFINE BUFFER bf-fechto-produt-period FOR fechto-produt-period.

/** DEFINIÄ«O DE VARIµVEIS LOCAIS **/
DEFINE VARIABLE l-imprime             AS LOGICAL   INITIAL YES            NO-UNDO.
DEFINE VARIABLE de-total-item         LIKE tt-item-doc-est.preco-total[1] NO-UNDO.
DEFINE VARIABLE i-cod-regra-utilizada AS INTEGER                          NO-UNDO.

DEFINE VARIABLE c-titulo-p            AS CHARACTER FORMAT "x(20)"         NO-UNDO.
DEFINE VARIABLE c-destino             AS CHARACTER FORMAT "x(20)"         NO-UNDO.             
DEFINE VARIABLE c-contas              AS CHARACTER FORMAT "x(08)"         NO-UNDO.
DEFINE VARIABLE c-opcao               AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cMotivo               AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cMsg                  AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-return              AS CHARACTER                        NO-UNDO.

DEFINE VARIABLE h-acomp               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boin090             AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boad00463           AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-apb061za            AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-boad098             AS HANDLE                           NO-UNDO.

/** IMPRESS«O DE PARAMETROS EM TELA **/
DEFINE VARIABLE c-lb-impr        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-dest        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-usuar       AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-sel         AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-regiao      AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-rota        AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-grupo       AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-produtor    AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-propriedade AS CHAR NO-UNDO.
DEFINE VARIABLE c-msg            AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-par         AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-estabel     AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-period      AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-item        AS CHAR NO-UNDO.
DEFINE VARIABLE c-nome-estabel   AS CHAR NO-UNDO.
DEFINE VARIABLE c-desc-item      AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-dig         AS CHAR NO-UNDO.
DEFINE VARIABLE c-texto          AS CHAR NO-UNDO.

RUN utp/ut-acomp.p        PERSISTENT SET h-acomp.
RUN inbo/boin090.p        PERSISTENT SET h-boin090.
RUN adbo/boad00463.p      PERSISTENT SET h-boad00463.
RUN adbo/boad098.p        PERSISTENT SET h-boad098.        
RUN prgfin/apb/apb061za.p PERSISTENT SET h-apb061za.

{utp/ut-liter.i Eliminaá∆o_Notas_Fiscais_Produtor *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE). 


FORM tt-erro-elimina.cod-period       COLUMN-LABEL "Per°odo"
     tt-erro-elimina.nro-docto        COLUMN-LABEL "Nro. Nota"
     tt-erro-elimina.serie-docto      COLUMN-LABEL "SÇrie"
     tt-erro-elimina.nat-operacao     COLUMN-LABEL "Nat. Operaá∆o"
     tt-erro-elimina.cdn-produt-rural COLUMN-LABEL "Emitente"
     tt-erro-elimina.motivo           COLUMN-LABEL "Motivo" FORMAT "x(70)"
     WITH WIDTH 132 FRAME f-erros STREAM-IO.

RUN utp/ut-trfrrp.p (INPUT FRAME f-erros:HANDLE).

FORM tt-concluidos.cod-period       COLUMN-LABEL "Per°odo"
     tt-concluidos.nro-docto        COLUMN-LABEL "Nro. Nota"
     tt-concluidos.serie-docto      COLUMN-LABEL "SÇrie"
     tt-concluidos.nat-operacao     COLUMN-LABEL "Nat. Operaá∆o"
     tt-concluidos.cdn-produt-rural COLUMN-LABEL "Emitente"
     tt-concluidos.nome-produtor    COLUMN-LABEL "Nome" FORMAT "x(70)"
     WITH WIDTH 132 FRAME f-concluidos STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-concluidos:HANDLE).

FORM tt-digita.cdn-produt   COLUMN-LABEL "Cod. Produtor"
     tt-digita.cod-propried COLUMN-LABEL "Cod. Propriedade" FORMAT "X(115)"
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-digita.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
  CREATE tt-digita.
  RAW-TRANSFER raw-digita TO tt-digita.
END.

FORM                     
   SKIP(2)
   c-titulo-p       NO-LABEL COLON 14 SKIP(1)
   c-destino                 COLON 20
   tt-param.arquivo NO-LABEL          SKIP(1)
   tt-param.usuario          COLON 20 SKIP(1)
   WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao. 

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
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
    
{utp/ut-liter.i Eliminaá∆o_Notas_Fiscais_Produtor AQR}
ASSIGN c-titulo-relat = RETURN-VALUE.

{utp/ut-liter.i MATERIAIS aqr}  
ASSIGN c-programa     = "aqr0325"
       c-versao       = "I.00"
       c-revisao      = "002"
       c-sistema      = RETURN-VALUE.

{include/i-rpcab.i}
{include/i-rpout.i}

FIND FIRST tt-param NO-LOCK NO-ERROR.

FIND FIRST param-re NO-LOCK
     WHERE param-re.usuario = tt-param.usuario NO-ERROR.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

EMPTY TEMP-TABLE tt-fechto-produt-period.
EMPTY TEMP-TABLE tt-docum-est.
EMPTY TEMP-TABLE tt-docum-est-aux.

{utp/ut-liter.i Eliminando_nota_produtor:_}  
ASSIGN c-texto = RETURN-VALUE.

FIND FIRST tt-digita NO-ERROR.
IF AVAIL tt-digita THEN DO:
/*Percorre registros com base na aba de Digitaá∆o*/
  FOR EACH tt-digita:
    blk_fechto:
    FOR EACH fechto-produt-period 
      FIELDS(cod-period cdn-produt-rural cod-propried it-codigo cod-estabel)
       WHERE fechto-produt-period.cod-period       = tt-param.cod-periodo
         AND fechto-produt-period.cdn-produt-rural = tt-digita.cdn-produt
         AND fechto-produt-period.cod-propried     = tt-digita.cod-propried
         AND fechto-produt-period.it-codigo        = tt-param.it-codigo
         AND fechto-produt-period.cod-estabel      = tt-param.cod-estabel
         AND fechto-produt-period.idi-situacao     = 3   NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT c-texto + STRING(fechto-produt-period.cdn-produt-rural)).

        RUN pi-extracao-nf-produtor (INPUT fechto-produt-period.cod-period,
                                     INPUT fechto-produt-period.cdn-produt-rural,
                                     INPUT fechto-produt-period.cod-propried,
                                     INPUT fechto-produt-period.it-codigo,
                                     INPUT fechto-produt-period.cod-estabel).
        IF RETURN-VALUE = "NOK" THEN
           NEXT blk_fechto.
    END.
  END.

  FOR EACH tt-docum-est-aux:
    CREATE tt-docum-est.
    BUFFER-COPY tt-docum-est-aux TO tt-docum-est.
  END.

  RUN pi-trataEliminacao.

END.
ELSE DO: 
/*Percorre registros com base na aba seleá∆o */
  blk_fechto:
  FOR EACH fechto-produt-period
    FIELDS(cod-period cdn-produt-rural cod-propried it-codigo cod-estabel cod-rota cod-regiao)
     WHERE fechto-produt-period.cod-period        = tt-param.cod-periodo
       AND fechto-produt-period.cdn-produt-rural >= tt-param.prod-rural-ini 
       AND fechto-produt-period.cdn-produt-rural <= tt-param.prod-rural-fim
       AND fechto-produt-period.cod-propried     >= tt-param.propried-ini
       AND fechto-produt-period.cod-propried     <= tt-param.propried-fim
       AND fechto-produt-period.it-codigo         = tt-param.it-codigo
       AND fechto-produt-period.cod-estabel       = tt-param.cod-estabel
       AND fechto-produt-period.idi-situacao      = 3 NO-LOCK:

       RUN pi-acompanhar IN h-acomp (INPUT c-texto + STRING(fechto-produt-period.cdn-produt-rural)). 

       IF fechto-produt-period.cod-rota < tt-param.rota-ini OR
          fechto-produt-period.cod-rota > tt-param.rota-fim THEN
          NEXT blk_fechto.

       IF fechto-produt-period.cod-regiao < tt-param.regiao-ini OR
          fechto-produt-period.cod-regiao > tt-param.regiao-fim THEN
          NEXT blk_fechto.

       FIND produt-rural NO-LOCK
          WHERE produt-rural.cdn-produt-rural = fechto-produt-period.cdn-produt-rural NO-ERROR.
       IF AVAIL produt-rural THEN DO:

         IF produt-rural.cdn-grp-produt < tt-param.grp-prod-ini OR
            produt-rural.cdn-grp-produt > tt-param.grp-prod-fim THEN
            NEXT blk_fechto.

       END.
       ELSE NEXT blk_fechto.

       RUN pi-extracao-nf-produtor (INPUT fechto-produt-period.cod-period,
                                    INPUT fechto-produt-period.cdn-produt-rural,
                                    INPUT fechto-produt-period.cod-propried,
                                    INPUT fechto-produt-period.it-codigo,
                                    INPUT fechto-produt-period.cod-estabel).
       IF RETURN-VALUE = "NOK" THEN
          NEXT blk_fechto.
  END.

  FOR EACH tt-docum-est-aux:
    CREATE tt-docum-est.
    BUFFER-COPY tt-docum-est-aux TO tt-docum-est.
  END.

  RUN pi-trataEliminacao.

END.

/************** Imprime Resultado  **************/
FOR FIRST tt-concluidos:
  {utp/ut-liter.i NOTAS_FISCAIS_ELIMINADAS_COM_SUCESSO! * r}
  ASSIGN cMsg = TRIM(RETURN-VALUE).
  PUT UNFORM cMsg.
END.

FOR EACH tt-concluidos:
  DISP tt-concluidos.cod-period
       tt-concluidos.nro-docto
       tt-concluidos.serie-docto
       tt-concluidos.nat-operacao
       tt-concluidos.cdn-produt-rural
       tt-concluidos.nome-produtor
       WITH DOWN FRAME f-concluidos.
       DOWN WITH FRAME f-concluidos.
END.


FOR FIRST tt-erro-elimina:
  {utp/ut-liter.i NOTAS_FISCAIS_N«O_ELIMINADAS! * r}
  IF CAN-FIND(FIRST tt-concluidos) THEN
     PUT SKIP(2).
  ASSIGN cMsg = TRIM(RETURN-VALUE).
  PUT UNFORM cMsg.
END.

FOR EACH tt-erro-elimina:
  DISP tt-erro-elimina.cod-period
       tt-erro-elimina.nro-docto
       tt-erro-elimina.serie-docto
       tt-erro-elimina.nat-operacao
       tt-erro-elimina.cdn-produt-rural
       tt-erro-elimina.motivo
       WITH DOWN FRAME f-erros.
       DOWN WITH FRAME f-erros.
END.

PROCEDURE pi-extracao-nf-produtor :
/*-------------------------------------------------------------------------------
  Purpose: Efetua a extraá∆o dos registros ref. Nota Fiscal de Produtor.
-------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pr-cod-period       LIKE fechto-produt-period.cod-period.      
    DEFINE INPUT PARAM pr-cdn-produt-rural LIKE fechto-produt-period.cdn-produt-rural.
    DEFINE INPUT PARAM pr-cod-propried     LIKE fechto-produt-period.cod-propried.    
    DEFINE INPUT PARAM pr-it-codigo        LIKE fechto-produt-period.it-codigo.       
    DEFINE INPUT PARAM pr-cod-estabel      LIKE fechto-produt-period.cod-estabel.
    
    FOR EACH nf-produt-propried NO-LOCK
        WHERE nf-produt-propried.cod-period       = pr-cod-period
          AND nf-produt-propried.cdn-produt-rural = pr-cdn-produt-rural
          AND nf-produt-propried.cod-propried     = pr-cod-propried
          AND nf-produt-propried.it-codigo        = pr-it-codigo
          AND nf-produt-propried.cod-estabel      = pr-cod-estabel:
    
        /*Filtro de Notas*/
        IF nf-produt-propried.num-livre-1 = 0 THEN DO: /*Nota Padr∆o*/
            IF tt-param.elimina-nota-compl AND tt-param.elimina-nota = NO THEN
                NEXT.
        END.
        
        IF nf-produt-propried.num-livre-1 = 1 THEN DO: /*Nota Complementar*/
            IF tt-param.elimina-nota AND tt-param.elimina-nota-compl = NO THEN
                NEXT.
        END.
        
        FIND docum-est NO-LOCK
           WHERE docum-est.serie-docto  = nf-produt-propried.serie-docto
             AND docum-est.nro-docto    = nf-produt-propried.nro-docto   
             AND docum-est.cod-emitente = nf-produt-propried.cdn-produt-rural
             AND docum-est.nat-operacao = nf-produt-propried.nat-operacao NO-ERROR.

        IF AVAIL docum-est THEN DO:

            /* Produtor Rural */
            IF docum-est.origem <> "AQR":U THEN DO:
                ASSIGN cMotivo = "Nota Fiscal n∆o foi gerada pelo AQR.".
                RUN pi-geraErro (INPUT nf-produt-propried.cod-period,
                                 INPUT nf-produt-propried.serie-docto,
                                 INPUT nf-produt-propried.nro-docto,
                                 INPUT nf-produt-propried.nat-operacao,
                                 INPUT nf-produt-propried.cdn-produt-rural,
                                 INPUT nf-produt-propried.cod-propried,
                                 INPUT cMotivo).
                NEXT.
            END.
            
            IF(docum-est.ce-atual = YES  /* Atualizado Estoque */ OR
               docum-est.log-1    = YES) /* Faturamento        */ THEN DO:
            
                IF docum-est.ce-atual THEN
                    ASSIGN cMotivo = "Nota Fiscal j† atualizada no m¢dulo de Estoque.".
                ELSE
                    ASSIGN cMotivo = "Nota Fiscal j† atualizada no Faturamento.".
                
                RUN pi-geraErro (INPUT nf-produt-propried.cod-period,
                                 INPUT nf-produt-propried.serie-docto,
                                 INPUT nf-produt-propried.nro-docto,
                                 INPUT nf-produt-propried.nat-operacao,
                                 INPUT nf-produt-propried.cdn-produt-rural,
                                 INPUT nf-produt-propried.cod-propried,
                                 INPUT cMotivo).

                NEXT.
            END.
            
            CREATE tt-docum-est-aux.
            BUFFER-COPY docum-est TO tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.r-rowid = ROWID(docum-est).
        
        END.
    END.
    
    /*** Criaá∆o dos registros que ser∆o eliminados ***/
    CREATE tt-fechto-produt-period.
    ASSIGN tt-fechto-produt-period.cod-period       = pr-cod-period      
           tt-fechto-produt-period.cdn-produt-rural = pr-cdn-produt-rural
           tt-fechto-produt-period.cod-propried     = pr-cod-propried    
           tt-fechto-produt-period.it-codigo        = pr-it-codigo       
           tt-fechto-produt-period.cod-estabel      = pr-cod-estabel.
    
    RETURN "OK".
  
END PROCEDURE.


PROCEDURE pi-trataEliminacao :
/*-------------------------------------------------------------------------------
  Purpose: Verificar se os registros est∆o dispon°veis para concluir a eliminaá∆o
-------------------------------------------------------------------------------*/

  DEFINE VARIABLE r-rowidEsoc AS ROWID                NO-UNDO.
  DEFINE VARIABLE qtde-aux    AS DECIMAL              NO-UNDO.
  DEFINE VARIABLE c-texto2    AS CHARACTER            NO-UNDO.  
  DEFINE VARIABLE da-event    LIKE docum-est.dt-trans NO-UNDO.
  DEFINE VARIABLE i-sit-nota  AS INT  INITIAL 2       NO-UNDO. /*Situaá∆o 2-Confirmada como padr∆o*/

  {utp/ut-liter.i Desfazendo_integraá∆o_Produtor:_ *}
  ASSIGN c-texto2 = RETURN-VALUE.

  blk_elimina:
  FOR EACH tt-fechto-produt-period:

    RUN pi-acompanhar IN h-acomp (INPUT c-texto2 + STRING(tt-fechto-produt-period.cdn-produt-rural)).

    DO ON ERROR  UNDO blk_elimina, NEXT blk_elimina
       ON ENDKEY UNDO blk_elimina, NEXT blk_elimina
       ON STOP   UNDO blk_elimina, NEXT blk_elimina:

      FOR EACH nf-produt-propried NO-LOCK
         WHERE nf-produt-propried.cod-period       = tt-fechto-produt-period.cod-period
           AND nf-produt-propried.cdn-produt-rural = tt-fechto-produt-period.cdn-produt-rural
           AND nf-produt-propried.cod-propried     = tt-fechto-produt-period.cod-propried
           AND nf-produt-propried.it-codigo        = tt-fechto-produt-period.it-codigo
           AND nf-produt-propried.cod-estabel      = tt-fechto-produt-period.cod-estabel:
         
        /*Filtro de Notas*/
        IF nf-produt-propried.num-livre-1 = 0 THEN DO: /*Nota Padr∆o*/
            IF tt-param.elimina-nota-compl AND tt-param.elimina-nota = NO THEN
                NEXT.
        END.
        
        IF nf-produt-propried.num-livre-1 = 1 THEN DO: /*Nota Complementar*/
            IF tt-param.elimina-nota AND tt-param.elimina-nota-compl = NO THEN
                NEXT.
        END.

        IF NOT CAN-FIND (FIRST tt-docum-est-aux
                            WHERE tt-docum-est-aux.serie-docto  = nf-produt-propried.serie-docto
                              AND tt-docum-est-aux.nro-docto    = nf-produt-propried.nro-docto   
                              AND tt-docum-est-aux.cod-emitente = nf-produt-propried.cdn-produt-rural
                              AND tt-docum-est-aux.nat-operacao = nf-produt-propried.nat-operacao) THEN DO:
            NEXT.
        END.
        
        /*deleta evento imposto retido*/
        IF nf-produt-propried.num-livre-1 <> 1 THEN DO: /* Nota Complementar n„o gera evento */    
            FOR FIRST docum-est FIELDS(dt-trans) NO-LOCK        
                WHERE docum-est.serie-docto  = nf-produt-propried.serie-docto 
                  AND docum-est.nro-docto    = nf-produt-propried.nro-docto   
                  AND docum-est.cod-emitente = nf-produt-propried.cdn-produt-rural
                  AND docum-est.nat-operacao = nf-produt-propried.nat-operacao:
            
                ASSIGN da-event = docum-est.dt-trans.
            
            END.
            
            FOR EACH event-aquis-rural FIELDS(cod-evento cdn-tipo) NO-LOCK
                WHERE event-aquis-rural.cod-estabel = nf-produt-propried.cod-estabel
                  AND event-aquis-rural.it-codigo   = nf-produt-propried.it-codigo:  
                  
                IF event-aquis-rural.cdn-tipo = 5 OR   /*n„o conformidade*/ 
                   event-aquis-rural.cdn-tipo = 6 THEN /*incentivo*/
                    NEXT.
            
                EMPTY TEMP-TABLE tt_row_errors5.
            
                RUN pi_eliminar_movto_event_financ_chave_sem_num_seq in h-apb061za (INPUT i-ep-codigo-usuario,
                                                                                    INPUT nf-produt-propried.cdn-produt-rural,
                                                                                    INPUT nf-produt-propried.cod-propried,
                                                                                    INPUT event-aquis-rural.cod-evento,
                                                                                    INPUT da-event,
                                                                                    INPUT tt-param.cod-estabel,
                                                                                    OUTPUT TABLE tt_row_errors5).
            
            END.
            
            IF CAN-FIND (FIRST tt_row_errors5) THEN DO:
                FOR EACH tt_row_errors5:
                  RUN pi-geraErro (INPUT nf-produt-propried.cod-period,
                                   INPUT nf-produt-propried.serie-docto,
                                   INPUT nf-produt-propried.nro-docto,
                                   INPUT nf-produt-propried.nat-operacao,
                                   INPUT nf-produt-propried.cdn-produt-rural,
                                   INPUT nf-produt-propried.cod-propried,
                                   INPUT tt_row_errors5.ttv_des_erro + " " + tt_row_errors5.ttv_des_help).
                END.
                DELETE tt-fechto-produt-period.
                UNDO, NEXT blk_elimina.
            END.
        END.    
        /******************************/

        IF nf-produt-propried.cdn-id-movto-event <> 0 THEN DO:
          EMPTY TEMP-TABLE tt_row_errors5.
          RUN pi_apagar_movto_event_financ IN h-apb061za (INPUT nf-produt-propried.cdn-id-movto-event,
                                                          INPUT YES, /* Eliminar evento Financeiro */
                                                          OUTPUT TABLE tt_row_errors5).
        END.

        IF CAN-FIND (FIRST tt_row_errors5) THEN DO:
            FOR EACH tt_row_errors5:
              RUN pi-geraErro (INPUT nf-produt-propried.cod-period,
                               INPUT nf-produt-propried.serie-docto,
                               INPUT nf-produt-propried.nro-docto,
                               INPUT nf-produt-propried.nat-operacao,
                               INPUT nf-produt-propried.cdn-produt-rural,
                               INPUT nf-produt-propried.cod-propried,
                               INPUT tt_row_errors5.ttv_des_erro + " " + tt_row_errors5.ttv_des_help).
            END.
            DELETE tt-fechto-produt-period.
            UNDO, NEXT blk_elimina.
        END.

        FIND tt-docum-est NO-LOCK
           WHERE tt-docum-est.serie-docto  = nf-produt-propried.serie-docto 
             AND tt-docum-est.nro-docto    = nf-produt-propried.nro-docto   
             AND tt-docum-est.cod-emitente = nf-produt-propried.cdn-produt-rural
             AND tt-docum-est.nat-operacao = nf-produt-propried.nat-operacao NO-ERROR.
        IF AVAIL tt-docum-est THEN DO:

            {aqp/aq0325.i} /*elimina docum-est e suas dependÍncias*/
            
            /*Adicionado tratamento para n∆o considerar erros de query vazia ou ultimo registro da tabela*/
            IF CAN-FIND(FIRST RowErrors
	                        WHERE RowErrors.ErrorType <> "INTERNAL":U AND
		                          RowErrors.ErrorSubType = "Error":U) THEN DO:
              FOR EACH RowErrors:
                RUN pi-geraErro (INPUT nf-produt-propried.cod-period,
                                 INPUT nf-produt-propried.serie-docto,
                                 INPUT nf-produt-propried.nro-docto,
                                 INPUT nf-produt-propried.nat-operacao,
                                 INPUT nf-produt-propried.cdn-produt-rural,
                                 INPUT nf-produt-propried.cod-propried,
                                 INPUT RowErrors.ErrorDescription).
              END.
              DELETE tt-fechto-produt-period.
              UNDO, NEXT blk_elimina.
            END.
            
            IF NOT CAN-FIND(FIRST RowErrors
                            WHERE RowErrors.ErrorType <> "INTERNAL":U
                              AND RowErrors.ErrorSubType = "Error":U ) THEN DO:
            
              RUN deleteEsocRecebimento IN h-boad00463 (INPUT r-rowidEsoc).
            
            END.
            
            FOR FIRST quant-fornec-produt EXCLUSIVE-LOCK 
                WHERE quant-fornec-produt.cdn-produt-rural = tt-docum-est.cod-emitente
                  AND quant-fornec-produt.it-codigo        = nf-produt-propried.it-codigo
                  AND quant-fornec-produt.dat-inic        <= tt-docum-est.dt-emiss
                  AND quant-fornec-produt.dat-fim         >= tt-docum-est.dt-emiss:
               ASSIGN quant-fornec-produt.qtd-fornec = quant-fornec-produt.qtd-fornec - qtde-aux.
            END.

        END.

        RUN findCodigo IN h-boad098(INPUT nf-produt-propried.cdn-produt-rural, OUTPUT c-return).
        IF c-return = "" THEN
          RUN getCharfield IN h-boad098(INPUT "nome-abrev", OUTPUT c-return).

        CREATE tt-concluidos.
        ASSIGN tt-concluidos.cod-period       = nf-produt-propried.cod-period
               tt-concluidos.serie-docto      = nf-produt-propried.serie-docto
               tt-concluidos.nro-docto        = nf-produt-propried.nro-docto
               tt-concluidos.nat-operacao     = nf-produt-propried.nat-operacao
               tt-concluidos.cdn-produt-rural = nf-produt-propried.cdn-produt-rural
               tt-concluidos.nome-produtor    = c-return.

        FIND FIRST bf-produt-propried OF nf-produt-propried EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bf-produt-propried THEN
            DELETE bf-produt-propried.
      END.
    END.

    /* Se nao ocorreu erro, atualiza o idi-situacao da fechto-produt-period */
    IF NOT CAN-FIND (FIRST tt-erro-elimina
                     WHERE tt-erro-elimina.cod-period       = tt-fechto-produt-period.cod-period
                       AND tt-erro-elimina.cdn-produt-rural = tt-fechto-produt-period.cdn-produt-rural
                       AND tt-erro-elimina.cod-propried     = tt-fechto-produt-period.cod-propried) THEN DO:

        /*Se os dois parametros de eliminaá∆o estiverem marcado situaá∆o passa para 2-Confirmada
          Caso somente o parametro de eliminaá∆o de Nota Complementar estiver marcado, passa para 3-NF Gerada*/
        IF tt-param.elimina-nota-compl AND NOT tt-param.elimina-nota THEN 
            ASSIGN i-sit-nota = 3. /*NF Gerada*/

        FIND FIRST bf-fechto-produt-period OF tt-fechto-produt-period EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL bf-fechto-produt-period THEN
            ASSIGN bf-fechto-produt-period.idi-situacao = i-sit-nota. /*Se for nota complementar altera para 3-NF Gerada sen∆o grava 2-Confirmada*/
    END.
    
  END.

END PROCEDURE.

PROCEDURE pi-geraErro :
/*-------------------------------------------------------------------------------
  Purpose: Gerar a listagens dos erros que ser∆o impressos ao final do relat¢rio
-------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pr-cod-period       LIKE nf-produt-propried.cod-period.
    DEFINE INPUT PARAM pr-serie-docto      LIKE nf-produt-propried.serie-docto.
    DEFINE INPUT PARAM pr-nro-docto        LIKE nf-produt-propried.nro-docto.
    DEFINE INPUT PARAM pr-nat-operacao     LIKE nf-produt-propried.nat-operacao.
    DEFINE INPUT PARAM pr-produtor         LIKE nf-produt-propried.cdn-produt-rural.
    DEFINE INPUT PARAM pr-cod-propried     LIKE nf-produt-propried.cod-propried.
    DEFINE INPUT PARAM pr-motivo           AS CHARACTER.

    CREATE tt-erro-elimina.
    ASSIGN tt-erro-elimina.cod-period       = pr-cod-period
           tt-erro-elimina.serie-docto      = pr-serie-docto
           tt-erro-elimina.nro-docto        = pr-nro-docto
           tt-erro-elimina.nat-operacao     = pr-nat-operacao
           tt-erro-elimina.cdn-produt-rural = pr-produtor
           tt-erro-elimina.cod-propried     = pr-cod-propried
           tt-erro-elimina.motivo           = pr-motivo.

END PROCEDURE.

/************** Imprime Parametros **************/
{utp/ut-liter.i SELEÄ«O: * r}
ASSIGN c-lb-sel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Regi∆o * r}
ASSIGN c-lb-regiao = TRIM(RETURN-VALUE).
{utp/ut-liter.i Rota * r}
ASSIGN c-lb-rota = TRIM(RETURN-VALUE).
{utp/ut-liter.i Grupo_Produtor * r}
ASSIGN c-lb-grupo = TRIM(RETURN-VALUE).
{utp/ut-liter.i Produtor * r}
ASSIGN c-lb-produtor = TRIM(RETURN-VALUE).
{utp/ut-liter.i Propriedade_Rural * r}
ASSIGN c-lb-propriedade = TRIM(RETURN-VALUE).

{utp/ut-liter.i PAR∂METRO: * r}
ASSIGN c-lb-par = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento * r}
ASSIGN c-lb-estabel = TRIM(RETURN-VALUE).
{utp/ut-liter.i Per°odo * r}
ASSIGN c-lb-period = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * r}
ASSIGN c-lb-item = TRIM(RETURN-VALUE).

{utp/ut-liter.i DIGITAÄ«O: * r}
ASSIGN c-lb-dig = TRIM(RETURN-VALUE).

{utp/ut-liter.i IMPRESS«O: * r}
ASSIGN c-lb-impr = TRIM(RETURN-VALUE).
{utp/ut-liter.i Destino * r}
ASSIGN c-lb-dest = TRIM(RETURN-VALUE).
{utp/ut-liter.i Usu†rio * r}
ASSIGN c-lb-usuar = TRIM(RETURN-VALUE).

FOR FIRST item FIELDS(desc-item) NO-LOCK WHERE item.it-codigo = tt-param.it-codigo:
    ASSIGN c-desc-item = item.desc-item.
END.

PUT UNFORMATTED SKIP(3)
    c-lb-sel                SKIP(1)
    c-lb-regiao             AT 5  ": " tt-param.regiao-ini       AT 24 "|<  >| " AT 37 tt-param.regiao-fim
    c-lb-rota               AT 5  ": " tt-param.rota-ini         AT 24 "|<  >| " AT 37 tt-param.rota-fim
    c-lb-grupo              AT 5  ": " tt-param.grp-prod-ini     AT 24 "|<  >| " AT 37 tt-param.grp-prod-fim
    c-lb-produtor           AT 5  ": " tt-param.prod-rural-ini   AT 24 "|<  >| " AT 37 tt-param.prod-rural-fim
    c-lb-propriedade        AT 5  ": " tt-param.propried-ini     AT 24 "|<  >| " AT 37 tt-param.propried-fim.

PUT UNFORMATTED SKIP(1)
    c-lb-par               SKIP(1)
    c-lb-estabel            AT 5  ": " tt-param.cod-estabel                 AT 24 " " c-nome-estabel
    c-lb-period             AT 5  ": " tt-param.cod-period FORMAT "99/9999" AT 24
    c-lb-item               AT 5  ": " tt-param.it-codigo                   AT 24 " " c-desc-item.

IF CAN-FIND(FIRST tt-digita) THEN DO:
  PUT UNFORMATTED SKIP(1)
      c-lb-dig    SKIP(1).
  /* Digitaá∆o */
  FOR EACH tt-digita:
    DISP tt-digita.cdn-produt
         tt-digita.cod-propried
         WITH FRAME f-digita.
         DOWN WITH FRAME f-digita.
  END.
END.

PUT UNFORMATTED SKIP(1)
    c-lb-impr               SKIP(1)
    c-lb-dest               AT 5  ": " tt-param.destino " - " tt-param.arquivo
    c-lb-usuar              AT 5  ": " tt-param.usuario SKIP(1).

{include/i-rpclo.i}

RUN pi-finalizar IN h-acomp.

IF VALID-HANDLE(h-boad098) THEN
  DELETE PROCEDURE h-boad098.

IF VALID-HANDLE(h-boin090) THEN
  DELETE PROCEDURE h-boin090.

IF VALID-HANDLE(h-boad00463) THEN
  DELETE PROCEDURE h-boad00463.

IF VALID-HANDLE(h-apb061za) THEN
  DELETE PROCEDURE h-apb061za.

RETURN "OK".
