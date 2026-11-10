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
{include/i-prgvrs.i BOIN168MAN 2.00.00.083 } /*** "010083" 29/10/2024 16:45:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin168man MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName it-requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName it-requisicao
&GLOBAL-DEFINE TableLabel it-requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin168.i RowObject}

{include/i-epc200.i boin168}
{include/i_dbvers.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmnt.i} /** Pr‚-processadores da Manuten‡Æo  **/
{cdp/cdcfgmat.i} /* Mudan‡a de base */
{cdp/cdcfgdis.i} /* Defini‡Æo dos pr‚-processadores que diferenciam releases*/
{cdp/cd0669.i} /*tt-erro*/
{cdp/cd9911.i} /*Unidade de Nerg¢cio*/ 

DEFINE TEMP-TABLE tt-erro-mla NO-UNDO
    FIELD i-sequen AS INTEGER
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER FORMAT "x(255)".

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER b-{&TableName} FOR {&TableName}.

/**************Defini‡Æo das variaveis *****************/
    def var i-nr-requisicao       LIKE requisicao.nr-requisicao init 0 no-undo. 
    def var i-requis-ini          LIKE requisicao.nr-requisicao init 0 no-undo.
    def var i-requis-fin          LIKE requisicao.nr-requisicao init 999999999 no-undo.
    def var r-chave-it-requisicao as rowid no-undo.
    def var inum-ordem            as int   no-undo.
    def var ccod-comprado         as char  no-undo.
    def var depreco               as dec   no-undo.
    def var l-retorno             as logical no-undo.
    def var l-ScCodigo            as logical no-undo.
    def var c-cod-utiliz-aux      as char no-undo.
    def var i-moeda-req           as int no-undo.
    def var de-limite-req         as dec no-undo.
    def var de-solic              as dec no-undo.
    def var de-total-req          as dec no-undo.
    def var i-moeda-solic         as dec no-undo.
    def var de-tot-solic          as dec no-undo.
    def var i-tipo-doc            as int   no-undo.
    def var i-tipo-trans          as int   no-undo.
    def var de-preco-u            as dec   no-undo.
    def var r-requisicao          as rowid no-undo.
    def var de-sal-ant            as dec   no-undo.
    def var r-item-re             as rowid no-undo.
    def var l-pendente            as log   no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    def var i-ep-codigo-usuario   LIKE empresa.ep-codigo   no-undo.
&ELSE
    def var i-ep-codigo-usuario   as int   no-undo.
&ENDIF
    def var l-achou               as log   no-undo.
    def var c-sc-codigo           as char  no-undo.
    def var c-ct-codigo           as char  no-undo.    
    def var l-classif             as log   no-undo.
    def var i-nat-desp            as int   no-undo.
    def var c-param               as char  no-undo.
    def var i-tp-ressup           as int   no-undo.
    def var c-cod-utiliz          as char  no-undo.
    def var l-deb-direto          as log   no-undo.
    def var l-retorno-aprov       as log   no-undo.
    def var i-seq                 as int   no-undo.
    def var i-moeda-lim           as int   no-undo.
    def var i-tipo-moeda          as int   no-undo.
    def var de-valor-doc          as dec   no-undo.
    def var de-valor-lim          as dec   no-undo.
    def var c-tipo-moeda          as char  no-undo.
    def var c-moeda-lim           as char  no-undo.    
    def var c-lista-prioridade    as char  no-undo.
    def var c-cod-estabel         as char  no-undo.
    def var irequisicao           as int   no-undo.
    def var isequencia            as int   no-undo.
    def var lAprovacaoItem        as log init yes no-undo.
    def var cPrograma             as char init "":U no-undo.
    def var iEmpresa              like param-global.empresa-prin no-undo. 
    def var de-valor-item         as dec   no-undo.
    def var de-valor-total        as dec   no-undo.
    def var i-estoque             as integer   no-undo.
    def var ind                   as integer   no-undo.

    {cdp/cdunif001.i}
    

    DEFINE VARIABLE l-retorno-aed AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iNrOrdProdu   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lOrdemMMV     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE h-bomn250     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hcdapi024     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-bofr134     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-bofr072     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-bomn134     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-mlaapi010a  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-mlaapi010b  AS HANDLE     NO-UNDO.

    def new global shared var gl-proxima-aprovacao  as logical no-undo.
    def new global shared var gi-proxima-prioridade as integer no-undo.
    def new global shared var c-seg-usuario as char format "x(12)" no-undo.

    DEFINE TEMP-TABLE tt-it-requisicao-dest NO-UNDO LIKE it-requisicao
           field nr-requis-orig LIKE requisicao.nr-requisicao
           field seq-requis-orig as integer
           field r-rowid as rowid.

    DEFINE TEMP-TABLE tt-unid-neg-requis NO-UNDO LIKE unid-neg-requis.

    def temp-table tt-erro-invest no-undo
        field i-sequen  as int             
        field cd-erro   as int
        field mensagem  as char format "x(255)"
        field c-param   as char .

    

/** Vari vel para Execu‡Æo Or‡ament ria **/
DEFINE VARIABLE l-exec-api-mi           AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-exec-api-mmv          AS LOGICAL     NO-UNDO.
DEFINE VARIABLE r-rowid-anterior        AS ROWID       NO-UNDO.
&IF DEFINED (bf_mnt_ems206b) &THEN
{cdp/cd1008.i}
&ENDIF

run cdp/cd9902.p (input 3).
IF  RETURN-VALUE = "OK":U THEN DO:
    {cdp/cd1008.i1} /* Manuten‡Æo Mecƒnica */
END.
    

DEFINE NEW GLOBAL SHARED VARIABLE l-cd0738    AS LOG NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-cd0744b   AS LOG NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-miapi103a AS LOG NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-miapi103b AS LOG NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN

    def  temp-table tt-erro-aux no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)".
        



    DEF TEMP-TABLE tt-matriz-om NO-UNDO LIKE unid-negoc-om 
        FIELD r-Rowid AS ROWID.    
        {cdp/cd9590.i} 


    DEFINE TEMP-TABLE tt-matriz-om-mv NO-UNDO
        FIELD nr-ord-produ        AS INTEGER             
        FIELD cod-unid-negoc      AS CHARACTER FORMAT "x(003)"
        FIELD val-perc-unid-negoc AS DECIMAL.

&endif

DEFINE VARIABLE cNomeAbrevNovo AS CHARACTER INITIAL "" NO-UNDO.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 22.5
         WIDTH              = 55.
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


{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.
find first param-compra no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addItemRequisTarget DBOProgram 
PROCEDURE addItemRequisTarget :
/*------------------------------------------------------------------------------
  Purpose: Adicionar item na temp-table tt-it-requisicao-dest
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-it-codigo           LIKE it-requisicao.it-codigo     NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao       LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER c-cod-estabel         LIKE requisicao.cod-estabel      NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao-dest  LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER i-incremento-seq      LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT PARAMETER da-nova-entrega       LIKE it-requisicao.dt-entrega    NO-UNDO.
DEFINE INPUT PARAMETER i-sequencia           LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT PARAMETER l-adiciona-tempo        AS LOGICAL                     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-it-requisicao-dest.

DEFINE VARIABLE i-new-seq AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-seq-ant AS INTEGER    NO-UNDO.

find last it-requisicao
    where it-requisicao.nr-requisicao = i-nr-requisicao-dest
    no-lock no-error.
if avail it-requisicao then do:
    if (it-requisicao.sequencia + i-incremento-seq) > 999 then do:
        assign i-seq-ant = 1.
        repeat:
            if not can-find(it-requisicao
                        where it-requisicao.nr-requisicao = i-nr-requisicao-dest
                          and it-requisicao.sequencia     = i-seq-ant) then do:
                if not can-find(tt-it-requisicao-dest
                        where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                    leave.
                end.
            end.
            assign i-seq-ant = i-seq-ant + 1.
        end.
        assign i-new-seq = i-seq-ant.
    end.
    else do:
        find last tt-it-requisicao-dest no-error.
        if avail tt-it-requisicao-dest then do:
            if (tt-it-requisicao-dest.sequencia + i-incremento-seq) > 999 then do:
                assign i-seq-ant = 1.
                repeat:
                    if not can-find(it-requisicao
                                where it-requisicao.nr-requisicao = i-nr-requisicao-dest
                                  and it-requisicao.sequencia     = i-seq-ant) then do:
                        if not can-find(tt-it-requisicao-dest
                                where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                            leave.
                        end.
                    end.
                    assign i-seq-ant = i-seq-ant + 1.
                end.
                assign i-new-seq = i-seq-ant.
            end.
            else do:
                assign i-new-seq = tt-it-requisicao-dest.sequencia + i-incremento-seq.
            end.
        end.
        else do:
            assign i-new-seq = it-requisicao.sequencia + i-incremento-seq.
        end.
    end.
end.
else do:
    find last tt-it-requisicao-dest no-error.
    if avail tt-it-requisicao-dest then do:
        if (tt-it-requisicao-dest.sequencia + i-incremento-seq) > 999 then do:
            assign i-seq-ant = 1.
            repeat:
                if not can-find(tt-it-requisicao-dest
                        where tt-it-requisicao-dest.sequencia = i-seq-ant) then do:
                    leave.
                end.
                assign i-seq-ant = i-seq-ant + 1.
            end.
            assign i-new-seq = i-seq-ant.
        end.
        else do:
            assign i-new-seq = tt-it-requisicao-dest.sequencia + i-incremento-seq.
        end.
    end.
    else do:
        assign i-new-seq = i-incremento-seq.
    end.
end.

if i-new-seq > 999 then
    return "NOK":U.

if l-adiciona-tempo then do:
    find first item-uni-estab
         where item-uni-estab.it-codigo   = c-it-codigo
           and item-uni-estab.cod-estabel = c-cod-estabel
         no-lock no-error.
    if avail item-uni-estab then
        assign da-nova-entrega = da-nova-entrega +
                                 item-uni-estab.res-int-comp + 
                                 item-uni-estab.res-for-comp.
end.

find it-requisicao 
    where it-requisicao.it-codigo     = c-it-codigo 
    and   it-requisicao.nr-requisicao = i-nr-requisicao
    and   it-requisicao.sequencia     = i-sequencia
    no-lock no-error.

if avail it-requisicao then do:
    create tt-it-requisicao-dest.
    buffer-copy it-requisicao except nr-requisicao sequencia qt-a-atender situacao to tt-it-requisicao-dest.
    assign tt-it-requisicao-dest.r-rowid              = rowid(it-requisicao)
           tt-it-requisicao-dest.nr-requis-orig       = it-requisicao.nr-requisicao
           tt-it-requisicao-dest.seq-requis-orig      = it-requisicao.sequencia
           tt-it-requisicao-dest.nr-requisicao        = i-nr-requisicao-dest
           tt-it-requisicao-dest.sequencia            = i-new-seq
           tt-it-requisicao-dest.dt-entrega           = da-nova-entrega
           tt-it-requisicao-dest.seq-planej           = 0
           tt-it-requisicao-dest.qt-a-atender         = tt-it-requisicao-dest.qt-requisitada
           tt-it-requisicao-dest.situacao             = 1
           overlay(tt-it-requisicao-dest.char-2,1,16) = fill(" ",16).
end.
else
    return "NOK":U.


return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterDeleteRecord DBOProgram 
PROCEDURE AfterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_mnt_ems206b) &THEN
        FIND FIRST ord-prod WHERE
                   ord-prod.nr-ord-produ = iNrOrdProdu NO-LOCK NO-ERROR.
        
        IF AVAIL ord-prod AND (ord-prod.origem = "MI" OR ord-prod.origem = "MV") AND l-unidade-negocio THEN DO: 
            FOR EACH  unid-neg-requis 
                WHERE unid-neg-requis.nr-requisicao = RowObject.nr-requisicao
                AND   unid-neg-requis.sequencia     = RowObject.sequencia
                AND   unid-neg-requis.it-codigo     = RowObject.it-codigo exclusive-lock:
                    DELETE unid-neg-requis.
            END.
        END.
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraCompradorEDepositoItRequisicao DBOProgram 
PROCEDURE alteraCompradorEDepositoItRequisicao :
/*------------------------------------------------------------------------------
  Purpose: Valida e altera o comprador e o dep¢sito das ordens selecionadas.  
  Parameters: 
             ipar1 : prItRequisicao : rowid do item da requisicao
             ipar2 : pcCodDepos     : c¢digo do dep¢sito 
             ipar3 : pcCodComprado  : c¢digo do comprador
             ipar4 : plCodDepos     : indica se o dep¢sito deverÿ ser alterado 
             ipar5 : plCodComprado  : indica se o comprador deverÿ ser alterado
             opar6 : rowErrors      : tabela de erros
  Notes:       
------------------------------------------------------------------------------*/

    def input  param prOrdemCompra  as rowid no-undo.
    def input  param pcCodDepos     as char  no-undo.
    def input  param pcCodComprado  as char  no-undo.
    def input  param plCodDepos     as log   no-undo.
    def input  param plCodComprado  as log   no-undo.
    def output param table for RowErrors.
    
    if plCodComprado then do:
        if  not can-find (comprador where comprador.cod-comprado = pcCodComprado)
        then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-comprador AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Comprador" *}
            ASSIGN c-lbl-liter-comprador = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-comprador"} 
        end. 
    end.
               
    if  plCodDepos then do:           
        if  not can-find(deposito where deposito.cod-depos = pcCodDepos)
        then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Deposito" *}
            ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="47"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-deposito"}
        end.     
    end.
   
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.  

    ELSE DO: 
        FOR EACH it-requisicao fields (cod-depos char-1)
            where rowid(it-requisicao) = prOrdemCompra EXCLUSIVE-LOCK:
            if plCodDepos then     
                assign it-requisicao.cod-depos  = pcCodDepos. 
            if plCodComprado then     
                assign substring(it-requisicao.char-1,2,12) = pcCodComprado.                
        END.    
    END.

    RETURN "OK". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atribuiPrecoDebitoNaoDireto DBOProgram 
PROCEDURE atribuiPrecoDebitoNaoDireto :
/*------------------------------------------------------------------------------
  Purpose:    Include.: CD1406A.i5 Objetivo: Validar campos a partir da narrativa.
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 
    DEFINE VARIABLE l-criou-item-estab AS LOGICAL NO-UNDO.
    
    ASSIGN l-criou-item-estab = NO.

    find first item-estab
        where item-estab.it-codigo   = RowObject.it-codigo
        and   item-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
        
    if  not avail item-estab then do:
        create item-estab.
        assign item-estab.it-codigo   = RowObject.it-codigo
               item-estab.cod-estabel = requisicao.cod-estabel.
        VALIDATE item-estab.
        FIND CURRENT item-estab NO-LOCK.               
        ASSIGN l-criou-item-estab = YES.               
    end.

    IF  l-criou-item-estab THEN DO:
        FOR FIRST item-estab
            WHERE item-estab.it-codigo   = RowObject.it-codigo
              AND item-estab.cod-estabel = requisicao.cod-estabel NO-LOCK:
        END.
    END.    

    &if  defined(bf_mat_custeio_item) &then
         find first estab-mat 
              where estab-mat.cod-estabel = item-estab.cod-estabel no-lock no-error.
    &endif
    
    find first estabelec
         where estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.
        
    if AVAIL item AND 
       (item.tipo-contr <> 4 or
      (item.it-codigo  <> " " and
       item.it-codigo  <> ?)) then do:
       if usuar-mater.tp-preco = 1 and item.tipo-contr <> 4 then do:
            &if  defined(bf_mat_custeio_item) &then
                if  avail estab-mat then do:
                    if  estab-mat.custo-contab = 1 then
                        assign de-preco-u = (item-estab.val-unit-mat-m[1]
                                             +  item-estab.val-unit-ggf-m[1]
                                             +  item-estab.val-unit-mob-m[1]).
                    else
                    if  estab-mat.custo-contab = 2 then
                        assign de-preco-u = (item-estab.val-unit-mat-o[1]
                                             +  item-estab.val-unit-ggf-o[1]
                                             +  item-estab.val-unit-mob-o[1]).
                end.            
            &else
                if  avail estabelec then do:
                    if  estabelec.custo-contab = 1 then
                        assign de-preco-u = (item-estab.val-unit-mat-m[1]
                                             +  item-estab.val-unit-ggf-m[1]
                                             +  item-estab.val-unit-mob-m[1]).
                    else
                    if  estabelec.custo-contab = 2 then
                        assign de-preco-u = (item-estab.val-unit-mat-o[1]
                                             +  item-estab.val-unit-ggf-o[1]
                                             +  item-estab.val-unit-mob-o[1]).
                    else
                    if  estabelec.custo-contab = 3 then
                        assign de-preco-u = (item-estab.val-unit-mat-p[1]
                                             +  item-estab.val-unit-ggf-p[1]
                                             +  item-estab.val-unit-mob-p[1]).
                end.
            &endif
            if  de-preco-u = 0 then do:
                assign de-preco-u = item.preco-ul-ent.        
                  if avail estabelec then do:
                    for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                        item-uni-estab.it-codigo   = item.it-codigo and
                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                    if avail item-uni-estab then    
                       assign de-preco-u = item-uni-estab.preco-ul-ent.
                  end.     
                if  de-preco-u <> 0 then do:
                    /* ‚ltima Entrada */
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="3168"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="''"}
                end.
                else do:
                    assign de-preco-u = item.preco-repos.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-repos.
                      end.     
                    if  de-preco-u <> 0 then do: /* Pre‡o Reposi‡Æo */
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="3169"
                                           &ErrorType="EMS"
                                           &ErrorSubType="INFORMATION"}
                    end.     
                    else do:
                        assign de-preco-u = item.preco-base.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-base.
                          end.     
                        if  de-preco-u <> 0 then do: /* Pre‡o Base */
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3170"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"} 
                        end.     
                        else do:
                            assign de-preco-u = 1.
                            /* Valorizada a 1,00 */
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="8509"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"}     
                        end.
                    end.
                end.
            end.

       end.
       else do:
            if (usuar-mater.tp-preco = 2 and item.tipo-contr <> 4)
            or  item.tipo-contr       = 4  then do:
                assign de-preco-u = item.preco-base.
                  if avail estabelec then do:
                    for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                        item-uni-estab.it-codigo   = item.it-codigo and
                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                    if avail item-uni-estab then    
                       assign de-preco-u = item-uni-estab.preco-base.
                  end.     
                if  de-preco-u = 0 then do:
                    assign de-preco-u = item.preco-ul-ent.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-ul-ent.
                      end.     
                    if  de-preco-u <> 0 then do: /* ‚ltima Entrada */
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="3168"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"}   
                    end.                                     
                    else do:
                        assign de-preco-u = item.preco-repos.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-repos.
                          end.     
                        if  de-preco-u <> 0 then do:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3169"
                                               &ErrorType="EMS"
                                               &ErrorSubType="INFORMATION"}
                        end.                                     
                        else do:
                            assign de-preco-u = 1.
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="8509"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}
                        end.
                    end.
                end.
            end.
            else do:
                if (usuar-mater.tp-preco = 3 and item.tipo-contr <> 4)
                or  item.tipo-contr       = 4 then do:
                    assign de-preco-u = item.preco-repos.
                      if avail estabelec then do:
                        for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-u = item-uni-estab.preco-repos.
                      end.     
                    if  de-preco-u = 0 then do:
                        assign de-preco-u = item.preco-ul-ent.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-ul-ent.
                          end.     
                        if  de-preco-u <> 0 then do:
                            {method/svc/errors/inserr.i
                                               &ErrorNumber="3168"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR" 
                                               &ErrorParameters="''"}  
                        end.                                      
                        else do:
                            assign de-preco-u = item.preco-base.
                              if avail estabelec then do:
                                for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                    item-uni-estab.it-codigo   = item.it-codigo and
                                    item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                if avail item-uni-estab then    
                                   assign de-preco-u = item-uni-estab.preco-base.
                              end.     
                            if  de-preco-u <> 0 then do:
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="3170"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}
                            end.                                      
                            else do:
                                assign de-preco-u = 1.
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="8508"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="ERROR" 
                                                   &ErrorParameters="''"}  
                            end.
                        end.
                    end.
                end.
                else do:
                    if (usuar-mater.tp-preco = 4
                    and item.tipo-contr      <> 4)
                    or  item.tipo-contr       = 4 then do:
                        assign de-preco-u = item.preco-ul-ent.
                          if avail estabelec then do:
                            for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-u = item-uni-estab.preco-ul-ent.
                          end.     
                        if  de-preco-u = 0 then do:
                            assign de-preco-u = item.preco-repos.
                              if avail estabelec then do:
                                for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                                    item-uni-estab.it-codigo   = item.it-codigo and
                                    item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                if avail item-uni-estab then    
                                   assign de-preco-u = item-uni-estab.preco-repos.
                              end.     
                            if  de-preco-u <> 0 then do:
                                {method/svc/errors/inserr.i
                                                   &ErrorNumber="3169"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="INFORMATION"}
                            end.    
                            else do:
                                assign de-preco-u = item.preco-base.
                                  if avail estabelec then do:
                                    for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                        item-uni-estab.it-codigo   = item.it-codigo and
                                        item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock: end.
                                    if avail item-uni-estab then    
                                       assign de-preco-u = item-uni-estab.preco-base.
                                  end.     
                                if  de-preco-u <> 0 then do:
                                    {method/svc/errors/inserr.i
                                                       &ErrorNumber="3170"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR" 
                                                       &ErrorParameters="''"}
                                end.    
                                else do:
                                    assign de-preco-u = 1.
                                    {method/svc/errors/inserr.i
                                                       &ErrorNumber="8509"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR" 
                                                       &ErrorParameters="''"}
                                end.
                            end.
                        end.
                    end.
                     else do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="1627"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"}   
                    end.
                end.
            end.
       end.
    end.
    assign r-requisicao = rowid(requisicao).

    
/*    /*---------------------- chamada IN2201 --------------------
 *     if  param-global.modulo-in = yes then do:
 *         run inp/in2201.p (input  ROWID(rowobject),
 *                           output l-achou, output i-ct-codigo,
 *                           output i-sc-codigo).
 *         /*
 *         if  not l-achou
 *         and RowObject.num-ord-inv <> 0 then do:
 *             run utp/ut-msgs.p (input "show", input 7175, input "").
 *             apply 'entry' to RowObject.it-codigo in frame {&frame-name}.
 *             return 'adm-error'.
 *         end.
 *         */ /*****estÿ comentado no uib*******/*/
    
        find estabelec where estabelec.cod-estabel = 
             RowObject.cod-estabel no-lock no-error.
        
        assign RowObject.num-ord-inv 
               RowObject.ep-codigo = if param-global.modulo-in and 
                                         RowObject.num-ord-inv <> 0
                                         then if avail estabelec estabelec.ep-codigo
                                         else  param-global.empresa-prin.
    end.
    
/*    ----------------------- chamada IN2101 --------------------
 *     if  param-global.modulo-in
 *     and RowObject.num-ord-inv <> 0 then do:
 *         assign r-requisicao = rowid(requisicao)
 *                r-item-re    = rowid(RowObject).
 *         run inp/in2101.p (input r-requisicao, 
 *                           input r-item-re,
 *                           input c-opcao-aux).
 *     end.
 *     -----------------------------------------------------------*/*/
    /* fim include */

    return "OK". 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* API de Execu‡Æo Or‡ament ria com tratamento da Manuten‡Æo Industrial e Manuten‡Æo Mecƒnica */
IF  RowObject.qt-a-atender > 0 THEN DO:
    ASSIGN l-exec-api-mi  = NO
           l-exec-api-mmv = NO
           lOrdemMMV      = NO.
    IF  CAN-FIND (FIRST ord-manut WHERE ord-manut.nr-ord-produ = iNrOrdProdu NO-LOCK)
        AND l-integra-material THEN DO:
        ASSIGN l-exec-api-mi = YES.
        RUN cdp/cdapi282.p (input ?                     ,  /** rowid it-requisicao                           **/                          
                            INPUT TABLE rowobject       ,  /** registro alterado                             **/                            
                            INPUT 1                     ,  /** funcao: 1-BeforeCreateRecord Item-Requisicao  **/ 
                            INPUT iNrOrdProdu           ,  /** Nœmero da Ordem de Manuten»’o Industrial      **/
                            INPUT ?                     ,  /** Rowid do registro antes de alterar            **/
                            OUTPUT TABLE RowErrors      ). /** tt que retorna erro                           **/  
    END.
    run cdp/cd9902.p (input 3).
    IF  RETURN-VALUE = "OK":U THEN DO:
        IF NOT VALID-HANDLE(h-bofr072) THEN
            RUN frbo/bofr072.p PERSISTENT SET h-bofr072.
        
        RUN canFindOrdemMMV IN h-bofr072 (INPUT iNrOrdProdu,
                                          OUTPUT lOrdemMMV).    
        IF lOrdemMMV = YES THEN DO:
            IF l-integra-mat-mmv THEN DO:
                ASSIGN l-exec-api-mmv = YES.
                RUN cdp/cdapi282.p (input ?                     ,  /** rowid it-requisicao                           **/                          
                                    INPUT TABLE rowobject       ,  /** registro alterado                             **/                            
                                    INPUT 1                     ,  /** funcao: 1-BeforeCreateRecord Item-Requisicao  **/ 
                                    INPUT iNrOrdProdu           ,  /** N£mero da Ordem de Manuten‡Æo Mecƒnica        **/
                                    INPUT ?                     ,  /** Rowid do registro antes de alterar            **/
                                    OUTPUT TABLE RowErrors      ). /** tt que retorna erro                           **/  
            END.
        END.
        
        IF VALID-HANDLE(h-bofr072) THEN
            DELETE OBJECT h-bofr072.	
    END.
    IF NOT l-exec-api-mi AND NOT l-exec-api-mmv THEN DO:
        /** API de Execu»’o Or»amentÿria **/
        RUN cdp/cdapi193.p (input ?,                 /** rowid it-requisicao                           **/  
                            INPUT TABLE rowobject,   /** registro alterado                             **/  
                            INPUT 1,                 /** funcao: 1-BeforeCreateRecord Item-Requisicao  **/  
                            OUTPUT TABLE RowErrors). /** tt que retorna erro                           **/
    END. /** fim RowObject.qt-a-atender > 0 **/
END.

IF CAN-FIND(FIRST RowErrors
            WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
    RETURN "NOK":U.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* API de Execu»’o Or»amentÿria com tratamento da Manuten»’o Industrial  */
IF  RowObject.qt-a-atender >= 0 THEN DO:
    ASSIGN l-exec-api-mi  = NO
           l-exec-api-mmv = NO
           lOrdemMMV      = NO.
    IF  CAN-FIND (FIRST ord-manut WHERE ord-manut.nr-ord-produ = iNrOrdProdu NO-LOCK)
        AND l-integra-material THEN DO:
        ASSIGN l-exec-api-mi = YES.
        RUN cdp/cdapi282.p (input ?                    ,  /** rowid it-requisicao                           **/                          
                            INPUT TABLE rowobject      ,  /** registro alterado                             **/                            
                            INPUT 3                    ,  /** funcao: 3-BeforeDeleteRecord Item-Requisicao  **/ 
                            INPUT iNrOrdProdu          ,  /** Nœmero da Ordem de Manuten»’o Industrial      **/
                            INPUT ?                    ,  /** Rowid do registro antes de alterar            **/
                            OUTPUT TABLE RowErrors     ). /** tt que retorna erro                           **/  
    END.
    run cdp/cd9902.p (input 3).
    IF  RETURN-VALUE = "OK":U THEN DO:
        IF NOT VALID-HANDLE(h-bofr072) THEN
            RUN frbo/bofr072.p PERSISTENT SET h-bofr072.
        
        RUN canFindOrdemMMV IN h-bofr072 (INPUT iNrOrdProdu,
                                          OUTPUT lOrdemMMV).    
        IF lOrdemMMV = YES THEN DO:
           IF l-integra-mat-mmv THEN DO:
                ASSIGN l-exec-api-mmv = YES.
                RUN cdp/cdapi282.p (input ?                     ,  /** rowid it-requisicao                           **/                          
                                    INPUT TABLE rowobject       ,  /** registro alterado                             **/                            
                                    INPUT 3                     ,  /** funcao: 3-BeforeDeleteRecord Item-Requisicao  **/ 
                                    INPUT iNrOrdProdu           ,  /** Nœmero da Ordem de Manuten»’o Mecƒnica        **/
                                    INPUT ?                     ,  /** Rowid do registro antes de alterar            **/
                                    OUTPUT TABLE RowErrors      ). /** tt que retorna erro                           **/  
           END.
        END.
        
        IF VALID-HANDLE(h-bofr072) THEN
            DELETE OBJECT h-bofr072.  
    END.
    IF NOT l-exec-api-mi AND NOT l-exec-api-mmv THEN DO:
        /** API de Execu»’o Or»amentÿria **/
        RUN cdp/cdapi193.p (input ?,                 /** rowid it-requisicao                           **/  
                            INPUT TABLE rowobject,   /** registro alterado                             **/  
                            INPUT 3,                 /** funcao: 3-BeforeDeleteRecord Item-Requisicao  **/  
                            OUTPUT TABLE RowErrors). /** tt que retorna erro                           **/
    END. /** fim RowObject.qt-a-atender >= 0 **/
END.

/*************************************************************
**  Valida‡äes necess rias para Tabela (req-ord-produc)     **
*************************************************************/
define variable l-ordem-requis as logical no-undo.
/** Valida se Registros de Movimentos de Estoque do tipo 7 (DRM) e 30 (RM)
    cont‚m a extensÆo <req-ord-produc> para a tabela <it-requisicao> **/
&IF '{&bf_mat_versao_ems}' >= '2.05' &THEN
    assign l-ordem-requis = yes.
&else
    assign l-ordem-requis = no.
    &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
        for first funcao
            where funcao.cd-funcao = "spp-int-req-om":U
            and   funcao.ativo     = yes no-lock:
            assign l-ordem-requis = yes.
        end.
    &ENDIF
&ENDIF
/************************************************************/
/* exclusÆo do relacionamento entre item da requisi‡Æo e ordem de manuten‡Æo */
if l-ordem-requis then
    run cdp/cd0741.p (input it-requisicao.nr-requisicao,
                      input it-requisicao.sequencia).
/* Fim exclusÆo do relacionamento entre item da requisi‡Æo e ordem de manuten‡Æo */
if connected("mginv")     and
   can-find(FIRST param-global 
            WHERE param-global.modulo-in = YES) and 
   it-requisicao.num-ord-inv <> 0 THEN
    FOR FIRST requisicao NO-LOCK
        WHERE requisicao.nr-requisicao = it-requisicao.nr-requisicao:
        run inp/in2101.p(input rowid(requisicao), input rowid(it-requisicao) , "Elimina":U).
        if return-value = "NOK":U then 
           return "NOK":U.
    END.
/*--- Verifica ocorrˆncia de erros ---*/
IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
   RETURN "NOK":U.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeUpdateRecord DBOProgram 
PROCEDURE BeforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* API de Execu»’o Or»amentÿria com tratamento da Manuten»’o Industrial  */
IF  RowObject.qt-a-atender >= 0 THEN DO:
    ASSIGN l-exec-api-mi  = NO
           l-exec-api-mmv = NO
           lOrdemMMV      = NO.

    IF  CAN-FIND (FIRST ord-manut WHERE ord-manut.nr-ord-produ = iNrOrdProdu NO-LOCK)
        AND l-integra-material THEN DO:
        ASSIGN l-exec-api-mi = YES.
        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.nr-requisicao = rowobject.nr-requisicao
               AND bf{&TableName}.sequencia     = rowobject.sequencia NO-LOCK NO-ERROR.
        IF  AVAIL bf{&TableName} THEN
            ASSIGN r-rowid-anterior = rowid(bf{&TableName}).
        ELSE
            ASSIGN r-rowid-anterior = ?.
        RUN cdp/cdapi282.p (input ?                    ,  /** rowid it-requisicao                           **/                          
                            INPUT TABLE rowobject      ,  /** registro alterado                             **/                            
                            INPUT 2                    ,  /** funcao: 2-BeforeUpdateRecord Item-Requisicao  **/ 
                            INPUT iNrOrdProdu          ,  /** Nœmero da Ordem de Manuten»’o Industrial      **/
                            INPUT r-rowid-anterior     ,  /** Rowid do registro antes de alterar            **/
                            OUTPUT TABLE RowErrors     ). /** tt que retorna erro                           **/  
    END.
    run cdp/cd9902.p (input 3).
    IF  RETURN-VALUE = "OK":U THEN DO:

        IF NOT VALID-HANDLE(h-bofr072) THEN
            RUN frbo/bofr072.p PERSISTENT SET h-bofr072.
        
        RUN canFindOrdemMMV IN h-bofr072 (INPUT iNrOrdProdu,
                                          OUTPUT lOrdemMMV).    
        IF lOrdemMMV = YES THEN DO:
            IF l-integra-mat-mmv THEN DO:
                ASSIGN l-exec-api-mmv = YES.
                FIND FIRST bf{&TableName}
                     WHERE bf{&TableName}.nr-requisicao = rowobject.nr-requisicao
                       AND bf{&TableName}.sequencia     = rowobject.sequencia NO-LOCK NO-ERROR.
                IF  AVAIL bf{&TableName} THEN
                    ASSIGN r-rowid-anterior = rowid(bf{&TableName}).
                ELSE
                    ASSIGN r-rowid-anterior = ?.
                RUN cdp/cdapi282.p (input ?                    ,  /** rowid it-requisicao                           **/                          
                                    INPUT TABLE rowobject      ,  /** registro alterado                             **/                            
                                    INPUT 2                    ,  /** funcao: 2-BeforeUpdateRecord Item-Requisicao  **/ 
                                    INPUT iNrOrdProdu          ,  /** Nœmero da Ordem de Manuten»’o Mecƒnica        **/
                                    INPUT r-rowid-anterior     ,  /** Rowid do registro antes de alterar            **/
                                    OUTPUT TABLE RowErrors     ). /** tt que retorna erro                           **/  
            END.
        END.
        
        IF VALID-HANDLE(h-bofr072) THEN
            DELETE OBJECT h-bofr072.	
    END.
    IF NOT l-exec-api-mi AND NOT l-exec-api-mmv THEN DO:
        /** API de Execu»’o Or»amentÿria **/
        RUN cdp/cdapi193.p (input ?,                 /** rowid it-requisicao                           **/  
                            INPUT TABLE rowobject,   /** registro alterado                             **/  
                            INPUT 2,                 /** funcao: 2-BeforeUpdateRecord Item-Requisicao  **/  
                            OUTPUT TABLE RowErrors). /** tt que retorna erro                           **/
    END. /** fim RowObject.qt-a-atender >= 0 **/
END.

IF CAN-FIND(FIRST RowErrors
            WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
    RETURN "NOK":U.
ELSE
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaMatrizOrdMi DBOProgram 
PROCEDURE criaMatrizOrdMi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel  LIKE requisicao.cod-estabel NO-UNDO.
    &IF DEFINED(bf_mnt_ems206b) &THEN
        /*--- Inicializa Handles ---*/
        IF NOT VALID-HANDLE(h-bomn250) THEN
            RUN mnbo/bomn250.p PERSISTENT SET h-bomn250.
    
        IF NOT VALID-HANDLE(hcdapi024) THEN
            RUN cdp/cdapi024.p PERSISTENT SET hcdapi024. 
    
        /*--- Limpa a temp-table tt-matriz-om ---*/
        FOR EACH tt-matriz-om EXCLUSIVE-LOCK:
            DELETE tt-matriz-om.
        END.
        
        /*--- Retorna a Matriz de Unidade Neg¢cio da Ordem de Manuten‡Æo Informada ---*/
        RUN criattMatrizUnidNegoc IN h-bomn250 (INPUT p-nr-ord-produ,
                                                OUTPUT TABLE tt-matriz-om).
        FOR EACH tt-matriz-om NO-LOCK:
            EMPTY TEMP-TABLE tt-erro-aux.
            /*--- UN X ESTAB ---*/
            RUN ValidaUnidadeNegocioEstabel IN hcdapi024 (INPUT p-cod-estabel,
                                                          INPUT TODAY,
                                                          INPUT tt-matriz-om.cod-unid-negoc,
                                                          OUTPUT TABLE tt-erro-aux).
           /*--- Cria Erro ---*/
            FOR EACH tt-erro-aux NO-LOCK:
                {method/svc/errors/inserr.i                     
                                &ErrorNumber= tt-erro-aux.cd-erro            
                                &ErrorType="EMS"                
                                &ErrorSubType="ERROR":U           
                                &ErrorParameters= tt-erro-aux.mensagem }
            END.
            EMPTY TEMP-TABLE tt-erro-aux.
            /*--- UN X USUARIO ---*/
            RUN ValidaUnidadeNegocioUsuario IN hcdapi024 (INPUT c-seg-usuario,
                                                          INPUT tt-matriz-om.cod-unid-negoc,
                                                          OUTPUT TABLE tt-erro-aux).
             /*--- Cria Erro ---*/
            FOR EACH tt-erro-aux NO-LOCK:
                {method/svc/errors/inserr.i                     
                                &ErrorNumber= tt-erro-aux.cd-erro            
                                &ErrorType="EMS"                
                                &ErrorSubType="ERROR":U           
                                &ErrorParameters= tt-erro-aux.mensagem }
            END.
        END.
        IF NOT CAN-FIND(FIRST tt-erro-aux) THEN DO:
            FOR EACH  unid-neg-requis
                WHERE unid-neg-requis.nr-requisicao = RowObject.nr-requisicao AND
                      unid-neg-requis.sequencia     = RowObject.sequencia  EXCLUSIVE-LOCK:
                DELETE unid-neg-requis.
            END.
            /*--- Copia Matriz Unidade Neg¢cio da Ordem de Manuten‡Æo para a Matriz da Requisi‡Æo ---*/
            FOR EACH tt-matriz-om:    
                CREATE unid-neg-requis.
                ASSIGN unid-neg-requis.perc-unid-neg   = tt-matriz-om.val-perc-unid-negoc
                       unid-neg-requis.it-codigo       = RowObject.it-codigo
                       unid-neg-requis.nr-requisicao   = RowObject.nr-requisicao
                       unid-neg-requis.sequencia       = RowObject.sequencia.
                       unid-neg-requis.cod_unid_negoc  = tt-matriz-om.cod-unid-negoc.
            END.

            ASSIGN RowObject.cod-unid-negoc = "".
    
        END.
    
       /*--- Limpa a temp-table tt-matriz-om ---*/
        FOR EACH tt-matriz-om EXCLUSIVE-LOCK:
            DELETE tt-matriz-om.
        END.
        
        /*--- Elimina Handles ---*/
        IF VALID-HANDLE(h-bomn250) THEN
            DELETE PROCEDURE h-bomn250.
        IF VALID-HANDLE(hcdapi024) THEN
            DELETE PROCEDURE hcdapi024.
    
        /*:T--- Verifica ocorrˆncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U no-lock) THEN
            RETURN "NOK":U.
    
        RETURN "Ok":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaMatrizOrdMv DBOProgram 
PROCEDURE criaMatrizOrdMv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nr-ord-produ LIKE reservas.nr-ord-produ   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel  LIKE requisicao.cod-estabel NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN
    
        /*--- Inicializa Handles ---*/
        IF NOT VALID-HANDLE(h-bofr134) THEN
            RUN frbo/bofr134.p PERSISTENT SET h-bofr134.
    
        IF NOT VALID-HANDLE(hcdapi024) THEN
            RUN cdp/cdapi024.p PERSISTENT SET hcdapi024. 
    
        /*--- Limpa a temp-table tt-matriz-om-mv ---*/
        FOR EACH tt-matriz-om-mv EXCLUSIVE-LOCK:
            DELETE tt-matriz-om-mv.
        END.
        
        /*--- Retorna a Matriz de Unidade Neg¢cio da Ordem de Manuten‡Æo Informada ---*/
        RUN criattMatrizOmAux IN h-bofr134 (INPUT p-nr-ord-produ,
                                            OUTPUT TABLE tt-matriz-om-mv).
        FOR EACH tt-matriz-om-mv NO-LOCK:
            EMPTY TEMP-TABLE tt-erro-aux.
            /*--- UN X ESTAB ---*/
            RUN ValidaUnidadeNegocioEstabel IN hcdapi024 (INPUT p-cod-estabel,
                                                          INPUT TODAY,
                                                          INPUT tt-matriz-om-mv.cod-unid-negoc,
                                                          OUTPUT TABLE tt-erro-aux).
           /*--- Cria Erro ---*/
            FOR EACH tt-erro-aux NO-LOCK:
                {method/svc/errors/inserr.i                     
                                &ErrorNumber= tt-erro-aux.cd-erro            
                                &ErrorType="EMS"                
                                &ErrorSubType="ERROR":U           
                                &ErrorParameters= tt-erro-aux.mensagem }
            END.
            EMPTY TEMP-TABLE tt-erro-aux.
            /*--- UN X USUARIO ---*/
            RUN ValidaUnidadeNegocioUsuario IN hcdapi024 (INPUT c-seg-usuario,
                                                          INPUT tt-matriz-om-mv.cod-unid-negoc,
                                                          OUTPUT TABLE tt-erro-aux).
             /*--- Cria Erro ---*/
            FOR EACH tt-erro-aux NO-LOCK:
                {method/svc/errors/inserr.i                     
                                &ErrorNumber= tt-erro-aux.cd-erro            
                                &ErrorType="EMS"                
                                &ErrorSubType="ERROR":U           
                                &ErrorParameters= tt-erro-aux.mensagem }
            END.
        END.
        IF NOT CAN-FIND(FIRST tt-erro-aux) THEN DO:
            FOR EACH  unid-neg-requis
                WHERE unid-neg-requis.nr-requisicao = RowObject.nr-requisicao AND
                      unid-neg-requis.sequencia     = RowObject.sequencia  EXCLUSIVE-LOCK:
                DELETE unid-neg-requis.
            END.
            /*--- Copia Matriz Unidade Neg¢cio da Ordem de Manuten‡Æo para a Matriz da Requisi‡Æo ---*/
            FOR EACH tt-matriz-om-mv:    
                CREATE unid-neg-requis.
                ASSIGN unid-neg-requis.perc-unid-neg   = tt-matriz-om-mv.val-perc-unid-negoc
                       unid-neg-requis.it-codigo       = RowObject.it-codigo
                       unid-neg-requis.nr-requisicao   = RowObject.nr-requisicao
                       unid-neg-requis.sequencia       = RowObject.sequencia.
                       unid-neg-requis.cod_unid_negoc  = tt-matriz-om-mv.cod-unid-negoc.
            END.

            ASSIGN RowObject.cod-unid-negoc = "".
    
        END.
    
       /*--- Limpa a temp-table tt-matriz-om-mv ---*/
        FOR EACH tt-matriz-om-mv EXCLUSIVE-LOCK:
            DELETE tt-matriz-om-mv.
        END.
        
        /*--- Elimina Handles ---*/
        IF VALID-HANDLE(h-bofr134) THEN
            DELETE PROCEDURE h-bofr134.
        IF VALID-HANDLE(hcdapi024) THEN
            DELETE PROCEDURE hcdapi024.

        /*:T--- Verifica ocorrˆncia de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
            RETURN "NOK":U.
    
        RETURN "OK":U.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delItemRequisTarget DBOProgram 
PROCEDURE delItemRequisTarget :
/*------------------------------------------------------------------------------
  Purpose: Adicionar item na temp-table tt-it-requisicao-dest
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-it-codigo           LIKE it-requisicao.it-codigo     NO-UNDO.
DEFINE INPUT PARAMETER i-nr-requisicao       LIKE it-requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER i-sequencia           LIKE it-requisicao.sequencia     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowObject.

find it-requisicao 
    where it-requisicao.it-codigo     = c-it-codigo 
    and   it-requisicao.nr-requisicao = i-nr-requisicao
    and   it-requisicao.sequencia     = i-sequencia
    no-lock no-error.

if avail it-requisicao then do:
    if not can-find(RowObject 
                    where RowObject.it-codigo     = it-requisicao.it-codigo
                      and RowObject.nr-requisicao = it-requisicao.nr-requisicao
                      and RowObject.sequencia     = it-requisicao.sequencia) then do:
        create RowObject.
        buffer-copy it-requisicao to RowObject.
        assign RowObject.r-rowid         = rowid(it-requisicao).
    end.
end.
else
    return "NOK":U.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButtonsItRequisicao DBOProgram 
PROCEDURE enableButtonsItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param prRequisicao    as rowid no-undo.
    def input  param pcUsuario       as char  no-undo.
    def output param plbt-habilitado as log   no-undo.
    
    def var c-usuario-aux as char no-undo.
    
    assign c-usuario-aux = pcUsuario.
    
    find requisicao where 
         rowid(requisicao) = prRequisicao 
         no-lock no-error.
         
    find first it-requisicao where 
         it-requisicao.nr-requisicao = requisicao.nr-requisicao 
         no-lock no-error.

    if avail it-requisicao then
        assign i-seq = it-requisicao.sequencia.
    
    if avail requisicao then do:
        for first usuar-mater fields (cod-usuario char-1)
           where usuar-mater.cod-usuario = c-usuario-aux
           no-lock: END.
        if requisicao.nome-abrev <> c-usuario-aux   
        &if defined(bf_mat_aprova_eletronica) &then
        and avail usuar-mater 
        and substring(usuar-mater.char-1,10,01) <> "Y" &endif
        then
            assign plbt-habilitado = no /* disable */.
        else do:
            assign plbt-habilitado = yes /*enable*/.
            if avail it-requisicao then do:
                if it-requisicao.situacao = 2 or it-requisicao.situacao = 4 then do:         
                    assign plbt-habilitado = no /* disable */.
                end.  
                else
                    assign plbt-habilitado = yes /*enable*/.
            end. 
            else
                assign plbt-habilitado = yes /*enable*/.
        end.
    end.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFieldsMod DBOProgram 
PROCEDURE enableFieldsMod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    def input  param prItRequisicao as rowid no-undo.
    def input  param prRequisicao   as rowid no-undo.
    def output param plCtCodigo     as log   no-undo.
    def output param plScCodigo     as log   no-undo.
    def output param plCodUtiliz    as log   no-undo.
    def output param plNumOrdInv    as log   no-undo.
    def output param plCodRefer     as log   no-undo.
    def output param plPrecoUnit    as log   no-undo.
    def output param plClassif      as log   no-undo.
    def output param piNatDesp      as int   no-undo.
    
    ASSIGN plCodRefer  = yes 
           plCtCodigo  = yes 
           plSCCodigo  = yes 
           plCodUtiliz = yes
           plNumOrdInv = yes
           plCodRefer  = yes
           plPrecoUnit = no.
    
    find it-requisicao where 
         rowid(it-requisicao) = prItRequisicao
         no-lock no-error.

    find requisicao where
         rowid(requisicao) = prRequisicao
         no-lock no-error.

    find first param-global 
        no-lock no-error.
    
    if avail it-requisicao then 
        find first item where
             item.it-codigo = it-requisicao.it-codigo
             no-lock no-error.

    find usuar-mater where 
         usuar-mater.cod-usuario = requisicao.nome-abrev 
         no-lock no-error.           
        
    /*mod*/     
    
    if  requisicao.tp-requis = 2 then /* solicita‡Æo de compras */
        assign plPrecoUnit = yes.

    if avail usuar-mater then
        assign plCtCodigo  = usuar-mater.log-1
               plScCodigo  = usuar-mater.log-2        
               plCodUtiliz = substring(usuar-mater.char-1,1,1) = "y" and
                             (not avail it-requisicao or 
                              (avail it-requisicao and it-requisicao.num-ord-inv = 0)).
                                         
    if avail it-requisicao then do:
        find item where
             item.it-codigo = it-requisicao.it-codigo 
             no-lock no-error.

        if  avail item and item.tipo-con-est = 4 then 
            assign plCodRefer = yes. /*enable*/
        
        if avail item then do:
            for first item-uni-estab fields (it-codigo cod-estabel nat-despesa altera-conta)
                where item-uni-estab.it-codigo   = item.it-codigo
                and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                no-lock: end.
            if avail item-uni-estab then
                assign l-classif  = item-uni-estab.altera-conta   /*se NO entÆo deve montar a conta*/
                       i-nat-desp = item-uni-estab.nat-despesa. /*nat-despesa*/
            else do:
                for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                    where fam-mat-estab.fm-codigo   = item.fm-codigo
                    and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                    no-lock: end.
                if avail fam-mat-estab then 
                    assign l-classif  = fam-mat-estab.altera-conta
                           i-nat-desp = fam-mat-estab.nat-despesa. /*nat-despesa*/
                else 
                    assign l-classif  = no
                           i-nat-desp = item.nat-despesa. /*nat-despesa*/
            end.
        end.
        /* Se utilizar classifica‡Æo contÿbil, nÆo sugere a conta
           (mesmo que o usuÿrio tenha permissÆo para alterar a conta/sub-conta */
           
        if l-classif then 
           assign  plCtCodigo = no /*disable*/ 
                   plScCodigo = no.

        if (it-requisicao.num-ord-inv <> 0 and
            it-requisicao.num-ord-inv <> ?) or
           param-global.modulo-in = no then do:
             assign plNumOrdInv = no.
        end.   
        /* Deverÿ ser retirado quando for feita uma DTR e corrigida a integra‡Æo */
        assign plNumOrdInv = no.
    end.

/***
    find first param-estoq no-lock no-error.
    if avail param-estoq then do:
       if substr(param-estoq.char-1,3,1) = "Y" then assign plScCodigo = no.
    end.
****/

    assign plClassif = l-classif
           piNatDesp = i-nat-desp.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRequis DBOProgram 
PROCEDURE findRequis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-nr-requisicao LIKE requisicao.nr-requisicao  no-undo.
def input parameter i-sequencia     as int  no-undo.
def output parameter c-return       as char no-undo.

    RUN openQueryStatic (input "Main":U).

    RUN goToKeyReqSeq (input i-nr-requisicao,
                       input i-sequencia).
                      
  
    if return-value = "OK" then assign c-return = "".  
    
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":u,
                           input 2,
                           input return-value).
        assign c-return =  return-value.  
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-aprov":U THEN ASSIGN pFieldValue = RowObject.nome-aprov.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
   &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
   &ELSE
   &ENDIF
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-devolvida":U THEN ASSIGN pFieldValue = RowObject.qt-devolvida.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-a-atender":U THEN ASSIGN pFieldValue = RowObject.qt-a-atender.
        WHEN "qt-a-devolver":U THEN ASSIGN pFieldValue = RowObject.qt-a-devolver.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
        WHEN "qt-requisitada":U THEN ASSIGN pFieldValue = RowObject.qt-requisitada.
        WHEN "val-item":U THEN ASSIGN pFieldValue = RowObject.val-item.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "seq-planej":U THEN ASSIGN pFieldValue = RowObject.seq-planej.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        &if defined(bf_mat_aprova_eletronica) &then
              WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        &endif        
   &IF "{&mguni_version}" >= "2.071" &THEN
   &ELSE
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
   &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ðndice ITEM-REQ
  Parameters:
               retorna valor dos campos do ðndice ITEM-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-requisicao = RowObject.nr-requisicao.
    ASSIGN psequencia = RowObject.sequencia.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÆo esteja ser˜
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidRequisicao DBOProgram 
PROCEDURE getRowidRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
    Procura o rowid da requisi‡Æo a partir do numero da requisi‡Æo
    que vem da tabela it-requisicao.
  Parameters:  
      ipar1 : r-it-requisicao : rowid do registro da tabela it-requisicao
      opar2 : r-requisicao    : rowid da tabela requisicao
  Notes:       
------------------------------------------------------------------------------*/
 
 def input  param r-it-requisicao as rowid no-undo.
 def output param r-requisicao    as rowid no-undo.    

    find it-requisicao where
         rowid(it-requisicao) = r-it-requisicao 
         no-lock no-error.
    
    if avail it-requisicao then do:
        find first requisicao where
                   requisicao.nr-requisicao = it-requisicao.nr-requisicao
                   no-lock no-error.
         if avail requisicao then
            assign r-requisicao = rowid(requisicao).
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ðndice ITEM-REQ
  Parameters:
               recebe valor dos campos do ðndice ITEM-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE it-requisicao.nr-requisicao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE it-requisicao.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    FIND FIRST bfit-requisicao WHERE
        bfit-requisicao.nr-requisicao = pnr-requisicao AND
        bfit-requisicao.sequencia = psequencia AND
        bfit-requisicao.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser˜ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser˜ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyReqSeq DBOProgram 
PROCEDURE goToKeyReqSeq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
def input parameter i-sequencia     as int no-undo.
 
    find first bfit-requisicao where
        bfit-requisicao.nr-requisicao = i-nr-requisicao and
        bfit-requisicao.sequencia = i-sequencia
        no-lock no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro ser˜ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser˜ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HabilitaBotaoBrowserItensCompra DBOProgram 
PROCEDURE HabilitaBotaoBrowserItensCompra :
/*------------------------------------------------------------------------------
  Purpose:     
    Verifica se os botoes Ordem,Parcela,Cotacao,Pedido,Recebimento,Narrativa podem ser habilitados
    ou nÆo.
  Parameters: 
    ipar1:  p-campos   : rowid it-requisicao, ordem e item do registro selecionado no browser Concatenados.
    opar2:  p-ordem    : rowid ordem-compra.
    opar3:  p-pedid    : rowid pedido.
    opar4:  p-receb    : rowid recebimento
    opar5:  p-item     : rowid item
    opar6:  p-bot-ordem: habilita botÆo ordem(yes/no)
    opar7:  p-bot-parce: habilita botÆo parcelas(yes/no)
    opar8:  p-bot-cotac: habilita botÆo cota‡Æo(yes/no)
    opar9:  p-bot-pedid: habilita botÆo pedido(yes/no)
    opar10: p-bot-receb: habilita botÆo recebimento(yes/no)
    opar11: p-bot-narra: habilita botÆo narrativa(yes/no)
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-campos    as char  no-undo.
def output param p-ordem     as rowid no-undo.
def output param p-pedid     as rowid no-undo.
def output param p-receb     as rowid no-undo.
def output param p-item      as rowid no-undo.
def output param p-bot-ordem as char  no-undo.
def output param p-bot-parce as char  no-undo.
def output param p-bot-cotac as char  no-undo.
def output param p-bot-pedid as char  no-undo.
def output param p-bot-receb as char  no-undo.
def output param p-bot-narra as char  no-undo.
def var r-it-requis          as rowid no-undo.  
def var c-it-codigo          as char  no-undo.
def var i-ordem              as int   no-undo.
  assign
     p-bot-ordem = 'no'
     p-bot-parce = 'no'
     p-bot-cotac = 'no'
     p-bot-pedid = 'no'
     p-bot-receb = 'no'
     p-bot-narra = 'no'.
     
  assign r-it-requis = to-rowid(entry(1,p-campos))
         c-it-codigo = entry(2,p-campos)
         i-ordem     = int(entry(3,p-campos)).
         
      find first item where item.it-codigo = c-it-codigo no-lock no-error.
      if available item then 
          assign p-item = rowid(item).
      find ordem-compra where 
            ordem-compra.numero-ordem = i-ordem
            no-lock no-error.
      
      if available ordem-compra then do:
            assign  p-bot-ordem = 'yes'
                    p-bot-parce = 'yes'
                    p-bot-narra = 'yes'
                    p-ordem   = rowid(ordem-compra).

            find first cotacao-item where
                       cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                       cotacao-item.cot-aprovada = yes no-lock no-error.
                    if available cotacao-item then 
                        assign p-bot-cotac = 'yes'.
            
            find pedido-compr where
                 pedido-compr.num-pedido = ordem-compra.num-pedido no-lock no-error.
            if available pedido-compr then do: 
               assign p-bot-pedid = 'yes'
                      p-pedid = rowid(pedido-compr).
               find first recebimento where 
                          recebimento.num-pedido   = pedido-compr.num-pedido and
                          recebimento.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
               if avail recebimento then do:
                  assign p-receb = rowid(recebimento).
                  if recebimento.quant-receb > 0 then
                     assign p-bot-receb = 'yes'.  
                  else
                     assign p-bot-receb = 'no'.
               end.                        
            end.
            else
               assign p-bot-receb = 'no'.
      end.
      else do:
           assign  p-bot-ordem   = 'no'
                   p-bot-parce   = 'no'
                   p-bot-narra   = 'no'.      
      end.  
  return string(c-it-codigo) + string(i-ordem).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDefaultFields DBOProgram 
PROCEDURE initializeDefaultFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param prItRequisicao as rowid no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    def output param piCodEmp       LIKE empresa.ep-codigo no-undo.
&ELSE
    def output param piCodEmp       as int no-undo.
&ENDIF
    def output param pdePreco       as dec no-undo.
    def output param plUrgente      as log no-undo.
    def output param plHomologa     as log no-undo.
    def output param plAfetaQlde    as log no-undo.
    def output param piPrioridade   as int no-undo.

    find first param-global
         no-lock no-error.
    
    find it-requisicao where 
         rowid(it-requisicao) = prItRequisicao
         no-lock no-error.

    find first requisicao where 
         requisicao.nr-requisicao = it-requisicao.nr-requisicao
         no-lock no-error.
    
    if avail requisicao then 
        find estabelec where 
             estabelec.cod-estabel = requisicao.cod-estabel 
             no-lock no-error.      
        if avail estabelec and param-global.modulo-in = yes
               then assign piCodEmp = estabelec.ep-codigo.
    
    if  avail it-requisicao then do:
       assign dePreco = it-requisicao.val-item / it-requisicao.qt-a-atender.

       if  dePreco <> 0 and dePreco <> ? then
           assign pdePreco = dePreco.
           
        if  it-requisicao.log-1 = yes then
            assign plUrgente = yes.
        else
            assign plUrgente = no.
        if  it-requisicao.log-2 = yes then
            assign plHomologa = yes.
        else
            assign plHomologa = no.
        if  substr(it-requisicao.char-1,1,1) = "Y" then
            assign plAfetaQlde = yes.
        else
            assign plAfetaQlde = no.
            
        &if defined(bf_mat_aprova_eletronica) &then
             if it-requisicao.prioridade-aprov >= 0 and
                it-requisicao.prioridade-aprov <= 300 then
                assign piPrioridade = 4.
             if it-requisicao.prioridade-aprov >  300 and
                it-requisicao.prioridade-aprov <= 600 then
                assign piPrioridade = 3.
             if it-requisicao.prioridade-aprov >  600 and
                it-requisicao.prioridade-aprov <  999 then
                assign piPrioridade = 2.
             if it-requisicao.prioridade-aprov =  999 then
                assign piPrioridade = 1.
        &endif  
    end.
    else assign piPrioridade = 4.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdem-Compra DBOProgram 
PROCEDURE linkToOrdem-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param ph-ordem as handle no-undo.
    
    RUN GetKey in ph-ordem (output ccod-comprado, output inum-ordem).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRequisicao DBOProgram 
PROCEDURE linkToRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pRequisicao as handle no-undo.
    
    RUN GetKey in pRequisicao (OUTPUT c-cod-estabel, OUTPUT i-nr-requisicao).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mensagemAprovacaoItemRequisicao DBOProgram 
PROCEDURE mensagemAprovacaoItemRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**
    ***   Mensagem de Aprova‡Æo
    **/
    if i-tipo-doc > 0 then do:
        IF  NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            run cdp/cdapi174.p (i-tipo-doc,
                                rowid(it-requisicao),
                                output i-moeda-lim,
                                output i-tipo-moeda,
                                output de-valor-doc,
                                output de-valor-lim).
            find moeda where
                moeda.mo-codigo = i-moeda-lim
                no-lock no-error.
            assign c-moeda-lim  = string(i-moeda-lim,"9") + " - ":U + moeda.descricao.
            case i-tipo-moeda:
                when 1 then do:
                    {utp/ut-liter.i (Usuario) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 2 then do:
                    {utp/ut-liter.i (Aprovador) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 3 then do:
                    {utp/ut-liter.i (Familia) * r}
                    assign c-tipo-moeda = return-value.
                end.
                when 4 then do:
                    {utp/ut-liter.i (Mestre) * r}
                    assign c-tipo-moeda = return-value.
                end.
            end case.
           
           
            if it-requisicao.estado = 1 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="16725"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters="c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}    
            end.
            else do:
                    {method/svc/errors/inserr.i &ErrorNumber="16724"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters="c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             
    
            end.
        END.
    end.
    else do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="''"} 
         return "NOK"  .                                
    end.




    return "OK".
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextSeqItRequisicao DBOProgram 
PROCEDURE nextSeqItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    def input  param prRequisicao     as rowid no-undo.
    def output param pi-sequencia     as int   no-undo.
    def output param pi-nr-requisicao LIKE requisicao.nr-requisicao   no-undo.
    def output param pc-centro-custo  as char  no-undo.

    disable triggers for dump of requisicao.
    disable triggers for dump of it-requisicao.
    
    def var i-count as integer no-undo.
        
    find requisicao where 
         rowid(requisicao) = prRequisicao 
         no-lock no-error.
    
    if  avail requisicao then do:
    
        find usuar-mater where 
             usuar-mater.cod-usuario = requisicao.nome-abrev 
             no-lock no-error.           
        if avail usuar-mater then
           assign pc-centro-custo = usuar-mater.sc-codigo.
    
        find last it-requisicao where 
             it-requisicao.nr-requisicao = requisicao.nr-requisicao
             no-lock no-error.
        FIND FIRST funcao
             WHERE funcao.cd-funcao = "spp-seq-req-solic":U AND funcao.ativo = YES NO-LOCK NO-ERROR.
        IF  AVAIL funcao THEN DO:
            if  avail it-requisicao then
                assign pi-sequencia = it-requisicao.sequencia + 1.
            if  not avail it-requisicao then
                assign pi-sequencia = 1.
        END.
        ELSE DO:
            if  avail it-requisicao then
                assign pi-sequencia = it-requisicao.sequencia + 10.
            if  not avail it-requisicao then
                assign pi-sequencia = 10.
        END.
        
        if  pi-sequencia > 999 then do:
            do i-count = 1 to 999:
                if can-find(first it-requisicao
                            where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                              and it-requisicao.sequencia     = i-count) then 
                    assign pi-sequencia = 1.
                else do:
                    assign pi-sequencia = i-count.
                    leave.
                end.
            end.
        end.
        
        assign pi-nr-requisicao  = requisicao.nr-requisicao.
    end.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            RUN openQueryStatic (input "Main":U) .
        when 2 then
            RUN openQueryStatic (input "ByOrdem-Compra":U) .
        when 3 then
            RUN openQueryStatic (input "ByItemReq":U) .
        when 4 then
            RUN openQueryStatic (input "ByRequisicao":U) .
        when 5 then
            RUN openQueryStatic (input "ByFaixaRequisicao":U) .

    end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByFaixaRequisicao DBOProgram 
PROCEDURE openQueryByFaixaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     it-requisicao.nr-requisicao >= i-requis-ini and
                                     it-requisicao.nr-requisicao <= i-requis-fin no-lock INDEXED-REPOSITION. 
    RETURN "OK":U.                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemReq DBOProgram 
PROCEDURE openQueryByItemReq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.nr-requisicao = i-nr-requisicao and
                                     {&TABLENAME}.sequencia     = i-seq           no-lock
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem-Compra DBOProgram 
PROCEDURE openQueryByOrdem-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                      it-requisicao.numero-ordem = inum-ordem no-lock INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByRequisicao DBOProgram 
PROCEDURE openQueryByRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
                                     {&TABLENAME}.nr-requisicao = i-nr-requisicao
                                     NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH it-requisicao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoItem DBOProgram 
PROCEDURE retornaDescricaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input  parameter pc-it-codigo      as char  no-undo.
    define input  parameter prRowidRequisicao as rowid no-undo.
    define output parameter pc-descricao      as char  no-undo.

    find item where item.it-codigo = pc-it-codigo no-lock no-error.
    if avail item then do:
        find item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error. 
        if avail item-mat and item-mat.log-1 = yes /*item Gen‚rico*/ and item.tipo-contr = 4 /* d‚bito direto */ then do:
            /* busca descri‡Æo da ordem-compra */
            find it-requisicao where rowid(it-requisicao) = prRowidRequisicao no-lock no-error.
            if avail it-requisicao then do:
               assign pc-descricao = substring(it-requisicao.narrativa,1,60).
            end.
            else do:
               assign pc-descricao = item.desc-item.
            end.   
        end.
        else do:
          assign pc-descricao = item.desc-item.
        end.  
    end.
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaPrograma DBOProgram 
PROCEDURE setaPrograma :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    define input parameter pPrograma as char no-undo.

    assign cPrograma = pPrograma.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint2 DBOProgram 
PROCEDURE setconstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter p-r-chave as rowid no-undo.
   
    RUN setconstraintOfOrdemCompra (input p-r-chave).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint3 DBOProgram 
PROCEDURE setconstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter p-rowid-requisicao as rowid no-undo.

    RUN setconstraintOfRequisicao (input p-rowid-requisicao).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint4 DBOProgram 
PROCEDURE setconstraint4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */

    def input parameter p-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
    
    RUN setconstraintByScCodigo (input p-nr-requisicao).    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint5 DBOProgram 
PROCEDURE setconstraint5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* ------------------------ PROXIES BO 1.1 ----------------------------- */

def input param  p-requis-ini LIKE requisicao.nr-requisicao no-undo.
def input param  p-requis-fin LIKE requisicao.nr-requisicao no-undo.

    RUN setconstraintNrRequisicao(input p-requis-ini, 
                                  input p-requis-fin).           
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByRequisicao DBOProgram 
PROCEDURE setConstraintByRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-nr-requisicao like requisicao.nr-requisicao no-undo.

    assign i-nr-requisicao = p-nr-requisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByScCodigo DBOProgram 
PROCEDURE setconstraintByScCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input paramete p-nr-requisicao LIKE requisicao.nr-requisicao no-undo.
    
    assign i-nr-requisicao = p-nr-requisicao.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintNrRequisicao DBOProgram 
PROCEDURE setconstraintNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-requis-ini LIKE requisicao.nr-requisicao no-undo.
def input parameter p-requis-fin LIKE requisicao.nr-requisicao no-undo.

assign i-requis-ini    = p-requis-ini
       i-requis-fin    = p-requis-fin.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintOfOrdemCompra DBOProgram 
PROCEDURE setconstraintOfOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-rowid-ordem-compra as rowid no-undo.

    find ordem-compra where rowid(ordem-compra) = p-rowid-ordem-compra no-lock no-error. 
    
    assign i-nr-requisicao = ordem-compra.nr-requisicao
           i-seq           = ordem-compra.sequencia.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintOfRequisicao DBOProgram 
PROCEDURE setconstraintOfRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-rowid-requisicao as rowid no-undo.

    find requisicao where rowid(requisicao) = p-rowid-requisicao no-lock no-error.
     
    assign i-nr-requisicao = requisicao.nr-requisicao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequisicao DBOProgram 
PROCEDURE setConstraintRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-requisicao LIKE requisicao.nr-requisicao no-undo.
def input parameter p-sequencia  as int   no-undo.

assign i-nr-requisicao    = p-requisicao
       i-seq              = p-sequencia.  

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetlAprovacaoItem DBOProgram 
PROCEDURE SetlAprovacaoItem :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    define input parameter plAprovacaoItem as logical no-undo.

    assign lAprovacaoItem = plAprovacaoItem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNrOrdProdu DBOProgram 
PROCEDURE setNrOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pi-nr-ord AS INTEGER NO-UNDO.

ASSIGN iNrOrdProdu = pi-nr-ord.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unidNegRequisOfItem DBOProgram 
PROCEDURE unidNegRequisOfItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-it-requisicao-dest.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-unid-neg-requis.

    for each tt-it-requisicao-dest NO-LOCK:
        for each unid-neg-requis
            where unid-neg-requis.nr-requisicao = tt-it-requisicao-dest.nr-requis-orig
              and unid-neg-requis.sequencia     = tt-it-requisicao-dest.seq-requis-orig
              and unid-neg-requis.it-codigo     = tt-it-requisicao-dest.it-codigo no-lock:
            create tt-unid-neg-requis.
            buffer-copy unid-neg-requis except nr-requisicao sequencia to tt-unid-neg-requis.
            assign tt-unid-neg-requis.nr-requisicao = tt-it-requisicao-dest.nr-requisicao
                   tt-unid-neg-requis.sequencia     = tt-it-requisicao-dest.sequencia.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateUpdateItRequisicao DBOProgram 
PROCEDURE validateCreateUpdateItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     validateCreateUpdateItRequisicao
  Parameters:  <none>
  Notes:       Valida e faz a manuten‡Æo do registro da it-requisicao.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcParam       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcCodUtiliz   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcbPrioridade AS INTEGER   NO-UNDO.    
DEFINE INPUT PARAMETER plUrgente     AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plHomologa    AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plAfetaQlde   AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER plClassif     AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER piNatDesp     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER plScCodigo    AS LOGICAL   NO-UNDO.

DEFINE VARIABLE r-chave     as rowid no-undo.
DEFINE VARIABLE r-it-requis as rowid no-undo.

assign l-ScCodigo         = plScCodigo
       c-lista-prioridade = "Muito Alta,Alta,M‚dia,Baixa"
       l-classif          = plClassif
       i-nat-desp         = piNatDesp 
       c-param            = pcParam
       c-cod-utiliz       = pcCodUtiliz 
       c-cod-utiliz-aux   = pcCodUtiliz.

FIND FIRST RowObject NO-ERROR.

if not avail RowObject then do:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-item-da-requisicao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Item_da_Requisi‡Æo" *}
    ASSIGN c-lbl-liter-item-da-requisicao = TRIM(RETURN-VALUE).
    {method/svc/errors/inserr.i
        &ErrorNumber="16283"
        &ErrorType="EMS"
        &ErrorSubType="ERROR"
        &ErrorParameters="c-lbl-liter-item-da-requisicao"}
    RETURN "NOK":U.
END.

FIND FIRST param-global no-lock no-error.
FIND FIRST param-estoq  no-lock no-error.
FIND FIRST param-compra no-lock no-error.

FIND FIRST requisicao
     where requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-LOCK no-error.

IF avail requisicao THEN
    assign r-requisicao = rowid(requisicao).

find FIRST usuar-mater 
     WHERE usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.

find FIRST it-requisicao 
     where it-requisicao.nr-requisicao = RowObject.nr-requisicao 
     and   it-requisicao.sequencia     = RowObject.sequencia no-lock no-error.

if pcParam = "ADD":U then do:
    if avail it-requisicao then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="5576"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"}
    END.
END.


IF pcParam = "DEL":U AND AVAIL it-requisicao THEN DO:
    IF c-seg-usuario NE it-requisicao.nome-abrev THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="27706"
            &ErrorType="EMS":U
            &ErrorSubType="ERROR":U} 
    END.
END.

FIND FIRST ITEM
     where item.it-codigo = RowObject.it-codigo no-lock no-error.

IF AVAIL ITEM AND (ITEM.tipo-contr = 4 AND requisicao.tp-requis <> 2) THEN
    ASSIGN RowObject.preco-unit = 0.

if cPrograma <> "CD0738":U AND cPrograma <> "MIAPI103A":U AND cPrograma <> "MIAPI103B":U then do:
    run validateFieldItemItRequisicao.
END.

if c-param <> "Add":U and (avail it-requisicao and it-requisicao.num-ord-inv = 0) THEN
    run validateFieldCodUtilizItRequisicao.

run validateFieldNumOrdInvItRequisicao.

/*--------- Valida‡„es do item requisitado/solicitado --------------*/
/******************** {cdp/cd1406a.i3} COM SHOW *********************/
run validateItemRequisicao.
/********************************************************************/

/** Copia Matriz Unidade Neg¢cio da Ordem de Manuten‡Æo para a Matriz da Requisi‡Æo **/
    &IF DEFINED(bf_mnt_ems206b) &THEN
    
        IF l-mat-unid-negoc AND l-unidade-negocio THEN DO:
            FOR FIRST ord-prod WHERE
                      ord-prod.nr-ord-produ = iNrOrdProdu NO-LOCK:
            END.
            IF AVAIL ord-prod AND ord-prod.origem = "MI" 
                              AND AVAIL requisicao 
                              AND CAN-FIND(FIRST unid-negoc-om WHERE
                                                 unid-negoc-om.num-ord-manut = iNrOrdProdu NO-LOCK) THEN DO:
                
                RUN criaMatrizOrdMi IN THIS-PROCEDURE (INPUT iNrOrdProdu,
                                                       INPUT requisicao.cod-estabel).
            END.
            ELSE DO:
                IF AVAIL ord-prod AND ord-prod.origem = "MV"
                                  AND AVAIL requisicao
                                  AND requisicao.tp-requis = 2 THEN DO:

                    RUN cdp/cd9902.p (INPUT 2).

                    IF RETURN-VALUE = "OK":U THEN DO:

                        IF NOT VALID-HANDLE(h-bofr134) THEN
                            RUN frbo/bofr134.p PERSISTENT SET h-bofr134.

                        RUN canFindMatrizMMV IN h-bofr134 (INPUT ord-prod.nr-ord-produ).

                        IF RETURN-VALUE = "OK":U THEN DO:

                            RUN criaMatrizOrdMv IN THIS-PROCEDURE (INPUT iNrOrdProdu,
                                                                   INPUT requisicao.cod-estabel).
                        END.

                        IF VALID-HANDLE(h-bofr134) THEN
                            DELETE PROCEDURE h-bofr134.
                    END.
                END.
            END.
        END.
    &endif
/** Fim Copia Matriz Unidade Neg¢cio da Ordem de Manuten‡Æo para a Matriz da Requisi‡Æo **/


if avail requisicao and requisicao.tp-requis <> 1 then do:
    FOR FIRST item-uni-estab
        where item-uni-estab.it-codigo   = RowObject.it-codigo
        and   item-uni-estab.cod-estabel = requisicao.cod-estabel NO-LOCK:

        IF  param-compra.int-2 = 1 /* Grupo de Compra */ THEN DO:
            ASSIGN RowObject.cod-grp-compra = item-uni-estab.cod-grp-compra.
        END.
        ELSE DO:
            &if '{&bf_mat_versao_ems}' >= '2.071' &then
                ASSIGN RowObject.cod-comprado = item-uni-estab.cod-comprado.
            &ELSE
                ASSIGN substring(RowObject.char-1,2,12) = item-uni-estab.cod-comprado.
            &endif
        END.
    END.
    IF NOT AVAIL item-uni-estab AND avail item THEN DO:
        IF  param-compra.int-2 = 1 /* Grupo de Compra */ THEN DO:
            ASSIGN RowObject.cod-grp-compra = &if "{&mgind_dbtype}" = "progress" 
                                              &then substr(item.char-2,188,12).
                                              &else substr(item.char-2,88,12).
                                              &endif
        END.
        ELSE DO:
            &if '{&bf_mat_versao_ems}' >= '2.071' &then
                ASSIGN RowObject.cod-comprado = item.cod-comprado.
            &ELSE
                ASSIGN substring(RowObject.char-1,2,12) = item.cod-comprado.
            &endif
        END.
    END.
END.

/*****  Antiga chamada da cd1406a.i2 *****/
/************* {cdp/cd1406a.i5} Atribui pre‡o caso nÆo for D‚bito Direto COM SHOW *********/
run atribuiPrecoDebitoNaoDireto.

/******************************************************************************************/
if avail ITEM
    and  item.tipo-contr = 4
    and  requisicao.tp-requis = 2 then /* Reatribui valor da tela - item d‚dito direto e solicita‡Æo */
    assign de-preco-u = RowObject.preco-unit.

if avail requisicao then do:
    find FIRST usuar-mater
         where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
    if requisicao.tp-requis = 1 then do: /* Requisicao */
        if avail usuar-mater then
            assign de-limite-req = usuar-mater.lim-requis
                   i-moeda-req   = usuar-mater.mo-codigo
                   de-total-req  = 0.
        run  cdp/cd0812.p (input  i-moeda-req,
                           input  0,
                           input  de-limite-req,
                           input  today,
                           output de-limite-req).

        ASSIGN RowObject.val-item = if RowObject.qt-a-atender > 0 then RowObject.qt-a-atender * de-preco-u
                                                                  else 0.

    END.
    else do: /* solicitacao */
        if avail usuar-mater then
            assign de-solic      = usuar-mater.lim-solic
                   i-moeda-solic = usuar-mater.mo-codigo
                   de-tot-solic  = 0.
        if i-moeda-solic <> 0 then
            run cdp/cd0812.p (input  i-moeda-solic,
                              input  0,
                              input  de-solic,
                              input  today,
                              output de-solic).
        
        assign RowObject.val-item = RowObject.qt-a-atender * de-preco-u.        
    END.

    /* 
    ** Caso o preco utilizado para valorizar o documento for inferior a 0,01 centavos, o valor do item     
    ** fica zerado, fazendo com que o documento nao tenha valor e consequentemente aprovado automaticamente 
    ** O calculo esta sendo feito fora da verificacao para solicitacao e requisicao, pois o erro ocorre nos dois casos
    */
    IF RowObject.val-item < 0.01 THEN
        ASSIGN RowObject.val-item = 0.01.
END.

/*****  Fim antiga chamada da cd1406a.i2 *****/

IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
    RETURN "NOK":U.
END.
else do:
    /*******************************************
    **  Cria‡Æo do Registro 
    *******************************************/
    if pcParam = "ADD":U then DO:
        run createRecord.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        assign r-chave =  rowid({&TableName}).
    END.
    /*******************************************
    **  Altera‡Æo do Registro 
    *******************************************/
    else do:
        find current {&TableName} exclusive-lock no-error.
        assign r-chave = rowid({&TableName}).
        run updateRecord.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
END.

/** Busca o Registro criado ou alterado **/
FIND FIRST it-requisicao 
    where rowid(it-requisicao) = r-chave EXCLUSIVE-LOCK no-error.


IF NOT AVAIL it-requisicao THEN DO:
    FIND FIRST it-requisicao 
         WHERE it-requisicao.nr-requisicao = RowObject.nr-requisicao
         AND   it-requisicao.sequencia     = RowObject.sequencia
         AND   it-requisicao.it-codigo     = RowObject.it-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAIL it-requisicao THEN RETURN "NOK":U.
END.

assign r-item-re = rowid(it-requisicao).
/** Busca o item somente se nÆo foi lido ainda **/
if not avail item or item.it-codigo <> it-requisicao.it-codigo then
    FIND FIRST item 
         where item.it-codigo = it-requisicao.it-codigo no-lock no-error.

/**  Melhorias **/
&if defined(bf_mat_aprova_eletronica) &then
    case pcbPrioridade :
        when 1 then assign it-requisicao.prioridade-aprov = 999.
        when 2 then assign it-requisicao.prioridade-aprov = 750.
        when 3 then assign it-requisicao.prioridade-aprov = 450.
        when 4 then assign it-requisicao.prioridade-aprov = 150.
    end case.
&endif
assign it-requisicao.num-ord-inv   = RowObject.num-ord-inv.


run validateQuantidadeItemSerie in this-procedure.

if  pcParam <> "mod" THEN
    assign it-requisicao.qt-requisitada = RowObject.qt-a-atender
           it-requisicao.qt-atendida    = 0
           it-requisicao.qt-devolvida   = 0
           it-requisicao.qt-a-devolver  = 0.

FIND FIRST estabelec 
     where estabelec.cod-estabel = requisicao.cod-estabel no-lock no-error.
if avail param-global     and
   param-global.modulo-in and 
   RowObject.num-ord-inv <> 0 then  
    assign  it-requisicao.ep-codigo   = if avail estabelec 
                                        then estabelec.ep-codigo
                                        else param-global.empresa-prin.
if avail item then
    assign it-requisicao.nome-abrev    = requisicao.nome-abrev
           it-requisicao.cod-estabel   = requisicao.cod-estabel
           it-requisicao.log-1         = plUrgente
           it-requisicao.log-2         = plHomologa.
           
if pcParam = "add" then do:
    if avail item AND it-requisicao.cod-depos = "" then 
            assign it-requisicao.cod-depos = item.deposito-pad.
    
    if can-find(first funcao where
                funcao.cd-funcao = "spp-whs-item-site" and
                funcao.ativo     = yes) then do:
         find item-uni-estab where 
              item-uni-estab.it-codigo   = it-requisicao.it-codigo and 
              item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
         if avail item-uni-estab then
              assign it-requisicao.cod-depos = item-uni-estab.deposito-pad.  
    end.
end.

if it-requisicao.num-ord-inv = 0 OR 
   NOT param-global.modulo-in then
   assign substring(it-requisicao.char-2,1,12) = c-cod-utiliz-aux.

assign substr(it-requisicao.char-1,1,1,"character") = if plAfetaQlde = yes then "Y" else "N".

/*****  Antiga chamada da cd1406a.i2 - o val-item passou a ser calculado antes da grava‡Æo para ser validado *****/

if avail item and item.tipo-con-est = 2 then
    assign it-requisicao.qt-a-atender = 1.
    
if  it-requisicao.preco-unit = 0 then
    assign it-requisicao.preco-unit = it-requisicao.val-item / it-requisicao.qt-requisitada.
    
assign de-sal-ant = it-requisicao.qt-a-atender.

if  it-requisicao.qt-a-atender = 0 then do:
    assign it-requisicao.situacao = 2.
    FIND FIRST b-it-requisicao
        where  b-it-requisicao.nr-requisicao = requisicao.nr-requisicao
        and   (b-it-requisicao.situacao = 1 or b-it-requisicao.situacao = 3)
        no-error.
    if  not avail b-it-requisicao and requisicao.situacao = 1 then do:
        assign requisicao.situacao = 2.
        find b-it-requisicao
            where rowid(it-requisicao) = r-item-re no-lock no-error.
    end.
    else
        find b-it-requisicao
            where rowid(it-requisicao) = r-item-re no-lock no-error.
end.


if pcParam = "add" then 
    run ccp/ccapi642.p (1, rowid(it-requisicao), 1).
else
    run ccp/ccapi642.p (1, rowid(it-requisicao), 2).

/***************************************************************************
** Aprova‡Æo colocada conforme o CD1406a-v01
***************************************************************************/
/** Verifica o tipo de transa‡Æo **/
assign i-tipo-trans = if c-param = "add" then 1 else 2.

if lAprovacaoItem and
   i-tipo-doc > 0 then do:
    if (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao":U)
    or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao":U)
    or  i-tipo-doc > 2 THEN DO:
        assign r-it-requis = rowid(it-requisicao).
        release it-requisicao.
        IF  CAN-FIND(funcao WHERE
                     funcao.cd-funcao = "Integra_MLA_EMS" AND
                     funcao.ativo     = YES) THEN DO:

            RUN lap/mlaapi099.p (INPUT i-tipo-doc).

            IF  RETURN-VALUE <> "NOK" THEN DO:    
                CASE i-tipo-doc:
                    WHEN 1 THEN DO:
                        IF  NOT VALID-HANDLE(h-mlaapi010a) THEN DO:
                            RUN lap/mlaapi010a.p PERSISTENT SET h-mlaapi010a (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro-mla APPEND).
                        END.

                        IF  VALID-HANDLE(h-mlaapi010a) THEN DO:
                            RUN pi-seta-ordem IN h-mlaapi010a (INPUT iNrOrdProdu).
                            RUN pi-executar IN h-mlaapi010a (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro-mla).
                            RUN getRowErrors IN h-mlaapi010a (OUTPUT TABLE RowErrors APPEND).
                        END.

                        IF VALID-HANDLE(h-mlaapi010a) THEN
                            DELETE OBJECT h-mlaapi010a.	
                    END.
                    WHEN 2 THEN DO:
                        IF  NOT VALID-HANDLE(h-mlaapi010b) THEN DO:
                            RUN lap/mlaapi010b.p PERSISTENT SET h-mlaapi010b (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro-mla APPEND).
                        END.

                        IF  VALID-HANDLE(h-mlaapi010b) THEN DO:
                            RUN pi-seta-ordem IN h-mlaapi010b (INPUT iNrOrdProdu).
                            RUN pi-executar IN h-mlaapi010b (INPUT i-tipo-trans, INPUT r-it-requis, output table tt-erro-mla).
                            RUN getRowErrors IN h-mlaapi010b (OUTPUT TABLE RowErrors APPEND).
                        END.

                        IF VALID-HANDLE(h-mlaapi010b) THEN
                            DELETE OBJECT h-mlaapi010b.	
                    END.
                    OTHERWISE DO:
                        RUN cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, r-it-requis).
                    END.
                END CASE.
            END.
        END.
        ELSE DO:
            RUN cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, r-it-requis).
        END.

        find it-requisicao where rowid(it-requisicao) = r-it-requis 
            exclusive-lock no-error.
    end.
end.

if lAprovacaoItem and
   param-compra.log-1 and
    i-tipo-doc < 3     and
  ((i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "sim":U) or 
   (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "sim":U)) then do:
    /* caso aprovacao total - sera consistido no final */
    assign requisicao.estado     = 2
           requisicao.nome-aprov = "":U.
    /**  Melhorias **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign it-requisicao.estado     = 2
               it-requisicao.nome-aprov = "":U.
    &endif
end.
else do:
    assign requisicao.estado     = 1
           requisicao.nome-aprov = requisicao.nome-abrev.
    /**  Melhorias **/
    assign it-requisicao.estado     = 1
           it-requisicao.nome-aprov = requisicao.nome-abrev.
    if  i-tipo-doc > 0 then do:
        assign l-pendente = no.
        run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente).
        if  l-pendente then do:
            assign requisicao.estado     = 2
                   requisicao.nome-aprov = "":U.
            /**  Melhorias **/
            assign it-requisicao.estado     = 2
                   it-requisicao.nome-aprov = "":U.
        end.
        else do:
            if  can-find (first b-it-requisicao 
                          where b-it-requisicao.nr-requisicao = it-requisicao.nr-requisicao 
                          and   b-it-requisicao.estado = 2 no-lock) then
                assign requisicao.estado     = 2 
                       requisicao.nome-aprov = "":U.
        end.
    end.
end.
/***************************************************************************
** Fim da Aprova‡Æo colocada conforme o CD1406a-v01
***************************************************************************/
if it-requisicao.num-ord-inv <> 0 and
   it-requisicao.num-ord-inv <> ? and
   requisicao.situacao = 3 and param-global.modulo-in = yes then do:
   assign requisicao.situacao = 1.
   for each bfit-requisicao 
      where bfit-requisicao.nr-requisicao = requisicao.nr-requisicao 
        and bfit-requisicao.situacao = 3 exclusive-lock:
        assign bfit-requisicao.situacao = 1.
   end.
end.

if  avail param-compra
and param-compra.log-1
and (  (i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao") 
    or (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao")
    or i-tipo-doc > 2 )
and lAprovacaoItem then do:
    run mensagemAprovacaoItemRequisicao.
end.
find current requisicao no-lock no-error.
find current it-requisicao no-lock no-error.

/********** run pi-msg-aprov. *********/

{method/svc/custom/custom.i &Event="AfterAll"}
/*{include/i-epc201.i "afterAll"}*/

IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
    RETURN "NOK":U.

return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldCodUtilizItRequisicao DBOProgram 
PROCEDURE validateFieldCodUtilizItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 

    if not l-classif AND c-cod-utiliz <> "" and (cPrograma <> "CD0738":U AND cPrograma <> "MIAPI103A":U AND cPrograma <> "MIAPI103B":U) then do:
            
        for first utiliz-natu-despes no-lock
            where utiliz-natu-despes.cod-nat-despesa = i-nat-desp 
              and utiliz-natu-despes.cod-utiliz = c-cod-utiliz: end.
        if avail utiliz-natu-despes then
            assign RowObject.ct-codigo = utiliz-natu-despes.ct-codigo
                   RowObject.sc-codigo = utiliz-natu-despes.sc-codigo.
        
        find first estabelec no-lock 
             where estabelec.cod-estabel = requisicao.cod-estabel no-error.
        if avail estabelec then
            assign iEmpresa = estabelec.ep-codigo when avail estabelec.
            
        IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

        run pi_valida_conta_contabil in h_api_cta_ctbl (input  iEmpresa,                    /* EMPRESA EMS2 */
                                                        input  RowObject.cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                        input  RowObject.cod-unid-negoc,    /* UNIDADE NEGàCIO */
                                                        input  "",                          /* PLANO CONTAS */ 
                                                        input  RowObject.ct-codigo,         /* CONTA */
                                                        input  "",                          /* PLANO CCUSTO */ 
                                                        input  RowObject.sc-codigo,         /* CCUSTO */
                                                        input  RowObject.dt-entrega,        /* DATA TRANSACAO */
                                                        output table tt_log_erro).          /* ERROS */
        IF VALID-HANDLE(h_api_cta_ctbl) THEN
            DELETE OBJECT h_api_cta_ctbl.

        for first tt_log_erro:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
            return "NOK".
        end.
      
    end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldItemItRequisicao DBOProgram 
PROCEDURE validateFieldItemItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/ 

      /* Verifica se o item/familia possui classifica‡Æo contÿbil (CD0250/CD0251) */
    if avail item then do:      
        for first item-uni-estab fields(it-codigo cod-estabel nat-despesa altera-conta) where
            item-uni-estab.it-codigo   = item.it-codigo and
            item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
        if avail item-uni-estab then do:
            assign i-nat-desp = item-uni-estab.nat-despesa
                   l-classif  = item-uni-estab.altera-conta.
        end.
        else do:
            for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta)
                where fam-mat-estab.fm-codigo   = item.fm-codigo
                and   fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                no-lock: end.
                if avail fam-mat-estab then 
                    assign i-nat-desp = fam-mat-estab.nat-despesa
                           l-classif  = fam-mat-estab.altera-conta.
                else 
                    assign i-nat-desp = item.nat-despesa
                           l-classif  = no.
        end.
        if not l-classif then do:
            if substring(usuar-mater.char-1,1,1) = "y" and 
               rowObject.num-ord-inv = 0 then do:  /**** Utiliza‡Æo de Material ******/
                for first natureza-despesa no-lock
                    where natureza-despesa.nat-despesa = i-nat-desp: end.
                if avail natureza-despesa and c-param = "add" then do:
                        for first utiliz-natu-despes no-lock
                            where utiliz-natu-despes.cod-nat-despesa = natureza-despesa.nat-despesa 
                              and utiliz-natu-despes.cod-utiliz      = c-cod-utiliz: end.
                        if avail utiliz-natu-despes then do:
                            for first utilizacao-mater fields (cod-utiliz des-utiliz) no-lock
                                where utilizacao-mater.cod-utiliz = utiliz-natu-despes.cod-utiliz: end.
                            assign substring(rowObject.char-2,1,12) = utiliz-natu-despes.cod-utiliz
                                   rowObject.ct-codigo              = utiliz-natu-despes.ct-codigo
                                   rowObject.sc-codigo              = utiliz-natu-despes.sc-codigo.
                        end.
                        else 
                            assign rowObject.ct-codigo = natureza-despesa.ct-codigo
                                   rowObject.sc-codigo = natureza-despesa.sc-codigo.
                end.
            end.
            if avail requisicao then 
                find usuar-mater where usuar-mater.cod-usuario = requisicao.nome-abrev no-lock no-error.
                if not l-ScCodigo /* disable */ then do:
                   if avail usuar-mater then 
                       assign rowObject.sc-codigo = usuar-mater.sc-codigo.
                end.
                /* se o campo estava habilitado na tela, a rowObject permanecerÿ com o valor informado */
        end.      
        if item.tipo-con-est <> 4 then
           assign rowObject.cod-refer = "".
    end.
      return "OK".          
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldNumOrdInvItRequisicao DBOProgram 
PROCEDURE validateFieldNumOrdInvItRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
  find first estabelec no-lock
       where estabelec.cod-estabel = requisicao.cod-estabel no-error.
  if avail estabelec and param-global.modulo-in = yes then
    assign i-ep-codigo-usuario = estabelec.ep-codigo.

/*/*---------------------- chamada IN2201 --------------------*/
 *   if RowObject.num-ord-inv <> 0 then do:
 *       run inp/in2201.p (input  rowobject.num-ord-inv,
 *                         input  yes,
 *                         output l-achou,
 *                         output c-ct-codigo,
 *                         output c-sc-codigo).
 *      
 *       if  l-achou = yes then do:
 *       
 *           assign iEmpresa = param-global.empresa-prin.
 *           &if defined (bf_dis_consiste_conta) &then
 *               find estabelec where
 *                    estabelec.cod-estabel = requisicao.cod-estabel no-lock no-error.
 *               if avail estabelec then     
 *               run cdp/cd9970.p (input  rowid(estabelec),
 *                                 output iEmpresa).
 *           &endif
 * 
 *           find conta-contab
 *               where conta-contab.ep-codigo = iEmpresa
 *               and   conta-contab.ct-codigo = c-ct-codigo
 *               and   conta-contab.sc-codigo = c-sc-codigo
 *               no-lock no-error.
 *           if  avail conta-contab then do:
 *               assign RowObject.conta-contabil = conta-contab.conta-contabil
 *                      RowObject.ct-codigo      = c-ct-codigo  
 *                      RowObject.sc-codigo      = c-sc-codigo    .   
 * 
 *           end.
 *           else do:
 *             /* Conta contÿbil nÆo cadastrada */
 *             {method/svc/errors/inserr.i
 *                                &ErrorNumber="47"
 *                                &ErrorType="EMS"
 *                                &ErrorSubType="ERROR" 
 *                                &ErrorParameters="'Conta Contÿbil'"}             
 *           end.
 *       end.
 *       else do: 
 *         /* Ordem de investimentos nÆo cadastrada */
 *             {method/svc/errors/inserr.i
 *                                &ErrorNumber="47"
 *                                &ErrorType="EMS"
 *                                &ErrorSubType="ERROR" 
 *                                &ErrorParameters="'Ordem de Investimento'"}             
 *       end.
 *   end. */
  
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN 
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateItemRequisicao DBOProgram 
PROCEDURE validateItemRequisicao :
/*------------------------------------------------------------------------------
  Purpose: Include: CD1406a.i3 Fun‡Æo.: Valida‡„es do item da requisi‡Æo    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/  

    DEFINE VARIABLE cErroAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCentroCusto LIKE it-requisicao.sc-codigo NO-UNDO.

   /* Valida‡Æo do movimento X conta cont bil de investimento */
   &IF DEFINED(bf_mat_conta_contab_inp) &THEN
       {inp/inapi060.i requisicao.cod-estabel rowObject.ct-codigo rowObject.sc-codigo rowObject.num-ord-inv NO tt-erro-invest}

       FIND FIRST param-global NO-LOCK NO-ERROR.

       IF  RETURN-VALUE = "NOK":U THEN DO:
           IF  rowObject.num-ord-inv <> 0 
           AND param-global.modulo-in
           AND (l-cd0738 =  YES OR l-cd0744b = YES OR l-miapi103a = YES OR l-miapi103b = YES)THEN DO: 
               /* conforme help dp IN0101 para ordem de producao/MI não deve ser validado a conta */ 
               FIND FIRST tt-erro-invest
                    WHERE tt-erro-invest.cd-erro = 28723
                       OR tt-erro-invest.cd-erro = 28722 NO-ERROR.
               IF AVAIL tt-erro-invest THEN
                   DELETE tt-erro-invest.
               ASSIGN l-cd0738    = NO
                      l-cd0744b   = NO
                      l-miapi103a = NO
                      l-miapi103b = NO.
           END.
           FIND FIRST tt-erro-invest EXCLUSIVE-LOCK NO-ERROR.
           IF AVAIL tt-erro-invest THEN DO:
               {method/svc/errors/inserr.i
                                  &ErrorNumber="tt-erro-invest.cd-erro"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="tt-erro-invest.c-param"}
               
               DELETE tt-erro-invest.
           END.
       END.
   &ENDIF
   /*----*/
   if c-param = "add" and
       can-find (b-it-requisicao where 
                 b-it-requisicao.nr-requisicao = rowObject.nr-requisicao and
                 b-it-requisicao.sequencia     = rowObject.sequencia) then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item-requisicao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item_Requisi‡Æo" *}
        ASSIGN c-lbl-liter-item-requisicao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                           &ErrorNumber="1"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="c-lbl-liter-item-requisicao"}  
   end.        
   assign i-tp-ressup = 1.

   &if defined(bf_mat_tipo_ressup) &then
       if avail item and requisicao.tp-requis > 1 then
           run cdp/cd1406a2.p (item.it-codigo,
                               requisicao.cod-estabel,
                               output i-tp-ressup).
   &endif

   /* Valida Centro de Custo - CE0101 */
   find first item-uni-estab where item-uni-estab.it-codigo   = item.it-codigo 
        and   item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
   if  substr(param-estoq.char-1,3,1) = "Y" and
       avail item-uni-estab                 and 
       item-uni-estab.altera-conta = no     and 
       rowobject.sc-codigo <> ""            then do:
         find usuar-ccusto where
            usuar-ccusto.sc-codigo   = rowObject.sc-codigo    and    
            usuar-ccusto.cod-usuario = requisicao.nome-abrev no-lock no-error.
      if  not avail usuar-ccusto then do:
           {method/svc/errors/inserr.i
                              &ErrorNumber="16040"
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"}
       end.
   end.
   assign l-deb-direto = no.

   find item where 
        item.it-codigo = rowObject.it-codigo
        no-lock no-error.
   if  not avail item then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                           &ErrorNumber="56"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="c-lbl-liter-item"}        
   end.
   else do:
          if can-find(estabelec 
             where estabelec.cod-estabel = requisicao.cod-estabel no-lock) then
                   for first item-uni-estab fields(it-codigo cod-estabel cod-obsoleto ) where
                        item-uni-estab.it-codigo   = item.it-codigo and
                        item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
          if avail item-uni-estab then do:
               if  requisicao.tp-requis = 2 or requisicao.tp-requis = 3 then do:
                   if  item-uni-estab.cod-obsoleto = 3 or item-uni-estab.cod-obsoleto = 4 then do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="1568"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"} 
                   end.
               end.
               if  requisicao.tp-requis = 1 then do:
                   if  item-uni-estab.cod-obsoleto = 4 then do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="1568"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"}                    
                   end.
               end.
          end.
          else do:
              {method/svc/errors/inserr.i
                                 &ErrorNumber="25904"
                                 &ErrorType="EMS"
                                 &ErrorSubType="ERROR" 
                                 &ErrorParameters= " string(item.it-codigo) + '~~~~' + string(requisicao.cod-estabel) "}  
          end.         
   
       if  item.tipo-contr = 4 and requisicao.tp-requis = 1 then do:
            {method/svc/errors/inserr.i
                               &ErrorNumber="1569"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="''"} 
       end.        
       if  param-global.modulo-cc then do:
           if can-find(estabelec 
               where estabelec.cod-estabel = requisicao.cod-estabel no-lock) then
                 for first item-uni-estab fields(it-codigo cod-estabel cod-comprado cod-grp-compra) where
                     item-uni-estab.it-codigo   = item.it-codigo and
                     item-uni-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
           
           if param-compra.int-2 = 1 then do:
               IF requisicao.tp-requis <> 1 THEN DO:
                   if avail item-uni-estab and item-uni-estab.cod-grp-compra = "" then do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="16419"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"} 
                   end.
               END.
           end.       
           if param-compra.int-2 = 2 then do:            
              if requisicao.tp-requis <> 1 then do:        
                    if avail item-uni-estab then
                       find comprador where comprador.cod-comprado = item-uni-estab.cod-comprado no-lock no-error.
                    if not avail comprador or comprador.cod-comprado = "" then do:
                        {method/svc/errors/inserr.i
                                           &ErrorNumber="15712"
                                           &ErrorType="EMS"
                                           &ErrorSubType="ERROR" 
                                           &ErrorParameters="''"} 

                    end.
              end.   
           end.              
       end.  
       if  item.tipo-con-est <> 2 and 
          (c-param = "add" or (c-param = "mod" and requisicao.tp-requis <> 1))           
          then do:
           if  rowObject.qt-a-atender = 0 then do:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="1570"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="''"} 
           end.
       end.
       if  requisicao.tp-requis <> 1 and requisicao.tp-requis <> 3 then do:
           if  item.tipo-contr = 4 and rowObject.preco-unit = 0 then do:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="1573"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR" 
                                       &ErrorParameters="''"}         
           end.
       end.
   end.
   
   if avail item then do:
        if  not(item.fraciona)
        and rowObject.qt-a-atender <>
            rowObject.qt-a-atender then do:
            /* Quantidade deve ser um valor inteiro */
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="847"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="''"} 
        end.
   end.   
   if avail item then do:
        if  rowObject.it-codigo = ?
        or  rowObject.it-codigo = ""
        or  item.tipo-contr = 4 then do:
            find first tab-unidade
                where  tab-unidade.un = rowObject.un
                no-lock no-error.
            if  not avail tab-unidade then do:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Unidade_de_Medida" *}
                 ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                                    &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-unidade-de-medida"} 
            end.
            
            find first item-fornec 
                where item-fornec.ativo and
                      item-fornec.it-codigo = item.it-codigo
                      no-lock no-error.
            if avail item-fornec then do:
                if  rowObject.un <> item.un then do: 
                     {method/svc/errors/inserr.i
                                        &ErrorNumber="1571"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"} 
                end.
            end.
        end.
        else do:
              if  rowObject.un <> item.un then do:
                   {method/svc/errors/inserr.i
                                      &ErrorNumber="1571"
                                      &ErrorType="EMS"
                                      &ErrorSubType="ERROR"} 
              end.
        end.     
   end.     
   if avail item then do:
        if  item.tipo-contr = 4
        and item.it-codigo  = ""
        and rowObject.narrativa = "" then do:
             {method/svc/errors/inserr.i
                                &ErrorNumber="1572"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="''"}
        end.
   end.     
/*   if  rowObject.num-ord-inv <> 0 then do:
 *        run inp/in2201.p (input  rowobject.num-ord-inv,
 *                          input  no,
 *                          output l-achou,
 *                          output c-ct-codigo,
 *                          output c-sc-codigo).
 *        if  l-achou = no then do:
 *            /* Ordem de Investimento nÆo cadastrado */
 *                 {method/svc/errors/inserr.i
 *                                    &ErrorNumber="56"
 *                                    &ErrorType="EMS"
 *                                    &ErrorSubType="ERROR" 
 *                                    &ErrorParameters="'Ordem de Investimento'"} 
 *        end.
 *    end.*/
   
   /* Verifica se o item/familia possui classifica‡Æo contÿbil (CD0250/CD0251) */
   /* Release 2.02 */ 
   if avail item then do:
           if can-find(estabelec 
              where estabelec.cod-estabel = requisicao.cod-estabel no-lock) then
              for first item-uni-estab fields (it-codigo cod-estabel nat-despesa altera-conta) /*nat-despesa*/
                where item-uni-estab.it-codigo   = rowObject.it-codigo
                and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                no-lock: end.				
           if avail item-uni-estab then
                assign l-classif  = item-uni-estab.altera-conta
                       i-nat-desp = item-uni-estab.nat-despesa. /*nat-despesa*/
           else do:
                for first fam-mat-estab fields (fm-codigo cod-estabel nat-despesa altera-conta) /*nat-despesa*/
                    where fam-mat-estab.fm-codigo   = item.fm-codigo
                     and  fam-mat-estab.cod-estabel = requisicao.cod-estabel 
                    no-lock: end.
                if avail fam-mat-estab then
                    assign l-classif  = fam-mat-estab.altera-conta
                           i-nat-desp = fam-mat-estab.nat-despesa. /*nat-despesa*/
                else 
                    assign l-classif = NO
                           i-nat-desp = item.nat-despesa.			   
           end.
   end.
   /* Se nÆo utilizar Classifica‡Æo Contÿbil ou utilizar e o usuÿrio alterou a conta
       do documento (tinha permissÆo/utiliza‡Æo de material), valida a conta */     
   if not l-classif then do:     
        find first estabelec no-lock 
             where estabelec.cod-estabel = requisicao.cod-estabel no-error.
        if avail estabelec then      
            assign iEmpresa = estabelec.ep-codigo when avail estabelec.

        IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
            RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

        run pi_valida_conta_contabil in h_api_cta_ctbl (input  iEmpresa,                    /* EMPRESA EMS2 */
                                                        input  RowObject.cod-estabel,       /* ESTABELECIMENTO EMS2 */
                                                        input  RowObject.cod-unid-negoc,    /* UNIDADE NEGàCIO */
                                                        input  "",                          /* PLANO CONTAS */ 
                                                        input  RowObject.ct-codigo,         /* CONTA */
                                                        input  "",                          /* PLANO CCUSTO */ 
                                                        input  RowObject.sc-codigo,         /* CCUSTO */
                                                        input  RowObject.dt-entrega,        /* DATA TRANSACAO */
                                                        output table tt_log_erro).          /* ERROS */
        FOR EACH tt_log_erro NO-LOCK:           
            {utp/ut-liter.i "C¢digo Erro Financeiro: "}                                                                                     
            ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).                                                
            {method/svc/errors/inserr.i                                                                                                     
                             &ErrorNumber="52046"                                                                                           
                             &ErrorType="EMS"                                                                                               
                             &ErrorSubType="ERROR"                                                                                          
                             &ErrorParameters= "tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux"} 
        END.
        
        IF NOT CAN-FIND(tt_log_erro) THEN DO :
            /** Busca as informa‡äes da conta **/
            RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT  iEmpresa,                    /* EMPRESA EMS2 */
                                                           INPUT  "",                          /* PLANO CONTAS */ 
                                                           INPUT-OUTPUT  RowObject.ct-codigo,  /* CONTA */
                                                           INPUT  TODAY,                       /* DATA TRANSACAO */
                                                           OUTPUT v_des_cta_ctbl,              /* Descri‡Æo da Contas. */
                                                           OUTPUT v_num_tip_cta_ctbl,          /* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Tðtulo. */
                                                           OUTPUT v_num_sit_cta_ctbl,          /* Situa‡Æo da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
                                                           OUTPUT v_ind_finalid_cta,           /* Finalidade da Conta. */
                                                           OUTPUT TABLE tt_log_erro).          /* ERROS */
            IF VALID-HANDLE(h_api_cta_ctbl) THEN
                DELETE OBJECT h_api_cta_ctbl.
        
           /* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Tðtulo. */
           IF ((v_num_tip_cta_ctbl <> 1 AND
                v_num_tip_cta_ctbl <> 2 AND
                v_num_tip_cta_ctbl <> 4 AND
                v_num_tip_cta_ctbl <> 5) OR 
                v_num_sit_cta_ctbl <> 3) THEN DO: /* Situa‡Æo da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
               /* Conta deve ser de Despesa, Passivo ou Ativo, e de Sistema */
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-conta-ordem AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Conta_Ordem" *}
               ASSIGN c-lbl-liter-conta-ordem = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-deve-ter-tipo-despesa-receita AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "deve_ter_tipo:_Despesa,_Receita,_Passivo,_Ativo_ou_T¡tulo_e_Situa‡Æo_igual_a_Ativa" *}
               ASSIGN c-lbl-liter-deve-ter-tipo-despesa-receita = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                                  &ErrorNumber="52046"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="c-lbl-liter-conta-ordem + ' ' + String(RowObject.ct-codigo) + ' ' + c-lbl-liter-deve-ter-tipo-despesa-receita"}
            END.
        END.
        ELSE DO:
            IF VALID-HANDLE(h_api_cta_ctbl) THEN
                DELETE OBJECT h_api_cta_ctbl.

            RETURN "NOK":U.
        END.
        
        /* Verifica Estoque */
        assign ind       = 1
               i-estoque = 0.
        do while ind <= 10:
            assign v_cod_finalid = {adinc/i05ad049.i 4 ind}.
        
            if lookup(v_cod_finalid, v_ind_finalid_cta) > 0 then do:
                assign i-estoque = ind.
                leave.
            end.
        
            assign ind = ind + 1.
        end.
        
       /** Conta nÆo ‚ de Consumo **/
         /* 1 Consumo                    
            2 NÆo Consumo                
            3 Ordem servi‡o              
            4 Transferˆncia              
            5 MÆo-de-obra                
            6 Custo mercadoria vendida   
            7 Transit¢ria de compras     
            8 Transit¢ria de devolu‡Æo   
            9 Saldo por grupo de estoque 
            10 NÆo gera lan‡amentos         */
       if not can-find(tt_log_erro) and 
          (i-estoque = 0  or  
          (i-estoque <> 1 and           /* Consumo                  */
           i-estoque <> 2 and           /* NÆo Consumo              */
           i-estoque <> 3 and           /* Ordem servi‡o            */
           i-estoque <> 5 and           /* MÆo-de-obra              */ 
           i-estoque <> 6)) then do:    /* Custo mercadoria vendida */
            /* Conta contabil nao aceita movimento */
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-conta-ordem-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Conta_Ordem" *}
            ASSIGN c-lbl-liter-conta-ordem-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-deve-ter-finalidade-consumo-na AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "deve_ter_finalidade:_Consumo,_NÆo_Consumo,_Ordem_Servi‡o,_MÆo_de_Obra_ou_Custo_Mercadoria_Vendida" *}
            ASSIGN c-lbl-liter-deve-ter-finalidade-consumo-na = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="52046"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-conta-ordem-2 + ' ' + String(RowObject.ct-codigo) + ' ' + c-lbl-liter-deve-ter-finalidade-consumo-na"}
       end.
   end.
    
   if substring(usuar-mater.char-1,1,1) = "y" and rowobject.num-ord-inv = 0 then do:      
       find first utilizacao-mater no-lock 
            where utilizacao-mater.cod-utiliz = c-cod-utiliz no-error.
       if not avail utilizacao-mater then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-utilizacao-de-materias AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Utiliza‡Æo_de_Materias" *}
            ASSIGN c-lbl-liter-utilizacao-de-materias = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="56"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-utilizacao-de-materias"}  
       end.
       for first utiliz-natu-despes no-lock
           where utiliz-natu-despes.cod-nat-despesa = i-nat-desp 
             and utiliz-natu-despes.cod-utiliz = c-cod-utiliz: end.
       if not avail utiliz-natu-despes then do:
            {method/svc/errors/inserr.i
                               &ErrorNumber="16848"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="string(i-nat-desp) + '~~~~' + c-cod-utiliz"}
       end.
   end.
   
   if rowObject.dt-entrega < today then do:
        {method/svc/errors/inserr.i
                           &ErrorNumber="1578"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR" 
                           &ErrorParameters="''"}         
   end.

    /*****  Aprova‡Æo EletrËnica  *****/
    assign i-tipo-trans = if c-param = "add" then 1 else 2
           i-tipo-doc = 0.  /*Inicializa com Zero*/

    if  requisicao.tp-requis = 1    /*Se for Requisicao e Aprova Requisicao*/
    and substr(param-estoq.char-1,4,1) = "Y"
    and param-compra.log-1  then
        assign i-tipo-doc = 2.
    else if  requisicao.tp-requis = 2 /*SenÆo, Se for Solicita‡Æo e utiliza aprova‡Æo eletrËnica*/
         and param-compra.log-1 then
        assign i-tipo-doc = 1.

   IF  i-tipo-doc > 0 THEN DO:
       IF  NOT CAN-FIND(funcao WHERE
                    funcao.cd-funcao = "Integra_MLA_EMS" AND
                    funcao.ativo     = YES) THEN DO:

           RUN cdp/cdapi173.p (INPUT  i-tipo-doc,
                               INPUT  rowObject.it-codigo,
                               INPUT  requisicao.nome-abrev,
                               OUTPUT l-retorno-aprov).

           /*  Inicio EPC Grendene */
           FOR EACH tt-epc
               WHERE tt-epc.cod-event = "validateItem" NO-LOCK:
               DELETE tt-epc.
           END.

           CREATE tt-epc.
           ASSIGN tt-epc.cod-event     = "validateItem":U
                  tt-epc.cod-parameter = "retorno-aprov":U
                  tt-epc.val-parameter = STRING(l-retorno-aprov).

           CREATE tt-epc.
           ASSIGN tt-epc.cod-event     = "validateItem":U
                  tt-epc.cod-parameter = "item":U
                  tt-epc.val-parameter = rowObject.it-codigo.

           {include/i-epc201.i "validateItem"}

           FIND FIRST tt-epc
                WHERE tt-epc.cod-event     = "validateItem":U
                AND tt-epc.cod-parameter = "retorno-aprov":U NO-ERROR.

           IF AVAIL tt-epc THEN
               ASSIGN l-retorno-aprov = IF tt-epc.val-parameter = "yes" THEN YES ELSE NO.
               IF CAN-FIND(FIRST tt-erro) THEN
                   ASSIGN l-retorno-aed   = IF tt-epc.val-parameter = "yes" THEN YES ELSE NO.

           /* Fim EPC Grendene */ 
           IF  NOT l-retorno-aed THEN DO:
               FIND FIRST tt-erro NO-ERROR.
               IF  AVAIL tt-erro THEN DO:
                   {method/svc/errors/inserr.i
                                      &ErrorNumber="tt-erro.cd-erro"
                                      &ErrorType="EMS":U
                                      &ErrorSubType="ERROR" :U
                                      &ErrorParameters="tt-erro.c-param"}
               END. 
           END.

           IF  NOT l-retorno-aprov THEN DO:
               {method/svc/errors/inserr.i
                                  &ErrorNumber="15661"
                                  &ErrorType="EMS"
                                  &ErrorSubType="ERROR" 
                                  &ErrorParameters="''"}                                
           END.
       END.
   END.

   /*****  Estatisticas Compras  *****/
   if c-param = "mod"
   then do:
       run ccp/ccapi642.p (1, rowid(it-requisicao), 3).
   end.
   /**********************************/
   /* Fim da Include */

    return "OK".   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateQuantidadeItemSerie DBOProgram 
PROCEDURE validateQuantidadeItemSerie :
/*------------------------------------------------------------------------------
  Purpose:     validateQuantidadeItemSerie
  Parameters:  <none>
  Notes:       tratamento para quantidade de item controlado por n£mero de s‚rie
------------------------------------------------------------------------------*/
/*Item controlado por N£mero de S‚rie, quantidade deve ser 1*/
if  item.tipo-con-est = 2 and
    it-requisicao.qt-a-atender > 1 then do:
    assign it-requisicao.qt-a-atender = 1.
    {method/svc/errors/inserr.i
                &ErrorNumber="30018"
                &ErrorType="EMS"
                &ErrorSubType="INFORMATION" 
                &ErrorParameters="''"} 
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, )
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parümetro pType para identificar quais as valida¯´es a serem
          executadas ---*/
    /*--- Os valores possðveis para o parümetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida¯´es ---*/

    /*--- Verifica ocorrˆncia de erros ---*/

   /** Valida‡äes de Cria‡Æo do registro **/
   if pType = "CREATE":U then do:
      /*****************************************************************************************************/
      /** Valida‡äes utilizadas apenas para quando a BO for executada pelo CD0738, MIAPI103A E MIAPI103B. **/
      /** OBS: necess rio isto, para nÆo interferir no processo WEBSPEED do CD1406                        **/
      /*****************************************************************************************************/
      if cPrograma = "CD0738":U OR cPrograma = "MIAPI103A":U OR cPrograma = "MIAPI103B":U then do:
          /*** Requisitante inexistente***/
          if not can-find (first requisitante
                           where requisitante.nome-abrev = RowObject.nome-abrev no-lock) then do:
              {utp/ut-liter.i "Requisitante Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /***  Item Inexistente ***/
          if not can-find (first item
                           where item.it-codigo = RowObject.it-codigo no-lock) then do:
              {utp/ut-liter.i "Item Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /*** Quantidade nÆo pode ser igual a zero**/
          if RowObject.qt-atendida = 0 and RowObject.qt-a-atender = 0 then do:
              {utp/ut-liter.i "Quantidade deve ser diferente de zero"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="1570"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="return-value"}
          end.
          /***Unidade de medida Inexistente***/
          if not can-find (first tab-unidade
                           where tab-unidade.un = rowObject.un no-lock) then do:
              {utp/ut-liter.i "Unidade de Medida Inexistente"}
              {method/svc/errors/inserr.i
                      &ErrorNumber="17567"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR" 
                      &ErrorParameters="return-value"}
          end. 
      end.
      /******************************************************************************/
      /**                    Fim das valida‡äes para o CD0738                      **/
      /******************************************************************************/
      &IF DEFINED(bf_mnt_ems206b) &THEN
         IF l-usa-unid-negoc = YES THEN DO:
             FIND FIRST ord-prod WHERE
                        ord-prod.nr-ord-produ =  iNrOrdProdu NO-LOCK NO-ERROR.
                
             IF AVAIL ord-prod AND (ord-prod.origem = "MI" OR ord-prod.origem = "MV")
                               AND AVAIL requisicao 
                               AND requisicao.tp-requis = 2 THEN DO:

                 IF NOT AVAIL param-mat OR param-mat.ind-unid-neg = NO THEN DO:
                     {method/svc/errors/inserr.i
                     &ErrorNumber="34475"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="return-value"}
                 END.
             END.             
         END.
      &endif

   end. /** CREATE **/

   IF NOT AVAIL it-requisicao THEN
      FIND FIRST it-requisicao WHERE it-requisicao.nr-requisicao  = RowObject.nr-requisicao    
                                 AND it-requisicao.sequencia      = RowObject.sequencia EXCLUSIVE-LOCK NO-ERROR.

   IF  pType = "Update":U OR pType = "Delete" THEN DO:
       FOR FIRST usuar-mater 
           WHERE usuar-mater.cod-usuario = c-seg-usuario
           AND substring(usuar-mater.char-1,10,01) = "N" NO-LOCK:
           IF  c-seg-usuario NE it-requisicao.nome-abrev THEN DO:
               {method/svc/errors/inserr.i &ErrorNumber="27706"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U} 
           END.
       END.
   END.

    IF pType = "DELETE":U THEN DO:
        FIND FIRST doc-pend-aprov
             WHERE doc-pend-aprov.nr-requisicao = RowObject.nr-requisicao
               AND doc-pend-aprov.sequencia     = RowObject.sequencia
               AND doc-pend-aprov.it-codigo     = RowObject.it-codigo EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL doc-pend-aprov THEN
            DELETE doc-pend-aprov.
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereDtEntrega DBOProgram 
PROCEDURE sugereDtEntrega :
/*------------------------------------------------------------------------------
  Purpose:   Sugere Data de Entrega de Acordo com a quantidade de ressuprimento
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT    PARAMETER pItCodigo   AS CHARACTER NO-UNDO.
DEFINE INPUT    PARAMETER pCodEstabel AS CHARACTER NO-UNDO.
DEFINE INPUT    PARAMETER pOrigem     AS CHARACTER NO-UNDO.
DEFINE INPUT    PARAMETER pNrOrdProdu AS INTEGER   NO-UNDO.
DEFINE OUTPUT   PARAMETER pDtEntrega  AS DATE      NO-UNDO.

DEFINE VARIABLE dias-ressup   AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-erro-calend AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-cd-calen    AS CHARACTER   NO-UNDO.

/* Verifica se o item/familia possui classifica‡Æo cont bil (CD0250/CD0251) */
FOR FIRST item-uni-estab WHERE
          item-uni-estab.it-codigo   = pItCodigo AND
          item-uni-estab.cod-estabel = pCodEstabel NO-LOCK: 
    IF AVAIL item-uni-estab THEN DO:
        /* considera somente dias £teis */
        ASSIGN dias-ressup = item-uni-estab.res-int-comp + item-uni-estab.res-for-comp.

        FIND FIRST param-compra NO-LOCK NO-ERROR.
        
        IF AVAIL param-compra AND SUBSTRING(param-compra.char-1,136,1) = "1" THEN DO:
			ASSIGN pDtEntrega = TODAY. 

            IF pOrigem = 'MI' THEN DO:
                IF NOT VALID-HANDLE(h-bomn134) THEN
                    RUN mnbo/bomn134.p PERSISTENT SET h-bomn134.

                RUN buscaCalenData IN h-bomn134 (INPUT  pNrOrdProdu, 
                                                 OUTPUT c-cd-calen).

                IF VALID-HANDLE(h-bomn134) THEN
                    DELETE OBJECT h-bomn134.    
            END.

            IF pOrigem = 'MV' THEN DO:
                IF NOT VALID-HANDLE(h-bofr072) THEN
                    RUN frbo/bofr072.p PERSISTENT SET h-bofr072.

                RUN buscaCalenData IN h-bofr072 (INPUT  pNrOrdProdu, 
                                                 OUTPUT c-cd-calen).

                IF VALID-HANDLE(h-bofr072) THEN
                    DELETE OBJECT h-bofr072.    
            END.

            {inbo/boin356.i3 "c-cd-calen"} 
		END.
        IF (AVAIL param-compra AND substring(param-compra.char-1,136,1) = " ") OR l-erro-calend THEN
            ASSIGN pDtEntrega = today + dias-ressup.

    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterUpdateRecord DBOProgram 
PROCEDURE AfterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  cNomeAbrevNovo <> "" THEN DO:
        FIND FIRST requisicao
             WHERE requisicao.nr-requisicao = RowObject.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL requisicao THEN DO:
            ASSIGN RowObject.nome-abrev = cNomeAbrevNovo.
                   requisicao.nome-abrev = cNomeAbrevNovo.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetNomeAbrevNovo DBOProgram 
PROCEDURE SetNomeAbrevNovo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNomeAbrevNovo AS CHARACTER NO-UNDO.

    ASSIGN cNomeAbrevNovo = pNomeAbrevNovo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

