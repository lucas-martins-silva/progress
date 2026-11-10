/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9029 2.00.00.007 } /*** "010007" 09/10/2025 11:26:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI9029 MUT}
&ENDIF


{include/i_dbvers.i}  /* versao das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then
/*------------------------------------------------------------------------ */
/*     File: bcapiwms.p                                                    */
/*     Purpose: Api with standart procedures for WMS                       */
/*------------------------------------------------------------------------ */


/* ***************************  Main Block  *************************** */


/* ***************************   Includes   *************************** */
{method/dbotterr.i}
{bcp/bc9102.i}
{bcp/bc9029.i}
{utp/ut-glob.i}


/* ***************************  Definitions  ************************** */
&global-define TEMPTABLE tt-storage-serial-wms

DEFINE TEMP-TABLE ttwm-docto-itens NO-UNDO LIKE wm-docto-itens.


DEFINE TEMP-TABLE ttwm-box-movto-idx NO-UNDO LIKE wm-box-movto
    FIELD val-prioridade AS INTEGER
    FIELD r-rowid        AS ROWID
    INDEX idx-prioridade val-prioridade DESC
    INDEX idx-movto id-movto ASC.

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.



DEFINE VARIABLE hBosc096 AS HANDLE NO-UNDO.
DEFINE VARIABLE Hbosc074 AS HANDLE NO-UNDO.

DEFINE VARIABLE i-cont   AS INTEGER  NO-UNDO.



/* **********************  Internal Procedures  *********************** */

/* ******************************************************************************************** */
PROCEDURE CreateTTErro:
/* ******************************************************************************************** */

    DEFINE INPUT PARAMETER pCdErro       AS INT.
    DEFINE INPUT PARAMETER pDescription  AS CHAR.

        ASSIGN i-cont = i-cont + 1.

        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = pCdErro
               tt-erro.mensagem = pDescription 
               tt-erro.i-sequen = i-cont.


END PROCEDURE.

/* ******************************************************************************************** */
PROCEDURE GetSerialStorageTask:
/* ******************************************************************************************** */

   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-storage-serial-wms.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

   DEFINE VARIABLE lEtiqReutilizada  AS LOGICAL                   NO-UNDO.
   DEFINE VARIABLE cCod-equipamento  AS CHARACTER                 NO-UNDO.
   DEFINE VARIABLE itipo-equipamento AS INTEGER                   NO-UNDO.
   DEFINE VARIABLE ccod-usuario      AS CHARACTER                 NO-UNDO.
   DEFINE VARIABLE dnum-serial       LIKE wm-etiqueta.id-etiqueta NO-UNDO.
   DEFINE VARIABLE iCont             AS INTEGER                   NO-UNDO.
    
   ASSIGN iCont = 0. 

   IF NOT VALID-HANDLE (Hbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET Hbosc096.
      RUN openQueryStatic In HBosc096 (Input "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(Hbosc074) THEN DO:
      RUN scbo/bosc074.p Persistent Set Hbosc074       NO-ERROR.
      RUN openQueryStatic In Hbosc074 (Input "Main":U) NO-ERROR.
   END.

   EMPTY TEMP-TABLE tt-erro.
   EMPTY TEMP-TABLE rowerrors.
   EMPTY TEMP-TABLE ttwm-docto-itens.
   EMPTY TEMP-TABLE ttwm-box-movto-idx.

   FIND FIRST tt-storage-serial-wms NO-ERROR.

   RUN getTarefaArmazenamento IN Hbosc096 (INPUT tt-storage-serial-wms.cod-equipamento,
                                           INPUT tt-storage-serial-wms.tipo-equipamento,
                                           INPUT tt-storage-serial-wms.cod-usuario,
                                           INPUT tt-storage-serial-wms.num-serial,
                                           OUTPUT lEtiqReutilizada,
                                           OUTPUT TABLE ttwm-docto-itens,
                                           OUTPUT TABLE ttwm-box-movto-idx). 

   IF RETURN-VALUE <> "OK":U THEN DO:
      RUN getRowErrors IN Hbosc096(OUTPUT TABLE rowErrors).
      FOR EACH Rowerrors NO-LOCK:
         RUN CreateTTErro (INPUT Rowerrors.ErrorNumber, INPUT Rowerrors.ErrorDescription).
      END.
      RUN destroy.
      RETURN "NOK":U.
   END.
   
   IF lEtiqReutilizada = NO THEN DO:
      FIND FIRST ttwm-docto-itens NO-ERROR.
      FIND FIRST ttwm-box-movto-idx NO-ERROR.
         IF AVAIL ttwm-docto-itens AND AVAIL ttwm-box-movto-idx THEN
            ASSIGN tt-storage-serial-wms.cod-estabel  = ttwm-docto-itens.cod-estabel  
                   tt-storage-serial-wms.cod-local    = ttwm-docto-itens.cod-local    
                   tt-storage-serial-wms.id-docto     = ttwm-docto-itens.id-docto     
                   tt-storage-serial-wms.id-movto     = ttwm-box-movto-idx.id-movto
                   tt-storage-serial-wms.num-seq-item = ttwm-docto-itens.num-seq-item 
                   tt-storage-serial-wms.num-box      = ttwm-box-movto-idx.id-box      
                   tt-storage-serial-wms.cod-item     = ttwm-box-movto-idx.cod-item
                   tt-storage-serial-wms.log-livre-5  = lEtiqReutilizada
                   tt-storage-serial-wms.qtd-saldo    = (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem).
   END.
   ELSE DO:
      ASSIGN cCod-equipamento  = tt-storage-serial-wms.cod-equipamento
             itipo-equipamento = tt-storage-serial-wms.tipo-equipamento
             ccod-usuario      = tt-storage-serial-wms.cod-usuario    
             dnum-serial       = tt-storage-serial-wms.num-serial.

      EMPTY TEMP-TABLE tt-storage-serial-wms.

      FOR EACH ttwm-docto-itens NO-LOCK:
         FOR EACH ttwm-box-movto-idx
            WHERE ttwm-box-movto-idx.cod-estabel  = ttwm-docto-itens.cod-estabel
              AND ttwm-box-movto-idx.cod-local    = ttwm-docto-itens.cod-local
              AND ttwm-box-movto-idx.id-docto     = ttwm-docto-itens.id-docto
              AND ttwm-box-movto-idx.num-seq-item = ttwm-docto-itens.num-seq-item NO-LOCK:
               
         ASSIGN iCont = iCont + 1. 
                 
         CREATE tt-storage-serial-wms.
         ASSIGN tt-storage-serial-wms.cod-equipamento  = cCod-equipamento
                tt-storage-serial-wms.tipo-equipamento = itipo-equipamento
                tt-storage-serial-wms.cod-usuario      = ccod-usuario
                tt-storage-serial-wms.num-serial       = dnum-serial
                tt-storage-serial-wms.cod-estabel      = ttwm-docto-itens.cod-estabel  
                tt-storage-serial-wms.cod-local        = ttwm-docto-itens.cod-local    
                tt-storage-serial-wms.id-docto         = ttwm-docto-itens.id-docto     
                tt-storage-serial-wms.id-movto         = ttwm-box-movto-idx.id-movto
                tt-storage-serial-wms.num-seq-item     = ttwm-docto-itens.num-seq-item 
                tt-storage-serial-wms.num-box          = ttwm-box-movto-idx.id-box      
                tt-storage-serial-wms.cod-item         = ttwm-box-movto-idx.cod-item
                tt-storage-serial-wms.qtd-saldo        = (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem)
                tt-storage-serial-wms.log-livre-4      = lEtiqReutilizada.
                     
         IF iCont > 1 THEN
            ASSIGN tt-storage-serial-wms.log-livre-5 = lEtiqReutilizada.  
         END.
      END.
   END.
    
   RUN destroy.
   RETURN "OK":U.

END PROCEDURE.

/* ******************************************************************************************** */
PROCEDURE Destroy:
/* ******************************************************************************************** */

    IF VALID-HANDLE (Hbosc096) THEN
        DELETE OBJECT Hbosc096. 

    IF VALID-HANDLE (Hbosc074) THEN
        DELETE OBJECT Hbosc074. 


END PROCEDURE.

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
