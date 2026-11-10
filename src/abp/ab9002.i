/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*------------------------------------------------------------------------------
  Purpose:     piValidaParametroAbastecimento
  Parameters:  entrada pLista = Lista com os c¢digos dos parƒmetros a serem 
                                validados.
                                Ex: "1,8,11,20"
  Notes:       Busca os parƒmetros de Abastecimento pela lista passada, para 
               verificar se os mesmos estÆo cadastrados.
------------------------------------------------------------------------------*/
procedure piValidaParametroAbastecimento:

define input parameter pLista as character no-undo.

define variable iCont  as integer no-undo.

{utp/ut-liter.i "Abastecimento"}
/** Repete processo at‚ o n£mero de c¢digos 
    dividos por v¡rgulas que encontrar **/
do iCont = 1 to num-entries(pLista):
    if not can-find(first mab-param 
                    where mab-param.cdn-param = integer(entry(iCont,pLista)) no-lock) then do:
        /** C¢digo deve estar cadastrado ou nÆo existe **/
        {method/svc/errors/inserr.i
                &ErrorNumber="28474"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="return-value + '~~~~' + entry(iCont,pLista) + '~~~~' + ''"}        
    end.
    else do:
        /** Busca ParÆmetros de Abastecimento **/
        for first mab-param fields(des-valor des-param cdn-param)
            where mab-param.cdn-param = integer(entry(iCont,pLista)) no-lock:
            /** C¢digo deve estar cadastrado **/
            if mab-param.des-valor = "" then do:
                 {method/svc/errors/inserr.i
                         &ErrorNumber="28474"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value + '~~~~' + string(mab-param.cdn-param) + '~~~~' + des-param"}
            end.
        end.
    end.
end.

/*:T--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.


return "OK":U.

END PROCEDURE.

