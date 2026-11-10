/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9043D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9043d MBC}
&ENDIF



{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
{bcp/bc9043.i " "}
{method/dbotterr.i}
/*********************************************************************************/

/*********************************************************************************/
Define INPUT        PARAMETER pNumTrans    AS  INTEGER NO-UNDO.
Define INPUT        PARAMETER pRawConteudo AS  RAW     NO-UNDO.
Define INPUT-OUTPUT PARAMETER TABLE        FOR tt-erro.
/*********************************************************************************/

DEF TEMP-TABLE tt-packing NO-UNDO
    FIELD val-etiq-packing LIKE  wms-box-packing.val-etiq-packing.
DO:
    FIND LAST Param-BC NO-LOCK NO-ERROR. 
    IF NOT AVAILABLE Param-BC THEN RETURN 'NOK'.

    CREATE tt-separa-packing.
    RAW-TRANSFER pRawConteudo to tt-separa-packing.  

    EMPTY TEMP-TABLE tt-packing.

    FOR EACH tt-separa-packing NO-LOCK :
        CREATE tt-packing.
        ASSIGN tt-packing.val-etiq-packing = tt-separa-packing.num-serial.
    END.

    FIND FIRST tt-separa-packing NO-LOCK NO-ERROR.
    IF AVAIL tt-separa-packing THEN DO:
        EMPTY TEMP-TABLE RowErrors. 
        RUN wmp/wm9072.p (INPUT tt-separa-packing.cod-estabel,                    
                          INPUT tt-separa-packing.cod-local,                      
                          INPUT tt-separa-packing.num-box,                        
                          INPUT TABLE tt-packing,                                 
                          INPUT tt-separa-packing.cod-usuario,                    
                          INPUT tt-separa-packing.cod-coletor,                    
                          INPUT tt-separa-packing.cod-equipamento,                
                          OUTPUT TABLE RowErrors).                                
        IF CAN-FIND(FIRST RowErrors) THEN DO:
           FOR EACH RowErrors:
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen   = RowErrors.ErrorSequence    
                      tt-erro.cd-erro    = RowErrors.ErrorNumber  
                      tt-erro.mensagem   = RowErrors.ErrorDescription.
           END.   
           EMPTY TEMP-TABLE RowErrors.
           RETURN 'NOK'.
        END.
    END.
END.  /* Do Main */
