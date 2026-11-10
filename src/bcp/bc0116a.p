/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0116A 2.00.00.005}  /*** "010005" 14/08/2023 08:00:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0116A MBC}
&ENDIF

/********************************************************************************
**
**  Programa..: bc0116a.p
**
**  Objetivo..: Fazer c¢pia da tabela bc-param-ext conforme chave primaria
**
********************************************************************************/

DEFINE INPUT PARAM  c-entidade  AS CHARACTER.
DEFINE INPUT PARAM  c-chave-old AS CHARACTER.
DEFINE INPUT PARAM  c-chave-new AS CHARACTER.

DEFINE BUFFER b_bc-param-ext FOR bc-param-ext.

DEFINE VAR h-acomp AS HANDLE.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Copiando ExtensÆo dos Parƒmetros Entidade: " + TRIM(c-entidade)).

FOR EACH b_bc-param-ext
   WHERE b_bc-param-ext.cod-entidade-param-ext = c-entidade
     AND b_bc-param-ext.cod-chave-param-ext    = c-chave-old NO-LOCK:

    DEFINE VARIABLE c-lbl-liter-chave-anterior AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Chave_Anterior" *}
    ASSIGN c-lbl-liter-chave-anterior = TRIM(RETURN-VALUE).

    DEFINE VARIABLE c-lbl-liter-chave-nova AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Chave_Nova" *}
    ASSIGN c-lbl-liter-chave-nova = TRIM(RETURN-VALUE).
    
    RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter-chave-anterior + ": " + TRIM(c-chave-old) + "   " + c-lbl-liter-chave-nova + ": " + TRIM(c-chave-new)).

    CREATE bc-param-ext.
    ASSIGN bc-param-ext.cod-entidade-param-ext = c-entidade
           bc-param-ext.cod-chave-param-ext    = c-chave-new.

    BUFFER-COPY b_bc-param-ext EXCEPT b_bc-param-ext.cod-entidade-param-ext
                                      b_bc-param-ext.cod-chave-param-ext    TO bc-param-ext NO-ERROR.

END.
RUN pi-finalizar IN h-acomp.
