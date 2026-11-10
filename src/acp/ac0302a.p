/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0302A.P 2.00.00.001 }  /*** 011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0302A MAC}
&ENDIF

/*teste*/

/*------------------------------------------------------------------------------
    Purpose   : 
    Parameters: 
    Notes     : Este sub-programa foi criado para atender chamada EPC da GRENDENE.
                05/03/2002 - Tatiani S. Tironi - brv13117
------------------------------------------------------------------------------*/

    define input parameter p-wgh-frame  as widget-handle no-undo.

    /*** Defini‡Æo de elementos referentes a EPC ***/
    {include/i-epc200.i "ac0302a"}

    for each tt-epc 
        where tt-epc.cod-event = "afterValidateCotas":
        delete tt-epc.
    end.

    /*** Criacao do registro para temp-table tt-epc ***/
    {include/i-epc200.i2 &CodEvent='"afterValidateCotas"'
                         &CodParameter='"p-wgh-frame"'
                         &ValueParameter="string(p-wgh-frame)"}

    /*** Chamada do programa EPC ***/
    {include/i-epc201.i "afterValidateCotas"}

    if  return-value = "NOK":U then 
        return "NOK":U.
    else
        return "OK":U.

/* FIM acp/ac0302a.p */
