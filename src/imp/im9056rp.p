/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9056RP 2.00.00.000}  /*** 010000 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9056rp MIM}
&ENDIF

{utp/ut-glob.i} /*Variaveis Globais*/

{cxbo/bocx351.i tt-licenciam-import-oc}

DEFINE TEMP-TABLE tt-param
       FIELD destino            AS INTEGER
       FIELD arquivo            AS CHARACTER
       FIELD usuario            AS CHARACTER
       FIELD data-exec          AS DATE
       FIELD hora-exec          AS INTEGER.

CREATE tt-param.
ASSIGN tt-param.usuario         = c-seg-usuario
       tt-param.destino         = 3
       tt-param.data-exec       = TODAY
       tt-param.hora-exec       = TIME
       tt-param.arquivo         = SESSION:TEMP-DIRECTORY
                                + "IM9056RP":U
                                + ".tmp":U.

{include/i-rpvar.i}
{include/i-rpcab.i}

find first tt-param     no-lock no-error.
find first param-global no-lock no-error.

    {utp/ut-liter.i Ordens_de_Compra_Sem_LI * R}
    ASSIGN c-titulo-relat = trim(RETURN-VALUE).

    {utp/ut-liter.i Com‚rcio_Exterior * R}
    ASSIGN c-sistema      = TRIM(RETURN-VALUE).

find first empresa
     where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else do:
    run utp/ut-msgs.p (input "show", input 16, input "").
    return error.
end.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.


DEFINE INPUT PARAMETER c-cod-estabel LIKE historico-embarque.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER c-embarque    LIKE historico-embarque.embarque    NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-licenciam-import-oc.


FORM HEADER
     "Estabelecimento........:"  AT 01
     c-cod-estabel              
     "Embarque...............:"  AT 01
     c-embarque           
     SKIP(1)                                                       
     WITH DOWN NO-BOX SIDE-LABELS WIDTH 132 STREAM-IO PAGE-TOP FRAME f-cabec-embarque.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-cabec-embarque:HANDLE).


FORM 
     tt-licenciam-import-oc.numero-ordem   COLUMN-LABEL "Ordem Compra"
     tt-licenciam-import-oc.parcela        COLUMN-LABEL "Parcela"
     tt-licenciam-import-oc.licenca-import COLUMN-LABEL "LI"
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-LI.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-LI:HANDLE).


    VIEW FRAME f-cabec-embarque.

    for each  tt-licenciam-import-oc
        where tt-licenciam-import-oc.licenca-import = "":U
        break by tt-licenciam-import-oc.numero-ordem
              by tt-licenciam-import-oc.parcela:

        if  first-of (tt-licenciam-import-oc.numero-ordem) then do:
            DISP tt-licenciam-import-oc.numero-ordem
                 tt-licenciam-import-oc.parcela
                 tt-licenciam-import-oc.licenca-import
                WITH FRAME f-LI.
            DOWN WITH FRAME f-LI.
        END.
    end.
    
    PUT SKIP(1).

    VIEW FRAME f-rodape.

OUTPUT CLOSE.

PROCEDURE WinExec  EXTERNAL  "kernel32.dll":
     DEF INPUT PARAM prg_name      AS CHARACTER.
     DEF INPUT PARAM prg_style     AS SHORT.
END PROCEDURE.

