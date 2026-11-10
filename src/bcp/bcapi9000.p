/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9000 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9000 MBC}
&ENDIF


DEFINE INPUT  PARAMETER pNumTrans    AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER id-etiqueta  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER id-agrupador AS CHARACTER  NO-UNDO.

/* gera historico */                                                                                                      
FIND FIRST bc-trans WHERE bc-trans.nr-trans =  pNumTrans NO-LOCK NO-ERROR.
IF AVAIL bc-trans THEN DO:  
                                                                                                                          
    FIND FIRST bc-param-ext WHERE bc-param-ext.cod-param-ext = "GERA_HISTORICO"                                               
                            AND   bc-param-ext.cod-entidade-param-ext = "bc-tipo-trans"                                       
                            AND   bc-param-ext.cod-chave-param-ext = bc-trans.cd-trans NO-LOCK NO-ERROR.                      
                                                                                                                              
    IF AVAIL bc-param-ext AND bc-param-ext.param-logico = YES THEN DO:                                                        
       FIND FIRST bc-etiqueta WHERE bc-etiqueta.progressivo = id-etiqueta EXCLUSIVE-LOCK NO-ERROR. 
       IF AVAIL bc-etiqueta THEN                                                                                              
          ASSIGN bc-etiqueta.cd-trans = bc-trans.cd-trans                                                                     
                 bc-etiqueta.nr-trans = bc-trans.nr-trans.                                                                    
       FIND FIRST bc-etiqueta WHERE bc-etiqueta.progressivo = id-agrupador EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL bc-etiqueta THEN                                                                                              
          ASSIGN bc-etiqueta.cd-trans = bc-trans.cd-trans                                                                     
                 bc-etiqueta.nr-trans = bc-trans.nr-trans.                                                                    
                                                                                                                              
    END.
END.
