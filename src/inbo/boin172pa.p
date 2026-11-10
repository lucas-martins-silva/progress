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
{include/i-prgvrs.i BOIN172PA 2.00.00.006} /*** "010006" 27/10/2023 17:03:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172pa MUT}
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
&GLOBAL-DEFINE DBOName BOIN172
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin172pa.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgman.i}

def temp-table ttItem NO-UNDO
    field it-codigo  as char format "x(16)"
    field rw-item    as rowid
    field diferencas as char format "x(400)"
    field des-erro   as char format "x(60)"
    index codigo is primary unique it-codigo.

def temp-table ttExpFields NO-UNDO
    field demanda       as   int format "9"
    field tipo-est-seg  as   int format "9"
    field div-ordem     as   int format "9"
    field periodo-fixo  like familia.periodo-fixo
    field fator-refugo  like familia.fator-refugo
    field quant-perda   like familia.quant-perda
    field lote-multipl  like familia.lote-multipl
    field lote-minimo   like familia.lote-minimo
    field quant-segur   like familia.quant-segur
    field tempo-segur   like familia.tempo-segur
    field res-cq-comp   like familia.res-cq-comp
    field res-cq-fabri  like familia.res-cq-fabri
    field res-for-comp  like familia.res-for-comp
    field res-int-comp  like familia.res-int-comp
    field ressup-fabri  like familia.ressup-fabri
    field horiz-fixo    like familia.horiz-fixo
    &IF DEFINED (bf_man_integra_aps) &THEN
    field cod-malha     like familia.cod-malha
    field cod-pulmao    like familia.cod-pulmao
    field politica-aps  like familia.politica-aps
    field geracao-ordem like familia.geracao-ordem
    field qtde-fixa     like familia.qtde-fixa
    field lote-repos    like familia.lote-repos
    field qtde-max      like familia.qtde-max
    field cons-produto  like familia.cons-produto
    field cons-saldo    like familia.cons-saldo
    field mp-restrit    like familia.mp-restrit
    field cons-consumo  like familia.cons-consumo
    &ENDIF
    field char-1        like familia.char-1
    field r-rowid       as   rowid.

def var cItCodigoIni as char no-undo.
def var cItCodigoFim as char no-undo.
DEF VAR cFamilIni    AS CHAR NO-UNDO.
DEF VAR cFamilFim    AS CHAR NO-UNDO.

def var iDemanda     as int init ? no-undo.
def var iContrPlan   as int init ? no-undo.
def var iTipoEstSeg  as int init ? no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.5
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if  substring(item.char-1,60,2) = "09" then
    assign item.politica = 5.

if  iDemanda <> ? then
    assign item.demanda = iDemanda.
    
if  iContrPlan <> ? then
    assign item.contr-plan = iContrPlan.
    
if  iTipoEstSeg <> ? then
    assign item.tipo-est-seg = iTipoEstSeg.        

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaContrPlan DBOProgram 
PROCEDURE atualizaContrPlan :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pContrPlan as int no-undo.

assign iContrPlan = pContrPlan.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDemanda DBOProgram 
PROCEDURE atualizaDemanda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pDemanda as int no-undo.

assign iDemanda = pDemanda.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTipoEstSeg DBOProgram 
PROCEDURE atualizaTipoEstSeg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pTipoEstSeg as int no-undo.

assign iTipoEstSeg = pTipoEstSeg.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CriaTTExportaItemFamilia DBOProgram 
PROCEDURE CriaTTExportaItemFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param table for ttExpFields.
    def output param table for ttItem.

    find first ttExpFields.
    
    find familia where
         rowid(familia) = ttExpFields.r-rowid no-lock.
    
    for each item where
             item.fm-codigo = familia.fm-codigo no-lock:
                     
        create ttItem.
        assign ttItem.it-codigo = item.it-codigo
               ttItem.rw-item   = rowid(item).

        &IF DEFINED (bf_man_integra_aps) &THEN

            if  item.politica-aps <> ttExpFields.politica-aps then
                assign ttItem.diferencas = "Politica".

            if  item.politica-aps        = 2
            and ttExpFields.politica-aps = 2 
            and item.geracao-ordem      <> ttExpFields.geracao-ordem then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Geraá∆o de Ordem".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Geraá∆o de Ordem".

            if  item.cons-produto <> ttExpFields.cons-produto then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Item como Produto".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Item como Produto".

            if  item.cons-saldo <> ttExpFields.cons-saldo then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Saldo Estoque".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Saldo Estoque".

            if  item.mp-restrit <> ttExpFields.mp-restrit then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "MatÇria Prima Restritiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", MatÇria Prima Restritiva".    

            if  ttExpFields.politica-aps = 4 
            and item.qtde-fixa          <> ttExpFields.qtde-fixa then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade Fixa".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Fixa".
        
            if (ttExpFields.politica-aps = 6
            or  ttExpFields.politica-aps = 7)
            and item.lote-repos         <> ttExpFields.lote-repos then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Lote Reposiá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Lote Reposiá∆o".
        
            if  item.qtde-max <> ttExpFields.qtde-max then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade M†xima".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade M†xima".    

            if  item.cons-consumo <> ttExpFields.cons-consumo then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Consumo de Previs∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Consumo de Previs∆o".    

            if  item.cod-malha <> ttExpFields.cod-malha then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Malha Produtiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Malha Produtiva".    

            if  item.cod-pulmao <> ttExpFields.cod-pulmao then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Pulm∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Pulm∆o".

        &ELSE
        
            if  substring(item.char-1,60,2) <> substring(ttExpFields.char-1,60,2) then
                assign ttItem.diferencas = "Politica".
        
            if substring(item.char-1,60,2)        =  "02" and
               substring(ttExpFields.char-1,60,2) =  "02" and
               substring(item.char-1,62,1)        <> substring(ttExpFields.char-1,62,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Geraá∆o de Ordem".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Geraá∆o de Ordem".
    
            if substring(item.char-1,63,1) <> substring(ttExpFields.char-1,63,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Item como Produto".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Item como Produto".

            if substring(item.char-1,64,1) <> substring(ttExpFields.char-1,64,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Saldo Estoque".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Saldo Estoque".

            if substring(item.char-1,65,1) <> substring(ttExpFields.char-1,65,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "MatÇria Prima Restritiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", MatÇria Prima Restritiva".    

            if substring(ttExpFields.char-1,60,2) =  "04" and
               substring(item.char-1,66,11)       <> substring(ttExpFields.char-1,66,11) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade Fixa".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Fixa".

            if (substring(ttExpFields.char-1,60,2) =  "06"  or
                substring(ttExpFields.char-1,60,2) =  "07") and  
                substring(item.char-1,66,11)       <> substring(ttExpFields.char-1,66,11) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Lote Reposiá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Lote Reposiá∆o".

            if substring(item.char-1,117,11) <> substring(ttExpFields.char-1,117,11) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade M†xima".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade M†xima".    

            if substring(item.char-1,77,1) <> substring(ttExpFields.char-1,77,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Consumo de Previs∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Consumo de Previs∆o".    

            if substring(item.char-1,78,5) <> substring(ttExpFields.char-1,78,5) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Malha Produtiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Malha Produtiva".    

            if  substring(item.char-1,83,5) <> substring(ttExpFields.char-1,83,5) then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Pulm∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Pulm∆o".
                    
            if substring(item.char-1,128,1) <> substring(ttExpFields.char-1,128,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Taxa de Produá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Taxa de Produá∆o".
                        
            if int(substring(item.char-1,129,3)) <> int(substring(ttExpFields.char-1,129,3)) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Per°odo Fixo Exportaá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Per°odo Fixo Exportaá∆o".
        &ENDIF


        if substring(item.char-1,149,5) <> substring(ttExpFields.char-1,149,5) then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "CritÇrio de Agrupamento".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", CritÇrio de Agrupamento".

        if int(substring(item.char-1,154,3)) <> int(substring(ttExpFields.char-1,154,3)) then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Horizonte de Agrupamento".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Horizonte de Agrupamento".

        if  item.demanda <> ttExpFields.demanda then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Demanda".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Demanda".
                
        if  item.tipo-est-seg <> ttExpFields.tipo-est-seg then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Tipo Estoque Segur".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Tipo Estoque Segur".

        if  item.div-ordem <> ttExpFields.div-ordem then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Divis∆o de Ordens".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Divis∆o de Ordens".

        if  item.periodo-fixo <> ttExpFields.periodo-fixo then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Per°odo Fixo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Per°odo Fixo".

        if  item.fator-refugo <> ttExpFields.fator-refugo then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Fator de Refugo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Fator de Refugo".

        if  item.quant-perda <> ttExpFields.quant-perda then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Quantidade de Perda".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Quantidade de Perda".

        if  item.lote-multipl <> ttExpFields.lote-multipl then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Lote Multiplo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Lote Multiplo".

        if  item.lote-minimo <> ttExpFields.lote-minimo then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Lote M°nimo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Lote M°nimo".

        if  item.quant-segur <> ttExpFields.quant-segur then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Quantidade Seguranáa".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Seguranáa".
                
        if  item.tempo-segur <> ttExpFields.tempo-segur then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Tempo Seguranáa".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Tempo Seguranáa".

        if  item.res-int-comp <> ttExpFields.res-int-comp then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Compra".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Compra".

        if  item.res-for-comp <> ttExpFields.res-for-comp then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Fornecedor".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Fornecedor".

        if  item.res-cq-comp <> ttExpFields.res-cq-comp then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento CQ de Compra".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento CQ de Compra".

        if  item.ressup-fabri <> ttExpFields.ressup-fabri then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Fabricaá∆o".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Fabricaá∆o".

        if  item.res-cq-fabri <> ttExpFields.res-cq-fabri then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento CQ de Fabricaá∆o".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento CQ de Fabricaá∆o".

        if  item.horiz-fixo <> ttExpFields.horiz-fixo then
            if  ttItem.diferencas = "" then
                assign ttItem.diferencas = "Horizonte Fixo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Horizonte Fixo".
    end.            
             
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CriaTTExportaItemFamiliaAnt DBOProgram 
PROCEDURE CriaTTExportaItemFamiliaAnt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param table for ttExpFields.
    def output param table for ttItem.

    find first ttExpFields.
    
    find familia where
         rowid(familia) = ttExpFields.r-rowid no-lock.
    
    for each item where
             item.fm-codigo = familia.fm-codigo no-lock:
                     
        create ttItem.
        assign ttItem.it-codigo = item.it-codigo
               ttItem.rw-item   = rowid(item).
        
        &IF DEFINED (bf_man_integra_aps) &THEN
        
            if  item.politica-aps =  familia.politica-aps 
            and item.politica-aps <> ttExpFields.politica-aps then
                assign ttItem.diferencas = "Politica".
                 
            if (ttExpFields.politica-aps = 2 and item.politica-aps <> 2) 
            or (ttExpFields.politica-aps = 2 and item.politica-aps  = 2 
            and item.geracao-ordem       = familia.geracao-ordem 
            and item.geracao-ordem      <> ttExpFields.geracao-ordem) then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Geraá∆o de Ordem".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Geraá∆o de Ordem".
            
            if  item.cons-produto  = familia.cons-produto 
            and item.cons-produto <> ttExpFields.cons-produto then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Item como Produto".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Item como Produto".
                    
            if  item.cons-saldo =  familia.cons-saldo 
            and item.cons-saldo <> ttExpFields.cons-saldo then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Saldo Estoque".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Saldo Estoque".
                    
            if  item.mp-restrit =  familia.mp-restrit 
            and item.mp-restrit <> ttExpFields.mp-restrit then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "MatÇria Prima Restritiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", MatÇria Prima Restritiva".    
                    
            if  ttExpFields.politica-aps = 4 
            and item.qtde-fixa           = familia.qtde-fixa 
            and item.qtde-fixa          <> ttExpFields.qtde-fixa then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade Fixa".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Fixa".
    
            if (ttExpFields.politica-aps = 6  
            or  ttExpFields.politica-aps = 7) 
            and item.lote-repos          = familia.lote-repos
            and item.lote-repos         <> ttExpFields.lote-repos then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Lote Reposiá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Lote Reposiá∆o".
        
            if  item.qtde-max  = familia.qtde-max
            and item.qtde-max <> ttExpFields.qtde-max then 
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade M†xima".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade M†xima".    
            
            if  item.cons-consumo  = familia.cons-consumo
            and item.cons-consumo <> ttExpFields.cons-consumo then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Consumo de Previs∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Consumo de Previs∆o".    
            
            if  item.cod-malha  = familia.cod-malha 
            and item.cod-malha <> ttExpFields.cod-malha then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Malha Produtiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Malha Produtiva".    
                    
            if  item.cod-pulmao  = familia.cod-pulmao 
            and item.cod-pulmao <> ttExpFields.cod-pulmao then
                if  ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Pulm∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Pulm∆o".

        &ELSE
        
            if substring(item.char-1,60,2) =  substring(familia.char-1,60,2) and 
               substring(item.char-1,60,2) <> substring(ttExpFields.char-1,60,2) then
                assign ttItem.diferencas = "Politica".

            if (substring(ttExpFields.char-1,60,2) =  "02" and
                substring(item.char-1,60,2)        <> "02") or
               (substring(ttExpFields.char-1,60,2) =  "02" and
                substring(item.char-1,60,2)        =  "02" and
                substring(item.char-1,62,1)        =  substring(familia.char-1,62,1) and
                substring(item.char-1,62,1)        <> substring(ttExpFields.char-1,62,1)) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Geraá∆o de Ordem".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Geraá∆o de Ordem".
            
            if substring(item.char-1,63,1) =  substring(familia.char-1,63,1) and
               substring(item.char-1,63,1) <> substring(ttExpFields.char-1,63,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Item como Produto".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Item como Produto".
                    
            if substring(item.char-1,64,1) =  substring(familia.char-1,64,1) and
               substring(item.char-1,64,1) <> substring(ttExpFields.char-1,64,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Saldo Estoque".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Saldo Estoque".
                    
            if substring(item.char-1,65,1) =  substring(familia.char-1,65,1) and
               substring(item.char-1,65,1) <> substring(ttExpFields.char-1,65,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "MatÇria Prima Restritiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", MatÇria Prima Restritiva".    
                    
            if substring(ttExpFields.char-1,60,2) =  "04" and
               substring(item.char-1,66,11)       =  substring(familia.char-1,66,11) and
               substring(item.char-1,66,11)       <> substring(ttExpFields.char-1,66,11) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade Fixa".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Fixa".
    
            if (substring(ttExpFields.char-1,60,2) =  "06"  or
                substring(ttExpFields.char-1,60,2) =  "07") and  
                substring(item.char-1,66,11)       =  substring(familia.char-1,66,11) and
                substring(item.char-1,66,11)       <> substring(ttExpFields.char-1,66,11) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Lote Reposiá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Lote Reposiá∆o".
        
            if substring(item.char-1,117,11) =  substring(familia.char-1,117,11) and
               substring(item.char-1,117,11) <> substring(ttExpFields.char-1,117,11) then 
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Quantidade M†xima".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Quantidade M†xima".    
            
            if substring(item.char-1,77,1) =  substring(familia.char-1,77,1) and
               substring(item.char-1,77,1) <> substring(ttExpFields.char-1,77,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Consumo de Previs∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Consumo de Previs∆o".    
            
            if substring(item.char-1,78,5) =  substring(familia.char-1,78,5) and
               substring(item.char-1,78,5) <> substring(ttExpFields.char-1,78,5) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Malha Produtiva".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Malha Produtiva".    
                    
            if substring(item.char-1,83,5) =  substring(familia.char-1,83,5) and
               substring(item.char-1,83,5) <> substring(ttExpFields.char-1,83,5) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Pulm∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Pulm∆o".
                    
            if substring(item.char-1,95,5) =  substring(familia.char-1,95,5) and
               substring(item.char-1,95,5) <> substring(ttExpFields.char-1,95,5) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "C¢digo Tempo Processo".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", C¢digo Tempo Processo".

            if substring(item.char-1,128,1) =  substring(familia.char-1,128,1) and
               substring(item.char-1,128,1) <> substring(ttExpFields.char-1,128,1) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Considera Taxa de Produá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Considera Taxa de Produá∆o".
            
            if int(substring(item.char-1,129,3)) =  int(substring(familia.char-1,129,3)) and
               int(substring(item.char-1,129,3)) <> int(substring(ttExpFields.char-1,129,3)) then
                if ttItem.diferencas = "" then
                    assign ttItem.diferencas = "Per°odo Fixo Exportaá∆o".
                else
                    assign ttItem.diferencas = ttItem.diferencas + ", Per°odo Fixo Exportaá∆o".
        &ENDIF
        
        if substring(item.char-1,149,5) =  substring(familia.char-1,149,5) and
           substring(item.char-1,149,5) <> substring(ttExpFields.char-1,149,5) then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "CritÇrio de Agrupamento".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", CritÇrio de Agrupamento".

        if int(substring(item.char-1,154,3)) =  int(substring(familia.char-1,154,3)) and
           int(substring(item.char-1,154,3)) <> int(substring(ttExpFields.char-1,154,3)) then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Horizonte de Agrupamento".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Horizonte de Agrupamento".


        if item.demanda =  familia.demanda and
           item.demanda <> ttExpFields.demanda then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Demanda".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Demanda".
                
        if item.tipo-est-seg =  familia.tipo-est-seg and
           item.tipo-est-seg <> ttExpFields.tipo-est-seg then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Tipo Estoque Segur".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Tipo Estoque Segur".

        if item.div-ordem =  familia.div-ordem and
           item.div-ordem <> ttExpFields.div-ordem then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Divis∆o de Ordens".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Divis∆o de Ordens".

        if item.periodo-fixo =  familia.periodo-fixo and
           item.periodo-fixo <> ttExpFields.periodo-fixo then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Per°odo Fixo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Per°odo Fixo".

        if item.fator-refugo =  familia.fator-refugo and
           item.fator-refugo <> ttExpFields.fator-refugo then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Fator de Refugo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Fator de Refugo".

        if item.quant-perda =  familia.quant-perda and
           item.quant-perda <> ttExpFields.quant-perda then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Quantidade de Perda".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Quantidade de Perda".

        if item.lote-multipl =  familia.lote-multipl and
           item.lote-multipl <> ttExpFields.lote-multipl then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Lote Multiplo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Lote Multiplo".

        if item.lote-minimo =  familia.lote-minimo and
           item.lote-minimo <> ttExpFields.lote-minimo then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Lote M°nimo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Lote M°nimo".

        if item.quant-segur =  familia.quant-segur and
           item.quant-segur <> ttExpFields.quant-segur then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Quantidade Seguranáa".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Quantidade Seguranáa".
                
        if item.tempo-segur =  familia.tempo-segur and
           item.tempo-segur <> ttExpFields.tempo-segur then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Tempo Seguranáa".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Tempo Seguranáa".

        if item.res-int-comp =  familia.res-int-comp and
           item.res-int-comp <> ttExpFields.res-int-comp then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Compra".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Compra".

        if item.res-for-comp =  familia.res-for-comp and
           item.res-for-comp <> ttExpFields.res-for-comp then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Fornecedor".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Fornecedor".

        if item.res-cq-comp =  familia.res-cq-comp and
           item.res-cq-comp <> ttExpFields.res-cq-comp then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento CQ de Compra".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento CQ de Compra".

        if item.ressup-fabri =  familia.ressup-fabri and
           item.ressup-fabri <> ttExpFields.ressup-fabri then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento de Fabricaá∆o".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento de Fabricaá∆o".

        if item.res-cq-fabri =  familia.res-cq-fabri and
           item.res-cq-fabri <> ttExpFields.res-cq-fabri then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Ressuprimento CQ de Fabricaá∆o".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Ressuprimento CQ de Fabricaá∆o".

        if item.horiz-fixo =  familia.horiz-fixo and
           item.horiz-fixo <> ttExpFields.horiz-fixo then
            if ttItem.diferencas = "" then
                assign ttItem.diferencas = "Horizonte Fixo".
            else
                assign ttItem.diferencas = ttItem.diferencas + ", Horizonte Fixo".
    end.
             
RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportaItemFamilia DBOProgram 
PROCEDURE ExportaItemFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for ttExpFields.
    def input param table for ttItem.
    
    def var iCont as int no-undo.
    
    find first ttExpFields.
    
    for each ttItem,
        first item where
              rowid(item) = ttItem.rw-item:
                   
        do iCont = 1 to num-entries(ttItem.diferencas):
        
            case trim(entry(iCont,ttItem.diferencas)):
                
                &IF DEFINED (bf_man_integra_aps) &THEN

                    when "Politica" then do:
                        if  ttExpFields.politica-aps = 9 then
                            assign item.politica = 5.
    
                        assign item.politica-aps = ttExpFields.politica-aps.                    
                    end.
                    
                    when "Geraá∆o de Ordem" then
                        assign item.geracao-ordem = ttExpFields.geracao-ordem.
        
                    when "Considera item como Produto" then
                        assign item.cons-produto = ttExpFields.cons-produto.
                    
                    when "Considera Saldo Estoque" then
                        assign item.cons-saldo = ttExpFields.cons-saldo.
            
                    when "MatÇria Prima Restritiva" then
                        assign item.mp-restrit = ttExpFields.mp-restrit.
            
                    when "Quantidade Fixa" then
                        assign item.qtde-fixa = ttExpFields.qtde-fixa.
                    
                    when "Lote Reposiá∆o" then
                        assign item.lote-repos = ttExpFields.lote-repos.
                    
                    when "Quantidade M†xima" then
                        assign item.qtde-max = ttExpFields.qtde-max.
                    
                    when "Consumo de Previs∆o" then
                        assign item.cons-consumo = ttExpFields.cons-consumo.
                    
                    when "Malha Produtiva" then
                        assign item.cod-malha = ttExpFields.cod-malha.
                    
                    when "Pulm∆o" then
                        assign item.cod-pulmao = ttExpFields.cod-pulmao.
                        
                &ELSE

                    when "Politica" then do:
                        if substring(ttExpFields.char-1,60,2) = "09" then
                            assign item.politica = 5.
    
                        assign substring(item.char-1,60,2) = substring(ttExpFields.char-1,60,2).                    
                    end.
                    
                    when "Geraá∆o de Ordem" then
                        assign substring(item.char-1,62,1) = substring(ttExpFields.char-1,62,1).
        
                    when "Considera item como Produto" then
                        assign substring(item.char-1,63,1) = substring(ttExpFields.char-1,63,1).
                    
                    when "Considera Saldo Estoque" then
                        assign substring(item.char-1,64,1) = substring(ttExpFields.char-1,64,1).
            
                    when "MatÇria Prima Restritiva" then
                        assign substring(item.char-1,65,1) = substring(ttExpFields.char-1,65,1).
            
                    when "Quantidade Fixa" then
                        assign substring(item.char-1,66,11) = substring(ttExpFields.char-1,66,11).
                    
                    when "Lote Reposiá∆o" then
                        assign substring(item.char-1,66,11) = substring(ttExpFields.char-1,66,11).
                    
                    when "Quantidade M†xima" then
                        assign substring(item.char-1,117,11) = substring(ttExpFields.char-1,117,11).
                    
                    when "Consumo de Previs∆o" then
                        assign substring(item.char-1,77,1) = substring(ttExpFields.char-1,77,1).
                    
                    when "Malha Produtiva" then
                        assign substring(item.char-1,78,5) = substring(ttExpFields.char-1,78,5).
                    
                    when "Pulm∆o" then
                        assign substring(item.char-1,83,5) = substring(ttExpFields.char-1,83,5).

                    when "Considera Taxa de Produá∆o" then
                        assign substring(item.char-1,128,1) = substring(ttExpFields.char-1,128,1).

                    when "Per°odo Fixo Exportaá∆o" then
                        assign substring(item.char-1,129,3) = substring(ttExpFields.char-1,129,3).
                        
                &ENDIF

                when "CritÇrio Agrupamento" then
                    assign substring(item.char-1,149,5) = substring(ttExpFields.char-1,149,5).

                when "Horizonte Agrupamento" then
                    assign substring(item.char-1,154,3) = substring(ttExpFields.char-1,154,3).

                when "Demanda" then
                    assign item.demanda = ttExpFields.demanda.
                    
                when "Tipo Estoque Segur" then
                    assign item.tipo-est-seg = ttExpFields.tipo-est-seg.

                when "Divis∆o de Ordens" then
                    assign item.div-ordem = ttExpFields.div-ordem.

                when "Per°odo Fixo" then
                    assign item.periodo-fixo = ttExpFields.periodo-fixo.

                when "Fator de Refugo" then
                    assign item.fator-refugo = ttExpFields.fator-refugo.

                when "Quantidade de Perda" then
                    assign item.quant-perda = ttExpFields.quant-perda.

                when "Lote Multiplo" then
                    assign item.lote-multipl = ttExpFields.lote-multipl.

                when "Lote M°nimo" then
                    assign item.lote-minimo = ttExpFields.lote-minimo.

                when "Quantidade Seguranáa" then
                    assign item.quant-segur = ttExpFields.quant-segur.
                    
                when "Tempo Seguranáa" then
                    assign item.tempo-segur = ttExpFields.tempo-segur.

                when "Ressuprimento de Compra" then
                    assign item.res-int-comp = ttExpFields.res-int-comp.

                when "Ressuprimento de Fornecedor" then
                    assign item.res-for-comp = ttExpFields.res-for-comp.

                when "Ressuprimento CQ de Compra" then
                    assign item.res-cq-comp = ttExpFields.res-cq-comp.

                when "Ressuprimento de Fabricaá∆o" then
                    assign item.ressup-fabri = ttExpFields.ressup-fabri.

                when "Ressuprimento CQ de Fabricaá∆o" then
                    assign item.res-cq-fabri = ttExpFields.res-cq-fabri.

                when "Horizonte Fixo" then
                    assign item.horiz-fixo = ttExpFields.horiz-fixo.

            end case.
        end.
    end.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pcItCodigo as char no-undo.
    def output parameter pcReturn  as char no-undo.
    
    run openQueryStatic ("Main":U).
    
    run goToKey (pcItCodigo).
    if return-value = "OK" then assign pcreturn = "".  /* esse Ç o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa Ç a mensagem esperada nas interfaces 1.1  qdo n∆o acha o registro */
    end.
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
        WHEN "cd-folh-item":U THEN ASSIGN pFieldValue = RowObject.cd-folh-item.
        WHEN "cd-folh-lote":U THEN ASSIGN pFieldValue = RowObject.cd-folh-lote.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "cd-tag":U THEN ASSIGN pFieldValue = RowObject.cd-tag.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-auxiliar":U THEN ASSIGN pFieldValue = RowObject.cod-auxiliar.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-imagem":U THEN ASSIGN pFieldValue = RowObject.cod-imagem.
        WHEN "cod-lista-destino":U THEN ASSIGN pFieldValue = RowObject.cod-lista-destino.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-produto":U THEN ASSIGN pFieldValue = RowObject.cod-produto.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "codigo-refer":U THEN ASSIGN pFieldValue = RowObject.codigo-refer.
        WHEN "conta-aplicacao":U THEN ASSIGN pFieldValue = RowObject.conta-aplicacao.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "de-codigo-prin":U THEN ASSIGN pFieldValue = RowObject.de-codigo-prin.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "desc-inter":U THEN ASSIGN pFieldValue = RowObject.desc-inter.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "desc-nacional":U THEN ASSIGN pFieldValue = RowObject.desc-nacional.
        WHEN "descricao-1":U THEN ASSIGN pFieldValue = RowObject.descricao-1.
        WHEN "descricao-2":U THEN ASSIGN pFieldValue = RowObject.descricao-2.
        WHEN "fm-cod-com":U THEN ASSIGN pFieldValue = RowObject.fm-cod-com.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "inform-compl":U THEN ASSIGN pFieldValue = RowObject.inform-compl.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-demanda":U THEN ASSIGN pFieldValue = RowObject.it-demanda.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "niv-rest-fora":U THEN ASSIGN pFieldValue = RowObject.niv-rest-fora.
        WHEN "niv-rest-icms":U THEN ASSIGN pFieldValue = RowObject.niv-rest-icms.
        WHEN "path":U THEN ASSIGN pFieldValue = RowObject.path.
        WHEN "prefixo-lote":U THEN ASSIGN pFieldValue = RowObject.prefixo-lote.
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
      &IF DEFINED (bf_man_205) &THEN
      &ELSE
        WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
        WHEN "rv-codigo":U THEN ASSIGN pFieldValue = RowObject.rv-codigo.
      &ENDIF
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "usuario-obsol":U THEN ASSIGN pFieldValue = RowObject.usuario-obsol.
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
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-implant":U THEN ASSIGN pFieldValue = RowObject.data-implant.
        WHEN "data-liberac":U THEN ASSIGN pFieldValue = RowObject.data-liberac.
        WHEN "data-obsol":U THEN ASSIGN pFieldValue = RowObject.data-obsol.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
        WHEN "dt-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.dt-pr-fisc.
        WHEN "dt-ult-ben":U THEN ASSIGN pFieldValue = RowObject.dt-ult-ben.
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
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-ISS":U THEN ASSIGN pFieldValue = RowObject.aliquota-ISS.
        WHEN "altura":U THEN ASSIGN pFieldValue = RowObject.altura.
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        WHEN "comprim":U THEN ASSIGN pFieldValue = RowObject.comprim.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "fator-reaj-icms":U THEN ASSIGN pFieldValue = RowObject.fator-reaj-icms.
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "ft-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.ft-conv-fmcoml.
        WHEN "ft-conversao":U THEN ASSIGN pFieldValue = RowObject.ft-conversao.
        WHEN "largura":U THEN ASSIGN pFieldValue = RowObject.largura.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-mulven":U THEN ASSIGN pFieldValue = RowObject.lote-mulven.
        WHEN "per-min-luc":U THEN ASSIGN pFieldValue = RowObject.per-min-luc.
        WHEN "per-rest-fora":U THEN ASSIGN pFieldValue = RowObject.per-rest-fora.
        WHEN "per-rest-icms":U THEN ASSIGN pFieldValue = RowObject.per-rest-icms.
        WHEN "perc-demanda":U THEN ASSIGN pFieldValue = RowObject.perc-demanda.
        WHEN "perc-nqa":U THEN ASSIGN pFieldValue = RowObject.perc-nqa.
        WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "pr-sem-tx":U THEN ASSIGN pFieldValue = RowObject.pr-sem-tx.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "qt-var-max":U THEN ASSIGN pFieldValue = RowObject.qt-var-max.
        WHEN "qt-var-min":U THEN ASSIGN pFieldValue = RowObject.qt-var-min.
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-pacote":U THEN ASSIGN pFieldValue = RowObject.quant-pacote.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "tp-cons-prev":U THEN ASSIGN pFieldValue = RowObject.tp-cons-prev.
        WHEN "tx-importacao":U THEN ASSIGN pFieldValue = RowObject.tx-importacao.
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
        WHEN "valor-ipi-beb":U THEN ASSIGN pFieldValue = RowObject.valor-ipi-beb.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-req-maior":U THEN ASSIGN pFieldValue = RowObject.var-req-maior.
        WHEN "var-req-menor":U THEN ASSIGN pFieldValue = RowObject.var-req-menor.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
        WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
        WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
        WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "calc-cons-prev":U THEN ASSIGN pFieldValue = RowObject.calc-cons-prev.
        WHEN "calc-lead-time":U THEN ASSIGN pFieldValue = RowObject.calc-lead-time.
        WHEN "capac-recip-beb":U THEN ASSIGN pFieldValue = RowObject.capac-recip-beb.
        WHEN "cd-formula":U THEN ASSIGN pFieldValue = RowObject.cd-formula.
        WHEN "cd-origem":U THEN ASSIGN pFieldValue = RowObject.cd-origem.
        WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
        WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
        WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "cod-servico":U THEN ASSIGN pFieldValue = RowObject.cod-servico.
        WHEN "cod-tax":U THEN ASSIGN pFieldValue = RowObject.cod-tax.
        WHEN "cod-tax-serv":U THEN ASSIGN pFieldValue = RowObject.cod-tax-serv.
        WHEN "codigo-orig":U THEN ASSIGN pFieldValue = RowObject.codigo-orig.
        WHEN "compr-fabric":U THEN ASSIGN pFieldValue = RowObject.compr-fabric.
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "dec-conv-fmcoml":U THEN ASSIGN pFieldValue = RowObject.dec-conv-fmcoml.
        WHEN "dec-ftcon":U THEN ASSIGN pFieldValue = RowObject.dec-ftcon.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
        WHEN "enquad-beb":U THEN ASSIGN pFieldValue = RowObject.enquad-beb.
        WHEN "esp-beb":U THEN ASSIGN pFieldValue = RowObject.esp-beb.
        WHEN "fase-medio":U THEN ASSIGN pFieldValue = RowObject.fase-medio.
        WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
        WHEN "ind-imp-desc":U THEN ASSIGN pFieldValue = RowObject.ind-imp-desc.
        WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
      /*  WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.   ---> campo ems203 */
        WHEN "ind-serv-mat":U THEN ASSIGN pFieldValue = RowObject.ind-serv-mat.
        WHEN "INT-1":U THEN ASSIGN pFieldValue = RowObject.INT-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "isencao-import":U THEN ASSIGN pFieldValue = RowObject.isencao-import.
        WHEN "moeda-padrao":U THEN ASSIGN pFieldValue = RowObject.moeda-padrao.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "niv-mais-bai":U THEN ASSIGN pFieldValue = RowObject.niv-mais-bai.
        WHEN "niv-mps":U THEN ASSIGN pFieldValue = RowObject.niv-mps.
        WHEN "nivel":U THEN ASSIGN pFieldValue = RowObject.nivel.
        WHEN "nivel-apr-compra":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-compra.
        WHEN "nivel-apr-manut":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-manut.
        WHEN "nivel-apr-requis":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-requis.
        WHEN "nivel-apr-solic":U THEN ASSIGN pFieldValue = RowObject.nivel-apr-solic.
        WHEN "nr-item-dcr":U THEN ASSIGN pFieldValue = RowObject.nr-item-dcr.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-pontos-quotas":U THEN ASSIGN pFieldValue = RowObject.nr-pontos-quotas.
        WHEN "Nr-ult-peca":U THEN ASSIGN pFieldValue = RowObject.Nr-ult-peca.
        /*WHEN "num-id-item":U THEN ASSIGN pFieldValue = RowObject.num-id-item.---> campo ems203 */
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "resumo-mp":U THEN ASSIGN pFieldValue = RowObject.resumo-mp.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-atp.
        WHEN "tipo-con-est":U THEN ASSIGN pFieldValue = RowObject.tipo-con-est.
        WHEN "tipo-contr":U THEN ASSIGN pFieldValue = RowObject.tipo-contr.
        WHEN "tipo-desc-nt":U THEN ASSIGN pFieldValue = RowObject.tipo-desc-nt.
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-insp":U THEN ASSIGN pFieldValue = RowObject.tipo-insp.
        WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
        WHEN "tipo-recip-beb":U THEN ASSIGN pFieldValue = RowObject.tipo-recip-beb.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
        WHEN "tp-adm-lote":U THEN ASSIGN pFieldValue = RowObject.tp-adm-lote.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-desp-padrao":U THEN ASSIGN pFieldValue = RowObject.tp-desp-padrao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    
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
        WHEN "alt-refer":U THEN ASSIGN pFieldValue = RowObject.alt-refer.
        WHEN "atu-conf":U THEN ASSIGN pFieldValue = RowObject.atu-conf.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "fraciona":U THEN ASSIGN pFieldValue = RowObject.fraciona.
        WHEN "id-grade":U THEN ASSIGN pFieldValue = RowObject.id-grade.
        WHEN "incentivado":U THEN ASSIGN pFieldValue = RowObject.incentivado.
        WHEN "ind-backorder":U THEN ASSIGN pFieldValue = RowObject.ind-backorder.
        WHEN "ind-confprodcom":U THEN ASSIGN pFieldValue = RowObject.ind-confprodcom.
        WHEN "ind-especifico":U THEN ASSIGN pFieldValue = RowObject.ind-especifico.
        WHEN "ind-inf-qtf":U THEN ASSIGN pFieldValue = RowObject.ind-inf-qtf.
        WHEN "ind-ipi-dife":U THEN ASSIGN pFieldValue = RowObject.ind-ipi-dife.
        WHEN "ind-item-fat":U THEN ASSIGN pFieldValue = RowObject.ind-item-fat.
        WHEN "ind-quotas":U THEN ASSIGN pFieldValue = RowObject.ind-quotas.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
        WHEN "log-carac-tec":U THEN ASSIGN pFieldValue = RowObject.log-carac-tec.
        WHEN "log-utiliza-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.log-utiliza-batch-padrao.
        WHEN "pm-ja-calc":U THEN ASSIGN pFieldValue = RowObject.pm-ja-calc.
        WHEN "rot-quant":U THEN ASSIGN pFieldValue = RowObject.rot-quant.
        WHEN "rot-refer":U THEN ASSIGN pFieldValue = RowObject.rot-refer.
        WHEN "rot-revis":U THEN ASSIGN pFieldValue = RowObject.rot-revis.
        WHEN "tp-lote-econom":U THEN ASSIGN pFieldValue = RowObject.tp-lote-econom.
        WHEN "tp-lote-minimo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-minimo.
        WHEN "tp-lote-multiplo":U THEN ASSIGN pFieldValue = RowObject.tp-lote-multiplo.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo it-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item.it-codigo NO-UNDO.

    FIND FIRST bfitem WHERE 
        bfitem.it-codigo = pit-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaItem DBOProgram 
PROCEDURE openQueryFaixaItem :
/*------------------------------------------------------------------------------
  Purpose: wz03in172.p    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tablename}.it-codigo >= cItCodigoIni
           and {&tablename}.it-codigo <= cItCodigoFim
           use-index codigo NO-LOCK INDEXED-REPOSITION.
   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroFamilia DBOProgram 
PROCEDURE openQueryFiltroFamilia :
/*------------------------------------------------------------------------------
  Purpose:   Busca conjunto de registros da tabela item dentro de uma faixa
             de famÌlia inicial e final.  
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK WHERE 
                                         {&TABLENAME}.fm-codigo >= cFamilIni AND
                                         {&TABLENAME}.fm-codigo <= cFamilFim 
                                          USE-INDEX codigo.
        RETURN "OK":U.
    &endif
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

  open query qr{&tableName} for each {&tableName} 
       no-lock
       indexed-reposition.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroFamilia DBOProgram 
PROCEDURE setConstraintFiltroFamilia :
/*------------------------------------------------------------------------------
  Purpose:   Seta as vari·veis de controle para queries contendo a famÌlia
             inicial e final.  
  Parameters: ipar1:pfamilia-ini:FamÌlia Inicial
              ipar2:pfamilia-fim:FamÌlia Final 
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then     
    &else
        def input param pfamilia-ini as char no-undo.
        def input param pfamilia-fim as char no-undo.
        
        assign cFamilIni = pfamilia-ini
               cFamilFim = pfamilia-fim.
               
        RETURN "OK":U.
    &endif   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose: wz03in172.p    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcItCodigoIni as char no-undo.
def input param pcItCodigoFim as char no-undo.

    assign cItCodigoIni = pcItCodigoIni
           cItCodigoFim = pcItCodigoFim.
           
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


