&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN404Q01 2.00.00.007} /*** "010007" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin404q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN404
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-saldo-terc
&GLOBAL-DEFINE TableLabel tt-saldo-terc
&GLOBAL-DEFINE QueryName qr{&TableName}  

{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin404.i RowObject}
{inbo/boin404.i tt-saldo-terc}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
DEFINE QUERY qrSaldo for saldo-terc scrolling.

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&tableName}.
DEFINE BUFFER bfSaldoTerc    FOR saldo-terc.

def var l-sai-benef       as logical init yes no-undo.
def var l-ent-benef       as logical init yes no-undo.
def var l-transf          as logical init yes no-undo.
def var l-sai-consig      as logical init yes no-undo.
def var l-ent-consig      as logical init yes no-undo.
def var l-preco-medio     as logical init yes no-undo.
def var l-saldo-zero      as logical init yes no-undo.

define variable iCodEmit      as inte no-undo.
define variable cItCodigo     as char no-undo.
defin  variable cCallerProg   as char no-undo.
define variable cCodEstab     as char no-undo.
define variable iCodEmitIni   as inte no-undo.
define variable iCodEmitFim   as inte no-undo.
define variable cItemIni      as char no-undo.
define variable cItemFim      as char no-undo.
define variable cSerieIni     as char no-undo.
define variable cSerieFim     as char no-undo.
define variable cNroDoctoIni  as char no-undo.
define variable cNroDoctoFim  as char no-undo.
define variable cNat-OperIni  as char no-undo.
define variable cNat-OperFim  as char no-undo.
define variable dDtRetornoIni as date no-undo.
define variable dDtRetornoFim as date no-undo.


/********************* saldo-terc-duplic ********************************/
DEFINE TEMP-TABLE tt-saldo-terc-duplic NO-UNDO
    FIELD cod-emitente   like saldo-terc.cod-emitente
    FIELD cod-estabel    like saldo-terc.cod-estabel
    FIELD tipo-sal-terc  like saldo-terc.tipo-sal-terc
    FIELD it-codigo      like saldo-terc.it-codigo.
/**************************************************************/

/********************* Carrega TT ******************************/
def var c-naveg        as char  no-undo.
def var i-nrlinhas     as int   no-undo.
DEF VAR i-nr-page      AS INT   NO-UNDO.

def var i-pg-first     as INT   no-undo.
def var i-pg-last      as INT   no-undo.
DEF VAR r-ini-aux      AS ROWID NO-UNDO.
DEF VAR r-fim-aux      AS ROWID NO-UNDO.
DEF VAR i-cont         AS INT   NO-UNDO.
DEF VAR i-cont-pg      AS INT   NO-UNDO.
/**************************************************************/

DEFINE VAR c-it-codigo    LIKE saldo-terc.it-codigo    NO-UNDO.
DEFINE VAR i-cod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.96
         WIDTH              = 38.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSaldoTercEmit DBOProgram 
PROCEDURE carregaTTSaldoTercEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each {&tableName}:
        delete {&tableName}.
    end.

    /* i-nr-page => nro da pagina a ser exibida
       i-cont-pg => conta em que p†gina est† lendo registros
    */
    ASSIGN i-cont    = 0
           i-cont-pg = 0.

    IF i-nr-page = 0 THEN ASSIGN i-nrlinhas = i-nrlinhas + 1. /* corrigir defasagem da primeira pagina */
                     ELSE ASSIGN i-cont = -1.

    FOR EACH  saldo-terc where
                 saldo-terc.cod-emitente  = iCodEmit      AND
                 saldo-terc.cod-estabel   = cCodEstab     AND
                 saldo-terc.it-codigo    >= cItemIni      AND
                 saldo-terc.it-codigo    <= cItemFim      AND
                 saldo-terc.serie-docto  >= cSerieIni     and
                 saldo-terc.serie-docto  <= cSerieFim     and 
                 saldo-terc.nro-docto    >= cNroDoctoIni  and
                 saldo-terc.nro-docto    <= cNroDoctoFim  and
                 saldo-terc.nat-operacao >= cNat-OperIni  and
                 saldo-terc.nat-operacao <= cNat-OperFim  and
                 saldo-terc.dt-retorno   >= dDtRetornoIni and
                 saldo-terc.dt-retorno   <= dDtRetornoFim and
                 saldo-terc.quantidade >  0 
           and (   ( saldo-terc.tipo-sal-terc = 1 and l-sai-benef  )  
                or ( saldo-terc.tipo-sal-terc = 2 and l-ent-benef  )  
                or ( saldo-terc.tipo-sal-terc = 3 and l-transf     )   
                or ( saldo-terc.tipo-sal-terc = 4 and l-sai-consig )  
                or ( saldo-terc.tipo-sal-terc = 5 and l-ent-consig ) )
                NO-LOCK 
                BY saldo-terc.cod-emitente
                BY saldo-terc.it-codigo:

        find first tt-saldo-terc-duplic where
                   tt-saldo-terc-duplic.it-codigo     = saldo-terc.it-codigo     and
                   tt-saldo-terc-duplic.cod-emitente  = saldo-terc.cod-emitente  and
                   tt-saldo-terc-duplic.cod-estabel   = saldo-terc.cod-estabel   and
                   tt-saldo-terc-duplic.tipo-sal-terc = saldo-terc.tipo-sal-terc 
                   no-lock no-error.
        if not avail tt-saldo-terc-duplic then do:
            create tt-saldo-terc-duplic.
            assign tt-saldo-terc-duplic.it-codigo     = saldo-terc.it-codigo
                   tt-saldo-terc-duplic.cod-emitente  = saldo-terc.cod-emitente  
                   tt-saldo-terc-duplic.cod-estabel   = saldo-terc.cod-estabel  
                   tt-saldo-terc-duplic.tipo-sal-terc = saldo-terc.tipo-sal-terc. 
            
            ASSIGN i-cont = i-cont + 1.
            
            IF i-cont = i-nrlinhas THEN DO:   /* nro de linhas do browser */
               ASSIGN i-cont = 0.
               ASSIGN i-cont-pg = i-cont-pg + 1.
            END.
    
            IF (i-cont-pg = i-nr-page) THEN DO:
               create {&tableName}.
               buffer-copy saldo-terc to {&tableName}.
               /*assign {&tableName}.r-rowid = rowid(saldo-terc).*/
            END.
            
            /*ASSIGN i-cont = i-cont + 1.*/
            
            IF i-cont-pg > i-nr-page THEN LEAVE.
        END.
    END.

    ASSIGN i-pg-first = i-nr-page - 1.
    ASSIGN i-pg-last  = i-nr-page + 1.

    IF i-pg-first < 0 THEN ASSIGN i-pg-first = ?.
    IF i-cont <> 0 THEN ASSIGN i-pg-last  = ?.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTSaldoTercItem DBOProgram 
PROCEDURE carregaTTSaldoTercItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    for each {&tableName}:
        delete {&tableName}.
    end.

    /* i-nr-page => nro da pagina a ser exibida
       i-cont-pg => conta em que p†gina est† lendo registros
    */
    ASSIGN i-cont    = 0
           i-cont-pg = 0.

    IF i-nr-page = 0 THEN ASSIGN i-nrlinhas = i-nrlinhas + 1. /* corrigir defasagem da primeira pagina */
                     ELSE ASSIGN i-cont = -1.

    FOR EACH  saldo-terc where
                 saldo-terc.it-codigo    =  cItCodigo     and
                 saldo-terc.cod-estabel  =  cCodEstab     and
                 saldo-terc.cod-emitente >= iCodEmitIni   and
                 saldo-terc.cod-emitente <= iCodEmitFim   and
                 saldo-terc.serie-docto  >= cSerieIni     and
                 saldo-terc.serie-docto  <= cSerieFim     and 
                 saldo-terc.nro-docto    >= cNroDoctoIni  and
                 saldo-terc.nro-docto    <= cNroDoctoFim  and
                 saldo-terc.nat-operacao >= cNat-OperIni  and
                 saldo-terc.nat-operacao <= cNat-OperFim  and
                 saldo-terc.dt-retorno   >= dDtRetornoIni and
                 saldo-terc.dt-retorno   <= dDtRetornoFim and
                 saldo-terc.quantidade >  0 
           and (   ( saldo-terc.tipo-sal-terc = 1 and l-sai-benef  )  
                or ( saldo-terc.tipo-sal-terc = 2 and l-ent-benef  )  
                or ( saldo-terc.tipo-sal-terc = 3 and l-transf     )   
                or ( saldo-terc.tipo-sal-terc = 4 and l-sai-consig )  
                or ( saldo-terc.tipo-sal-terc = 5 and l-ent-consig ) )
                 NO-LOCK 
              BY saldo-terc.it-codigo 
              BY saldo-terc.cod-emitente:

        find first tt-saldo-terc-duplic where
                   tt-saldo-terc-duplic.it-codigo     = saldo-terc.it-codigo     and
                   tt-saldo-terc-duplic.cod-emitente  = saldo-terc.cod-emitente  and
                   tt-saldo-terc-duplic.cod-estabel   = saldo-terc.cod-estabel   and
                   tt-saldo-terc-duplic.tipo-sal-terc = saldo-terc.tipo-sal-terc 
                   no-lock no-error.
        if not avail tt-saldo-terc-duplic then do:
            create tt-saldo-terc-duplic.
            assign tt-saldo-terc-duplic.it-codigo     = saldo-terc.it-codigo
                   tt-saldo-terc-duplic.cod-emitente  = saldo-terc.cod-emitente  
                   tt-saldo-terc-duplic.cod-estabel   = saldo-terc.cod-estabel  
                   tt-saldo-terc-duplic.tipo-sal-terc = saldo-terc.tipo-sal-terc. 
            
            ASSIGN i-cont = i-cont + 1.
            
            IF i-cont = i-nrlinhas THEN DO:   /* nro de linhas do browser */
               ASSIGN i-cont = 0.
               ASSIGN i-cont-pg = i-cont-pg + 1.
            END.
    
            IF (i-cont-pg = i-nr-page) THEN DO:
               create {&tableName}.
               buffer-copy saldo-terc to {&tableName}.
               /*assign {&tableName}.r-rowid = rowid(saldo-terc).*/
            END.
            
            /*ASSIGN i-cont = i-cont + 1.*/
            
            IF i-cont-pg > i-nr-page THEN LEAVE.
        END.
    END.

    ASSIGN i-pg-first = i-nr-page - 1.
    ASSIGN i-pg-last  = i-nr-page + 1.

    IF i-pg-first < 0 THEN ASSIGN i-pg-first = ?.
    IF i-cont <> 0 THEN ASSIGN i-pg-last  = ?.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "desp-cons":U THEN ASSIGN pFieldValue = RowObject.desp-cons.
        WHEN "qt-aloca-trans":U THEN ASSIGN pFieldValue = RowObject.qt-aloca-trans.
        WHEN "qtd-ini":U THEN ASSIGN pFieldValue = RowObject.qtd-ini.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "sald-ini-mat":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mat.
        WHEN "sald-ini-mob":U THEN ASSIGN pFieldValue = RowObject.sald-ini-mob.
        WHEN "valor[1]":U THEN ASSIGN pFieldValue = RowObject.valor[1].
        WHEN "valor[2]":U THEN ASSIGN pFieldValue = RowObject.valor[2].
        WHEN "valor[3]":U THEN ASSIGN pFieldValue = RowObject.valor[3].
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm[1]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[1].
        WHEN "valor-icm[2]":U THEN ASSIGN pFieldValue = RowObject.valor-icm[2].
        WHEN "valor-ipi[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[1].
        WHEN "valor-ipi[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ipi[2].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[1].
        WHEN "valor-mob[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[2].
        WHEN "valor-mob[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "vl-icm-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-icm-cmi.
        WHEN "vl-ipi-cmi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-cmi.
        WHEN "vl-saldo-mat":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mat.
        WHEN "vl-saldo-mob":U THEN ASSIGN pFieldValue = RowObject.vl-saldo-mob.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescTipoSaldo DBOProgram 
PROCEDURE getDescTipoSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: recebe o tipo do saldo terceiros e retorna sua descriá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param i-tipo-sal as  int no-undo.
    def output param c-tipo-sal as char no-undo.

    if i-tipo-sal <= 0 
    or i-tipo-sal > 10 then 
       return "NOK":U.
    
    assign c-tipo-sal = {ininc/i01in404.i 04 i-tipo-sal}.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-prod":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-sal-terc":U THEN ASSIGN pFieldValue = RowObject.tipo-sal-terc.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           psequencia = RowObject.sequencia.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLastTT DBOProgram 
PROCEDURE getRowidFirstLastTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pi-pg-first        as CHAR no-undo.
    def output param pi-pg-last         as CHAR no-undo.

    ASSIGN pi-pg-first = string(i-pg-first)
           pi-pg-last  = string(i-pg-last).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE saldo-terc.sequencia NO-UNDO.

    FIND FIRST bf{&tableName} WHERE 
        bf{&tableName}.serie-docto = pserie-docto AND 
        bf{&tableName}.nro-docto = pnro-docto AND 
        bf{&tableName}.cod-emitente = pcod-emitente AND 
        bf{&tableName}.nat-operacao = pnat-operacao AND 
        bf{&tablename}.it-codigo = pit-codigo AND 
        bf{&tableName}.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&tableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&tableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE informaNavegRowid DBOProgram 
PROCEDURE informaNavegRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def INPUT PARAMETER pc-naveg    as char no-undo.
    def INPUT PARAMETER pc-nrPage   as CHAR no-undo.
    def INPUT PARAMETER pi-linhas   as INT  no-undo.

    assign c-naveg       = pc-naveg
           i-nr-page     = INT(pc-nrPage)
           i-nrlinhas    = pi-linhas.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente1 DBOProgram 
PROCEDURE openQueryEmitente1 :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&tableName} where NO-LOCK 
                                  BY {&tableName}.cod-emitente 
                                  BY {&tablename}.it-codigo 
                                  INDEXED-REPOSITION.    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem1 DBOProgram 
PROCEDURE openQueryItem1 :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&tableName} where NO-LOCK 
                                  BY {&tablename}.it-codigo 
                                  BY {&tableName}.cod-emitente 
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName} no-lock indexed-reposition.

  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnQtde DBOProgram 
PROCEDURE returnQtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM QTDE   AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM QTALOC AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM VALOR  AS DECIMAL NO-UNDO.

    def var dVal as decimal no-undo.

    FOR EACH  bfSaldoTerc /* FIELDS( serie-docto nro-docto cod-emitente nat-operacao
                                      it-codigo cod-refer sequencia quantidade dec-1
                                      valor-mat-m valor-mob-m valor-ggf-m ) */
        WHERE bfSaldoTerc.it-codigo     = {&tablename}.it-codigo     
          AND bfSaldoTerc.cod-emitente  = {&TableName}.cod-emitente  
          AND bfSaldoTerc.cod-estabel   = {&TableName}.cod-estabel   
          AND bfSaldoTerc.tipo-sal-terc = {&TableName}.tipo-sal-terc 
          AND bfSaldoTerc.serie-docto  >= cSerieIni      
          AND bfSaldoTerc.serie-docto  <= cSerieFim      
          AND bfSaldoTerc.nro-docto    >= cNroDoctoIni  
          AND bfSaldoTerc.nro-docto    <= cNroDoctoFim  
          AND bfSaldoTerc.nat-operacao >= cNat-OperIni   
          AND bfSaldoTerc.nat-operacao <= cNat-OperFim   
          AND bfSaldoTerc.dt-retorno   >= dDtRetornoIni 
          AND bfSaldoTerc.dt-retorno   <= dDtRetornoFim NO-LOCK:
     
            ASSIGN QTDE     = QTDE   + bfSaldoTerc.quantidade 
                   QTALOC   = QTALOC + bfSaldoTerc.dec-1.
            
            IF  l-preco-medio THEN DO:
                ASSIGN VALOR    = VALOR + 
                                  ((bfSaldoTerc.valor-mat-m[1] + bfSaldoTerc.valor-mob-m[1] 
                                   + bfSaldoTerc.valor-ggf-m[1]) * bfSaldoTerc.quantidade).
            END.
            ELSE DO:
                FOR FIRST componente FIELDS ( preco-total[1] quantidade ) 
                    OF bfSaldoTerc NO-LOCK:
                    ASSIGN VALOR = (componente.preco-total[1])
                                    + VALOR.
                END.
            END.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmitente DBOProgram 
PROCEDURE setConstraintEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    define input parameter pCodEmit    as inte no-undo.
    define input parameter pCallerProg as char no-undo.
    define input parameter pCodEstab   as char no-undo.
    define input parameter pItemIni    as char no-undo.    
    define input parameter pItemFim    as char no-undo.    
    define input parameter pSerieIni     like {&tableName}.serie-docto  no-undo.
    define input parameter pSerieFim     like {&tableName}.serie-docto  no-undo.
    define input parameter pNroDoctoIni  like {&tableName}.nro-docto    no-undo.
    define input parameter pNroDoctoFim  like {&tableName}.nro-docto    no-undo.
    define input parameter pNatOperIni   like {&tableName}.nat-operacao no-undo.
    define input parameter pNatOperFim   like {&tableName}.nat-operacao no-undo.
    define input parameter pDtRetornoIni like {&tableName}.dt-retorno   no-undo.
    define input parameter pDtRetornoFim like {&tableName}.dt-retorno   no-undo.

    assign iCodEmit      = pCodEmit
           cCallerProg   = pCallerProg
           cCodEstab     = pCodEstab  
           cItemIni      = pItemIni
           cItemFim      = pItemFim
           cSerieIni     = pSerieIni
           cSerieFim     = pSerieFim
           cNroDoctoIni  = pNroDoctoIni
           cNroDoctoFim  = pNroDoctoFim
           cNat-OperIni  = pNatOperIni
           cNat-OperFim  = pNatOperFim
           dDtRetornoIni = pDtRetornoIni
           dDtRetornoFim = pDtRetornoFim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    define input parameter pItCodigo     as char no-undo.
    define input parameter pCallerProg   as char no-undo.
    define input parameter pCodEstab     as char no-undo.
    define input parameter pCodEmitIni   as inte no-undo.
    define input parameter pCodEmitFim   as inte no-undo.
    define input parameter pSerieIni     like {&tableName}.serie-docto  no-undo.
    define input parameter pSerieFim     like {&tableName}.serie-docto  no-undo.
    define input parameter pNroDoctoIni  like {&tableName}.nro-docto    no-undo.
    define input parameter pNroDoctoFim  like {&tableName}.nro-docto    no-undo.
    define input parameter pNatOperIni   like {&tableName}.nat-operacao no-undo.
    define input parameter pNatOperFim   like {&tableName}.nat-operacao no-undo.
    define input parameter pDtRetornoIni like {&tableName}.dt-retorno   no-undo.
    define input parameter pDtRetornoFim like {&tableName}.dt-retorno   no-undo.
    
    assign cItCodigo     = pItCodigo
           cCallerProg   = pCallerProg
           cCodEstab     = pCodEstab  
           iCodEmitIni   = pCodEmitIni
           iCodEmitFim   = pCodEmitFim
           cSerieIni     = pSerieIni
           cSerieFim     = pSerieFim
           cNroDoctoIni  = pNroDoctoIni
           cNroDoctoFim  = pNroDoctoFim
           cNat-OperIni  = pNatOperIni
           cNat-OperFim  = pNatOperFim
           dDtRetornoIni = pDtRetornoIni
           dDtRetornoFim = pDtRetornoFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters DBOProgram 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pl-sai-benef      as logical no-undo.
    def input param pl-ent-benef      as logical no-undo.
    def input param pl-transf         as logical no-undo.
    def input param pl-sai-consig     as logical no-undo.
    def input param pl-ent-consig     as logical no-undo.
    def input param pl-preco-medio    as logical no-undo.
    def input param pl-saldo-zero     as logical no-undo.

    assign l-sai-benef      = pl-sai-benef
           l-ent-benef      = pl-ent-benef
           l-transf         = pl-transf
           l-sai-consig     = pl-sai-consig
           l-ent-consig     = pl-ent-consig
           l-preco-medio    = pl-preco-medio
           l-saldo-zero     = pl-saldo-zero.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

