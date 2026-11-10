&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */


def temp-table tt-dados no-undo
    field i-cod-emit           like emitente.cod-emit
    field fi-periodo           as char         format "99/9999"
    field da-data-conver       as date
    field tipo-consulta        as int initial 1
    field cod-versao-integ     as int
    field l-vid-rel            as logical.

def temp-table tt-estatistica no-undo
    field dt-maior-tit         like estatist.dt-maior-tit
    field vl-maior-tit         like estatist.vl-maior-tit
    field dt-ult-tit           like estatist.dt-ult-tit
    field vl-ult-tit           like estatist.vl-ult-tit 
    field fi-vendas            as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-acumuladas as decimal      format "->>,>>>,>>9.99"
    field fi-saldo-aberto      as decimal      format "->>,>>>,>>9.99"
    field fi-periodo-1         as char         
    field fi-periodo-2         as char     
    field fi-periodo-3         as char     
    field fi-periodo-4         as char     
    field fi-periodo-5         as char     
    field fi-periodo-6         as char     
    field fi-periodo-7         as char     
    field fi-periodo-8         as char     
    field fi-periodo-9         as char     
    field fi-periodo-10        as char     
    field fi-periodo-11        as char     
    field fi-periodo-12        as char    
    field fi-atm-1             as integer      format "->>9"
    field fi-atm-2             as integer      format "->>9"
    field fi-atm-3             as integer      format "->>9"
    field fi-atm-4             as integer      format "->>9"
    field fi-atm-5             as integer      format "->>9"
    field fi-atm-6             as integer      format "->>9"
    field fi-atm-7             as integer      format "->>9"
    field fi-atm-8             as integer      format "->>9"
    field fi-atm-9             as integer      format "->>9"
    field fi-atm-10            as integer      format "->>9"
    field fi-atm-11            as integer      format "->>9"
    field fi-atm-12            as integer      format "->>9"
    field fi-atm-media         as integer      format "->>9"
    field fi-pmr-1             as integer      format "->>9"
    field fi-pmr-2             as integer      format "->>9"
    field fi-pmr-3             as integer      format "->>9"
    field fi-pmr-4             as integer      format "->>9"
    field fi-pmr-5             as integer      format "->>9"
    field fi-pmr-6             as integer      format "->>9"
    field fi-pmr-7             as integer      format "->>9"
    field fi-pmr-8             as integer      format "->>9"
    field fi-pmr-9             as integer      format "->>9"
    field fi-pmr-10            as integer      format "->>9"
    field fi-pmr-11            as integer      format "->>9"
    field fi-pmr-12            as integer      format "->>9"
    field fi-pmr-media         as integer      format "->>9"
    field fi-vendas-1          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-2          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-3          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-4          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-5          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-6          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-7          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-8          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-9          as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-10         as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-11         as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-12         as decimal      format "->>,>>>,>>9.99"
    field fi-vendas-media      as decimal      format "->>,>>>,>>9.99".

def temp-table tt-estatistica-aux like tt-estatistica.

def temp-table tt-erro no-undo
    field i-cod-erro        as integer format "9999999"
    field c-desc-erro       as char format "x(70)"
    field c-arquivo-erro    as char format "x(100)".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOTempTable
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOTempTable ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


