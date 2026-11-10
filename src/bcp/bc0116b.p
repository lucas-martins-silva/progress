/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0116B 2.00.00.007 } /*** "010007" 09/10/2025 11:26:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0116B MBC}
&ENDIF

/********************************************************************************
**
**  Programa..: bc0116a.p
**
**  Objetivo..: Elimina tabela bc-param-ext conforme chave primaria
**
********************************************************************************/

DEFINE INPUT PARAM  c-entidade  AS CHARACTER.
DEFINE INPUT PARAM  c-chave-old AS CHARACTER.

DEFINE VAR h-acomp  AS HANDLE.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Eliminando ExtensÆo dos Parƒmetros Entidade: " + TRIM(c-entidade)).

FOR EACH bc-param-ext
   WHERE bc-param-ext.cod-entidade-param-ext  = c-entidade
     AND bc-param-ext.cod-chave-param-ext     = c-chave-old EXCLUSIVE-LOCK:

    DEFINE VARIABLE c-lbl-liter-chave AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Chave" *}
    ASSIGN c-lbl-liter-chave = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-lbl-liter-param AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Param" *}
    ASSIGN c-lbl-liter-param = TRIM(RETURN-VALUE).

    RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-chave + ": " + TRIM(c-chave-old) + "   " + c-lbl-liter-param + ": " + TRIM(bc-param-ext.cod-param-ext)).
    DELETE bc-param-ext.
END.
RUN pi-finalizar IN h-acomp.
