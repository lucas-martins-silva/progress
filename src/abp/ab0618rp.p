&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0618RP 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0618rp MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0618RP.p
**
**       DATA....: 10/07/2006
**
**       AUTOR...: Herc°lio Werneck de Capistrano - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Impress∆o do Hist¢rico de Vida do Equipamento
**
*****************************************************************************/
                                             /** Definiá∆o das temp-tables **/
{abp/ab0618.i1}                                             

DEFINE STREAM stExcel.
DEFINE VARIABLE tgPrimeiro  AS LOGICAL INITIAL YES  NO-UNDO.
/****************************************************************************/
                                               /** Definiá∆o de ParÉmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferància de parÉmetros para temp-table padr∆o **/
create tt-param.
raw-transfer raw-param to tt-param.
/** Este c¢digo deve existir somente se relat¢rio contiver digitaá∆o **/
for each tt-raw-digita no-lock:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.
/****************************************************************************/
                                                /** Definiá∆o de Vari†veis **/
define variable h-acomp as handle no-undo.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabeáalho e Forms **/
{abp/ab0618.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.63
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/** Parametriza padr‰es de cabeáalho e rodapÇ a serem exibidos **/
run piInicial in this-procedure.

    FOR EACH  mab-movto-km-eqpto NO-LOCK
        WHERE mab-movto-km-eqpto.ep-codigo    = tt-param.ep-codigo
        AND   mab-movto-km-eqpto.cod-eqpto    = tt-param.cod-eqpto
        AND   mab-movto-km-eqpto.dat-movto   >= tt-param.data-ini 
        AND   mab-movto-km-eqpto.dat-movto   <= tt-param.data-fim 
        AND   mab-movto-km-eqpto.hra-inicial >= tt-param.hora-ini 
        AND   mab-movto-km-eqpto.hra-inicial <= tt-param.hora-fim 
        AND   mab-movto-km-eqpto.num-docto   >= tt-param.docto-ini
        AND   mab-movto-km-eqpto.num-docto   <= tt-param.docto-fim:
        CREATE tt-digita.
        BUFFER-COPY mab-movto-km-eqpto TO tt-digita.
    END.


FOR FIRST mab-eqpto
    WHERE mab-eqpto.ep-codigo = tt-param.ep-codigo
    AND   mab-eqpto.cod-eqpto = tt-param.cod-eqpto NO-LOCK:
END.
IF NOT AVAIL mab-eqpto THEN RETURN "NOK":U.

IF tt-param.lGeraExcel
THEN DO:
    OUTPUT STREAM stExcel TO VALUE(tt-param.ArquivoExcel) CONVERT TARGET "ISO8859-1".
END.
/** Imprime cabeáalho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}
/** Procedure para inicializar c†lculos e impress∆o **/
run piPrincipal in this-procedure.

RUN imprimeParametros IN THIS-PROCEDURE.

/** Fecha o output para arquivo **/
IF tt-param.lGeraExcel
THEN DO:
    OUTPUT STREAM stExcel CLOSE.
END.

{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-imprimeParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeParametros Procedure 
PROCEDURE imprimeParametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF tt-param.lParam THEN DO:
    PAGE.

    DISPLAY tt-param.data-ini 
            tt-param.data-fim 
            tt-param.hora-ini 
            tt-param.hora-fim 
            tt-param.docto-ini
            tt-param.docto-fim
        WITH FRAME f-param-definidos.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que ser∆o mostrados o cabeáalho e rodapÇ
------------------------------------------------------------------------------*/
assign c-programa = "AB/0618"
       c-versao   = "2.00"
       c-revisao  = "000".
       /** Define o destino do arquivo a ser gerado **/
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 integer(tt-param.destino)}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}.
&endif

/** Busca os parÉmetros criados na interface gr†fica **/
find first tt-param NO-LOCK NO-ERROR.

/** Busca empresa padr∆o **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t°tulos **/
{utp/ut-liter.i "Hist¢rico de Vida dos Equipamentos" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "MAB" *}
assign c-sistema = trim(return-value).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplicaá∆o
------------------------------------------------------------------------------*/
FOR FIRST mab-model
    WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
END.
IF NOT AVAIL mab-model THEN DO:
    {utp/ut-liter.i "Modelo N∆o Encontrado"}
    ASSIGN cModelo     = RETURN-VALUE
           cDescUn     = ""
           cDescUn2    = ""
           cDescUnSec  = ""
           cDescUnSec2 = "".
END.
ELSE DO:
    ASSIGN cModelo     = mab-model.des-model
           cDescUn     = mab-model.un
           cDescUn2    = cDescUn
           cDescUnSec  = SUBSTRING(mab-model.cod-livre-1, 1, 2)
           cDescUnSec2 = cDescUnSec.
END.

ASSIGN cDescTip       = {frinc/i00fr007.i 04 mab-eqpto.idi-tip-eqpto}
       dtInicio       = mab-eqpto.dat-inicial
       contInicial    = mab-eqpto.val-hodom-horim-inicial
       deUso          = mab-eqpto.val-km-inicial
       contInicialSec = mab-eqpto.val-hodom-horim-sec
       deUsoSec       = mab-eqpto.val-km-sec.

/** Mostra frames de cabeáalho e rodapÇ padr‰es da Datasul **/
view frame f-cabec.
view frame f-rodape. 

/** Inicializa programa de acompanhamento padr∆o Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espaáo deve-se colocar a l¢gica para busca as informaá‰es e 
   tambÇm para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espaáo.
*********************************************************************/

/** Se N«O utiliza Contador Secund†rio, N«O mostrar Unidades Secund†rias em tela **/
FIND FIRST mab-eqpto
    WHERE mab-eqpto.cod-eqpto = tt-param.cod-eqpto
      AND mab-eqpto.log-cont-sec NO-LOCK NO-ERROR.
IF NOT AVAIL mab-eqpto THEN
    ASSIGN cDescUnSec  = ""
           cDescUnSec2 = cDescUnSec.

/** L¢gica opcional do programador **/
DISPLAY tt-param.ep-codigo
        tt-param.cod-eqpto
        cModelo
        cDescTip
        dtInicio
        contInicial
        cDescUn
        deUso
        cDescUn2
        contInicialSec
        cDescUnSec
        deUsoSec
        cDescUnSec2 SKIP(1)
    WITH FRAME f-visoes.

IF tt-param.lGeraExcel
THEN DO:
    PUT STREAM stExcel UNFORMATTED
        tt-param.ep-codigo:LABEL
        ":;"
        tt-param.ep-codigo
        ";"
        tt-param.cod-eqpto
        ";"
        cModelo
        SKIP
        cDescTip:LABEL
        ":;"
        cDescTip
        SKIP
        dtInicio:LABEL
        ":;"
        dtInicio
        SKIP
        contInicial:LABEL
        ":;"
        contInicial
        ";"
        cDescUn
        SKIP
        deUso:LABEL
        ":;"
        deUso
        ";"
        cDescUn2
        SKIP
        contInicialSec:LABEL
        ":;"
        contInicialSec
        ";"
        cDescUnSec
        SKIP
        deUsoSec:LABEL
        ":;"
        deUsoSec
        ";"
        cDescUnSec2
        SKIP(1)
        .
END.


FOR EACH tt-digita NO-LOCK
    BREAK BY tt-digita.dat-movto   DESCENDING
          BY tt-digita.hra-inicial DESCENDING:
    FOR FIRST mab-abastec-lubrific fields(num-docto idi-consist)
        WHERE mab-abastec-lubrific.num-docto = tt-digita.num-docto no-lock:
        ASSIGN cDescStatus = {frinc/i00fr055.i 04 mab-abastec-lubrific.idi-consist}.
    END.
    ASSIGN cDescTpDoc = {frinc/i00fr060.i 04 tt-digita.idi-origem}.
    DISPLAY tt-digita.dat-movto
            tt-digita.hra-inicial
            tt-digita.val-hodom-horim
            cDescUN
            tt-digita.val-km-real
            tt-digita.val-livre-1 FORMAT ">,>>>,>>9.9" 
            cDescUnSec           
            tt-digita.val-livre-2 FORMAT ">,>>>,>>9.9"
            tt-digita.num-docto
            cDescTpDoc
            tt-digita.log-abastec-prim  COLUMN-LABEL "Prim"
            cDescStatus     FORMAT "X(28)"
        WITH FRAME f-dados.
    DOWN WITH FRAME f-dados.

    IF tt-param.lGeraExcel
    THEN DO:
        IF tgPrimeiro THEN DO:
            PUT STREAM stExcel UNFORMATTED
                        tt-digita.dat-movto:LABEL
                        ";"
                        tt-digita.hra-inicial:LABEL
                        ";"
                        tt-digita.val-hodom-horim:LABEL
                        ";"
                        cDescUN:LABEL
                        ";"
                        tt-digita.val-km-real:LABEL
                        ";"
                        tt-digita.val-livre-1:LABEL
                        ";"
                        cDescUnSec:LABEL
                        ";"
                        tt-digita.val-livre-2:LABEL
                        ";"
                        tt-digita.num-docto:LABEL
                        ";"
                        cDescTpDoc:LABEL
                        ";"
                        tt-digita.log-abastec-prim:LABEL
                        ";"
                        cDescStatus:LABEL
                        SKIP.
            ASSIGN tgPrimeiro = NO.
        END.
        PUT STREAM stExcel
                    tt-digita.dat-movto
                    ";"
                    tt-digita.hra-inicial
                    ";"
                    tt-digita.val-hodom-horim
                    ";"
                    cDescUN
                    ";"
                    tt-digita.val-km-real
                    ";"
                    tt-digita.val-livre-1 FORMAT ">,>>>,>>9.9" 
                    ";"
                    cDescUnSec           
                    ";"
                    tt-digita.val-livre-2 FORMAT ">,>>>,>>9.9"
                    ";"
                    tt-digita.num-docto
                    ";"
                    cDescTpDoc
                    ";"
                    tt-digita.log-abastec-prim
                    ";"
                    cDescStatus
                    SKIP.

    END.


END.

/*********************************************************************
   Fim do espaáo para l¢gica de c†lculo e display das informaá‰es
*********************************************************************/

/** Finaliza programa de acompanhamento padr∆o Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

