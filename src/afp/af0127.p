/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0127 1.00.00.001 } /*** "010016" 21/07/2023 15:17:35  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AF0127 MLA}
&ENDIF

/********************************************************************************
**
**   Programa..:  AF0127.P
**   Data......:  19/10/2023.
**   Objetivo .:  Altera narrativa apr
**   Cria‡Æo ..:  Rafael F.
**
********************************************************************************/
    
{lap/MLAAPI001.i99}
{cdp/cd0666.i}
{utp/utapi019.i}
{cdp/cd0020.i} 
{utp/ut-glob.i}
{method/dbotterr.i} /*rowErrors*/
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO 
    LIKE RowErrors.

/**  Defini‡Æo de elementos referentes a UPC **/
{include/i-epc200.i "AF0127"}

/**  Parametros
**/
DEFINE INPUT  PARAMETER p-cod-tip-doc AS INTEGER   NO-UNDO.    
DEFINE INPUT  PARAMETER TABLE FOR tt-mla-chave.    

def var i-chave         as integer no-undo.
def var c-chave         as char    no-undo.

RUN pi-executar.                
                 
RETURN RETURN-VALUE.   

PROCEDURE pi-executar:  

    EMPTY TEMP-TABLE RowErrors.                          

    /**   Monta chave do documento
    **/
    {lap/mlachave.i}
    
    FOR EACH mla-doc-pend-aprov EXCLUSIVE-LOCK            
       WHERE mla-doc-pend-aprov.ep-codigo   = tt-mla-chave.valor[9] 
         AND mla-doc-pend-aprov.cod-estabel = tt-mla-chave.valor[1]
         AND mla-doc-pend-aprov.cod-tip-doc = p-cod-tip-doc
         AND mla-doc-pend-aprov.chave-doc   = c-chave:
         
        ASSIGN mla-doc-pend-aprov.narrativa-apr = tt-mla-chave.valor[10]. 
    END.                        
               
    RETURN "OK":U.
END PROCEDURE.
