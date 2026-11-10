/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9045C 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9045c MBC}
&ENDIF                              

{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
{bcp/bc9045.i " "}
{method/dbotterr.i}
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT        PARAMETER pNumTrans    AS  INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER pRawConteudo AS  RAW     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE        FOR tt-erro.

DEFINE VARIABLE wgboin089wm AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgbosc074   AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE ttWm-etiqueta NO-UNDO LIKE wm-etiqueta. 

DEFINE TEMP-TABLE ttWm-etiqueta-aux NO-UNDO LIKE wm-etiqueta
    FIELD RowNum AS INTEGER INIT 1
    FIELD r-Rowid AS ROWID.
/*********************************************************************************/

DO:
    IF NOT VALID-HANDLE(wgboin089wm) THEN
        RUN inbo/boin089wm.p PERSISTENT SET wgboin089wm.
    RUN openQueryStatic IN wgboin089wm (INPUT "Main":U) NO-ERROR. 

    IF NOT VALID-HANDLE(wgbosc074) THEN
        RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
    RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR. 

    FIND LAST Param-BC NO-LOCK NO-ERROR. 
    IF NOT AVAILABLE Param-BC THEN RETURN 'NOK'.

    CREATE tt-conf-rec-fisico.
    RAW-TRANSFER pRawConteudo to tt-conf-rec-fisico.  

    FIND FIRST tt-conf-rec-fisico NO-LOCK NO-ERROR.
    IF AVAIL tt-conf-rec-fisico THEN DO:
        IF ind-fim-conf = YES THEN DO:
            EMPTY TEMP-TABLE ttWm-etiqueta. 
            RUN getConteudoCarga IN wgbosc074(INPUT tt-conf-rec-fisico.id-carga,
                                              INPUT NO,
                                              INPUT YES,
                                              INPUT NO,
                                              OUTPUT TABLE ttWm-etiqueta).  
            FOR EACH ttWm-etiqueta:
                EMPTY TEMP-TABLE ttWm-etiqueta-aux.
                RUN gotokey   IN wgbosc074(INPUT ttWm-etiqueta.id-etiqueta).        
                RUN getRecord IN wgbosc074(OUTPUT TABLE ttWm-etiqueta-aux).
                FIND FIRST ttWm-etiqueta-aux NO-ERROR. 
                &IF '{&mgscm_version}' >= '2.08' &THEN
                    ASSIGN ttWm-etiqueta-aux.log-confer = YES.
                &ELSE
                    ASSIGN ttWm-etiqueta-aux.log-1 = YES. 
                &ENDIF                               
                RUN emptyRowErrors IN wgbosc074.
                RUN setRecord      IN wgbosc074 (INPUT TABLE ttWm-etiqueta-aux).
                RUN updateRecord   IN wgbosc074.
            END.
            EMPTY TEMP-TABLE RowErrors.
            RUN conferenciaWMS IN wgboin089wm (INPUT tt-conf-rec-fisico.nro-docto, 
                                               INPUT tt-conf-rec-fisico.serie,              
                                               INPUT tt-conf-rec-fisico.tipo-nota,          
                                               INPUT tt-conf-rec-fisico.emitente,          
                                               INPUT tt-conf-rec-fisico.cod-usuario,
                                               INPUT YES,
                                               OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN DO:                                      
               FOR EACH RowErrors:                                                     
                   CREATE tt-erro.
                   ASSIGN tt-erro.i-sequen   = RowErrors.ErrorSequence    
                          tt-erro.cd-erro    = RowErrors.ErrorNumber  
                          tt-erro.mensagem   = RowErrors.ErrorDescription.
               END.         
               IF VALID-HANDLE(wgboin089wm) THEN DO:
                   RUN DESTROY IN wgboin089wm.
                   DELETE OBJECT wgboin089wm NO-ERROR.
               END.
               RETURN 'NOK':U.
            END.
        END.
        ELSE DO:
            EMPTY TEMP-TABLE RowErrors.
            RUN gravaContagemWMS IN wgboin089wm (INPUT tt-conf-rec-fisico.nro-docto,        
                                                 INPUT tt-conf-rec-fisico.serie,             
                                                 INPUT tt-conf-rec-fisico.tipo-nota,         
                                                 INPUT tt-conf-rec-fisico.emitente,         
                                                 INPUT tt-conf-rec-fisico.it-codigo,         
                                                 INPUT tt-conf-rec-fisico.lote,              
                                                 INPUT tt-conf-rec-fisico.cod-refer,         
                                                 INPUT tt-conf-rec-fisico.quant-conf,        
                                                 INPUT tt-conf-rec-fisico.seq-item,
                                                 OUTPUT TABLE RowErrors).      
            IF CAN-FIND(FIRST RowErrors) THEN DO:                                      
               FOR EACH RowErrors:                                                     
                   CREATE tt-erro.
                   ASSIGN tt-erro.i-sequen   = RowErrors.ErrorSequence    
                          tt-erro.cd-erro    = RowErrors.ErrorNumber  
                          tt-erro.mensagem   = RowErrors.ErrorDescription.
               END.         
               IF VALID-HANDLE(wgboin089wm) THEN DO:
                   RUN DESTROY IN wgboin089wm.
                   DELETE OBJECT wgboin089wm NO-ERROR.
               END.
               RETURN 'NOK':U.
            END.
            RUN fechaContagemWMS IN wgboin089wm (INPUT tt-conf-rec-fisico.num-serial).
        END.
    END.
    IF VALID-HANDLE(wgboin089wm) THEN DO:
        RUN DESTROY IN wgboin089wm.
        DELETE OBJECT wgboin089wm NO-ERROR.
    END.

    IF VALID-HANDLE(wgbosc074) THEN DO:
        RUN DESTROY IN wgbosc074.
        DELETE OBJECT wgbosc074 NO-ERROR.
    END.

    RETURN 'OK':U.
END.  /* Do Main */
