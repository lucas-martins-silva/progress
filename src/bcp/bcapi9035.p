/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9035 2.00.00.007 } /*** "010007" ***/

&if '{&mgscm_version}' >= '2.04' &then
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : bcp/bcapi9026.p
    Purpose     : Permitir a impress’o de etiquetas pelo WMS

    Syntax      :

    Description :

    Author(s)   : Frank Rinald Rodrigues
    Created     : 20 de maio de 2006
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* tt-wms-etiq-packing */
DEFINE TEMP-TABLE tt-wms-etiq-packing LIKE wms-etiq-packing. 
/* DEFINIDO desta forma pois a tabela nao consta na versao 2.02 - FLAVIO.ARCEGA */
DEFINE VARIABLE h_bcapi001 AS HANDLE      NO-UNDO.


/* Definicao da temp-table ROWERRORS */
{method/dbotterr.i}

/*** Definicao das temp-tables para a API de criacao de transacao do CLD tt-trans***/
{bcp/bcapi001.i}

/*** Definicao da temp-table de erros ***/
{cdp/cd0666.i}

/*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta***/
{bcp/bcapi002.i}

/* Restada o usuÿrio que estÿ conectado no EMS */
def new global shared var c-seg-usuario as char  format "x(12)" no-undo.

run bcp/bcapi001.p PERSISTENT SET h_bcapi001 (  input-output table tt-trans,
                                                input-output table tt-erro).



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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-geraEtiquetaPacking) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraEtiquetaPacking Procedure 
PROCEDURE geraEtiquetaPacking :
/*------------------------------------------------------------------------------
  Purpose:     Imprime etiquetas Master a partir do m½dulo WMS
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-wms-etiq-packing.                 /*Temp-table*/
    DEFINE INPUT  PARAMETER pcCdTransacao   LIKE bc-tipo-trans.cd-trans.    /*Codigo da transa»’o no DATACOLLECTION */
    DEFINE INPUT  PARAMETER piCodLayout     LIKE tipo-etiqueta.cod-layout.  /*Layout da etiqueta no DATACOLLECTION*/
    DEFINE INPUT  PARAMETER piQtdEtiqueta   AS INTEGER  NO-UNDO.            /*Campo reservado*/
    DEFINE OUTPUT PARAMETER TABLE FOR rowerrors.                            /*Retorna a temp-table de erros*/
    /*  */
    DEFINE VARIABLE i-sequencia AS INTEGER NO-UNDO.
    /*  */
    EMPTY TEMP-TABLE rowerrors.
    EMPTY TEMP-TABLE tt-etiqueta.

    /* Gera a etiqueta para todos os registros da tt-wms-etiq-packing */
    FOR EACH tt-wms-etiq-packing.
        /*  */
        EMPTY TEMP-TABLE TT-ERRO.
        EMPTY TEMP-TABLE TT-TRANS.
        /*  */
        ASSIGN i-sequencia = i-sequencia + 1.

        /* Cria a temp-table, passando a transacao e tipo de etiqueta */
        CREATE tt-etiqueta.
        ASSIGN 
            tt-etiqueta.cod-versao-integracao   = 1
            tt-etiqueta.i-sequen                = i-sequencia
            tt-etiqueta.cd-trans                = pcCdTransacao /*wmout014*/  
            tt-etiqueta.tipo-etiq               = piCodLayout /*98*/
            tt-etiqueta.usuario                 = c-seg-usuario 
            tt-etiqueta.dt-impressao            = TODAY
            tt-etiqueta.hora-impressao          = STRING(TIME,"HH:MM:SS")
            tt-etiqueta.qt-etiqueta             = piQtdEtiqueta
            tt-etiqueta.quantidade              = 1                                            /*Quantidade vai ser sempre 1*/
            tt-etiqueta.cod-estabel             = tt-wms-etiq-packing.cod-estabel
            tt-etiqueta.auxiliar-11             = STRING(tt-wms-etiq-packing.val-etiq-packing) /*Codigo de barra da etiqueta*/ 
            tt-etiqueta.auxiliar-12             = STRING(tt-wms-etiq-packing.cdd-embarq)       /*Numero de embarque*/
            tt-etiqueta.auxiliar-13             = STRING(tt-wms-etiq-packing.nr-resumo)        /*Numero do resumo*/
            tt-etiqueta.auxiliar-14             = tt-wms-etiq-packing.nome-abrev               /*Nome abriviado do cliente*/
            tt-etiqueta.auxiliar-15             = STRING(tt-wms-etiq-packing.nr-pedcli)        /*Codigo pedido do cliente*/
            tt-etiqueta.auxiliar-16             = STRING(tt-wms-etiq-packing.dt-geracao)       /*DAta da geracao*/
            tt-etiqueta.auxiliar-17             = STRING(tt-wms-etiq-packing.hra-gerac)       /*Hora da geracao*/
            tt-etiqueta.auxiliar-18             = STRING(tt-wms-etiq-packing.nr-pedido)        /*Numero do pedido*/
            tt-etiqueta.auxiliar-19             = STRING(tt-wms-etiq-packing.num-volume)       /*Numero do volume*/
            tt-etiqueta.auxiliar-20             = c-seg-usuario                                /*Usuario na etiqueta*/ .

        /*  */
        RUN piCriaTransacao IN THIS-PROCEDURE (INPUT TABLE tt-etiqueta,
                                               OUTPUT TABLE tt-erro).

        /* Transfere os erros de temp-table */
        FOR EACH tt-erro.
            CREATE rowerrors.
            ASSIGN 
                rowerrors.ErrorSequence     = tt-erro.i-sequen
                rowerrors.ErrorNumber       = tt-erro.cd-erro
                rowerrors.ErrorDescription  = tt-erro.mensagem + ' (DC)'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaTransacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTransacao Procedure 
PROCEDURE piCriaTransacao PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-etiqueta.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    

    /*  */
    DEFINE VARIABLE cDetalhe AS CHARACTER  NO-UNDO. /*Armazena o detalhe da transa»’o*/

    /*  */
    FIND FIRST tt-etiqueta NO-ERROR.

    /*  */
    ASSIGN 
        cDetalhe = 'EMB: ' + tt-etiqueta.auxiliar-12 + 
                   ' RES: ' + tt-etiqueta.auxiliar-13 + 
                   ' CLI: ' + tt-etiqueta.auxiliar-14 + 
                   ' ETQ: ' + tt-etiqueta.auxiliar-11.
    /*  */
    CREATE tt-trans.
    assign 
        tt-trans.cod-versao-integracao = 1
        tt-trans.i-sequen              = tt-etiqueta.i-sequen
        tt-trans.cd-trans              = tt-etiqueta.cd-trans
        tt-trans.usuario               = tt-etiqueta.usuario
        tt-trans.atualizada            = no
        tt-trans.etiqueta              = YES
        tt-trans.detalhe               = cDetalhe.
    
    /*  */
    Raw-transfer TT-ETIQUETA To tt-trans.conteudo-trans.
    
    /*  */

    RUN piCriaTransacao IN h_bcapi001 ( input-output table tt-trans,
                                        input-output table tt-erro).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaTransacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTransacao Procedure 
PROCEDURE piFinalizaAPI  :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h_bcapi001)
    THEN DO:
        RUN piFinalizaAPI IN h_bcapi001.
        DELETE PROCEDURE h_bcapi001.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&endif.
