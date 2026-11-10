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
{include/i-prgvrs.i AO0302RP 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302rp MAO}
&ENDIF


{include/i_fnctrad.i}
/*****************************************************************************
**
**       PROGRAMA: AO0302R
**
**       DATA....: Janeiro de 2005
**
**       AUTOR...: Carlos Valentini - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Impress∆o Consulta AO0302RP - Ficha de An†lise de ‡leo
**
*****************************************************************************/
                                             /** Definiá∆o das temp-tables **/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field i-seq            as integer
    field c-cod            as character format "x(300)"
    field i-visao          as integer
    field iTipo            as integer
    field cTipo            as character
    field lParam           as logical
    field lObs             as logical
    FIELD lHistorico       AS LOGICAL    
    field lQuebra          as logical.

{aop/ao0302.i3 tt-digita shared} /** Definiá∆o da temp-table de dados **/

def temp-table tt-raw-digita
   field raw-digita as raw.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.

/****************************************************************************/
                                               /** Definiá∆o de ParÉmetros **/   
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
/****************************************************************************/
                    /** Transferància de parÉmetros para temp-table padr∆o **/
create tt-param.
raw-transfer raw-param to tt-param.
/****************************************************************************/
                                                /** Definiá∆o de Vari†veis **/
DEFINE VARIABLE h-acomp     AS HANDLE                   NO-UNDO.
/**** Descriá‰es ****/
DEFINE VARIABLE cDescStatus AS character format "x(22)"  NO-UNDO.
DEFINE VARIABLE cDescResult AS character format "x(17)"  NO-UNDO.
DEFINE VARIABLE cDescLog    AS CHARACTER format "x(5)"   NO-UNDO.
DEFINE VARIABLE cVal-min    AS CHARACTER  format "x(25)" NO-UNDO.
DEFINE VARIABLE cVal-max    AS CHARACTER  format "x(25)" NO-UNDO.
DEFINE VARIABLE cDatResult  AS CHARACTER  FORMAT "X(25)" NO-UNDO.
DEFINE VARIABLE cDatResultAnt  AS CHARACTER  FORMAT "X(25)" NO-UNDO.
DEFINE VARIABLE cObs        AS CHARACTER  format "x(12)" NO-UNDO.
DEFINE VARIABLE c-cod-frasco AS CHARACTER FORMAT "X(12)":U NO-UNDO.
define buffer bfDigita  for tt-digita.
define buffer bfDigita2 for tt-digita.
{include/i-rpvar.i}
/****************************************************************************/
                                                     /** Cabeáalho e Forms **/
{aop/ao0302.i1}
{include/pi-edit.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fnLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnLog Procedure 
FUNCTION fnLog RETURNS CHARACTER
  ( pLog as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnResultado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnResultado Procedure 
FUNCTION fnResultado RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnStatus Procedure 
FUNCTION fnStatus RETURNS CHARACTER
  ( pEstado as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 9.21
         WIDTH              = 31.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/** Parametriza padr‰es de cabeáalho e rodapÇ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabeáalho e abre o output para arquivo **/
{include/i-rpcab.i}    
{include/i-rpout.i}

/** Procedure para inicializar c†lculos e impress∆o **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parÉmetros selecionados
------------------------------------------------------------------------------*/
/** Cria a p†gina dos parÉmetros **/
page.

/******************************************************************
  Espaáo reservado para buscar informaá‰es a serem impressas nos 
  parÉmetros (Opcional)
******************************************************************/

/** L¢gica opcional do programador **/

/******************************************************************
  Final do espaáo reservado
******************************************************************/

DISPLAY /*PAR∂METROS*/
        c-liter-par
        tt-param.iTipo
        tt-param.cTipo
        tt-param.lHistorico
        tt-param.lObs
        tt-param.lQuebra
        
        /*IMPRESS«O*/
        c-liter-imp          
        c-destino            
        tt-param.arquivo
        tt-param.usuario     
    WITH FRAME f-param-definidos.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeDados) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeDados Procedure 
PROCEDURE imprimeDados :
/*------------------------------------------------------------------------------
  Purpose:     imprimeDados
  Parameters:  <none>
  Notes:       Busca n°veis abaixo, coforme seleá∆o do n°vel
------------------------------------------------------------------------------*/
define input parameter cDimensao as character  no-undo.
define variable cPai as character no-undo.
assign cPai = "".

for each  bfDigita 
    where bfDigita.cod-dimens-pai = cDimensao no-lock:
    /** Verifica se existem n°veis abaixo  **/
    if bfDigita.sequencia <= tt-param.i-visao then do:
        /** Chama recursivamente atÇ encontrar vis∆o pai dos Resultados **/
        run imprimeDados (bfDigita.cod-dimensao).
    end.
    else do:
        if cPai <> bfDigita.cod-dimens-pai then do:
            /** Imprime os cabeáalhos **/
            IF NOT tt-param.lHistorico AND NOT tt-Param.lObs THEN
                PUT SKIP (1).
            PUT SKIP(1).
            run imprimeVisao (input rowid(bfDigita),         
                              input bfDigita.cod-dimens-pai).
            put skip(1).
            assign cPai = bfDigita.cod-dimens-pai.
        end.

        {utp/ut-liter.i Documento * }
        assign bfDigita.cod-oficial:label in frame f-dados        = trim(return-value)
               cDescLog                                           = fnLog(bfDigita.log-padrao)          
               cDescStatus                                        = fnStatus(bfDigita.idi-estado-ensaio)
               cDescResult                                        = fnResultado(bfDigita.idi-tip-restdo)
               cVal-min                                           = bfDigita.des-val-min
               cVal-max                                           = bfDigita.des-val-max
               cDatResult                                         = SUBSTRING(bfDigita.dat-result,1,25)
               cDatResultAnt                                      = SUBSTRING(bfDigita.dat-result-ant,1,25). 

        display bfDigita.cod-oficial     format "x(20)"        at 01          
                bfDigita.cod-ensaio      format "x(08)"        at 22          
                bfDigita.desc-dimensao   format "x(30)"        at 31         
                cDescStatus              format "x(25)"        at 62          
                cDescLog                 format "x(05)"        at 88          
                bfDigita.des-val-restdo  format "x(25)"        at 97 
                with frame f-dados.
                down with frame f-dados.

        /* Verifica se usu†rio deseja imprimir o Hist¢rico. */
        IF tt-param.lHistorico THEN DO:  
              /*busca e grava os valores dos campos Ultimo Resultado e Pen£ltimo Resultado*/

              /**** Busca o £ltimo ensaio****/
              FIND FIRST mao-amostra-oleo WHERE mao-amostra-oleo.num-amostra-oleo = int(bfDigita.cod-oficial) NO-LOCK NO-ERROR.
              IF AVAIL mao-amostra-oleo THEN DO:
                  FIND PREV mao-amostra-oleo NO-LOCK NO-ERROR.
                  IF AVAIL mao-amostra-oleo THEN DO:

                        /*grava o label do campo £ltimo resultado (Data)*/
                        ASSIGN cDatResult:label in frame f-historico = string(mao-amostra-oleo.dat-amostra).
                        /*procura resultado do ensaio daquela amostra*/
                        FIND FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo = mao-amostra-oleo.num-amostra-oleo
                                                       AND mao-restdo-ensaio.cod-ensaio       = bfDigita.cod-ensaio NO-LOCK NO-ERROR.
                        IF AVAIL mao-restdo-ensaio THEN
                            ASSIGN substring(bfDigita.dat-result,1,25) = string(mao-restdo-ensaio.des-val-restdo).
                        ELSE
                            ASSIGN bfDigita.dat-result = "".

                        /*Busca o pen£ltimo ensaio*/
                        FIND PREV mao-amostra-oleo NO-LOCK NO-ERROR.
                        IF AVAIL mao-amostra-oleo THEN DO:
                            /*grava o label do campo £ltimo resultado (Data)*/
                            ASSIGN cDatResultAnt:label in frame f-historico = string(mao-amostra-oleo.dat-amostra).
                            /*procura resultado do ensaio daquela amostra*/
                            FIND FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo = mao-amostra-oleo.num-amostra-oleo
                                                           AND mao-restdo-ensaio.cod-ensaio       = bfDigita.cod-ensaio NO-LOCK NO-ERROR.
                            IF AVAIL mao-restdo-ensaio THEN
                                ASSIGN substring(bfDigita.dat-result-ant,1,25) = string(mao-restdo-ensaio.des-val-restdo).
                            ELSE
                                ASSIGN bfDigita.dat-result-ant = "":U.
                         END. /*IF AVAIL mao-amostra-oleo PENULTIMO*/
                         ELSE DO:
                              {utp/ut-liter.i Pen£ltimo_Resultado * }
                              ASSIGN cDatResultAnt:LABEL IN FRAME f-historico = RETURN-VALUE
                                     bfDigita.dat-result-ant               = "":U.
                         END.

                  END. /*IF AVAIL mao-amostra-oleo*/
                  ELSE DO: 
                      /*nao encontrou £ltimo ensaio, entao grava branco.*/
                      {utp/ut-liter.i Èltimo_Resultado * }
                      ASSIGN cDatResult:label in frame f-historico = RETURN-VALUE.
                             bfDigita.dat-result                   = "":U.
                      {utp/ut-liter.i Pen£ltimo_Resultado * }
                      ASSIGN cDatResultAnt:LABEL IN FRAME f-historico = RETURN-VALUE
                             bfDigita.dat-result-ant               = "":U.
                  END.
              END. /*IF AVAIL mao-amostra-oleo THEN DO:*/
              ELSE DO: 
                  /*nao encontrou £ltimo ensaio, entao grava branco.*/
                  {utp/ut-liter.i Èltimo_Resultado * }
                  ASSIGN cDatResult:label in frame f-historico = RETURN-VALUE.
                         bfDigita.dat-result                   = "":U.
                  {utp/ut-liter.i Pen£ltimo_Resultado * }
                  ASSIGN cDatResultAnt:LABEL IN FRAME f-historico = RETURN-VALUE
                         bfDigita.dat-result-ant               = "":U.
              END.

              PUT SKIP(1).
              DISPLAY cVal-min             format "x(25)"  at 03                            
                      cVal-max             format "x(25)"  at 30                            
                      bfDigita.num-tabela                  at 56                            
                      bfDigita.dat-result     @ cDatResult        FORMAT "X(25)"  at 63  
                      bfDigita.dat-result-ant @ cDatResultAnt     FORMAT "X(25)"  at 89  
                      cDescResult                          at 115  
                      with frame f-historico.
                      down with frame f-historico.
              PUT SKIP(1).
        END.

        /* Verifica se usu†rio deseja imprimir a Observaá∆o. */
        if tt-Param.lObs then do:
           if bfDigita.dsl-obs <> "" then do:
               IF NOT tt-param.lHistorico THEN
                    PUT SKIP (01).
               empty temp-table tt-editor.
               run pi-print-editor (bfDigita.dsl-obs, 80).
               DISP cObs with frame f-obs.
               for each tt-editor where tt-editor.linha >= 1:
                   Put tt-editor.conteudo at 37.
               end.
               put skip(1).
           end.
        end.
    end.

   /****Quebra p†gina por Documento ****/
   if tt-param.lQuebra  THEN DO:
       FIND FIRST bfDigita2 WHERE  rowid(bfDigita2) = rowid(bfDigita) NO-LOCK NO-ERROR.
       IF AVAIL bfDigita2 THEN DO:
           FIND NEXT bfDigita2 WHERE bfDigita2.cod-dimens-pai =   cDimensao        AND 
                     bfDigita2.sequencia                      >  tt-param.i-visao  NO-LOCK NO-ERROR.
           IF NOT AVAIL bfDigita2 THEN
              page.
       END.        
   END. /*if tt-param.lQuebra */
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imprimeVisao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimeVisao Procedure 
PROCEDURE imprimeVisao :
/*------------------------------------------------------------------------------
  Purpose:     imprimeVisao
  Parameters:  entrada rRow    = Rowid da temp-table                
               entrada cCodPai = C¢digo da dimens∆o do registro pai 
  Notes:       Imprime os cabeáalhos, buscando os n°veis acima do selecionado
------------------------------------------------------------------------------*/
define input parameter rRow    as rowid     no-undo.
define input parameter cCodPai as character no-undo.

/** Verifica se existem vis‰es acima **/
if can-find(first bfDigita2
            where bfDigita2.cod-dimensao = cCodPai no-lock) then do:
    /** Se existir, chama recursivamente enquanto existir **/
    for first bfDigita2
        where bfDigita2.cod-dimensao = cCodPai no-lock:
        /** Chamada recursiva **/
        run imprimeVisao (input rowid(bfDigita2),
                          input bfDigita2.cod-dimens-pai).
    end.
end.
/** Imprime a vis∆o, ignorando se for uma tarefa **/
for first bfDigita2
    where rowid(bfDigita2) = rRow 
    and   bfDigita2.p-image <> 12 no-lock:
    /** Busca label do c¢digo **/
    {aop/ao0302.i2 bfDigita2.p-image}
    assign tt-digita.cod-oficial:label in frame f-visoes = trim(return-value).
    /** Imprime vis∆o **/
    display bfDigita2.cod-oficial   @ tt-digita.cod-oficial   
            bfDigita2.desc-dimensao @ tt-digita.desc-dimensao
        with frame f-visoes.
    down with frame f-visoes.
/*     IF bfDigita2.cod-oficial <> 0 THEN               */
/*         ASSIGN c-cod-frasco = bfDigita2.cod-oficial. */
end.

return "OK":U.

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
assign c-programa = "AO/0302"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
.
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
find first tt-param.

/** Busca empresa padr∆o **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t°tulos **/
{utp/ut-liter.i "Resultados dos Ensaios" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "ANµLISE DE ‡LEO" *}
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

/** Imprime Somente vis∆o selecionada **/
if tt-param.iTipo = 1 then do:
  /** AtravÇs da vis∆o selecionada, chama a impress∆o **/
  for first tt-digita
      where tt-digita.sequencia    = tt-param.i-seq
      and   tt-digita.cod-dimensao = tt-param.c-cod no-lock:
      /** Busca vis‰es a serem impressas **/
      run imprimeDados (input tt-digita.cod-dimensao).
  end.
end.
/** Imprime Completo **/
else do:
    /** Busca todas as vis‰es de primeiro n°vel **/
    for each  tt-digita
        where tt-digita.sequencia = 1 no-lock:
        /** Busca vis‰es a serem impressas **/
        run imprimeDados (input tt-digita.cod-dimensao).
    end.
end.

/*********************************************************************
   Fim do espaáo para l¢gica de c†lculo e display das informaá‰es
*********************************************************************/

/** Mostra parÉmetros selecionados **/
if tt-param.lParam then
    run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padr∆o Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fnLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnLog Procedure 
FUNCTION fnLog RETURNS CHARACTER
  ( pLog as logical ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(5)" NO-UNDO.
if pLog  then do:
 {utp/ut-liter.i Sim * }
  assign cDesc =  return-value.   
end.
else do:
 {utp/ut-liter.i N∆o * }
  assign cDesc =  return-value.   
end.
RETURN cDesc.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnResultado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnResultado Procedure 
FUNCTION fnResultado RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.
if pEstado <> 0 THEN DO:
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao002 = {frinc/i00fr103.i 04 pEstado }.
       run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                           INPUT "",
                           INPUT "").
       ASSIGN  cDesc = RETURN-VALUE.
   &else
       ASSIGN cDesc = {frinc/i00fr103.i 04 pEstado }.
   &endif
END.
else
   assign cDesc = "":U.


  RETURN cDesc.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fnStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnStatus Procedure 
FUNCTION fnStatus RETURNS CHARACTER
  ( pEstado as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDesc AS CHARACTER format "x(30)" NO-UNDO.
if pEstado <> 0 THEN DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao003 = {frinc/i00fr105.i 04 pEstado }.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  cDesc = RETURN-VALUE.
    &else
        ASSIGN cDesc = {frinc/i00fr105.i 04 pEstado }.
    &endif
END.
else
    assign cDesc = "":U.


  RETURN cDesc.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

