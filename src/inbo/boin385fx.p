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
{include/i-prgvrs.i BOIN385FX 2.00.00.018 } /*** "010018" 09/05/2025 15:10:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin385fx MUT}
&ENDIF
/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName requisicao
&GLOBAL-DEFINE TableLabel requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin385.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.

{cdp/cdcfgmat.i}
{utp/ut-glob.i} /* Vari†veis Globais */
{cdp/cd0669.i}  /*tt-erro*/
{cdp/cd1001.i}  /* definiá∆o tt_xml_input_1 */
{inbo/boin168.i tt-it-requisicao}
{inbo/boin658fx.i ttUnidNegRequis} 

def new global shared var l-especial    as log      no-undo. /* indica que o n£mero da requisiá∆o deve ser sugerido pela faixa de Solic. Especial */

def var c-diferencas                    as char     no-undo. /* vari†vel utilizada para armazenar o resultado da comparaá∆o de registros alterados */

def var de-preco-unit                   as dec      no-undo.
def var i-tipo-doc                      as int      no-undo.
def var i-moeda-lim                     as int      no-undo.
def var i-tipo-moeda                    as int      no-undo.
def var de-valor-doc                    as dec      no-undo.
def var de-valor-lim                    as dec      no-undo.
def var c-tipo-moeda                    as char     no-undo.
def var c-moeda-lim                     as char     no-undo.
def var l-pendente                      as log      no-undo.
def var i-tipo-trans                    as int      no-undo.
def var de-valor-item                   as dec      no-undo.
def var de-valor-total                  as dec      no-undo.
def var i-tipo-req-old                  like requisicao.tp-requis no-undo.
def var i-tipo-doc-old                  as int      no-undo.    


/* Vari†veis para traduá∆o */                                           
def var c-lst-situacao                  as char                         no-undo.

def var h-boin168sdfx                   as handle   no-undo.
def var h-boin168fx                     as handle   no-undo.

def var l-integra-aed-ems               as log      no-undo.
assign l-integra-aed-ems = can-find(first funcao
                                    where funcao.cd-funcao = "Integra_AED_EMS"
                                      and funcao.ativo     = yes).

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
         HEIGHT             = 17.42
         WIDTH              = 45.57.
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

/* Situaá∆o da requisiá∆o */
assign c-lst-situacao = {ininc/i01in385.i 03}.
run utp/ut-list.p (input-output c-lst-situacao).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
    for first requisicao fields(tp-requis) no-lock
        where requisicao.nr-requisicao = RowObject.nr-requisicao:
        assign i-tipo-req-old = requisicao.tp-requis.
    end.

    if  i-tipo-req-old = 1                            /* Requisiá∆o Estoque */
        and param-compra.log-1                        /* Aprovaá∆o Eletrìnica */
        and substr(param-estoq.char-1,4,1) = "Y" then /* Aprovaá∆o Requisiá∆o */
           assign i-tipo-doc-old = 2.
        else if i-tipo-req-old = 2                    /* Solicitaá∆o de Compra */
            and param-compra.log-1 then               /* Aprovaá∆o Eletrìnica */
            assign i-tipo-doc-old = 1.
        else 
            assign i-tipo-doc-old = 0.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    if  lookup("nome-abrev",c-diferencas)  <> 0
    or  lookup("cod-estabel",c-diferencas) <> 0
    or  lookup("tp-requis",c-diferencas)   <> 0 then do:

        if  lookup("cod-estabel",c-diferencas) <> 0 then do:
            IF NOT VALID-HANDLE(h-boin168sdfx) THEN
                RUN inbo/boin168sdfx.p PERSISTENT SET h-boin168sdfx.
        end.

        for each it-requisicao
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao exclusive-lock:
    
            /*******************************************************************************
            Atualizaá∆o do requisitante no item da requisiá∆o.
            *******************************************************************************/
            if  lookup("nome-abrev",c-diferencas) <> 0 then
                assign it-requisicao.nome-abrev = RowObject.nome-abrev.
    
            /*******************************************************************************
            Atualizaá∆o do tipo da requisiá∆o no item da requisiá∆o.
            *******************************************************************************/
            &if "{&bf_mat_versao_ems}" >= "2.071" &then
                if  lookup("tp-requis",c-diferencas) <> 0 then
                    assign it-requisicao.tp-requis = RowObject.tp-requis.
            &endif
            /*******************************************************************************
            Atualizaá∆o do estabelecimento no item da requisiá∆o.
            Atualizaá∆o do preáo do item ap¢s a alteraá∆o do estabelecimento na requisiá∆o
            *******************************************************************************/
            if  lookup("cod-estabel",c-diferencas) <> 0 then do:
    
                assign it-requisicao.cod-estabel = RowObject.cod-estabel.
    
                {cdp/finditem.i it-requisicao.it-codigo}
                if  avail item then do:
        
                    if item.tipo-contr <> 1 then do: /* F°sico */
        
                        empty temp-table tt-it-requisicao.
            
                        create tt-it-requisicao.
                        buffer-copy it-requisicao using nr-requisicao sequencia it-codigo
                            to tt-it-requisicao.
            
                        run setDefaults in h-boin168sdfx (input  "update",
                                                           input  "",
                                                           input  table tt-it-requisicao,
                                                           input  table ttUnidNegRequis,
                                                           output table tt-it-requisicao,
                                                           output table ttUnidNegRequis).
            
                        run setUnitPriceItem in h-boin168sdfx (output de-preco-unit).
        
                        assign it-requisicao.preco-unit = de-preco-unit
                               it-requisicao.val-item   = it-requisicao.qt-a-atender * de-preco-unit.
                    end.
                end.
            end.

            /*** EXECUÄ«O ORÄAMENTµRIA ***/
            if  lookup("cod-estabel",c-diferencas)    <> 0
            or  (    lookup("tp-requis",c-diferencas) <> 0
                 and RowObject.tp-requis <> 3) then do: /* Solicitaá∆o Cotaá∆o */

                run cdp/cdapi198.p (input rowid(it-requisicao),
                                    input 2, /* confirmaá∆o */
                                    input yes,
                                    input-output table tt_xml_input_1).
                if  return-value = "NOK" then 
                    return "NOK".
            end.                                                                              
            /*****************************/

            /*** INVESTIMENTOS ***/
            if  connected("mginv")
            and param-global.modulo-in
            and it-requisicao.num-ord-inv <> 0 then do:

                run inp/in2101.p(input RowObject.r-rowid, 
                                 input rowid(it-requisicao),
                                 input "Modifica").
                if  return-value = "NOK" then
                    return "NOK".

                if  requisicao.situacao = 3 then /* Incompleta */
                    assign requisicao.situacao = 1. /* Aberta */
                if  it-requisicao.situacao = 3 then /* Incompleta */
                    assign it-requisicao.situacao = 1. /* Aberta */
            end.
            /*********************/

        end.
        IF h-boin168sdfx <> ? AND VALID-HANDLE(h-boin168sdfx) THEN DO:
            DELETE PROCEDURE h-boin168sdfx.
            ASSIGN h-boin168sdfx = ?.
        END.
    end.

    /* Atualizaá∆o Aprovaá∆o Eletrìnica */
    run updateEletronicApproval.

    RETURN "OK".
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

    /*** APROVAÄ«O ELETR‚NICA ***/
    if  RowObject.tp-requis = 1                   /* Requisiá∆o Estoque */
    and param-compra.log-1                        /* Aprovaá∆o Eletrìnica */
    and substr(param-estoq.char-1,4,1) = "Y" then /* Aprovaá∆o Requisiá∆o */
       assign i-tipo-doc = 2.
    else if RowObject.tp-requis = 2 /* Solicitaá∆o de Compra */
        and param-compra.log-1 then /* Aprovaá∆o Eletrìnica */
        assign i-tipo-doc = 1.
    else 
        assign i-tipo-doc = 0.
    /******************************/

    IF NOT VALID-HANDLE(h-boin168fx) THEN
        RUN inbo/boin168fx.p PERSISTENT SET h-boin168fx.

    run openQueryStatic in h-boin168fx (input "Main").

    for each it-requisicao
        where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:

        /*** APROVAÄ«O ELETR‚NICA ***/
        if  i-tipo-doc > 0 then
            run cdp/cdapi171.p (input i-tipo-doc,
                                input 3, /* Eliminaá∆o */
                                input rowid(it-requisicao)).
        /******************************/
                
        /*** Eliminaá∆o dos Itens da Requisiá∆o ***/
        run emptyRowErrors   in h-boin168fx.
        run repositionRecord in h-boin168fx (input rowid(it-requisicao)).
        run deleteRecord     in h-boin168fx.

        if  return-value = "NOK" then do:
            run getRowErrors in h-boin168fx (output table RowErrors).

            for each RowErrors
                where RowErrors.ErrorType = "INTERNAL":
                delete RowErrors.
            end.

            if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
                return "NOK".
        end.
        /******************************************/
    end.

    IF h-boin168fx <> ? AND VALID-HANDLE(h-boin168fx) THEN DO:
        DELETE PROCEDURE h-boin168fx.
        ASSIGN h-boin168fx = ?.
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eletronicApprovalMessage DBOProgram 
PROCEDURE eletronicApprovalMessage :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    
    /* VERIFICAR SE ESTE PONTO DO PROGRAMA ESTµ CORRETO */
    
    find first param-compra no-lock no-error.

    /**
    ***   Mensagem de Aprovaá∆o
    **/
    if i-tipo-doc = 0 then do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}         
        return "NOK"  .             
    end.  

    for each it-requisicao 
        where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:
        run cdp/cdapi174.p (i-tipo-doc,
                            rowid(it-requisicao),
                            output i-moeda-lim,
                            output i-tipo-moeda,
                            output de-valor-doc,
                            output de-valor-lim).
        find moeda where
            moeda.mo-codigo = i-moeda-lim
            no-lock no-error.
        assign c-moeda-lim  = string(i-moeda-lim,"9") + " - " + moeda.descricao.
        case i-tipo-moeda:
            when 1 then do:
                {utp/ut-liter.i (Usu†rio) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 2 then do:
                {utp/ut-liter.i (Aprovador) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 3 then do:
                {utp/ut-liter.i (Fam°lia) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 4 then do:
                {utp/ut-liter.i (Mestre) * r}
                assign c-tipo-moeda = return-value.
            end.
        end case.
        
        if  avail param-compra and 
            param-compra.log-1 and
            ((i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao") or
             (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao") or
              i-tipo-doc > 2 ) then do:
              
            if requisicao.tp-requis = 1 then 
               {utp/ut-liter.i Requisiá∆o}
            else 
               {utp/ut-liter.i Solicitaá∆o}

               if  not l-pendente then do:
                    {method/svc/errors/inserr.i &ErrorNumber="18346"
                                                &ErrorType="EMS"
                                                &ErrorSubType="INFORMATION"
                                                &ErrorParameters="trim(return-value) + ' ' 
                                                                 + string(requisicao.nr-requisicao) + '~~~~'
                                                                 + c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}                     

               end.
               else do:
                    {method/svc/errors/inserr.i &ErrorNumber="18347"
                                                &ErrorType="EMS"
                                                &ErrorSubType="INFORMATION"
                                                &ErrorParameters="trim(return-value) + ' ' 
                                                                 + string(requisicao.nr-requisicao) + '~~~~'
                                                                 + c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}                 
               end.
        end.
        else do:               
            if  l-pendente = no then do:
                {method/svc/errors/inserr.i &ErrorNumber="16725"
                                            &ErrorType="EMS"
                                            &ErrorSubType="INFORMATION"
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             
            end.
            else do:
                {method/svc/errors/inserr.i &ErrorNumber="16724"
                                            &ErrorType="EMS"
                                            &ErrorSubType="INFORMATION"
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             

            end.
            leave.
        end.   
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        WHEN "loc-entrega" THEN ASSIGN pFieldValue = RowObject.loc-entrega.
        WHEN "narrativa" THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev" THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-aprov" THEN ASSIGN pFieldValue = RowObject.nome-aprov.
        WHEN "char-1" THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2" THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum" THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel" THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "ct-codigo" THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo" THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        WHEN "data-1" THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2" THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atend" THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-devol" THEN ASSIGN pFieldValue = RowObject.dt-devol.
        WHEN "dt-requisicao" THEN ASSIGN pFieldValue = RowObject.dt-requisicao.
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        WHEN "dec-1" THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2" THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        WHEN "estado" THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "impressa" THEN ASSIGN pFieldValue = RowObject.impressa.
        WHEN "int-1" THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2" THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao" THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-id-documento" THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "situacao" THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-requis" THEN ASSIGN pFieldValue = RowObject.tp-requis.
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ESTAB-REQ
  Parameters:
               retorna valor dos campos do °ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK".

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-requisicao = RowObject.nr-requisicao.

    RETURN "OK".
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        WHEN "log-1" THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2" THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK" ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK".

    CASE pFieldName:
        OTHERWISE RETURN "NOK".
    END CASE.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:
               
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.
   
    
    FIND FIRST bfrequisicao WHERE
        bfrequisicao.nr-requisicao = pnr-requisicao 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK" ---*/
    IF NOT AVAILABLE bfrequisicao THEN
        RETURN "NOK".

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK" ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrequisicao)).
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

        RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE identifyChanges DBOProgram 
PROCEDURE identifyChanges :
/*------------------------------------------------------------------------------
  Purpose:     Identificar os campos alterados
  Parameters:  pDiferencas: lista dos campos alterados, separados por v°rgula
  Notes:       Identifica os campos alterados para executar regras de neg¢cio
               que est∆o atreladas ao campo alterado.
------------------------------------------------------------------------------*/

    def output param pDiferencas        as char     no-undo.

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then
        buffer-compare requisicao to RowObject
            save result in pDiferencas.

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

/*
       /* Se as tràs vari†veis abaixo forem iguais o tipo da requisicao pode ser 
          igualada sem utilizar a cl†usula 'OR' que causava muitos acessos a base */
       IF  ifiltro1 = ifiltro2
       AND ifiltro1 = ifiltro3 THEN DO:
           IF  laberta
           AND lfechada
           AND lpendente
           AND lcomordem THEN
               /* Quando for parametrizado para mostrar todas as situaá‰es 
                  de requisicao n∆o ser† restringido o campo situaá∆o */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND {&TABLENAME}.tp-requis      = ifiltro1 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
           ELSE
           IF laberta
           AND NOT lfechada
           AND NOT lpendente
           AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as abertas 
                  ser† restringido o campo situacao = 1 */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND {&TABLENAME}.tp-requis      = ifiltro1            
                          AND {&TABLENAME}.situacao       = 1 NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
            IF  NOT laberta
            AND lfechada
            AND NOT lpendente
            AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as fechadas 
                  ser† restringido o campo situacao = 2 */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND {&TABLENAME}.tp-requis      = ifiltro1            
                           AND {&TABLENAME}.situacao       = 2 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND lpendente
             AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as pendentes 
                  ser† restringido o campo situacao = 3 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND {&TABLENAME}.tp-requis      = ifiltro1            
                            AND {&TABLENAME}.situacao       = 3 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.

             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND NOT lpendente
             AND lcomordem THEN
               /* Quando for parametrizado para mostrar somente as com Ordem 
                  ser† restringido o campo situacao = 4 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND {&TABLENAME}.tp-requis      = ifiltro1            
                            AND {&TABLENAME}.situacao       = 4 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
               /* Quando for qualquer outra combinaá∆o, ser† obrigat¢rio
                  a utilizaá∆o da cl†usula 'OR' no campo situacao */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND {&TABLENAME}.tp-requis      = ifiltro1            
                           AND (   (laberta   AND {&TABLENAME}.situacao = 1) 
                                OR (lfechada  AND {&TABLENAME}.situacao = 2) 
                                OR (lpendente AND {&TABLENAME}.situacao = 3) 
                                OR (lcomordem AND {&TABLENAME}.situacao = 4)) NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.

       END.
       ELSE DO:
           IF  laberta
           AND lfechada
           AND lpendente
           AND lcomordem THEN
               /* Quando for parametrizado para mostrar todas as situaá‰es 
                  de requisicao n∆o ser† restringido o campo situaá∆o */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
           ELSE
           IF laberta
           AND NOT lfechada
           AND NOT lpendente
           AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as abertas 
                  ser† restringido o campo situacao = 1 */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                          AND {&TABLENAME}.situacao       = 1 NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
            IF  NOT laberta
            AND lfechada
            AND NOT lpendente
            AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as fechadas 
                  ser† restringido o campo situacao = 2 */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                           AND {&TABLENAME}.situacao       = 2 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND lpendente
             AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as pendentes 
                  ser† restringido o campo situacao = 3 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                            AND {&TABLENAME}.situacao       = 3 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND NOT lpendente
             AND lcomordem THEN
               /* Quando for parametrizado para mostrar somente as com Ordem 
                  ser† restringido o campo situacao = 4 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                            AND {&TABLENAME}.situacao       = 4 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
               /* Quando for qualquer outra combinaá∆o, ser† obrigat¢rio
                  a utilizaá∆o da cl†usula 'OR' no campo situacao */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                          AND (   (laberta   AND {&TABLENAME}.situacao = 1) 
                               OR (lfechada  AND {&TABLENAME}.situacao = 2) 
                               OR (lpendente AND {&TABLENAME}.situacao = 3) 
                               OR (lcomordem AND {&TABLENAME}.situacao = 4)) NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
       END.
*/

       RETURN "OK".
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
    open query {&QueryName} for each requisicao no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateEletronicApproval DBOProgram 
PROCEDURE updateEletronicApproval :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  lookup("nome-abrev",c-diferencas)  <> 0
    or  lookup("cod-estabel",c-diferencas) <> 0
    or  lookup("tp-requis",c-diferencas)   <> 0 then do:

        if  i-tipo-doc > 0 then do:

            /* Eliminaá∆o de Pendàncias */
            for each it-requisicao 
                where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:
                run cdp/cdapi171.p (input i-tipo-doc-old,
                                    input 3, /* Eliminaá∆o */
                                    input rowid(it-requisicao)).   
            end.
            
            /* Aprovaá∆o por Item */
            if (    i-tipo-doc = 1 /* Requisiá∆o Estoque */
                and substr(param-compra.char-2,1,3) = "NAO") /* Aprovaá∆o por Item */
            or (    i-tipo-doc = 2 /* Solicitaá∆o Compra */
                and substr(param-compra.char-2,4,3) = "NAO") then do: /* Aprovaá∆o por Item */

                for each it-requisicao
                    where it-requisicao.nr-requisicao = RowObject.nr-requisicao exclusive-lock:
    
                    /* Eliminaá∆o de Pendàncias */
                    run cdp/cdapi171.p (input i-tipo-doc,
                                        input 3, /* Eliminaá∆o */
                                        input rowid(it-requisicao)).
        
                    /* Geraá∆o da Pendància */
                    run cdp/cdapi171.p (input i-tipo-doc,
                                        input i-tipo-trans,
                                        input rowid(it-requisicao)).
        
                    /* Verificaá∆o da Pendància */
                    run cdp/cdapi172.p (input  i-tipo-doc,
                                        input  rowid(it-requisicao),
                                        output l-pendente).

                    if  l-pendente then /* Documento pendente de aprovaá∆o */
                        assign it-requisicao.estado = 2. /* N∆o Aprovada */
                    else
                        assign it-requisicao.estado = 1. /* Aprovada */
                end.

                run eletronicApprovalMessage.

                if  can-find (first it-requisicao
                              where it-requisicao.nr-requisicao = RowObject.nr-requisicao
                                and it-requisicao.estado        = 2) then /* N∆o Aprovada */
                    assign requisicao.estado = 2. /* N∆o Aprovada */
            end.
            /* Aprovaá∆o por Total - Eliminaá∆o de Pendàncias */
            else if (    i-tipo-doc = 1 /* Solicitaá∆o de Compra */
                     and substr(param-compra.char-2,1,3) = "SIM")  /* Aprovaá∆o por Total */
                or  (    i-tipo-doc = 2 /* Requisiá∆o Estoque */
                     and substr(param-compra.char-2,4,3) = "SIM") then do: /* Aprovaá∆o por Total */

                find first it-requisicao
                    where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock no-error.
                if  avail it-requisicao then do:

                    run cdp/cdapi171.p (input i-tipo-doc-old,
                                        input 3, /* Eliminaá∆o */
                                        input rowid(it-requisicao)).
    
                    run cdp/cdapi171.p (input i-tipo-doc,
                                        input 2, /* Modificaá∆o */
                                        input rowid(it-requisicao)).
    
                    run cdp/cdapi172.p (input  i-tipo-doc,
                                        input  rowid(it-requisicao),
                                        output l-pendente).
    
                    assign requisicao.situacao = 1  /* Aberta */
                           requisicao.estado   = if  not l-pendente then 1 /* Aprovada */ else 2 /* N∆o Aprovada */.
    
                    for each it-requisicao
                        where it-requisicao.nr-requisicao = RowObject.nr-requisicao 
                        and (   it-requisicao.situacao = 1                  /* Aberta */
                             or it-requisicao.situacao = 3) exclusive-lock: /* Incompleta */
                        assign it-requisicao.estado     = requisicao.estado.
                    end.

                    run eletronicApprovalMessage.
                end.
            end.
        end.
    end.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBtAddItem DBOProgram 
PROCEDURE validateBtAddItem :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes a inclus∆o de itens da requisiá∆o
  Parameters:  <none>
  Notes:       MÇtodo executado ao acionar o bot∆o de inclus∆o do item.
------------------------------------------------------------------------------*/

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findusuarmater.i requisicao.nome-abrev}
        if  avail usuar-mater
        and requisicao.nome-abrev <> c-seg-usuario
        and substr(usuar-mater.char-1,10,1) = "N" then do: /* Altera Requisiá∆o */
            {utp/ut-liter.i incluir}
            {method/svc/errors/inserr.i &ErrorNumber="33913"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
            return "NOK".
        end.

        if  requisicao.situacao = 2          /* Fechada */
        or  requisicao.situacao = 4 then do: /* Com Ordem */
            {utp/ut-liter.i Requisiá∆o}
            {method/svc/errors/inserr.i &ErrorNumber="31232"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value + '~~~~' + entry(requisicao.situacao, c-lst-situacao)"}
            return "NOK".
        end.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateBtUpdateRequest DBOProgram 
PROCEDURE validateBtUpdateRequest :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes a modificaá∆o da requisiá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/findrequisicao.i RowObject.nr-requisicao}
    if  avail requisicao then do:

        {cdp/findusuarmater.i requisicao.nome-abrev}
        if  avail usuar-mater
        and requisicao.nome-abrev <> c-seg-usuario
        and substr(usuar-mater.char-1,10,1) = "N" then do: /* Altera Requisiá∆o */
            {utp/ut-liter.i modificar}
            {method/svc/errors/inserr.i &ErrorNumber="33913"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
            return "NOK".
        end.

        if  requisicao.situacao = 2          /* Fechada */
        or  requisicao.situacao = 4 then do: /* Com Ordem */
            {utp/ut-liter.i Requisiá∆o}
            {method/svc/errors/inserr.i &ErrorNumber="31232"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value + '~~~~' + entry(requisicao.situacao, c-lst-situacao)"}
            return "NOK".
        end.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateEletronicApproval DBOProgram 
PROCEDURE validateEletronicApproval :
/*------------------------------------------------------------------------------
  Purpose:     Validar a requisiá∆o para Aprovaá∆o Eletrìnica
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter pType as character no-undo.
        
    if  pType = "Update"
    and (   lookup("nome-abrev",c-diferencas)  <> 0
         or lookup("cod-estabel",c-diferencas) <> 0
         or lookup("tp-requis",c-diferencas)   <> 0) then do:
    
        if  RowObject.tp-requis = 1                   /* Requisiá∆o Estoque */
        and param-compra.log-1                        /* Aprovaá∆o Eletrìnica */
        and substr(param-estoq.char-1,4,1) = "Y" then /* Aprovaá∆o Requisiá∆o */
           assign i-tipo-doc = 2.
        else if RowObject.tp-requis = 2 /* Solicitaá∆o de Compra */
            and param-compra.log-1 then /* Aprovaá∆o Eletrìnica */
            assign i-tipo-doc = 1.
        else 
            assign i-tipo-doc = 0.

        assign i-tipo-trans = if pType = "Create" then 1 /* inclus∆o */ else 2 /* modificaá∆o */.
          
        if  i-tipo-doc > 0 then do:

            if  l-integra-aed-ems then do:

                assign de-valor-total = 0.

                /* Calcula valor total de requisiá∆o */
                for each it-requisicao fields(val-item)
                    where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:
                    assign de-valor-total = de-valor-total + it-requisicao.val-item.
                end.

                for each it-requisicao 
                    where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:

                     assign de-valor-item = it-requisicao.val-item.
      
                     run aedp/aedapi173.p (input i-tipo-doc,
                                           input it-requisicao.it-codigo,
                                           input RowObject.nome-abrev,
                                           input it-requisicao.ct-codigo,
                                           input RowObject.cod-estabel,
                                           input it-requisicao.sc-codigo,
                                           input de-valor-item,
                                           input de-valor-total,
                                           input RowObject.cod-estabel,
                                           output table tt-erro).
    
                     if  return-value = "NOK" then do:
                         find first tt-erro no-error.
                         if  avail tt-erro then do:
                             {method/svc/errors/inserr.i
                                        &ErrorNumber="tt-erro.cd-erro"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="tt-erro.c-param"}
                                        
                             return "NOK". 
                         end.
                     end.
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    define input parameter pType as character no-undo.
    
    {cdp/findparamglobal.i}
    {cdp/findparamcompra.i}
    {cdp/findparamestoq.i}

    run identifyChanges (output c-diferencas).
    
    if  pType = "Create" then do:
        if  can-find (first requisicao
                      where requisicao.nr-requisicao = RowObject.nr-requisicao) then do:
            {utp/ut-table.i movind requisicao 1}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
        end.        
        
        if  param-global.modulo-bh
        and can-find(first his-requisicao
                     where his-requisicao.nr-requisicao = RowObject.nr-requisicao) then do:
            {utp/ut-liter.i Hist¢rico_Requisiá∆o}
            {method/svc/errors/inserr.i &ErrorNumber="4521"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"} 
        end.
        
        if  RowObject.nr-requisicao = 0 then do:
            {utp/ut-table.i movind requisicao 1}
            {method/svc/errors/inserr.i &ErrorNumber="2333"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.         

        if  RowObject.nr-requisicao < param-compra.prim-solic-man
        or  RowObject.nr-requisicao > param-compra.ult-solic-man then do:
             {method/svc/errors/inserr.i &ErrorNumber="863"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="''"}           
        end.           
        
    end.
    
    if  pType = "Create"
    or  pType = "Update" then do:

        if  RowObject.dt-requisicao = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="173"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}   
        end.  

        {cdp/findestabelec.i RowObject.cod-estabel}
        if  not avail estabelec then do:
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}     
        end.   
         
        {cdp/findusuarmater.i RowObject.nome-abrev}
        if  not avail usuar-mater then do:
            {utp/ut-liter.i Requisitante}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}  
        end.
        else do:
            if  RowObject.tp-requis = 1
            and not usuar-mater.usuar-requis then do:
                {method/svc/errors/inserr.i &ErrorNumber="33836"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
            end.
            else if RowObject.tp-requis > 1
                and not usuar-mater.usuar-solic then do:
                {method/svc/errors/inserr.i &ErrorNumber="1083"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}        
            end.
        end.
        
        if (RowObject.situacao < 1)
        or (RowObject.situacao > 3)
        or (    RowObject.tp-requis = 1
            and RowObject.situacao = 3) then do:
            {method/svc/errors/inserr.i &ErrorNumber="4681"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        end.
        
        if  substr(param-global.char-2,29,1) <> "1" then do:
            {method/svc/errors/inserr.i &ErrorNumber="31562"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}             
        end.

        if  param-compra.log-1  = no
        and RowObject.tp-requis = 3
        and l-integra-aed-ems   = no then do:
            /* Mensagem: Solicitaá∆o de Cotaá∆o s¢ esta dispon°vel para aprovaá∆o eletrìnica */
            {method/svc/errors/inserr.i &ErrorNumber="15563"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}             
        end.
          
        if  param-compra.log-1
        and RowObject.tp-requis = 3
        and substr(param-compra.char-2,1,3) = "sim" then do:
            /* Mensagem: Solicitaá∆o de Cotaá∆o n∆o est† dispon°vel para aprovaá∆o total de documentos */
            {method/svc/errors/inserr.i &ErrorNumber="17532"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}  
       end.
    end.
    
    if  pType = "Update" then do:

        if  RowObject.estado    = 1          /* Aprovado */
        and RowObject.tp-requis = 1 then do: /* Requisiá∆o Estoque */
            {method/svc/errors/inserr.i &ErrorNumber="1102"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        end.

        if  RowObject.estado    = 1          /* Aprovado */          
        and RowObject.tp-requis = 2 then do: /* Solicitaá∆o Compra */
            {method/svc/errors/inserr.i &ErrorNumber="15838"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        end.

        if  RowObject.tp-requis = 2 then do: /* Requisiá∆o Estoque */
            if  can-find(first it-requisicao
                         where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                           and it-requisicao.situacao      = 2) then do: /* Atendida */
                {method/svc/errors/inserr.i &ErrorNumber="875"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}  
            end.
        end.
        else if RowObject.tp-requis = 1 then do: /* Solicitaá∆o Compra */
            
            if  can-find(first it-requisicao
                         where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                           and (   it-requisicao.situacao = 3
                                or it-requisicao.situacao = 4)) then do:
                {method/svc/errors/inserr.i &ErrorNumber="876"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}  
            end.
        end.

        if  lookup("cod-estabel",c-diferencas) <> 0 then do:

            if  can-find(first it-requisicao
                         where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                           and it-requisicao.qt-atendida   > 0) then do:
                {method/svc/errors/inserr.i &ErrorNumber="872"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}  
            end.
        end.

        for each it-requisicao
            where it-requisicao.nr-requisicao = RowObject.nr-requisicao no-lock:

            {cdp/finditemuniestab.i it-requisicao.it-codigo Rowobject.cod-estabel}
            if  not avail item-uni-estab then do:
                {method/svc/errors/inserr.i &ErrorNumber="25904"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="'it-requisicao.it-codigo' + '~~~~' + 'Rowobject.cod-estabel'"}
                RETURN "NOK".
            end.
            else do:

                if  RowObject.tp-requis = 1 then do: /* Requisiá∆o Estoque */

                    if  item-uni-estab.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR" 
                                            &ErrorParameters="''"}                    
                    END.
                end.
                else do:
                    if  param-compra.int-2 = 2 then do: /* Geraá∆o Ordem Compra - Comprador */
    
                        if  not can-find(first comprador
                                         where comprador.cod-comprado = item-uni-estab.cod-comprado) then do:
                            {method/svc/errors/inserr.i &ErrorNumber="17074"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="''"}                                 
                        end.
                    end.
                    else if param-compra.int-2 = 1 then do: /* Geraá∆o Ordem Compra - Grupo de Compras */
    
                        if  not can-find(first grupo-compra
                                         where grupo-compra.cod-grp-compra = item-uni-estab.cod-grp-compra) then do:
                            {method/svc/errors/inserr.i &ErrorNumber="16419"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="''"}                        
                        end.
                        else do:
    
                            if  not can-find(first gr-cmp-comprad
                                             where gr-cmp-comprad.cod-grp-compra = item-uni-estab.cod-grp-compra) then do:
                                {method/svc/errors/inserr.i &ErrorNumber="16419"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="''"}
                            end.
                        end.                          
                    end.

                    if  item-uni-estab.cod-obsoleto = 3
                    or  item-uni-estab.cod-obsoleto = 4 then do:
                         {method/svc/errors/inserr.i
                                            &ErrorNumber="1568"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                    end.
                end.
            end.

            if  lookup("tp-requis",c-diferencas) <> 0
            and RowObject.tp-requis = 1 then do: /* Requisiá∆o Estoque */
     
                if  it-requisicao.ct-codigo = "" then do:
                    {method/svc/errors/inserr.i &ErrorNumber="15435"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}  
                end.

                {cdp/finditem.i it-requisicao.it-codigo}
                if  return-value = "ok" then do:

                    if  item.tipo-contr = 4 then do: /* DÇbito Direto */
                        {method/svc/errors/inserr.i &ErrorNumber="15483"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="''"}  
                    end.
                end.
            end.

            /*** EXECUÄ«O ORÄAMENTµRIA ***/
            if  lookup("cod-estabel",c-diferencas)   <> 0
            or (    lookup("tp-requis",c-diferencas) <> 0
                and RowObject.tp-requis <> 3) then do: /* Solicitaá∆o Cotaá∆o */

                run cdp/cdapi198.p (input rowid(it-requisicao),
                                    input 1, /* registro alterado -> elimina it-requisicao */
                                    input yes,
                                    input-output table tt_xml_input_1).
                if  return-value = "NOK" then 
                    return "NOK".
            end.                                                                              
            /*****************************/

        end.
    end.
    
    if  pType = "Delete" then do:

        if can-find(first it-requisicao
                    where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                      and it-requisicao.qt-atendida   > 0) then do:
                {method/svc/errors/inserr.i &ErrorNumber="7542"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".                            
        end.
    
        if  can-find(first it-requisicao
                     where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                       and it-requisicao.situacao      = 4) then do:
            {method/svc/errors/inserr.i &ErrorNumber="8131"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        end.                           
    end.
    
    /* Validaá‰es Aprovaá∆o Eletrìnica */
    run validateEletronicApproval (input pType).
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR") THEN
        RETURN "NOK".

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

