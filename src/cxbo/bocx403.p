&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOCX403 2.00.00.027 } /*** "010027" 10/07/2026 16:52:56 ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX403
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-adic
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{cxbo/bocx403.i RowObject} /*:T--- Include com definiá∆o da temptable RowObject ---*/
{cxbo/bocx402.i tt-decla-import-adic-itens}
{cxbo/bocx402.i tt-decla-import-adic-itens-aux}
{cxbo/bocx403.i tt-decla-import-adic}
{cxbo/bocx403.i tt-decla-import-adic-impostos}
{cxbo/bocx403.i tt-decla-import-adic-aux}
{cxbo/bocx404.i tt-decla-import-ord}
{cxbo/bocx404.i tt-decla-import-ord-aux}
{cxbo/bocx390.i tt-despes-adic}
{cxbo/bocx390.i tt-despes-adic-aux}
{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx351.i tt-licenciam-import-oc-aux}
{cxbo/bocx00506.i tt-decla-import-adic-trib}
{cxbo/bocx00506.i tt-decla-import-adic-trib-aux}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib}
{cxbo/bocx00512.i tt-decla-imp-adic-it-trib-aux}

DEFINE TEMP-TABLE tt-erro-adic NO-UNDO
    FIELD num-adic  LIKE decla-import-adic.num-adic
    FIELD num-erro  AS INTEGER
    FIELD desc-erro AS CHARACTER FORMAT "X(100)":U.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE h-bocx404         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx402         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx407         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx390         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx383a        AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx351         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00506       AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx00512       AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-lbl-traducao              AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i-reg-retornados            AS INTEGER                          NO-UNDO.
DEFINE VARIABLE l-utz-taxa-siscomex         AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE i-cod-desp                  AS INTEGER                          NO-UNDO.
DEFINE VARIABLE d-val-despes-tot            AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE d-val-despes                AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaIIantes                 AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaIPIantes                AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaPISantes                AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaCOFINSantes             AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaICMSantes               AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaIIdepois                AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaIPIdepois               AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaPISdepois               AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaCOFINSdepois            AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE somaICMSdepois              AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE i-cod-emitente-desp         LIKE emitente.cod-emitente          NO-UNDO.
DEFINE VARIABLE i-cod-cond-pag              LIKE emitente.cod-cond-pag          NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz-histor LIKE despes-adic.cdn-pto-contr      NO-UNDO.
DEFINE VARIABLE inum-di-ems                 LIKE decla-import.num-di-ems        NO-UNDO.
DEFINE VARIABLE inum-adic                   LIKE decla-import.num-adic          NO-UNDO.
DEFINE VARIABLE decdd-siscomex-dts          LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
DEFINE VARIABLE d-val-ii-aux                LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
DEFINE VARIABLE d-val-ipi-aux               LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
DEFINE VARIABLE d-val-pis-aux               LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
DEFINE VARIABLE d-val-cofins-aux            LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
DEFINE VARIABLE d-val-icms-aux              LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
DEFINE VARIABLE l-recalcula-trib            AS   LOGICAL INITIAL NO             NO-UNDO.
DEFINE VARIABLE l-nt2024002                 AS   LOGICAL                        NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).



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
         HEIGHT             = 17.96
         WIDTH              = 42.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*---[ Itens ]-------------------------------------------------------------------*/
    IF  l-nt2024002
    and not can-find(first decla-import-adic-itens NO-LOCK
                     WHERE decla-import-adic-itens.num-di-ems       = RowObject.num-di-ems
                     AND   decla-import-adic-itens.num-adic         = RowObject.num-adic
                     and   decla-import-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:

        FOR EACH decla-import-adic-trib EXCLUSIVE-LOCK
            WHERE decla-import-adic-trib.num-di-ems       = RowObject.num-di-ems
            AND   decla-import-adic-trib.num-adic         = RowObject.num-adic
            AND   decla-import-adic-trib.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
            DELETE decla-import-adic-trib.
        END.
    END.
    
    FOR EACH  decla-import-adic-itens EXCLUSIVE-LOCK
        WHERE decla-import-adic-itens.num-di-ems       = RowObject.num-di-ems
        AND   decla-import-adic-itens.num-adic         = RowObject.num-adic
        AND   decla-import-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
        FIRST decla-import-ord EXCLUSIVE-LOCK
            WHERE decla-import-ord.num-di-ems       = decla-import-adic-itens.num-di-ems
            AND   decla-import-ord.num-ordem        = decla-import-adic-itens.num-ordem
            AND   decla-import-ord.num-parcela      = decla-import-adic-itens.num-parcela
            AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
        
        IF l-nt2024002 THEN DO:
            FOR EACH decla-import-adic-trib
               WHERE decla-import-adic-trib.num-di-ems       = decla-import-adic-itens.num-di-ems
                 AND decla-import-adic-trib.num-adic         = decla-import-adic-itens.num-adic
                 and decla-import-adic-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts EXCLUSIVE-LOCK:
                 DELETE decla-import-adic-trib.
            END.
            FOR EACH decla-imp-adic-it-trib
               WHERE decla-imp-adic-it-trib.num-di-ems = decla-import-adic-itens.num-di-ems
                 AND decla-imp-adic-it-trib.num-adic   = decla-import-adic-itens.num-adic 
                 AND decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts EXCLUSIVE-LOCK:
                DELETE decla-imp-adic-it-trib.    
            END.
        END.
        ASSIGN decla-import-ord.num-adic  = 0
               decla-import-ord.num-seq   = 0.
        DELETE decla-import-adic-itens.
    END.

	/*---[ DI ]----------------------------------------------------------------------*/
	FOR FIRST decla-import EXCLUSIVE-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems
          AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts
          AND decla-import.log-ativo:
		  ASSIGN decla-import.num-adicoes = decla-import.num-adicoes - 1.
	END. 

    /*---[ NVE ]---------------------------------------------------------------------*/
    FOR EACH  decla-import-adic-nve EXCLUSIVE-LOCK
        WHERE decla-import-adic-nve.num-di-ems = RowObject.num-di-ems
        AND   decla-import-adic-nve.num-adic   = RowObject.num-adic
        AND   decla-import-adic-nve.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        
        DELETE decla-import-adic-nve.
    END. 

    /*---[ Doctos ]------------------------------------------------------------------*/
    FOR EACH  decla-import-adic-docto EXCLUSIVE-LOCK
        WHERE decla-import-adic-docto.num-di-ems = RowObject.num-di-ems
        AND   decla-import-adic-docto.num-adic   = RowObject.num-adic
        AND   decla-import-adic-docto.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE decla-import-adic-docto.
    END. 

    /*---[ Despesas das Adiá‰es ]----------------------------------------------------*/
    FOR EACH  despes-adic EXCLUSIVE-LOCK
        WHERE despes-adic.num-di-ems = RowObject.num-di-ems
        AND   despes-adic.num-adic   = RowObject.num-adic
        AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE despes-adic.
    END. 
    
    /*---[ Despesas dos Itens Adiá‰es ]----------------------------------------------*/
    FOR EACH  despes-adic-itens EXCLUSIVE-LOCK
        WHERE despes-adic-itens.num-di-ems = RowObject.num-di-ems
        AND   despes-adic-itens.num-adic   = RowObject.num-adic
        AND   despes-adic-itens.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
        DELETE despes-adic-itens.
    END. 

    FOR EACH duimp-item EXCLUSIVE-LOCK
        WHERE duimp-item.cod-duimp-dts = RowObject.num-di-ems
        and   duimp-item.seq-item      = RowObject.num-adic:
        
        FOR each duimp-acres-deduc-it EXCLUSIVE-LOCK
            WHERE duimp-acres-deduc-it.cod-duimp-dts = duimp-item.num-di-ems 
            and   duimp-acres-deduc-it.cod-item      = duimp-item.cod-item
            and   duimp-acres-deduc-it.seq-item      = duimp-item.seq-item:
            delete duimp-acres-deduc-it.
        END.
        
        DELETE duimp-item.
    END. 
    RELEASE decla-import.
    RELEASE decla-import-adic-trib.
    RELEASE decla-import-adic-itens.
    RELEASE decla-imp-adic-it-trib.
    RELEASE decla-import-adic-nve.
    RELEASE decla-import-adic-docto.
    RELEASE decla-import-ord.
    RELEASE duimp-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-recalcula-trib = NO.

    /*Todas as alteraá‰es feitas nas adiá‰es devem ser  levadas para as ordens que est∆o vinculadas */
    FOR EACH decla-import-ord EXCLUSIVE-LOCK
        WHERE decla-import-ord.num-di-ems = RowObject.num-di-ems
        AND   decla-import-ord.num-adic   = RowObject.num-adic 
        AND   decla-import-ord.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    
        ASSIGN decla-import-ord.log-emite-fabrican          = RowObject.log-emite-fabrican       
               decla-import-ord.cdn-fabrican                = RowObject.cdn-fabrican             
               decla-import-ord.cdn-naladi-sist-harmon      = RowObject.cdn-naladi-sist-harmon   
               decla-import-ord.cod-naladi-ncca             = RowObject.cod-naladi-ncca          
               decla-import-ord.cod-nbm                     = RowObject.cod-nbm                  
               decla-import-ord.cod-aladi                   = RowObject.cod-aladi                
               decla-import-ord.cod-licenc-import           = RowObject.cod-licenc-import        
               decla-import-ord.dat-livre-1                 = RowObject.dat-livre-1
               decla-import-ord.cod-tip-recip               = RowObject.cod-tip-recip            
               decla-import-ord.qtd-capac-recip             = RowObject.qtd-capac-recip          
               decla-import-ord.idi-ind-pagto               = RowObject.idi-ind-pagto
               decla-import-ord.idi-metod-val               = RowObject.idi-metod-val
               decla-import-ord.idi-tributac-icms           = RowObject.idi-tributac-icms              
               decla-import-ord.idi-tributac-ipi            = RowObject.idi-tributac-ipi            
               decla-import-ord.idi-tributac-pis            = RowObject.idi-tributac-pis            
               decla-import-ord.idi-tributac-cofins         = RowObject.idi-tributac-cofins         
               decla-import-ord.idi-tributac-impto-import   = RowObject.idi-tributac-impto-import   
               &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                   decla-import-ord.log-suspens-icms   = RowObject.log-suspens-icms    
                   decla-import-ord.log-suspens-pis    = RowObject.log-suspens-pis   
                   decla-import-ord.log-suspens-cofins = RowObject.log-suspens-cofins
               &ELSE
                   SUBSTRING(decla-import-ord.cod-livre-1,1,1) = SUBSTRING(RowObject.cod-livre-1,1,1) 
                   SUBSTRING(decla-import-ord.cod-livre-1,2,1) = SUBSTRING(RowObject.cod-livre-1,2,1) 
                   SUBSTRING(decla-import-ord.cod-livre-1,3,1) = SUBSTRING(RowObject.cod-livre-1,3,1) 
               &ENDIF
        
               decla-import-ord.val-aliq-cofins             = RowObject.val-aliq-cofins             
               decla-import-ord.val-aliq-icms               = RowObject.val-aliq-icms               
               decla-import-ord.val-aliq-ii                 = RowObject.val-aliq-ii                 
               decla-import-ord.val-aliq-ipi                = RowObject.val-aliq-ipi                
               decla-import-ord.val-aliq-pis                = RowObject.val-aliq-pis                
               decla-import-ord.val-perc-reduc-cofins       = RowObject.val-perc-reduc-cofins       
               decla-import-ord.val-perc-reduc-icms         = RowObject.val-perc-reduc-icms         
               decla-import-ord.val-perc-reduc-impto-import = RowObject.val-perc-reduc-impto-import   
               decla-import-ord.val-perc-reduc-ipi          = RowObject.val-perc-reduc-ipi          
               decla-import-ord.val-perc-reduc-pis          = RowObject.val-perc-reduc-pis          
               decla-import-ord.log-suspens-impto-import    = RowObject.log-suspens-impto-import    
               decla-import-ord.log-suspens-ipi-import      = RowObject.log-suspens-ipi-import      
               decla-import-ord.qtd-capac-recip             = RowObject.qtd-capac-recip             
               decla-import-ord.val-unit-pis                = RowObject.val-unit-pis                
               decla-import-ord.val-unit-cofins             = RowObject.val-unit-cofins             
               decla-import-ord.val-unit-ipi                = RowObject.val-unit-ipi.
    
        /*Atualizar as ordens embarque*/
        FOR FIRST ordens-embarque EXCLUSIVE-LOCK
            WHERE ordens-embarque.cod-estabel  = decla-import-ord.cod-estab 
            AND   ordens-embarque.embarque     = decla-import-ord.cod-embarq
            AND   ordens-embarque.numero-ordem = decla-import-ord.num-ordem
            AND   ordens-embarque.parcela      = decla-import-ord.num-parcela:
    
            ASSIGN ordens-embarque.val-cub-tot              = decla-import-ord.val-cub-tot
                   ordens-embarque.peso-liquido             = decla-import-ord.val-peso-liq
                   ordens-embarque.peso-bruto               = decla-import-ord.val-peso-brut-merc
                   ordens-embarque.idi-tributac-pis         = decla-import-ord.idi-tributac-pis
                   ordens-embarque.cd-trib-ipi              = decla-import-ord.idi-tributac-ipi
                   ordens-embarque.cd-trib-ii               = decla-import-ord.idi-tributac-impto-import
                   ordens-embarque.cd-trib-icms             = decla-import-ord.idi-tributac-icms
                   ordens-embarque.idi-tributac-cofins      = decla-import-ord.idi-tributac-cofins
                   ordens-embarque.log-suspens-impto-import = decla-import-ord.log-suspens-impto-import
                   ordens-embarque.log-suspens-ipi-import   = decla-import-ord.log-suspens-ipi-import
                   ordens-embarque.val-aliq-ext-pis         = decla-import-ord.val-aliq-pis
                   ordens-embarque.dec-1                    = decla-import-ord.val-aliq-pis
                   ordens-embarque.aliquota-ipi             = decla-import-ord.val-aliq-ipi
                   ordens-embarque.aliquota-ii              = decla-import-ord.val-aliq-ii
                   ordens-embarque.aliquota-icms            = decla-import-ord.val-aliq-icms
                   ordens-embarque.val-aliq-ext-cofins      = decla-import-ord.val-aliq-cofins
                   ordens-embarque.dec-2                    = decla-import-ord.val-aliq-cofins
                   OVERLAY(ordens-embarque.char-1,80,4)     = STRING(decla-import-ord.num-seq) /*SEQ ITEM ADIC*/
                   OVERLAY(ordens-embarque.char-1,105,8)    = STRING(RowObject.val-aliq-ii, ">>9.9999":U)
                   ordens-embarque.num-adic                 = decla-import-ord.num-adic.
    
        END. 
    
        /*LI*/
        IF NOT VALID-HANDLE (h-bocx351) THEN 
            RUN cxbo/bocx351.p  PERSISTENT SET h-bocx351.   /* licenciam-import-oc */
    
        EMPTY TEMP-TABLE tt-licenciam-import-oc-aux.
    
        CREATE tt-licenciam-import-oc-aux.
        ASSIGN tt-licenciam-import-oc-aux.licenca-import = RowObject.cod-licenc-import
               tt-licenciam-import-oc-aux.dat-livre-1    = RowObject.dat-livre-1
               tt-licenciam-import-oc-aux.numero-ordem   = decla-import-ord.num-ordem
               tt-licenciam-import-oc-aux.parcela        = decla-import-ord.num-parcela
               tt-licenciam-import-oc-aux.cod-livre-1    = decla-import-ord.cod-item.
    
        FOR FIRST item NO-LOCK WHERE item.it-codigo = decla-import-ord.cod-item:
            ASSIGN tt-licenciam-import-oc-aux.cod-livre-2 = item.class-fiscal.
        END. 
    
        RUN openQueryStatic IN h-bocx351 (INPUT 'Main':U).
        RUN goToKey IN h-bocx351 (INPUT decla-import-ord.num-ordem, INPUT decla-import-ord.num-parcela).
        
        IF  RETURN-VALUE = "NOK":U 
            AND RowObject.cod-licenc-import <> '' THEN DO:
            RUN setRecord    IN h-bocx351 (INPUT TABLE tt-licenciam-import-oc-aux).
            RUN createRecord IN h-bocx351.
        END.
        ELSE DO:
            RUN setRecord       IN h-bocx351 (INPUT TABLE tt-licenciam-import-oc-aux).
            IF decla-import-ord.cod-licenc-import = '' THEN
                RUN deleteRecord IN h-bocx351.
            ELSE
                RUN updateRecord IN h-bocx351.   
        END.
    
        /* leva os dados das ordens para os itens relacionados */
        FOR FIRST decla-import-adic-itens EXCLUSIVE-LOCK
            WHERE decla-import-adic-itens.num-di-ems = decla-import-ord.num-di-ems
            AND   decla-import-adic-itens.num-adic   = decla-import-ord.num-adic
            AND   decla-import-adic-itens.num-seq    = decla-import-ord.num-seq
            AND   decla-import-adic-itens.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
    
            ASSIGN decla-import-adic-itens.idi-tributac-cofins         = decla-import-ord.idi-tributac-cofins       
                   decla-import-adic-itens.idi-tributac-icms           = decla-import-ord.idi-tributac-icms         
                   decla-import-adic-itens.idi-tributac-impto-import   = decla-import-ord.idi-tributac-impto-import 
                   decla-import-adic-itens.idi-tributac-ipi            = decla-import-ord.idi-tributac-ipi          
                   decla-import-adic-itens.idi-tributac-pis            = decla-import-ord.idi-tributac-pis    
                
                   decla-import-adic-itens.val-aliq-cofins             = decla-import-ord.val-aliq-cofins           
                   decla-import-adic-itens.val-aliq-icms               = decla-import-ord.val-aliq-icms             
                   decla-import-adic-itens.val-aliq-ii                 = decla-import-ord.val-aliq-ii               
                   decla-import-adic-itens.val-aliq-ipi                = decla-import-ord.val-aliq-ipi              
                   decla-import-adic-itens.val-aliq-pis                = decla-import-ord.val-aliq-pis         
                
                   decla-import-adic-itens.log-suspens-impto-import    = decla-import-ord.log-suspens-impto-import  
                   decla-import-adic-itens.log-suspens-ipi-import      = decla-import-ord.log-suspens-ipi-import    
                   OVERLAY(decla-import-adic.cod-livre-1,1,1)          = SUBSTRING(decla-import-ord.cod-livre-1,1,1) /* icms suspenso */
                   OVERLAY(decla-import-adic.cod-livre-1,2,1)          = SUBSTRING(decla-import-ord.cod-livre-1,2,1) /* pis suspenso */
                   OVERLAY(decla-import-adic.cod-livre-1,3,1)          = SUBSTRING(decla-import-ord.cod-livre-1,3,1) /* cofins suspenso */
                
                   decla-import-adic-itens.val-perc-reduc-cofins       = decla-import-ord.val-perc-reduc-cofins   
                   decla-import-adic-itens.val-perc-reduc-icms         = decla-import-ord.val-perc-reduc-icms            
                   decla-import-adic-itens.val-perc-reduc-impto-import = decla-import-ord.val-perc-reduc-impto-import              
                   decla-import-adic-itens.val-perc-reduc-ipi          = decla-import-ord.val-perc-reduc-ipi             
                   decla-import-adic-itens.val-perc-reduc-pis          = decla-import-ord.val-perc-reduc-pis 
                
                   decla-import-adic-itens.log-cofins-unid             = decla-import-ord.log-cofins-unid           
                   decla-import-adic-itens.log-ipi-unid                = decla-import-ord.log-ipi-unid              
                   decla-import-adic-itens.log-pis-unid                = decla-import-ord.log-pis-unid
                
                   decla-import-adic-itens.val-unit-pis                = decla-import-ord.val-unit-pis
                   decla-import-adic-itens.val-unit-cofins             = decla-import-ord.val-unit-cofins
                   decla-import-adic-itens.val-unit-ipi                = decla-import-ord.val-unit-ipi.
        END.
        
        IF l-nt2024002 THEN DO:
            /* Atualiza a decla-import-ord-trib com as alteraá‰es da adiá∆o */
            FOR EACH decla-import-ord-trib EXCLUSIVE-LOCK
               WHERE decla-import-ord-trib.num-di-ems       = decla-import-ord.num-di-ems
               AND   decla-import-ord-trib.num-ordem        = decla-import-ord.num-ordem
               AND   decla-import-ord-trib.num-parcela      = decla-import-ord.num-parcela
               AND   decla-import-ord-trib.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
               
               FOR FIRST decla-import-adic-trib NO-LOCK
                   WHERE decla-import-adic-trib.num-di-ems       = decla-import-ord.num-di-ems
                   AND   decla-import-adic-trib.num-adic         = decla-import-ord.num-adic
                   AND   decla-import-adic-trib.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                   AND   decla-import-adic-trib.nom-trib         = decla-import-ord-trib.nom-trib
                   AND   decla-import-adic-trib.cod-campo        = decla-import-ord-trib.cod-campo:
                   
                   IF decla-import-ord-trib.cod-conteudo <> decla-import-adic-trib.cod-conteudo
                   AND LOOKUP(decla-import-ord-trib.cod-campo,"ALIQUOTA,ALIQ-RED,ALIQ-EFETIVA-REG") > 0 THEN 
                       ASSIGN l-recalcula-trib = YES.
                       
                   ASSIGN decla-import-ord-trib.cod-conteudo = decla-import-adic-trib.cod-conteudo.
               END.
            END.
            
            /* Atualiza a decla-imp-adic-it-trib com as alteraá‰es da adiá∆o */
            FOR EACH decla-imp-adic-it-trib EXCLUSIVE-LOCK
               WHERE decla-imp-adic-it-trib.num-di-ems       = decla-import-ord.num-di-ems
               AND   decla-imp-adic-it-trib.num-adic         = decla-import-ord.num-adic
               AND   decla-imp-adic-it-trib.num-seq          = decla-import-ord.num-seq
               AND   decla-imp-adic-it-trib.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
               
               FOR FIRST decla-import-adic-trib NO-LOCK
                   WHERE decla-import-adic-trib.num-di-ems       = decla-import-ord.num-di-ems
                   AND   decla-import-adic-trib.num-adic         = decla-import-ord.num-adic
                   AND   decla-import-adic-trib.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts
                   AND   decla-import-adic-trib.nom-trib         = decla-imp-adic-it-trib.nom-trib
                   AND   decla-import-adic-trib.cod-campo        = decla-imp-adic-it-trib.cod-campo:
                   
                   IF decla-imp-adic-it-trib.cod-conteudo <> decla-import-adic-trib.cod-conteudo
                   AND LOOKUP(decla-imp-adic-it-trib.cod-campo,"ALIQUOTA,ALIQ-RED,ALIQ-EFETIVA-REG") > 0 THEN 
                       ASSIGN l-recalcula-trib = YES.
                       
                   ASSIGN decla-imp-adic-it-trib.cod-conteudo = decla-import-adic-trib.cod-conteudo.
               END.
            END.
        END.
        
    END.
    
    IF VALID-HANDLE (h-bocx351)   THEN DO:
        DELETE PROCEDURE h-bocx351.   /* licenciam-import-oc */ 
        ASSIGN h-bocx351 = ?.
    END.

    IF NOT VALID-HANDLE(h-bocx383a) THEN
        RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.
    
    IF  l-nt2024002
    AND l-recalcula-trib THEN
        RUN pi-atualiza-pend-imp IN h-bocx383a(INPUT RowObject.num-di-ems, INPUT RowObject.cdd-siscomex-dts).
        
    /*verifica se os campos referentes aos impostos foram alterados*/
    IF tt-decla-import-adic-impostos.idi-tributac-icms           <> RowObject.idi-tributac-icms           OR 
       tt-decla-import-adic-impostos.idi-tributac-ipi            <> RowObject.idi-tributac-ipi            OR 
       tt-decla-import-adic-impostos.idi-tributac-pis            <> RowObject.idi-tributac-pis            OR 
       tt-decla-import-adic-impostos.idi-tributac-cofins         <> RowObject.idi-tributac-cofins         OR 
       tt-decla-import-adic-impostos.idi-tributac-impto-import   <> RowObject.idi-tributac-impto-import   OR       

       tt-decla-import-adic-impostos.log-suspens-impto-import    <> RowObject.log-suspens-impto-import    OR
       tt-decla-import-adic-impostos.log-suspens-ipi-import      <> RowObject.log-suspens-ipi-import      OR
    &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
        tt-decla-import-adic-impostos.log-suspens-icms        <> RowObject.log-suspens-icms               OR
        tt-decla-import-adic-impostos.log-suspens-pis         <> RowObject.log-suspens-pis                OR
        tt-decla-import-adic-impostos.log-suspens-cofins      <> RowObject.log-suspens-cofins             OR
    &ELSE
        SUBSTRING(tt-decla-import-adic-impostos.cod-livre-1,1,1) <> SUBSTRING(RowObject.cod-livre-1,1,1)  OR
        SUBSTRING(tt-decla-import-adic-impostos.cod-livre-1,2,1) <> SUBSTRING(RowObject.cod-livre-1,2,1)  OR
        SUBSTRING(tt-decla-import-adic-impostos.cod-livre-1,3,1) <> SUBSTRING(RowObject.cod-livre-1,3,1)  OR
    &ENDIF

      tt-decla-import-adic-impostos.val-aliq-cofins             <> RowObject.val-aliq-cofins              OR
      tt-decla-import-adic-impostos.val-aliq-icms               <> RowObject.val-aliq-icms                OR
      tt-decla-import-adic-impostos.val-aliq-ii                 <> RowObject.val-aliq-ii                  OR
      tt-decla-import-adic-impostos.val-aliq-ipi                <> RowObject.val-aliq-ipi                 OR
      tt-decla-import-adic-impostos.val-aliq-pis                <> RowObject.val-aliq-pis                 OR

      tt-decla-import-adic-impostos.val-perc-reduc-cofins       <> RowObject.val-perc-reduc-cofins        OR
      tt-decla-import-adic-impostos.val-perc-reduc-icms         <> RowObject.val-perc-reduc-icms          OR  
      tt-decla-import-adic-impostos.val-perc-reduc-impto-import <> RowObject.val-perc-reduc-impto-import  OR            
      tt-decla-import-adic-impostos.val-perc-reduc-ipi          <> RowObject.val-perc-reduc-ipi           OR  
      tt-decla-import-adic-impostos.val-perc-reduc-pis          <> RowObject.val-perc-reduc-pis           OR

      tt-decla-import-adic-impostos.val-unit-pis                <> RowObject.val-unit-pis                 OR
      tt-decla-import-adic-impostos.val-unit-cofins             <> RowObject.val-unit-cofins              OR
      tt-decla-import-adic-impostos.val-unit-ipi                <> RowObject.val-unit-ipi THEN DO:

        RUN pi-atualiza-pend-imp IN h-bocx383a (INPUT RowObject.num-di-ems,
                                                INPUT RowObject.cdd-siscomex-dts).
    END.

    IF tt-decla-import-adic-impostos.val-base-ii           <> RowObject.val-base-ii           OR
       somaIIantes <> somaIIdepois OR

       tt-decla-import-adic-impostos.val-base-ipi          <> RowObject.val-base-ipi          OR
       somaIPIantes <> somaIPIdepois OR

       tt-decla-import-adic-impostos.val-base-pis          <> RowObject.val-base-pis          OR
       somaPISantes <> somaPISdepois OR

       tt-decla-import-adic-impostos.val-base-cofins       <> RowObject.val-base-cofins       OR
       somaCOFINSantes <> somaCOFINSdepois OR

       tt-decla-import-adic-impostos.val-base-icms         <> RowObject.val-base-icms         OR
       somaICMSantes <> somaICMSdepois
    THEN DO:
       /* verifica os campos que foram alterados */

       /* caso o usu†rio altere o valor E a base do imposto, o sistema precisa validar os dados informados, caso o usu†rio altere o valor OU a base precisar† calcular o valor
       que n∆o foi alterado.
       Por exemplo: alterou o valor do imposto. Sistema precisar† recalcular a base a partir do novo valor do imposto informado pelo usu†rio
                    alterou a base do imposto. Sistema precisar† recalcular o valor do imposto a partir da nova base informada pelo usu†rio.
                    
       No caso do sistema ter que recalcular a base ou o valor, no final do calculo estes valores precisam ser validados de forma que garanta que os dados informados 
       e calculados sejam permitidos.
       
       formula: valor = base * aliq
                base = valor/aliq
       */

       /* alterou base do II */
       IF tt-decla-import-adic-impostos.val-base-ii <> RowObject.val-base-ii  THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-base-ii = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,4,1)  = "S":U.
           &ENDIF
           
           /* recalcular o valor do II */
           IF NOT decla-import-adic.log-suspens-impto-import THEN
                IF decla-import-adic.idi-tributac-impto-import = 1 OR 
                   decla-import-adic.idi-tributac-impto-import = 2 OR
                   decla-import-adic.idi-tributac-impto-import = 4 THEN
                    ASSIGN decla-import-adic.val-ii-db-cr  = decla-import-adic.val-base-ii * (decla-import-adic.val-aliq-ii / 100).
                ELSE 
                    ASSIGN decla-import-adic.val-ii-outras = decla-import-adic.val-base-ii * (decla-import-adic.val-aliq-ii / 100).
            ELSE
                ASSIGN decla-import-adic.val-ii-nao-tribut = decla-import-adic.val-base-ii * (decla-import-adic.val-aliq-ii / 100).
            /* fim - recalcular valor do II */
       END.                         

       /* alterou base do IPI */
       IF tt-decla-import-adic-impostos.val-base-ipi <> RowObject.val-base-ipi  THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-base-ipi = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,5,1)  = "S":U.
           &ENDIF
           
           /* recalcular o valor do ipi */
           IF NOT decla-import-adic.log-suspens-ipi-import THEN
                IF decla-import-adic.idi-tributac-ipi = 1 OR 
                   decla-import-adic.idi-tributac-ipi = 2 OR
                   decla-import-adic.idi-tributac-ipi = 4 THEN
                    ASSIGN decla-import-adic.val-ipi-db-cr  = decla-import-adic.val-base-ipi * (decla-import-adic.val-aliq-ipi / 100).
                ELSE 
                    ASSIGN decla-import-adic.val-ipi-outras = decla-import-adic.val-base-ipi * (decla-import-adic.val-aliq-ipi / 100).
            ELSE
                ASSIGN decla-import-adic.val-ipi-nao-tributad = decla-import-adic.val-base-ipi * (decla-import-adic.val-aliq-ipi / 100).
       END.

       /* alterou base do PIS */
       IF tt-decla-import-adic-impostos.val-base-pis <> RowObject.val-base-pis  THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-base-pis = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,6,1)  = "S":U.
           &ENDIF
           
           /* recalcular o valor do PIS */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-pis THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-pis = 1 OR 
                      decla-import-adic.idi-tributac-pis = 2 OR
                      decla-import-adic.idi-tributac-pis = 4 THEN
                       ASSIGN decla-import-adic.val-pis-db-cr  = decla-import-adic.val-base-pis * (decla-import-adic.val-aliq-pis / 100).
                   ELSE 
                       ASSIGN decla-import-adic.val-pis-outras = decla-import-adic.val-base-pis * (decla-import-adic.val-aliq-pis / 100).
               ELSE
                   ASSIGN decla-import-adic.val-pis-nao-tributad = decla-import-adic.val-base-pis * (decla-import-adic.val-aliq-pis / 100).
       END.

       /* alterou base do COFINS */
       IF tt-decla-import-adic-impostos.val-base-cofins <> RowObject.val-base-cofins  THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-base-cofins = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,7,1)  = "S":U.
           &ENDIF
           
           /* recalcular valor do COFINS */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-pis THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-cofins = 1 OR 
                      decla-import-adic.idi-tributac-cofins = 2 OR
                      decla-import-adic.idi-tributac-cofins = 4 THEN
                       ASSIGN decla-import-adic.val-cofins-db-cr  = decla-import-adic.val-base-cofins * (decla-import-adic.val-aliq-cofins / 100).
                   ELSE 
                       ASSIGN decla-import-adic.val-cofins-outras = decla-import-adic.val-base-cofins * (decla-import-adic.val-aliq-cofins / 100).
               ELSE
                   ASSIGN decla-import-adic.val-cofins-nao-tributad = decla-import-adic.val-base-cofins * (decla-import-adic.val-aliq-cofins / 100).
       END.

       /* alterou base do ICMS */
       IF tt-decla-import-adic-impostos.val-base-icms <> RowObject.val-base-icms  THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-base-icms = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,8,1)  = "S":U.
           &ENDIF
           
           /* recalcular valor do ICMS */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-pis THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-icms = 1 OR 
                      decla-import-adic.idi-tributac-icms = 2 OR
                      decla-import-adic.idi-tributac-icms = 4 THEN
                       ASSIGN decla-import-adic.val-icms-db-cr  = decla-import-adic.val-base-icms * (decla-import-adic.val-aliq-icms / 100).
                   ELSE 
                       ASSIGN decla-import-adic.val-icms-outras = decla-import-adic.val-base-icms * (decla-import-adic.val-aliq-icms / 100).
               ELSE
                   ASSIGN decla-import-adic.val-icms-nao-tributad = decla-import-adic.val-base-icms * (decla-import-adic.val-aliq-icms / 100). 
       END.

       /* valor do II */
       IF somaIIantes <> somaIIdepois THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-impto-ii = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,9,1)  = "S":U.
           &ENDIF
           

           /* recalcular a base do ii */
           IF NOT decla-import-adic.log-suspens-impto-import THEN
                IF decla-import-adic.idi-tributac-impto-import = 1 OR 
                   decla-import-adic.idi-tributac-impto-import = 2 OR
                   decla-import-adic.idi-tributac-impto-import = 4 THEN
                    ASSIGN d-val-ii-aux = decla-import-adic.val-ii-db-cr.
                ELSE 
                    ASSIGN d-val-ii-aux = decla-import-adic.val-ii-outras.
            ELSE
                ASSIGN d-val-ii-aux = decla-import-adic.val-ii-nao-tribut.

            ASSIGN decla-import-adic.val-base-ii = d-val-ii-aux / (decla-import-adic.val-aliq-ii / 100). /* atualiza a base */
       END.

       /* valor do IPI */
       IF  somaIPIantes <> somaIPIdepois THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-impto-ipi = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,10,1)  = "S":U.
           &ENDIF
           
           /* recalcular a base do ipi */
           IF NOT decla-import-adic.log-suspens-ipi-import THEN
                IF decla-import-adic.idi-tributac-ipi = 1 OR 
                   decla-import-adic.idi-tributac-ipi = 2 OR
                   decla-import-adic.idi-tributac-ipi = 4 THEN
                    ASSIGN d-val-ipi-aux = decla-import-adic.val-ipi-db-cr.
                ELSE 
                    ASSIGN d-val-ipi-aux = decla-import-adic.val-ipi-outras.
            ELSE
                ASSIGN d-val-ipi-aux = decla-import-adic.val-ipi-nao-tributad.

            ASSIGN decla-import-adic.val-base-ipi = d-val-ipi-aux / (decla-import-adic.val-aliq-ipi / 100). /* atualiza a base */
       END.

       /* valor do PIS */
       IF  somaPISantes <> somaPISdepois THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-impto-pis = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,11,1)  = "S":U.
           &ENDIF
           

           /* recalcular a base do pis */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-pis THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-pis = 1 OR 
                      decla-import-adic.idi-tributac-pis = 2 OR
                      decla-import-adic.idi-tributac-pis = 4 THEN
                       ASSIGN d-val-pis-aux = decla-import-adic.val-pis-db-cr.
                   ELSE 
                       ASSIGN d-val-pis-aux = decla-import-adic.val-pis-outras.
               ELSE
                   ASSIGN d-val-pis-aux = decla-import-adic.val-pis-nao-tributad.

            ASSIGN decla-import-adic.val-base-pis = d-val-pis-aux / (decla-import-adic.val-aliq-pis / 100). /* atualiza a base */
       END.

       /* valor do COFINS */
       IF  somaCOFINSantes <> somaCOFINSdepois THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-impto-cofins = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,12,1)  = "S":U.
           &ENDIF
           
           /* recalcular a base do cofins */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-cofins THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-cofins = 1 OR 
                      decla-import-adic.idi-tributac-cofins = 2 OR
                      decla-import-adic.idi-tributac-cofins = 4 THEN
                       ASSIGN d-val-cofins-aux = decla-import-adic.val-cofins-db-cr.
                   ELSE 
                       ASSIGN d-val-cofins-aux = decla-import-adic.val-cofins-outras.
               ELSE
                   ASSIGN d-val-cofins-aux = decla-import-adic.val-cofins-nao-tributad.

            ASSIGN decla-import-adic.val-base-cofins = d-val-cofins-aux / (decla-import-adic.val-aliq-cofins / 100). /* atualiza a base */
       END.

       /* valor do ICMS */
       IF  somaICMSantes <> somaICMSdepois THEN DO:
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               ASSIGN decla-import.log-ava-impto-icms = YES.
           &ELSE
               ASSIGN SUBSTRING(decla-import-adic.cod-livre-1,13,1)  = "S":U.
           &ENDIF
           
           /* recalcular a base do icms */
           &IF '{&BF_MAT_VERSAO_EMS}' >= '2.09' &THEN
               IF NOT decla-import-adic.log-suspens-icms THEN
           &ELSE
               IF SUBSTRING(decla-import-adic.cod-livre-1,1,1) = "0":U THEN
           &ENDIF
                   IF decla-import-adic.idi-tributac-icms = 1 OR 
                      decla-import-adic.idi-tributac-icms = 2 OR
                      decla-import-adic.idi-tributac-icms = 4 THEN
                       ASSIGN d-val-icms-aux = decla-import-adic.val-icms-db-cr.
                   ELSE 
                       ASSIGN d-val-icms-aux = decla-import-adic.val-icms-outras.
               ELSE
                   ASSIGN d-val-icms-aux = decla-import-adic.val-icms-nao-tributad.

            ASSIGN decla-import-adic.val-base-icms = d-val-icms-aux / (decla-import-adic.val-aliq-icms / 100). /* atualiza a base */
       END.

       {utp/ut-liter.i "Os_valores_dos_impostos_foram_alterados,_por_isso_o_c†lculo_dos_impostos_ser†_reaberto" *}
       RUN utp/ut-msgs.p ( INPUT "SHOW":U,
                           INPUT 19085,
                           INPUT RETURN-VALUE + '!').
            
       RUN pi-atualiza-pend-imp IN h-bocx383a(INPUT RowObject.num-di-ems,
                                              INPUT RowObject.cdd-siscomex-dts).
    END.

    RELEASE ordens-embarque.
    RELEASE decla-import-ord.

    IF VALID-HANDLE(h-bocx383a) THEN DO:
        DELETE PROCEDURE h-bocx383a.
        ASSIGN h-bocx383a = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-decla-import-adic-impostos.
    DEF VAR base-aux  LIKE decla-import-adic.val-base-ii  NO-UNDO.
    DEF VAR valor-aux LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
    DEF VAR l-correto AS LOGICAL                          NO-UNDO.
    DEF VAR l-erro    AS LOGICAL INITIAL NO               NO-UNDO.

    DEF VAR d-valor-aux-pis    LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR d-valor-aux-cofins LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR d-valor-aux-ipi    LIKE desp-imp.val-desp NO-UNDO.
    DEF VAR d-valor-aux-icms   LIKE desp-imp.val-desp NO-UNDO.
   
    
    FIND FIRST decla-import-adic EXCLUSIVE-LOCK
         WHERE decla-import-adic.num-di-ems = RowObject.num-di-ems
           AND decla-import-adic.num-adic   = RowObject.num-adic 
           AND decla-import-adic.cdd-siscomex = RowObject.cdd-siscomex-dts NO-ERROR.
    IF AVAIL decla-import-adic THEN
        BUFFER-COPY decla-import-adic TO tt-decla-import-adic-impostos.


    /* Antes - soma os valores de cada imposto para verificar se algum deles foi alterado a m∆o */
    ASSIGN somaIIantes     = decla-import-adic.val-ii-db-cr + 
                             decla-import-adic.val-ii-outras +
                             decla-import-adic.val-ii-nao-tribut
           somaIPIantes    = decla-import-adic.val-ipi-db-cr + 
                             decla-import-adic.val-ipi-outras +
                             decla-import-adic.val-ipi-nao-tributad
           somaPISantes    = decla-import-adic.val-pis-db-cr +
                             decla-import-adic.val-pis-outras +
                             decla-import-adic.val-pis-nao-tributad
           somaCOFINSantes = decla-import-adic.val-cofins-db-cr  +
                             decla-import-adic.val-cofins-outras +
                             decla-import-adic.val-cofins-nao-tributad
           somaICMSantes   = decla-import-adic.val-icms-db-cr +
                             decla-import-adic.val-icms-outras + 
                             decla-import-adic.val-icms-nao-tributad.

    /* Depois - soma os valores de cada imposto para verificar se algum deles foi alterado a m∆o */
    ASSIGN somaIIdepois     = RowObject.val-ii-db-cr + 
                              RowObject.val-ii-outras +
                              RowObject.val-ii-nao-tribut
           somaIPIdepois    = RowObject.val-ipi-db-cr + 
                              RowObject.val-ipi-outras +
                              RowObject.val-ipi-nao-tributad
           somaPISdepois    = RowObject.val-pis-db-cr +
                              RowObject.val-pis-outras +
                              RowObject.val-pis-nao-tributad
           somaCOFINSdepois = RowObject.val-cofins-db-cr  +
                              RowObject.val-cofins-outras +
                              RowObject.val-cofins-nao-tributad
           somaICMSdepois   = RowObject.val-icms-db-cr +
                              RowObject.val-icms-outras + 
                              RowObject.val-icms-nao-tributad.

    /* validar se os valores dos impostos foram alterados. Caso sim, os valores precisam ser validados */
    /*--[ II ]-----------------------------*/
    IF somaIIantes <> somaIIdepois AND
       decla-import-adic.val-base-ii <> RowObject.val-base-ii THEN DO:
        RUN pi-valida-valores(INPUT RowObject.val-ii-db-cr,
                              INPUT RowObject.val-ii-outras,
                              INPUT RowObject.val-ii-nao-tribut,
                              INPUT RowObject.val-aliq-ii,
                              INPUT RowObject.val-base-ii,
                              OUTPUT l-correto).

        IF NOT l-correto THEN DO:
            
            {utp/ut-liter.i "Alteraá∆o_n∆o_permitida" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "O_valor_do_Imposto_de_Importaá∆o_calculado_n∆o_confere_com_o_valor_informado" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
            ASSIGN l-erro = YES.
        END.

    END.
    /*--[ II ]-----------------------------*/

    /*--[ IPI ]-----------------------------*/
    IF somaIPIantes <> somaIPIdepois AND
       decla-import-adic.val-base-ipi <> RowObject.val-base-ipi THEN DO:
        RUN pi-valida-valores(INPUT RowObject.val-ipi-db-cr,
                              INPUT RowObject.val-ipi-outras,
                              INPUT RowObject.val-ipi-nao-tributad,
                              INPUT RowObject.val-aliq-ipi,
                              INPUT RowObject.val-base-ipi,
                              OUTPUT l-correto).

        IF NOT l-correto THEN DO:
            
            {utp/ut-liter.i "Alteraá∆o_n∆o_permitida" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "O_valor_do_IPI_calculado_n∆o_confere_com_o_valor_informado" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            ASSIGN d-valor-aux-ipi = RowObject.val-ipi-db-cr        WHEN RowObject.val-ipi-db-cr        > 0
                   d-valor-aux-ipi = RowObject.val-ipi-outras       WHEN RowObject.val-ipi-outras       > 0
                   d-valor-aux-ipi = RowObject.val-ipi-nao-tributad WHEN RowObject.val-ipi-nao-tributad > 0
                   OVERLAY(RowObject.cod-livre-1,56,19) = STRING(d-valor-aux-ipi * 100000000).
        END.


    END.
    /*--[ IPI ]-----------------------------*/

    /*--[ PIS ]-----------------------------*/
    IF somaPISantes <> somaPISdepois AND
       decla-import-adic.val-base-pis <> RowObject.val-base-pis THEN DO:
        RUN pi-valida-valores(INPUT RowObject.val-pis-db-cr,
                              INPUT RowObject.val-pis-outras,
                              INPUT RowObject.val-pis-nao-tributad,
                              INPUT RowObject.val-aliq-pis,
                              INPUT RowObject.val-base-pis,
                              OUTPUT l-correto).

        IF NOT l-correto THEN DO:
            
            {utp/ut-liter.i "Alteraá∆o_n∆o_permitida" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "O_valor_do_PIS_calculado_n∆o_confere_com_o_valor_informado" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
            ASSIGN l-erro = YES.
        END.
    END.

    /* se o valor OU a base for informada a m∆o pelo usu†rio, o rateio deve ser feito pelos valores antigos que o sistema calculou */
    IF somaPISantes <> somaPISdepois OR
       decla-import-adic.val-base-pis <> RowObject.val-base-pis THEN DO:
            /* passa o valor do pis para uma variavel */
            &if '{&bf_mat_versao_ems}' >= '2.09' &then
                IF decla-import-adic.log-suspens-pis THEN
            &else
                IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = '1' THEN
            &endif
                    ASSIGN d-valor-aux-pis = decla-import-adic.val-pis-nao-tributad.
                ELSE DO:
                    CASE decla-import-adic.idi-tributac-pis:
                        WHEN 1 THEN
                            ASSIGN d-valor-aux-pis = decla-import-adic.val-pis-db-cr.
                        WHEN 2 THEN
                            ASSIGN d-valor-aux-pis = decla-import-adic.val-pis-db-cr.
                        WHEN 3 THEN
                            ASSIGN d-valor-aux-pis = decla-import-adic.val-pis-outras.
                        WHEN 4 THEN
                            ASSIGN d-valor-aux-pis = decla-import-adic.val-pis-db-cr.
                    END CASE. /* case */
                END. /* else do */
            /* fim - passa o valor do pis para uma variavel */

            ASSIGN OVERLAY(RowObject.cod-livre-1,15,1)  = STRING(decla-import-adic.idi-tributac-pis)
                   OVERLAY(RowObject.cod-livre-1,16,19) = STRING(d-valor-aux-pis * 100000000).
    END.
    /*--[ PIS ]-----------------------------*/

    /*--[ COFINS ]-----------------------------*/
    IF somaCOFINSantes <> somaCOFINSdepois AND
       decla-import-adic.val-base-cofins <> RowObject.val-base-cofins THEN DO:
        RUN pi-valida-valores(INPUT RowObject.val-cofins-db-cr,
                              INPUT RowObject.val-cofins-outras,
                              INPUT RowObject.val-cofins-nao-tributad,
                              INPUT RowObject.val-aliq-cofins,
                              INPUT RowObject.val-base-cofins,
                              OUTPUT l-correto).

        IF NOT l-correto THEN DO:
            
            {utp/ut-liter.i "Alteraá∆o_n∆o_permitida" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "O_valor_do_COFINS_calculado_n∆o_confere_com_o_valor_informado" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
            ASSIGN l-erro = YES.
        END.
    END.

    /* se o valor OU a base for informada a m∆o pelo usu†rio, o rateio deve ser feito pelos valores antigos que o sistema calculou */
    IF somaCOFINSantes <> somaCOFINSdepois OR
       decla-import-adic.val-base-cofins <> RowObject.val-base-cofins THEN DO:
             /* passa o valor do cofins para uma variavel */
             &if '{&bf_mat_versao_ems}' >= '2.09' &then
                 IF decla-import-adic.log-suspens-cofins THEN
             &else
                 IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = '1' THEN
             &endif
                     ASSIGN d-valor-aux-cofins = decla-import-adic.val-cofins-nao-tributad.
                 ELSE DO:
                     CASE decla-import-adic.idi-tributac-cofins:
                         WHEN 1 THEN
                             ASSIGN d-valor-aux-cofins = decla-import-adic.val-cofins-db-cr.
                         WHEN 2 THEN
                             ASSIGN d-valor-aux-cofins = decla-import-adic.val-cofins-db-cr.
                         WHEN 3 THEN
                             ASSIGN d-valor-aux-cofins = decla-import-adic.val-cofins-outras.
                         WHEN 4 THEN
                             ASSIGN d-valor-aux-cofins = decla-import-adic.val-cofins-db-cr.
                     END CASE. /* case */
                 END. /* else do */
             /* fim - passa o valor do pis para uma variavel */
            
             ASSIGN overlay(decla-import-adic.cod-livre-1,35,1)  = STRING(RowObject.idi-tributac-cofins)
                    overlay(decla-import-adic.cod-livre-1,36,19) = STRING(d-valor-aux-cofins * 100000000).
    END.
    /*--[ COFINS ]-----------------------------*/

    /*--[ ICMS ]-----------------------------*/
    IF somaICMSantes <> somaICMSdepois AND
       decla-import-adic.val-base-icms <> RowObject.val-base-icms THEN DO:
        RUN pi-valida-valores(INPUT RowObject.val-icms-db-cr,
                              INPUT RowObject.val-icms-outras,
                              INPUT RowObject.val-icms-nao-tributad,
                              INPUT RowObject.val-aliq-icms,
                              INPUT RowObject.val-base-icms,
                              OUTPUT l-correto).

        IF NOT l-correto THEN DO:
            
            {utp/ut-liter.i "Alteraá∆o_n∆o_permitida" *}
            ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "O_valor_do_ICMS_calculado_n∆o_confere_com_o_valor_informado" *}
            
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            ASSIGN d-valor-aux-icms = RowObject.val-icms-db-cr        WHEN RowObject.val-icms-db-cr        > 0
                   d-valor-aux-icms = RowObject.val-icms-outras       WHEN RowObject.val-icms-outras       > 0
                   d-valor-aux-icms = RowObject.val-icms-nao-tributad WHEN RowObject.val-icms-nao-tributad > 0
                   OVERLAY(RowObject.cod-livre-1,76,19) = STRING(d-valor-aux-icms * 100000000).
        END.

    END.
    /*--[ ICMS ]-----------------------------*/

    /* reposicionar a decla-import-adic em EXCLUSIVE-LOCK para o progress n∆o se perder na gravaá∆o */
    RUN pi-posiciona-registro (INPUT RowObject.num-di-ems, INPUT RowObject.num-adic, INPUT RowObject.cdd-siscomex-dts).
    
    IF l-erro THEN
        RETURN "NOK":U.

    RETURN "OK":U.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-agenc-agent":U THEN ASSIGN pFieldValue = RowObject.cod-agenc-agent.
        WHEN "cod-aladi":U THEN ASSIGN pFieldValue = RowObject.cod-aladi.
        WHEN "cod-classif-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-classif-fisc.
        WHEN "cod-contrat-cambio":U THEN ASSIGN pFieldValue = RowObject.cod-contrat-cambio.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-licenc-import":U THEN ASSIGN pFieldValue = RowObject.cod-licenc-import.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-naladi-ncca":U THEN ASSIGN pFieldValue = RowObject.cod-naladi-ncca.
        WHEN "cod-nbm":U THEN ASSIGN pFieldValue = RowObject.cod-nbm.
        WHEN "cod-rof":U THEN ASSIGN pFieldValue = RowObject.cod-rof.
        WHEN "cod-tip-recip":U THEN ASSIGN pFieldValue = RowObject.cod-tip-recip.
        WHEN "dsl-compl-adic":U THEN ASSIGN pFieldValue = RowObject.dsl-compl-adic.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "qtd-capac-recip":U THEN ASSIGN pFieldValue = RowObject.qtd-capac-recip.
        WHEN "qtd-ncm":U THEN ASSIGN pFieldValue = RowObject.qtd-ncm.
        WHEN "val-acresc":U THEN ASSIGN pFieldValue = RowObject.val-acresc.
        WHEN "val-acresc-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[1].
        WHEN "val-acresc-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-acresc-me[2].
        WHEN "val-aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-icms":U THEN ASSIGN pFieldValue = RowObject.val-aliq-icms.
        WHEN "val-aliq-ii":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ii.
        WHEN "val-aliq-ipi":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ipi.
        WHEN "val-aliq-pis":U THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-base-cofins":U THEN ASSIGN pFieldValue = RowObject.val-base-cofins.
        WHEN "val-base-icms":U THEN ASSIGN pFieldValue = RowObject.val-base-icms.
        WHEN "val-base-ii":U THEN ASSIGN pFieldValue = RowObject.val-base-ii.
        WHEN "val-base-ipi":U THEN ASSIGN pFieldValue = RowObject.val-base-ipi.
        WHEN "val-base-pis":U THEN ASSIGN pFieldValue = RowObject.val-base-pis.
        WHEN "val-cofins-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-cofins-db-cr.
        WHEN "val-cofins-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-cofins-nao-tributad.
        WHEN "val-cofins-outras":U THEN ASSIGN pFieldValue = RowObject.val-cofins-outras.
        WHEN "val-cotac":U THEN ASSIGN pFieldValue = RowObject.val-cotac.
        WHEN "val-cub-tot":U THEN ASSIGN pFieldValue = RowObject.val-cub-tot.
        WHEN "val-deduc":U THEN ASSIGN pFieldValue = RowObject.val-deduc.
        WHEN "val-deduc-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-deduc-me[1].
        WHEN "val-deduc-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-deduc-me[2].
        WHEN "val-frete":U THEN ASSIGN pFieldValue = RowObject.val-frete.
        WHEN "val-frete-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[1].
        WHEN "val-frete-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-frete-me[2].
        WHEN "val-icms-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-icms-db-cr.
        WHEN "val-icms-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-icms-nao-tributad.
        WHEN "val-icms-outras":U THEN ASSIGN pFieldValue = RowObject.val-icms-outras.
        WHEN "val-ii-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ii-db-cr.
        WHEN "val-ii-nao-tribut":U THEN ASSIGN pFieldValue = RowObject.val-ii-nao-tribut.
        WHEN "val-ii-outras":U THEN ASSIGN pFieldValue = RowObject.val-ii-outras.
        WHEN "val-ipi-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-ipi-db-cr.
        WHEN "val-ipi-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-ipi-nao-tributad.
        WHEN "val-ipi-outras":U THEN ASSIGN pFieldValue = RowObject.val-ipi-outras.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-perc-reduc-cofins":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-cofins.
        WHEN "val-perc-reduc-icms":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-icms.
        WHEN "val-perc-reduc-impto-import":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-impto-import.
        WHEN "val-perc-reduc-ipi":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-ipi.
        WHEN "val-perc-reduc-pis":U THEN ASSIGN pFieldValue = RowObject.val-perc-reduc-pis.
        WHEN "val-peso-liq":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq.
        WHEN "val-pis-db-cr":U THEN ASSIGN pFieldValue = RowObject.val-pis-db-cr.
        WHEN "val-pis-nao-tributad":U THEN ASSIGN pFieldValue = RowObject.val-pis-nao-tributad.
        WHEN "val-pis-outras":U THEN ASSIGN pFieldValue = RowObject.val-pis-outras.
        WHEN "val-seguro":U THEN ASSIGN pFieldValue = RowObject.val-seguro.
        WHEN "val-seguro-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[1].
        WHEN "val-seguro-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-seguro-me[2].
        WHEN "val-unit-cofins":U THEN ASSIGN pFieldValue = RowObject.val-unit-cofins.
        WHEN "val-unit-icms":U THEN ASSIGN pFieldValue = RowObject.val-unit-icms.
        WHEN "val-unit-ii":U THEN ASSIGN pFieldValue = RowObject.val-unit-ii.
        WHEN "val-unit-ipi":U THEN ASSIGN pFieldValue = RowObject.val-unit-ipi.
        WHEN "val-unit-pis":U THEN ASSIGN pFieldValue = RowObject.val-unit-pis.
        WHEN "val-vmcv":U THEN ASSIGN pFieldValue = RowObject.val-vmcv.
        WHEN "val-vmcv-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[1].
        WHEN "val-vmcv-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmcv-me[2].
        WHEN "val-vmld":U THEN ASSIGN pFieldValue = RowObject.val-vmld.
        WHEN "val-vmld-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[1].
        WHEN "val-vmld-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmld-me[2].
        WHEN "val-vmle":U THEN ASSIGN pFieldValue = RowObject.val-vmle.
        WHEN "val-vmle-me[1]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[1].
        WHEN "val-vmle-me[2]":U THEN ASSIGN pFieldValue = RowObject.val-vmle-me[2].
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-acresc-moed":U THEN ASSIGN pFieldValue = RowObject.cdn-acresc-moed.
        WHEN "cdn-agent":U THEN ASSIGN pFieldValue = RowObject.cdn-agent.
        WHEN "cdn-banco":U THEN ASSIGN pFieldValue = RowObject.cdn-banco.
        WHEN "cdn-bco-agent":U THEN ASSIGN pFieldValue = RowObject.cdn-bco-agent.
        WHEN "cdn-classif-fisc-ex":U THEN ASSIGN pFieldValue = RowObject.cdn-classif-fisc-ex.
        WHEN "cdn-corretor":U THEN ASSIGN pFieldValue = RowObject.cdn-corretor.
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cdn-fornec":U THEN ASSIGN pFieldValue = RowObject.cdn-fornec.
        WHEN "cdn-modal-pagto":U THEN ASSIGN pFieldValue = RowObject.cdn-modal-pagto.
        WHEN "cdn-moed-deduc":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-deduc.
        WHEN "cdn-moed-frete":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-frete.
        WHEN "cdn-moed-seguro":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-seguro.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "cdn-motivo":U THEN ASSIGN pFieldValue = RowObject.cdn-motivo.
        WHEN "cdn-naladi-sist-harmon":U THEN ASSIGN pFieldValue = RowObject.cdn-naladi-sist-harmon.
        WHEN "cdn-praca":U THEN ASSIGN pFieldValue = RowObject.cdn-praca.
        WHEN "idi-ind-pagto":U THEN ASSIGN pFieldValue = RowObject.idi-ind-pagto.
        WHEN "idi-ind-vincul":U THEN ASSIGN pFieldValue = RowObject.idi-ind-vincul.
        WHEN "idi-metod-val":U THEN ASSIGN pFieldValue = RowObject.idi-metod-val.
        WHEN "idi-natur-cambial":U THEN ASSIGN pFieldValue = RowObject.idi-natur-cambial.
        WHEN "idi-tributac-cofins":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "idi-tributac-icms":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-icms.
        WHEN "idi-tributac-impto-import":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-impto-import.
        WHEN "idi-tributac-ipi":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-ipi.
        WHEN "idi-tributac-pis":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-pis.
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dclmpdc-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-adic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-adic LIKE decla-import-adic.num-adic NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-adic = RowObject.num-adic
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-cofins-unid":U THEN ASSIGN pFieldValue = RowObject.log-cofins-unid.
        WHEN "log-emite-fabrican":U THEN ASSIGN pFieldValue = RowObject.log-emite-fabrican.
        WHEN "log-ipi-unid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-unid.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-mater-encomen":U THEN ASSIGN pFieldValue = RowObject.log-mater-encomen.
        WHEN "log-mater-usado":U THEN ASSIGN pFieldValue = RowObject.log-mater-usado.
        WHEN "log-moed-nac":U THEN ASSIGN pFieldValue = RowObject.log-moed-nac.
        WHEN "log-nec-licenc":U THEN ASSIGN pFieldValue = RowObject.log-nec-licenc.
        WHEN "log-pis-unid":U THEN ASSIGN pFieldValue = RowObject.log-pis-unid.
        WHEN "log-suspens-impto-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-impto-import.
        WHEN "log-suspens-ipi-import":U THEN ASSIGN pFieldValue = RowObject.log-suspens-ipi-import.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dclmpdc-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-adic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-adic LIKE decla-import-adic.num-adic NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-adic WHERE 
        bfdecla-import-adic.num-di-ems = pnum-di-ems AND 
        bfdecla-import-adic.num-adic = pnum-adic AND 
        bfdecla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-adic THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-adic)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDI DBOProgram 
PROCEDURE openQueryByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} 
                                WHERE {&TABLENAME}.num-di-ems = inum-di-ems 
                                  AND {&TABLENAME}.cdd-siscomex-dts = decdd-siscomex-dts NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumDIEMS DBOProgram 
PROCEDURE openQueryByNumDIEMS :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                                WHERE {&TABLENAME}.num-di-ems = inum-di-ems 
                                AND   {&TABLENAME}.num-adic   = inum-adic 
                                AND   {&TABLENAME}.cdd-siscomex-dts = decdd-siscomex-dts NO-LOCK INDEXED-REPOSITION.
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
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores DBOProgram 
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-num-di-ems LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER i-num-adic   LIKE decla-import-adic.num-adic   NO-UNDO.
    DEFINE INPUT PARAMETER de-cdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.
    
    DEFINE OUTPUT PARAMETER d-val-vmcv-me1    LIKE bf{&TableName}.val-vmcv-me[1]    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-vmcv   AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmcv-me2    LIKE bf{&TableName}.val-vmcv-me[2]    NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmcv        LIKE bf{&TableName}.val-vmcv          NO-UNDO.
                                                                               
    DEFINE OUTPUT PARAMETER d-val-vmle-me1    LIKE bf{&TableName}.val-vmle-me[1]    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-vmle   AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmle-me2    LIKE bf{&TableName}.val-vmle-me[2]    NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmle        LIKE bf{&TableName}.val-vmle          NO-UNDO.
                                                                               
    DEFINE OUTPUT PARAMETER d-val-vmld-me1    LIKE bf{&TableName}.val-vmld-me[1]    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-vmld   AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmld-me2    LIKE bf{&TableName}.val-vmld-me[2]    NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-vmld        LIKE bf{&TableName}.val-vmld          NO-UNDO.
                                                                               
    DEFINE OUTPUT PARAMETER d-val-frete-me1   LIKE bf{&TableName}.val-frete-me[1]   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-frete  AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-frete-me2   LIKE bf{&TableName}.val-frete-me[2]   NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-frete       LIKE bf{&TableName}.val-frete         NO-UNDO.
                                                                               
    DEFINE OUTPUT PARAMETER d-val-seguro-me1  LIKE bf{&TableName}.val-seguro-me[1]  NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-seguro AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-seguro-me2  LIKE bf{&TableName}.val-seguro-me[2]  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-seguro      LIKE bf{&TableName}.val-seguro        NO-UNDO.
                                                                               
    DEFINE OUTPUT PARAMETER d-val-acresc-me1  LIKE bf{&TableName}.val-acresc-me[1]  NO-UNDO.
    DEFINE OUTPUT PARAMETER c-cdn-moed-acresc AS CHARACTER                          NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-acresc-me2  LIKE bf{&TableName}.val-acresc-me[1]  NO-UNDO.
    DEFINE OUTPUT PARAMETER d-val-acresc      LIKE bf{&TableName}.val-acresc        NO-UNDO.
    
    FOR FIRST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.num-di-ems = i-num-di-ems
            AND   bf{&TableName}.num-adic   = i-num-adic
            AND   bf{&TableName}.cdd-siscomex-dts = de-cdd-siscomex-dts:
    
        FIND FIRST decla-import NO-LOCK
                WHERE decla-import.num-di-ems = bf{&TableName}.num-di-ems
                  AND decla-import.cdd-siscomex-dts = bf{&TableName}.cdd-siscomex-dts NO-ERROR.
        FIND FIRST param-imp NO-LOCK
                WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.
    
        /* busca moeda vmcv, vmld e vmle */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = bf{&TableName}.cdn-moeda NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN c-cdn-moed-vmcv = string(moeda.mo-codigo) + " - ":U + moeda.descricao
                   c-cdn-moed-vmle = string(moeda.mo-codigo) + " - ":U + moeda.descricao
                   c-cdn-moed-vmld = string(moeda.mo-codigo) + " - ":U + moeda.descricao.
        
        /* busca moeda frete */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = bf{&TableName}.cdn-moed-frete NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN c-cdn-moed-frete  = string(moeda.mo-codigo) + " - ":U + moeda.descricao.
    
        /* busca moeda seguro */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = bf{&TableName}.cdn-moed-seguro NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN c-cdn-moed-seguro  = string(moeda.mo-codigo) + " - ":U + moeda.descricao.
    
        /* busca moeda acrescimo */
        FIND FIRST moeda NO-LOCK
                WHERE moeda.mo-codigo = param-imp.int-2 NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN c-cdn-moed-acresc  = string(moeda.mo-codigo) + " - ":U + moeda.descricao.
     
    
        ASSIGN d-val-vmcv-me1    = bf{&TableName}.val-vmcv-me[1]   
               d-val-vmcv-me2    = bf{&TableName}.val-vmcv-me[2]   
               d-val-vmcv        = bf{&TableName}.val-vmcv       
    
               d-val-vmle-me1    = bf{&TableName}.val-vmle-me[1]   
               d-val-vmle-me2    = bf{&TableName}.val-vmle-me[2]   
               d-val-vmle        = bf{&TableName}.val-vmle       
    
               d-val-vmld-me1    = bf{&TableName}.val-vmld-me[1]   
               d-val-vmld-me2    = bf{&TableName}.val-vmld-me[2]   
               d-val-vmld        = bf{&TableName}.val-vmld       
    
               d-val-frete-me1   = bf{&TableName}.val-frete-me[1]  
               d-val-frete-me2   = bf{&TableName}.val-frete-me[2]  
               d-val-frete       = bf{&TableName}.val-frete      
    
               d-val-seguro-me1  = bf{&TableName}.val-seguro-me[1] 
               d-val-seguro-me2  = bf{&TableName}.val-seguro-me[2] 
               d-val-seguro      = bf{&TableName}.val-seguro     
    
               d-val-acresc-me1  = bf{&TableName}.val-acresc-me[1] 
               d-val-acresc-me2  = bf{&TableName}.val-acresc-me[1] 
               d-val-acresc      = bf{&TableName}.val-acresc.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-buscaDados-emitente DBOProgram 
PROCEDURE pi-buscaDados-emitente :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF  INPUT PARAM pcod-emitente AS INTEGER NO-UNDO.
    DEF OUTPUT PARAM pcod-banco    AS INTEGER NO-UNDO.
    DEF OUTPUT PARAM pcod-agencia  AS CHAR    NO-UNDO.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = pcod-emitente:
        ASSIGN pcod-banco   = emitente.cod-banco
               pcod-agencia = emitente.agencia.
    END. 

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-erro DBOProgram 
PROCEDURE pi-gera-tt-erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-adic  LIKE decla-import-adic.num-adic NO-UNDO.
    DEF INPUT  PARAM p-num-erro  LIKE RowErrors.errorNumber      NO-UNDO.
    DEF INPUT  PARAM p-descricao LIKE RowErrors.errorDescription NO-UNDO.
    DEF OUTPUT PARAM p-retorno   AS LOGICAL                      NO-UNDO.
    
    ASSIGN p-retorno = NO.
    
    IF NOT CAN-FIND(FIRST tt-erro-adic
                    WHERE tt-erro-adic.num-adic  = p-num-adic  
                    AND   tt-erro-adic.num-erro  = p-num-erro  
                    AND   tt-erro-adic.desc-erro = p-descricao) THEN DO:
    
        CREATE tt-erro-adic.
        ASSIGN tt-erro-adic.num-adic  = p-num-adic 
               tt-erro-adic.num-erro  = p-num-erro 
               tt-erro-adic.desc-erro = p-descricao.
        ASSIGN p-retorno = YES.
    END.
    ELSE 
        ASSIGN p-retorno = NO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-posiciona-registro DBOProgram 
PROCEDURE pi-posiciona-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEF INPUT PARAM p-num-adic   LIKE decla-import-adic.num-adic   NO-UNDO.
    DEF INPUT PARAM p-cdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.

    FIND FIRST decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems = p-num-di-ems
        AND   decla-import-adic.num-adic   = p-num-adic 
        AND   decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-n-log-impostos DBOProgram 
PROCEDURE pi-seta-n-log-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-num-di-ems      LIKE decla-import-adic.num-di-ems       NO-UNDO.
    DEF INPUT PARAM pcdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.

    FOR FIRST decla-import-adic EXCLUSIVE-LOCK
        WHERE decla-import-adic.num-di-ems       = p-num-di-ems
          AND decla-import-adic.cdd-siscomex-dts = pcdd-siscomex-dts:
        
        ASSIGN overlay(decla-import-adic.cod-livre-1,4,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,5,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,6,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,7,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,8,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,9,1)  = "N":U
               overlay(decla-import-adic.cod-livre-1,10,1) = "N":U
               overlay(decla-import-adic.cod-livre-1,11,1) = "N":U
               overlay(decla-import-adic.cod-livre-1,12,1) = "N":U
               overlay(decla-import-adic.cod-livre-1,13,1) = "N":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-quebra-adicao DBOProgram 
PROCEDURE pi-valida-quebra-adicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-decla-import-ord.
    
    DEFINE VARIABLE l-retorno      AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-necessita-li AS LOGICAL     NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx383) THEN
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

    IF NOT VALID-HANDLE(h-bocx00506) THEN
        RUN cxbo/bocx00506.p PERSISTENT SET h-bocx00506.

    IF NOT VALID-HANDLE(h-bocx00512) THEN
        RUN cxbo/bocx00512.p PERSISTENT SET h-bocx00512.

    IF CAN-FIND(FIRST tt-decla-import-ord
                WHERE tt-decla-import-ord.num-adic = 0
                OR    tt-decla-import-ord.num-seq  = 0) THEN DO:
        
        {utp/ut-liter.i "N£mero_da_Adiá∆o_e_N£mero_da_Sequància_devem_ser_informados_para_todas_as_ordens_no_processo_de_geraá∆o_manual" *}
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="TRIM(RETURN-VALUE) + '.' + '~~~~' + TRIM(RETURN-VALUE) + '.'"}
    END.
    
    RUN pi-limpa-temp-table IN h-bocx383. /* limpa a tt-decla-import-adic e tt-decla-import-adic-itens que estao na handle h-bocx383 */
    
    FOR EACH tt-decla-import-ord:
        EMPTY TEMP-TABLE tt-decla-import-ord-aux.
        CREATE tt-decla-import-ord-aux.
        BUFFER-COPY tt-decla-import-ord TO tt-decla-import-ord-aux.
        RUN criaAdicao IN h-bocx383 (INPUT TABLE tt-decla-import-ord-aux,
                                     INPUT tt-decla-import-ord-aux.num-adic).
    END.
    
    EMPTY TEMP-TABLE tt-decla-import-adic.  
    EMPTY TEMP-TABLE tt-decla-import-adic-itens.
    EMPTY TEMP-TABLE tt-erro-adic.
    
    RUN getAdicoes IN h-bocx383 (OUTPUT TABLE tt-decla-import-adic, 
                                 OUTPUT TABLE tt-decla-import-adic-itens, 
                                 OUTPUT TABLE tt-decla-import-adic-trib, 
                                 OUTPUT TABLE tt-decla-imp-adic-it-trib).
    
    DEF BUFFER bf-tt-decla-import-adic-itens FOR tt-decla-import-adic-itens.
    DEF BUFFER bf-item FOR ITEM.
    DEF BUFFER bf-tt-decla-import-ord  FOR tt-decla-import-ord.
    
    FOR EACH tt-decla-import-adic-itens,
        FIRST tt-decla-import-adic 
        WHERE tt-decla-import-adic.num-di-ems = tt-decla-import-adic-itens.num-di-ems    
        AND   tt-decla-import-adic.num-adic   = tt-decla-import-adic-itens.num-adic  
        AND   tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts:
    
        /*S‡ FAZ A VALIDAÄ«O CASO EXISTA MAIS DE UM REGISTRO NA ADIÄ«O*/
        FIND FIRST tt-decla-import-ord
             WHERE tt-decla-import-ord.num-adic = tt-decla-import-adic.num-adic NO-LOCK NO-ERROR.
        IF AVAIL tt-decla-import-ord THEN DO:
            FIND NEXT tt-decla-import-ord 
                 WHERE tt-decla-import-ord.num-adic = tt-decla-import-adic.num-adic  NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-decla-import-ord THEN DO:
                NEXT.
            END.
        END.
    
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-decla-import-adic-itens.cod-item: END.
    
        IF CAN-FIND(FIRST bf-tt-decla-import-adic-itens
                    WHERE bf-tt-decla-import-adic-itens.num-di-ems = tt-decla-import-adic-itens.num-di-ems
                    AND   bf-tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic-itens.num-adic
                    AND   bf-tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
                    AND   tt-decla-import-adic.cod-classif-fisc    <> ITEM.class-fiscal) THEN DO:
            
                RUN pi-gera-tt-erro (INPUT tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192,
                                     INPUT "Classificaá∆o Fiscal":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
    
                    {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic) + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
        END.
        IF CAN-FIND(FIRST bf-tt-decla-import-adic-itens
                    WHERE bf-tt-decla-import-adic-itens.num-di-ems = tt-decla-import-adic-itens.num-di-ems
                    AND   bf-tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic-itens.num-adic
                    AND   bf-tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
                    AND   tt-decla-import-adic.cdn-classif-fisc-ex <> INT(ITEM.dec-1)) THEN DO:
            
            RUN pi-gera-tt-erro (INPUT tt-decla-import-adic-itens.num-adic,
                                 INPUT 52192  ,
                                 INPUT "EX Tarif†rio":U,
                                 OUTPUT l-retorno).
    
            IF l-retorno THEN DO:
                {utp/ut-liter.i "EX_Tarif†rio" *}
                {method/svc/errors/inserr.i &ErrorNumber="52192"
                                            &ErrorType="EMS"
                                            &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
            END. 
        END.
    
        FOR EACH  bf-tt-decla-import-adic-itens NO-LOCK
            WHERE bf-tt-decla-import-adic-itens.num-di-ems = tt-decla-import-adic-itens.num-di-ems
            AND   bf-tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic-itens.num-adic
            AND   bf-tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts:
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic        =  bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cod-naladi-ncca <> tt-decla-import-adic.cod-naladi-ncca) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Naladi/NCCA":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
    
                    {utp/ut-liter.i "Naladi/NCCA" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic                =  bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cdn-naladi-sist-harmon <> tt-decla-import-adic.cdn-naladi-sist-harmon) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Naladi/SH":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN  DO:
    
                    {utp/ut-liter.i "Naladi/SH" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic         = bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.qtd-capac-recip <> tt-decla-import-adic.qtd-capac-recip) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Capacidade Recipiente":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Capacidade_Recipiente" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic  =  bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cod-nbm  <> tt-decla-import-adic.cod-nbm) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "NBM":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
    
                    {utp/ut-liter.i "NBM" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic   = bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cod-aladi <> tt-decla-import-adic.cod-aladi) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Acordo Aladi":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Acordo_Aladi" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic   = bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cdn-fornec <> tt-decla-import-adic.cdn-fornec) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Fornecedor":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Fornecedor" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic      = bf-tt-decla-import-adic-itens.num-adic
                         AND   tt-decla-import-ord.cdn-fabrican <> tt-decla-import-adic.cdn-fabrican) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Fabricante":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Fabricante" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic                   = bf-tt-decla-import-adic-itens.num-adic
                         AND   (
                                tt-decla-import-ord.idi-tributac-cofins       <> bf-tt-decla-import-adic-itens.idi-tributac-cofins        OR
                                tt-decla-import-ord.idi-tributac-icms         <> bf-tt-decla-import-adic-itens.idi-tributac-icms          OR
                                tt-decla-import-ord.idi-tributac-impto-import <> bf-tt-decla-import-adic-itens.idi-tributac-impto-import  OR
                                tt-decla-import-ord.idi-tributac-ipi          <> bf-tt-decla-import-adic-itens.idi-tributac-ipi           OR
                                tt-decla-import-ord.idi-tributac-pis          <> bf-tt-decla-import-adic-itens.idi-tributac-pis 
                                )) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Regime de Tributaá∆o":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Regime_de_Tributaá∆o" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic         = bf-tt-decla-import-adic-itens.num-adic
                         AND   (
                                tt-decla-import-ord.val-aliq-cofins  <> bf-tt-decla-import-adic-itens.val-aliq-cofins    OR
                                tt-decla-import-ord.val-aliq-icms    <> bf-tt-decla-import-adic-itens.val-aliq-icms      OR
                                tt-decla-import-ord.val-aliq-ii      <> bf-tt-decla-import-adic-itens.val-aliq-ii        OR
                                tt-decla-import-ord.val-aliq-ipi     <> bf-tt-decla-import-adic-itens.val-aliq-ipi       OR
                                tt-decla-import-ord.val-aliq-pis     <> bf-tt-decla-import-adic-itens.val-aliq-pis
                                )) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Al°quotas":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Al°quotas" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic                    = bf-tt-decla-import-adic-itens.num-adic
                         AND   (
                                tt-decla-import-ord.val-perc-reduc-cofins       <> bf-tt-decla-import-adic-itens.val-perc-reduc-cofins         OR
                                tt-decla-import-ord.val-perc-reduc-icms         <> bf-tt-decla-import-adic-itens.val-perc-reduc-icms           OR
                                tt-decla-import-ord.val-perc-reduc-impto-import <> bf-tt-decla-import-adic-itens.val-perc-reduc-impto-import   OR
                                tt-decla-import-ord.val-perc-reduc-ipi          <> bf-tt-decla-import-adic-itens.val-perc-reduc-ipi            OR
                                tt-decla-import-ord.val-perc-reduc-pis          <> bf-tt-decla-import-adic-itens.val-perc-reduc-pis      
                                )) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "% Reduá∆o Base":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "%_Reduá∆o_Base" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
    
            IF CAN-FIND (FIRST tt-decla-import-ord
                         WHERE tt-decla-import-ord.num-adic                  = bf-tt-decla-import-adic-itens.num-adic
                         AND  (tt-decla-import-ord.log-suspens-impto-import  <> bf-tt-decla-import-adic-itens.log-suspens-impto-import OR 
                               tt-decla-import-ord.log-suspens-ipi-import    <> bf-tt-decla-import-adic-itens.log-suspens-ipi-import)) THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Indicativo de Suspens∆o":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Indicativo_de_Suspens∆o" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
        END.    
    END.
    
    FOR EACH tt-decla-import-adic,
        EACH tt-decla-import-adic-itens
        WHERE tt-decla-import-adic-itens.num-di-ems = tt-decla-import-adic.num-di-ems
        AND   tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic.num-adic
        AND   tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts:
    
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = tt-decla-import-adic-itens.cod-item: END.
    
        FOR FIRST param-imp
            WHERE param-imp.cod-estabel = tt-decla-import-adic-itens.cod-estab NO-LOCK: END.
    
        IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
            ASSIGN l-necessita-li = YES.
        ELSE 
            ASSIGN l-necessita-li = item.log-necessita-li.
    
        IF l-necessita-li THEN DO:
            IF CAN-FIND(FIRST tt-decla-import-ord NO-LOCK
                        WHERE tt-decla-import-ord.num-di-ems = tt-decla-import-adic-itens.num-di-ems
                        AND   tt-decla-import-ord.num-adic   = tt-decla-import-adic-itens.num-adic
                        AND   tt-decla-import-ord.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts
                        AND   tt-decla-import-ord.cod-licenc-import <> "") THEN DO:
    
                FOR EACH tt-decla-import-ord NO-LOCK
                    WHERE tt-decla-import-ord.num-di-ems = tt-decla-import-adic-itens.num-di-ems
                    AND   tt-decla-import-ord.num-adic   = tt-decla-import-adic-itens.num-adic 
                    AND   tt-decla-import-ord.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts:
    
                    IF CAN-FIND(FIRST bf-tt-decla-import-ord
                                WHERE bf-tt-decla-import-ord.num-di-ems         = tt-decla-import-ord.num-di-ems
                                AND   bf-tt-decla-import-ord.num-adic           = tt-decla-import-ord.num-adic
                                AND   bf-tt-decla-import-ord.cdd-siscomex-dts   = tt-decla-import-ord.cdd-siscomex-dts
                                AND   bf-tt-decla-import-ord.cod-licenc-import <> tt-decla-import-ord.cod-licenc-import) THEN DO:
                        RUN pi-gera-tt-erro (INPUT tt-decla-import-ord.num-adic,
                                             INPUT 52192  ,
                                             INPUT "LI informado e valores diferentes":U,
                                             OUTPUT l-retorno).
                        
                        IF l-retorno THEN DO:
    
                            {utp/ut-liter.i "LI_informado_e_valores_diferentes" *}
                            {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                        &ErrorType="EMS"
                                                        &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                        END. 
                    END.
                END.
            END.
        END.    
    
        FOR EACH  bf-tt-decla-import-adic-itens NO-LOCK
            WHERE bf-tt-decla-import-adic-itens.num-di-ems = tt-decla-import-adic-itens.num-di-ems
            AND   bf-tt-decla-import-adic-itens.num-adic   = tt-decla-import-adic-itens.num-adic
            AND   bf-tt-decla-import-adic-itens.cdd-siscomex-dts = tt-decla-import-adic-itens.cdd-siscomex-dts:
    
            FOR FIRST bf-item NO-LOCK
                WHERE bf-item.it-codigo = bf-tt-decla-import-adic-itens.cod-item: END.
    
            IF bf-item.log-necessita-li <> l-necessita-li THEN DO:
                RUN pi-gera-tt-erro (INPUT bf-tt-decla-import-adic-itens.num-adic,
                                     INPUT 52192  ,
                                     INPUT "Necessita LI":U,
                                     OUTPUT l-retorno).
                
                IF l-retorno THEN DO:
                    
                    {utp/ut-liter.i "Necessita_LI" *}
                    {method/svc/errors/inserr.i &ErrorNumber="52192"
                                                &ErrorType="EMS"
                                                &ErrorParameters="STRING(tt-decla-import-adic.num-adic)  + '~~~~' + TRIM(RETURN-VALUE)"}
                END. 
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                                AND   RowErrors.errorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    ELSE DO:
    
        FOR FIRST tt-decla-import-adic:
            RUN pi-deleta-relacs IN h-bocx383 (INPUT tt-decla-import-adic.num-di-ems,
                                               INPUT tt-decla-import-adic.cdd-siscomex-dts).
        END.
    
        IF NOT VALID-HANDLE(h-bocx402) THEN
            RUN cxbo/bocx402.p PERSISTEN SET h-bocx402.
        
        FOR EACH tt-decla-import-adic:
            EMPTY TEMP-TABLE tt-decla-import-adic-aux.
            CREATE tt-decla-import-adic-aux.
            BUFFER-COPY tt-decla-import-adic TO tt-decla-import-adic-aux.
    
            RUN openQueryStatic (INPUT 'Main':U).
            RUN emptyRowErrors.        
            RUN emptyRowObject.
            RUN setRecord (INPUT TABLE tt-decla-import-adic-aux).
            RUN createRecord.
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors (OUTPUT TABLE RowErrors APPEND).
            END.   
            ELSE DO:
                /*-------[ Calculo da taxa Siscomex ]------------------------------------*/
                IF NOT VALID-HANDLE(h-bocx390) THEN DO:
                    RUN cxbo/bocx390.p PERSISTENT SET h-bocx390.
                    RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
                END.
                
                ASSIGN d-val-despes-tot = 0.
                
                FIND FIRST decla-import EXCLUSIVE-LOCK
                     WHERE decla-import.num-di-ems = tt-decla-import-adic.num-di-ems 
                       AND decla-import.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts NO-ERROR.
                ASSIGN decla-import.num-adicoes = decla-import.num-adicoes + 1.
    
                FIND FIRST param-imp NO-LOCK
                        WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.
                
                IF NOT VALID-HANDLE(h-bocx407) THEN
                    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.
                
                IF NOT CAN-FIND(FIRST RowErrors
                                    WHERE RowErrors.errorType <> "INTERNAL":U ) THEN DO:
                    /* verificar param */
                     &if '{&bf_mat_versao_ems}' >= '2.07' &then
                         ASSIGN l-utz-taxa-siscomex = param-imp.log-tax-siscomex
                                i-cod-desp          = param-imp.cdn-despes-siscomex
                                i-cod-emitente-desp = param-imp.cdn-emit-siscomex.
                     &else
                         IF SUBSTRING(param-imp.char-1,105,1) = string(1) THEN
                             ASSIGN l-utz-taxa-siscomex = YES.
                         ELSE
                             ASSIGN l-utz-taxa-siscomex = NO.
                         ASSIGN i-cod-desp          = INTEGER(SUBSTRING(param-imp.char-1,91,5))
                                i-cod-emitente-desp = INTEGER(SUBSTRING(param-imp.char-1,96,9)).
                     &endif
                     
                     FOR FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = i-cod-emitente-desp:
                         ASSIGN i-cod-cond-pag = emitente.cod-cond-pag.
                     END.
                     
                     /* IF l-utz-taxa-siscomex THEN DO:*/
                     /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
                     RUN pi-seta-l-automatico IN h-bocx390(INPUT YES).
                     /* gerar uma despesa para cada adicao (despes-adic)*/
                     FOR EACH decla-import-adic NO-LOCK
                            WHERE decla-import-adic.num-di-ems = tt-decla-import-adic.num-di-ems
                            AND   decla-import-adic.num-adic   = tt-decla-import-adic.num-adic
                            AND   decla-import-adic.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts: 
    
                         FOR EACH tt-decla-import-adic-itens
                             WHERE tt-decla-import-adic-itens.num-di-ems = decla-import-adic.num-di-ems /*tt-decla-import-adic.num-di-ems */
                             AND   tt-decla-import-adic-itens.num-adic   = decla-import-adic.num-adic  /*tt-decla-import-adic.num-adic :*/
                             AND   tt-decla-import-adic-itens.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
                             EMPTY TEMP-TABLE tt-decla-import-adic-itens-aux.
                             CREATE tt-decla-import-adic-itens-aux.
                             BUFFER-COPY tt-decla-import-adic-itens TO tt-decla-import-adic-itens-aux.
    
                             RUN openQueryStatic IN h-bocx402(INPUT 'Main':U).
                             RUN emptyRowErrors  IN h-bocx402.        
                             RUN emptyRowObject  IN h-bocx402.
                             RUN setRecord       IN h-bocx402 (INPUT TABLE tt-decla-import-adic-itens-aux).
                             RUN createRecord    IN h-bocx402.
    
                             IF RETURN-VALUE = "NOK":U THEN DO:
                                 RUN getRowErrors IN h-bocx402(OUTPUT TABLE RowErrors APPEND).
                             END. 
                         END.
    
                         IF l-utz-taxa-siscomex THEN DO:
                             FOR EACH decla-import-ord NO-LOCK
                                    WHERE decla-import-ord.num-di-ems = decla-import-adic.num-di-ems
                                    AND   decla-import-ord.num-adic   = decla-import-adic.num-adic
                                    AND   decla-import-ord.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts:
    
                                FOR FIRST ordens-embarque NO-LOCK
                                        WHERE ordens-embarque.embarque      = decla-import-ord.cod-embarq
                                        AND   ordens-embarque.cod-estabel   = decla-import-ord.cod-estab
                                        AND   ordens-embarque.numero-ordem  = decla-import-ord.num-ordem
                                        AND   ordens-embarque.parcela       = decla-import-ord.num-parcela:
                                         
                                    RUN retorna-ponto-nacionalizacao IN h-bocx407 (INPUT decla-import-ord.cod-embarq,
                                                                                   INPUT decla-import-ord.cod-estab,
                                                                                   OUTPUT i-cdn-pto-nacionaliz-histor).
                                   
                                    ASSIGN d-val-despes = 0.
                                    &if '{&bf_mat_versao_ems}' >= '2.07' &then
                                         ASSIGN d-val-despes = ordens-embarque.val-tax-siscomex.
                                    &else
                                         ASSIGN d-val-despes = DECIMAL(SUBSTRING(ordens-embarque.char-1,64,16)) / 100000.
                                    &endif
                                         
                                    IF NOT CAN-FIND(FIRST tt-despes-adic
                                                        WHERE tt-despes-adic.num-di-ems = decla-import-adic.num-di-ems
                                                        AND   tt-despes-adic.num-adic   = decla-import-adic.num-adic
                                                        AND   tt-despes-adic.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts
                                                        AND   tt-despes-adic.cdn-despes = i-cod-desp) THEN DO:
                                        CREATE tt-despes-adic.
                                        ASSIGN tt-despes-adic.num-di-ems        = decla-import-adic.num-di-ems
                                               tt-despes-adic.num-adic          = decla-import-adic.num-adic
                                               tt-despes-adic.cdn-despes        = i-cod-desp
                                               tt-despes-adic.cdd-siscomex-dts  = decla-import-adic.cdd-siscomex-dts
                                               tt-despes-adic.cdn-emit-despes   = i-cod-emitente-desp                             
                                               tt-despes-adic.cdn-cond-pag      = i-cod-cond-pag
                                               tt-despes-adic.cdn-moeda         = 0
                                               tt-despes-adic.cdn-pto-control   = i-cdn-pto-nacionaliz-histor
                                               tt-despes-adic.val-despes        = d-val-despes
                                               tt-despes-adic.idi-orig-despes   = 2.
    
                                        RUN pi-busca-valor-taxa-siscomex IN h-bocx383 (INPUT decla-import.cod-estab,
                                                                                       INPUT tt-despes-adic.num-adic,
                                                                                       OUTPUT tt-despes-adic.val-despes).
    
                                    END.
                                END.
                            END.
                        END.
                
                         RUN openQueryStatic IN h-bocx390 (INPUT "Main":U) NO-ERROR.
                         RUN emptyRowObject  IN h-bocx390.
                         RUN emptyRowErrors  IN h-bocx390.
                
                         FOR EACH tt-despes-adic:
                            EMPTY TEMP-TABLE tt-despes-adic-aux.
                            CREATE tt-despes-adic-aux.
                            BUFFER-COPY tt-despes-adic TO tt-despes-adic-aux.
                
                            RUN goToKey IN h-bocx390(INPUT tt-despes-adic-aux.num-di-ems,
                                                     INPUT tt-despes-adic-aux.num-adic,
                                                     INPUT tt-despes-adic-aux.cdn-despes,
                                                     INPUT tt-despes-adic-aux.cdn-emit-despes,
                                                     INPUT tt-despes-adic-aux.cdd-siscomex-dts).
                    
                            IF RETURN-VALUE = "NOK":U THEN DO:
                                 RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                                 RUN createRecord    IN h-bocx390.
                                 RUN getRowErrors    IN h-bocx390(OUTPUT TABLE RowErrors).
                             END.
                             ELSE DO:
                                 RUN setRecord       IN h-bocx390 (INPUT TABLE tt-despes-adic-aux).
                                 RUN updateRecord    IN h-bocx390.
                             END.    
                         END.                                                                    
                         /* seta a variavel l-automatico para yes, para passar pela validaá∆o do siscomex */
                         RUN pi-seta-l-automatico IN h-bocx390(INPUT NO).
                     END.
                     
                     /* totaliza as despesas do parametro (taxa siscomex) para a DI */
                     RUN pi-totaliza-taxa-siscomex IN h-bocx383 (INPUT tt-decla-import-adic.num-di-ems, INPUT tt-decla-import-adic.cdd-siscomex-dts).

                     IF l-nt2024002 THEN DO:
                        FOR EACH tt-decla-import-adic-trib NO-LOCK:

                            EMPTY TEMP-TABLE tt-decla-import-adic-trib-aux.
                            CREATE tt-decla-import-adic-trib-aux.
                            BUFFER-COPY tt-decla-import-adic-trib TO tt-decla-import-adic-trib-aux.
                        
                            RUN openQueryStatic IN h-bocx00506(INPUT 'Main':U).
                            RUN emptyRowErrors  IN h-bocx00506.        
                            RUN emptyRowObject  IN h-bocx00506.                        
                            RUN goToKey         IN h-bocx00506 (INPUT tt-decla-import-adic-trib.num-di-ems,
                                                                INPUT tt-decla-import-adic-trib.num-adic,
                                                                INPUT tt-decla-import-adic-trib.cdd-siscomex-dts,
                                                                INPUT tt-decla-import-adic-trib.nom-trib,
                                                                INPUT tt-decla-import-adic-trib.cod-campo).    
                            IF RETURN-VALUE = "NOK" THEN DO:
                                RUN setRecord      IN h-bocx00506 (INPUT TABLE tt-decla-import-adic-trib-aux).
                                RUN createRecord   IN h-bocx00506.
                            
                                IF RETURN-VALUE = "NOK":U THEN DO:
                                    RUN getRowErrors IN h-bocx00506(OUTPUT TABLE RowErrors APPEND).
                                END.   
                                ELSE DO:                
                                    FOR EACH tt-decla-imp-adic-it-trib NO-LOCK
                                        WHERE tt-decla-imp-adic-it-trib.num-di-ems       = tt-decla-import-adic-trib.num-di-ems 
                                        AND   tt-decla-imp-adic-it-trib.num-adic         = tt-decla-import-adic-trib.num-adic
                                        AND   tt-decla-imp-adic-it-trib.cdd-siscomex-dts = tt-decla-import-adic-trib.cdd-siscomex-dts:

                                        EMPTY TEMP-TABLE tt-decla-imp-adic-it-trib-aux.
                                        CREATE tt-decla-imp-adic-it-trib-aux.
                                        BUFFER-COPY tt-decla-imp-adic-it-trib TO tt-decla-imp-adic-it-trib-aux.
                                    
                                        RUN openQueryStatic IN h-bocx00512(INPUT 'Main':U).
                                        RUN emptyRowErrors  IN h-bocx00512.
                                        RUN emptyRowObject  IN h-bocx00512.
                                        RUN goToKey         IN h-bocx00512 (INPUT tt-decla-imp-adic-it-trib-aux.num-di-ems,
                                                                            INPUT tt-decla-imp-adic-it-trib-aux.num-adic,
                                                                            INPUT tt-decla-imp-adic-it-trib-aux.num-seq,
                                                                            INPUT tt-decla-imp-adic-it-trib-aux.cdd-siscomex-dts,
                                                                            INPUT tt-decla-imp-adic-it-trib-aux.nom-trib,
                                                                            INPUT tt-decla-imp-adic-it-trib-aux.cod-campo).
                                        IF RETURN-VALUE = "NOK":U THEN DO:
                                            RUN setRecord       IN h-bocx00512 (INPUT TABLE tt-decla-imp-adic-it-trib-aux).
                                            RUN createRecord    IN h-bocx00512.

                                            IF RETURN-VALUE = "NOK":U THEN DO:
                                                RUN getRowErrors IN h-bocx00512(OUTPUT TABLE RowErrors APPEND).
                                            END.
                                        END.
                                    END.
                                END.
                            END.
                        END.
                     END.
                END. /*if can-find(row-errors)*/
                /*---------[ Fim - Calculo da taxa Siscomex ]--------------------------------------------*/
            END.
        END.
    
        IF VALID-HANDLE(h-bocx383) THEN 
            DELETE PROCEDURE h-bocx383.
        ASSIGN h-bocx383 = ?.
    
        IF VALID-HANDLE(h-bocx402) THEN     
            DELETE PROCEDURE h-bocx402.
        ASSIGN h-bocx402 = ?.
    
        IF VALID-HANDLE(h-bocx407) THEN 
            DELETE PROCEDURE h-bocx407.
        ASSIGN h-bocx407 = ?.
    
        IF VALID-HANDLE(h-bocx390) THEN 
            DELETE PROCEDURE h-bocx390.
        ASSIGN h-bocx390 = ?.

        IF VALID-HANDLE(h-bocx00506) THEN 
            DELETE PROCEDURE h-bocx00506.
        ASSIGN h-bocx00506 = ?.

        IF VALID-HANDLE(h-bocx00512) THEN 
            DELETE PROCEDURE h-bocx00512.
        ASSIGN h-bocx00512 = ?.        
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-valores DBOProgram 
PROCEDURE pi-valida-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: esta procedure recebe os valores informados para os impostos e 
         valida se os dados informados est∆o corretos.      
------------------------------------------------------------------------------*/
    DEF INPUT PARAM d-val-db-cr      LIKE decla-import-adic.val-ii-db-cr      NO-UNDO.
    DEF INPUT PARAM d-val-outras     LIKE decla-import-adic.val-ii-outras     NO-UNDO.
    DEF INPUT PARAM d-val-nao-tribut LIKE decla-import-adic.val-ii-nao-tribut NO-UNDO.
    DEF INPUT PARAM d-val-aliq       LIKE decla-import-adic.val-aliq-ii       NO-UNDO.
    DEF INPUT PARAM d-val-base       LIKE decla-import-adic.val-base-ii       NO-UNDO.
    DEF OUTPUT PARAM l-correto       AS LOGICAL                               NO-UNDO.

    DEF VAR valor-aux LIKE decla-import-adic.val-ii-db-cr NO-UNDO.
    DEF VAR base-aux  LIKE decla-import-adic.val-base-ii  NO-UNDO.

    ASSIGN valor-aux = d-val-db-cr      WHEN d-val-db-cr      > 0
           valor-aux = d-val-outras     WHEN d-val-outras     > 0
           valor-aux = d-val-nao-tribut WHEN d-val-nao-tribut > 0.

    ASSIGN base-aux = valor-aux / (d-val-aliq / 100).
    IF round(base-aux,2) >= ROUND(d-val-base,2) AND
       round(base-aux,2) <= ROUND(d-val-base,2)  THEN
        ASSIGN l-correto = YES.
    ELSE
        ASSIGN l-correto = NO.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-adic DBOProgram 
PROCEDURE pi-verifica-adic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER i-num-di-ems  LIKE {&TableName}.num-di-ems NO-UNDO.
    DEFINE INPUT  PARAMETER de-cdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER l-existe-adic AS LOGICAL                   NO-UNDO.

    ASSIGN l-existe-adic = CAN-FIND(FIRST bf{&TableName}
                                        WHERE bf{&TableName}.num-di-ems = i-num-di-ems 
                                         AND  bf{&TableName}.cdd-siscomex-dts = cdd-siscomex-dts).
                                            

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piContaRegistro DBOProgram 
PROCEDURE piContaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF  INPUT PARAM pnum-di-ems    LIKE decla-import-adic.num-di-ems NO-UNDO.
    DEF  INPUT PARAM pcdd-siscomex-dts LIKE decla-import-adic.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM pnum-registros AS   INTEGER NO-UNDO.

    DEF VAR i-conta AS INTEGER NO-UNDO.

    ASSIGN i-conta = 0.

    EMPTY TEMP-TABLE tt-decla-import-adic.

    RUN setConstraintByDI (INPUT pnum-di-ems,
                           INPUT pcdd-siscomex-dts).
    RUN openQueryStatic   (INPUT "ByDI":U).
    RUN getBatchRecords   (INPUT  ?,
                           INPUT  ?,
                           INPUT  99999,
                           OUTPUT i-reg-retornados,
                           OUTPUT TABLE tt-decla-import-adic).

    FOR EACH tt-decla-import-adic:
        ASSIGN i-conta = i-conta + 1.
    END.

    ASSIGN pnum-registros = i-conta.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaUnidadeNCM DBOProgram 
PROCEDURE piRetornaUnidadeNCM :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF  INPUT PARAM pnum-di-ems LIKE {&TableName}.num-di-ems NO-UNDO.
    DEF  INPUT PARAM pnum-adic   LIKE {&TableName}.num-adic   NO-UNDO.
    DEF  INPUT PARAM pcdd-siscomex-dts LIKE {&TableName}.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM pUN-NCM     AS CHAR NO-UNDO.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.num-di-ems = pnum-di-ems
        AND   bf{&TableName}.num-adic   = pnum-adic
        AND   bf{&TableName}.cdd-siscomex-dts = pcdd-siscomex-dts:
        FOR FIRST decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-di-ems = bf{&TableName}.num-di-ems
            AND   decla-import-ord.num-adic   = bf{&TableName}.num-adic
            AND   decla-import-ord.cdd-siscomex-dts = bf{&TableName}.cdd-siscomex-dts:

            FIND FIRST item NO-LOCK
                WHERE  item.it-codigo = decla-import-ord.cod-item NO-ERROR.
            IF  AVAIL item
            THEN
                ASSIGN pUN-NCM = item.un.
            ELSE
                ASSIGN pUN-NCM = "".
        END. 
    END. 

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-adicoes-embarq DBOProgram 
PROCEDURE retorna-adicoes-embarq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pCodEmbarq LIKE decla-import-adic-itens.cod-embarq NO-UNDO.
    DEF INPUT  PARAM pCodEstab  LIKE decla-import-adic-itens.cod-estab  NO-UNDO.
    DEF INPUT  PARAM pNumDiEms  LIKE decla-import-adic-itens.num-di-ems NO-UNDO.
    DEF INPUT  PARAM pCddSiscomexDts LIKE decla-import-adic-itens.cdd-siscomex-dts NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowObjectAux.
    
    EMPTY TEMP-TABLE RowObjectAux.
    
    FOR EACH decla-import-adic-itens NO-LOCK
        WHERE decla-import-adic-itens.num-di-ems = pNumDiEms
        AND   decla-import-adic-itens.cod-embarq = pCodEmbarq
        AND   decla-import-adic-itens.cod-estab  = pCodEstab
        AND   decla-import-adic-itens.cdd-siscomex-dts = pCddSiscomexDts,
        FIRST decla-import-adic NO-LOCK
        WHERE decla-import-adic.num-di-ems = decla-import-adic-itens.num-di-ems 
        AND   decla-import-adic.num-adic   = decla-import-adic-itens.num-adic
        AND   decla-import-adic.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
    
        IF NOT CAN-FIND(FIRST RowObjectAux 
                        WHERE RowObjectAux.num-di-ems = decla-import-adic.num-di-ems 
                        AND   RowObjectAux.num-adic   = decla-import-adic.num-adic   
                        AND   RowObjectAux.cdd-siscomex-dts = decla-import-adic.cdd-siscomex-dts) THEN DO:
            CREATE RowObjectAux.
            BUFFER-COPY decla-import-adic TO RowObjectAux.
        END.                    
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescItem DBOProgram 
PROCEDURE retornaDescItem :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-item  LIKE decla-import-adic-itens.cod-item NO-UNDO.
    DEF OUTPUT PARAM p-descricao AS CHARACTER FORMAT 'x(40)':U         NO-UNDO.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = p-cod-item NO-ERROR.
    IF  AVAIL item THEN
        ASSIGN p-descricao = (item.descricao-1 + item.descricao-2).
    ELSE
        ASSIGN p-descricao = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaUnidMed DBOProgram 
PROCEDURE retornaUnidMed :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-item LIKE decla-import-adic-itens.cod-item NO-UNDO.
    DEF OUTPUT PARAM p-un       LIKE item.un                          NO-UNDO.

    FIND FIRST item NO-LOCK
         WHERE item.it-codigo = p-cod-item NO-ERROR.
    IF AVAIL item THEN
        ASSIGN p-un = item.un.
    ELSE
        ASSIGN p-un = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFornPrimeiraAdic DBOProgram 
PROCEDURE retornaFornPrimeiraAdic :
/*------------------------------------------------------------------------------
   Purpose:    Retorna o fornecedor da primeira adiÁ„o da DI
     Notes:    Utilizado para sugerir o fornecedor na geraÁ„o da NF Complementar
Parameters:	   pi-di-ems - DI EMS
			   pi-fornec - CÛdigo Fornecedor AdiÁ„o
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pi-di-siscomex  LIKE decla-import.cod-di-siscomex NO-UNDO.
    DEF OUTPUT PARAM pi-fornec       LIKE decla-import-adic.cdn-fornec NO-UNDO.

    DEF VAR i-aux AS INTEGER NO-UNDO. 

    FOR FIRST decla-import field(num-di-ems) NO-LOCK
        WHERE decla-import.cod-di-siscomex = pi-di-siscomex,
        FIRST decla-import-adic field (cdn-fornec) NO-LOCK
    		WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
    		  AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

		ASSIGN pi-fornec = decla-import-adic.cdn-fornec.
	END.

    /* se nao achar pelo codigo da di-siscomex procurar pelo numero da di-ems */
    ASSIGN i-aux = INT(pi-di-siscomex) NO-ERROR.

    IF pi-fornec = 0 AND NOT ERROR-STATUS:ERROR THEN
        FOR FIRST decla-import field(num-di-ems cdd-siscomex-dts) NO-LOCK
            WHERE decla-import.num-di-ems = int(pi-di-siscomex),
            FIRST decla-import-adic field (cdn-fornec) NO-LOCK
        		WHERE decla-import-adic.num-di-ems = decla-import.num-di-ems
                  AND decla-import-adic.cdd-siscomex-dts = decla-import.cdd-siscomex-dts:

    		ASSIGN pi-fornec = decla-import-adic.cdn-fornec.
    	END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDI DBOProgram 
PROCEDURE setConstraintByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
    DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
    
    ASSIGN inum-di-ems = pNumDiEms
           decdd-siscomex-dts = pCddSiscomexDts.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumDIEMS DBOProgram 
PROCEDURE setConstraintByNumDIEMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pNumDiEms LIKE {&tablename}.num-di-ems NO-UNDO.
    DEF INPUT PARAM pNumAdic  LIKE {&tablename}.num-adic   NO-UNDO.
    DEF INPUT PARAM pCddSiscomexDts LIKE {&tablename}.cdd-siscomex-dts NO-UNDO.
    
    ASSIGN inum-di-ems = pNumDiEms
           inum-adic   = pNumAdic
           decdd-siscomex-dts = pCddSiscomexDts.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do  include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "CREATE":U OR pType = "COPY":U THEN DO:

        IF CAN-FIND (FIRST {&TABLENAME} WHERE                                         
                           {&TABLENAME}.num-di-ems  = RowObject.num-di-ems  AND 
                           {&TABLENAME}.num-adic    = RowObject.num-adic    AND
                           {&TABLENAME}.cdd-siscomex-dts  = RowObject.cdd-siscomex-dts  ) THEN DO:
                
                {utp/ut-liter.i "Adiá∆o_Declaraá∆o_Importaá∆o" *}
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                            &ErrorType="EMS":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    IF  pType = "UPDATE":U THEN DO:

        DEF VAR d-val-manual-ii         LIKE decla-import-adic.val-ii-db-cr     NO-UNDO.
        DEF VAR d-confere-ii-manual     LIKE decla-import-adic.val-ii-db-cr     NO-UNDO.
        DEF VAR d-val-manual-ipi        LIKE decla-import-adic.val-ipi-db-cr    NO-UNDO.
        DEF VAR d-confere-ipi-manual    LIKE decla-import-adic.val-ipi-db-cr    NO-UNDO.
        DEF VAR d-val-manual-pis        LIKE decla-import-adic.val-pis-db-cr    NO-UNDO.
        DEF VAR d-confere-pis-manual    LIKE decla-import-adic.val-pis-db-cr    NO-UNDO.
        DEF VAR d-val-manual-cofins     LIKE decla-import-adic.val-cofins-db-cr NO-UNDO.
        DEF VAR d-confere-cofins-manual LIKE decla-import-adic.val-cofins-db-cr NO-UNDO.
        DEF VAR d-val-manual-icms       LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
        DEF VAR d-confere-icms-manual   LIKE decla-import-adic.val-icms-db-cr   NO-UNDO.
        DEF VAR log-suspens-pis-aux     AS   LOGICAL                            NO-UNDO.
        DEF VAR log-suspens-cofins-aux  AS   LOGICAL                            NO-UNDO.
        DEF VAR log-suspens-icms-aux    AS   LOGICAL                            NO-UNDO.
        DEF VAR log-suspens-pis-novo    AS   LOGICAL                            NO-UNDO.
        DEF VAR log-suspens-cofins-novo AS   LOGICAL                            NO-UNDO.
        DEF VAR log-suspens-icms-novo   AS   LOGICAL                            NO-UNDO.
    

        FIND FIRST decla-import-adic NO-LOCK 
            WHERE decla-import-adic.num-di-ems = RowObject.num-di-ems
            AND   decla-import-adic.num-adic   = RowObject.num-adic 
            AND   decla-import-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-ERROR.

        &if '{&bf_mat_versao_ems}' >= '2.09' &then
            ASSIGN log-suspens-icms-aux    = decla-import-adic.log-suspens-icms
                   log-suspens-pis-aux     = decla-import-adic.log-suspens-pis
                   log-suspens-cofins-aux  = decla-import-adic.log-suspens-cofins
                   log-suspens-icms-novo   = RowObject.log-suspens-icms
                   log-suspens-pis-novo    = RowObject.log-suspens-pis
                   log-suspens-cofins-novo = RowObject.log-suspens-cofins.
        &else
            ASSIGN log-suspens-icms-aux    = IF SUBSTRING(decla-import-adic.cod-livre-1,1,1) = '1' THEN YES ELSE NO
                   log-suspens-pis-aux     = IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = '1' THEN YES ELSE NO
                   log-suspens-cofins-aux  = IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = '1' THEN YES ELSE NO
                   log-suspens-icms-novo   = IF SUBSTRING(RowObject.cod-livre-1,1,1)         = '1' THEN YES ELSE NO
                   log-suspens-pis-novo    = IF SUBSTRING(RowObject.cod-livre-1,2,1)         = '1' THEN YES ELSE NO
                   log-suspens-cofins-novo = IF SUBSTRING(RowObject.cod-livre-1,3,1)         = '1' THEN YES ELSE NO.
        &endif
        
        IF decla-import-adic.idi-tributac-impto-import   <> RowObject.idi-tributac-impto-import   OR
           decla-import-adic.idi-tributac-ipi            <> RowObject.idi-tributac-ipi            OR
           decla-import-adic.idi-tributac-pis            <> RowObject.idi-tributac-pis            OR
           decla-import-adic.idi-tributac-cofins         <> RowObject.idi-tributac-cofins         OR
           decla-import-adic.idi-tributac-icms           <> RowObject.idi-tributac-icms           OR
           decla-import-adic.val-aliq-ii                 <> RowObject.val-aliq-ii                 OR
           decla-import-adic.val-aliq-ipi                <> RowObject.val-aliq-ipi                OR
           decla-import-adic.val-aliq-pis                <> RowObject.val-aliq-pis                OR
           decla-import-adic.val-aliq-cofins             <> RowObject.val-aliq-cofins             OR
           decla-import-adic.val-aliq-icms               <> RowObject.val-aliq-icms               OR
           decla-import-adic.val-perc-reduc-impto-import <> RowObject.val-perc-reduc-impto-import OR
           decla-import-adic.val-perc-reduc-ipi          <> RowObject.val-perc-reduc-ipi          OR
           decla-import-adic.val-perc-reduc-pis          <> RowObject.val-perc-reduc-pis          OR
           decla-import-adic.val-unit-cofins             <> RowObject.val-unit-cofins             OR
           decla-import-adic.val-perc-reduc-icms         <> RowObject.val-perc-reduc-icms         OR
           decla-import-adic.log-suspens-ipi-import      <> RowObject.log-suspens-ipi-import      OR 
           decla-import-adic.log-suspens-impto-import    <> RowObject.log-suspens-impto-import    OR
           log-suspens-icms-aux                          <> log-suspens-icms-novo                 OR
           log-suspens-pis-aux                           <> log-suspens-pis-novo                  OR
           log-suspens-cofins-aux                        <> log-suspens-cofins-novo               THEN DO:

            IF NOT VALID-HANDLE(h-bocx383a) THEN
                RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.

            /* reabre o calculo dos impostos */
            RUN pi-atualiza-pend-imp IN h-bocx383a (INPUT RowObject.num-di-ems, INPUT RowObject.cdd-siscomex-dts).
            IF RETURN-VALUE <> "NOK":U THEN DO:

                {utp/ut-liter.i "Os_valores_dos_impostos_foram_alterados,_por_isso_o_c†lculo_dos_impostos_ser†_reaberto" *}
                {method/svc/errors/inserr.i &ErrorNumber="19085"
                                            &ErrorType="EMS":U
                                            &ErrorParameters="TRIM(RETURN-VALUE) + '!'"}
            END. 

            IF VALID-HANDLE(h-bocx383a) THEN DO:
                DELETE PROCEDURE h-bocx383a.
                ASSIGN h-bocx383a = ?.
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
