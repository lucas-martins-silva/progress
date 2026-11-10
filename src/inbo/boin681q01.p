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
{include/i-prgvrs.i BOIN681Q01 2.00.00.013 } /*** "010013" 24/11/2023 13:25:26  ***/
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
&GLOBAL-DEFINE DBOName tt-precos
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-precos
&GLOBAL-DEFINE TableLabel tt-precos
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE EXCLUDE-getRowid

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/

def var c-lista-itens  as char  no-undo.
def var c-naveg        as char  no-undo.
def var r-controle-preco   as ROWID no-undo.
def var r-comp-aux     as ROWID no-undo.
def var i-nrlinhas     as int   no-undo.
def var i-line-existe  as int   no-undo.
def var r-first        as ROWID no-undo.
def var r-last         as ROWID no-undo.
def var r-aux-pri      as ROWID no-undo.
def var l-existeComp   as log   no-undo initial no.
def var l-interrompido as log   no-undo initial no.
def var i-cont         as int   no-undo.

{inbo/boin681q01.i tt-precos}
{inbo/boin681q01.i tt-calc-perc-precos}
{inbo/boin681q01.i Rowobject}  

/*==========================================================================*/
/* Procedures Consulta_Preco_item e Converte_cotacao_moeda ---------------- */
{include/i-epc200.i boin681}

/* Quando a procedure for utilizada pela consulta  (wcc0392.p),precisara da moeda 1;
   quando a procedure for utilizada pelo relatorio (wcc0393.w),precisara das moedas 1 e 2 */
   
/* def var p-moeda1 as decimal no-undo.
 * def var p-moeda2 as decimal no-undo.*/

DEFINE BUFFER b-controle-preco FOR controle-preco.

def var da-data-ant                         as date    no-undo format "99/99/9999".  /* variaveis carregadas na procedure */
def var da-data-acum                        as date    no-undo format "99/99/9999".  /* Inicio_calculo_cotacao            */ 
def var da-inicio-calculo                   as date    no-undo format "99/99/9999".  /* in¡cio c lculo variacao */
    
def var de-preco                            as decimal no-undo format "->>>,>>9.99".

def var de-cotacao-moeda                    as decimal no-undo format "->>>,>>9.9999".
def var de-cotacao-moeda1                   as decimal no-undo format "->>>,>>9.9999".
def var de-cotacao-moeda2                   as decimal no-undo format "->>>,>>9.9999".

def var de-preco-conv                       as decimal no-undo format "->>>,>>9.9999". /* preco convertido */
def var de-preco-conv1                      as decimal no-undo format "->>>,>>9.9999". /* de acordo c/ a moeda*/
def var de-preco-conv2                      as decimal no-undo format "->>>,>>9.9999".

def var de-preco-ant                        as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-ant1                       as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-ant2                       as decimal no-undo format "->>>,>>9.9999". 

def var de-preco-acum                       as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-acum1                      as decimal no-undo format "->>>,>>9.9999". 
def var de-preco-acum2                      as decimal no-undo format "->>>,>>9.9999". 

def var c-data                              as char    no-undo format "999999".  /* ano + mes p/ pegar a cotacao */ 
def var i-dia                               as inte    no-undo.                   /* pega a cotacao da moeda no dia */

def var c-return                            as char    no-undo.
def var h-boad098                           as handle  no-undo.
def var h-boad098na                         as handle  no-undo.
def var c-nome-emit                         like emitente.nome-emit.

def var c-type                              as char    no-undo  initial "".

def var e-preco-moeda-1 as decimal format "->>>,>>9.9999" no-undo. 
def var e-preco-moeda-2 as decimal format "->>>,>>9.9999" no-undo.
def var e-preco-moeda-3 as decimal format "->>>,>>9.9999" no-undo.
def var e-perc-ant-1 as decimal format "->>9.99" no-undo.
def var e-perc-ant-2 as decimal format "->>9.99" no-undo.
def var e-perc-ant-3 as decimal format "->>9.99" no-undo.
def var e-perc-acum-1 as decimal format "->>9.99" no-undo.
def var e-perc-acum-2 as decimal format "->>9.99" no-undo.
def var e-perc-acum-3 as decimal format "->>9.99" no-undo.

/*==========================================================================*/

/*DEFINE TEMP-TABLE RowObject like tt-precos.*/

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

DEFINE QUERY qrComp for controle-preco scrolling.

DEFINE QUERY qrComp2 for b-controle-preco scrolling.

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*---------- Include de Pr‚-Processadores -------------*/

{cdp/cdcfgmat.i}

/*----------  handle -------------*/
def var h-bogin681    as handle     no-undo.

/*--Defini‡Æo variaveis usadas nas procedures--*/
def var i-nr-processo as int        no-undo.
def var h-boin681     as handle     no-undo.

def var linha-aux as int no-undo.	

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
/* ------------------------------ 
   Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
------------------------------- */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* ---------------------------
  DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.94
         WIDTH              = 40.
 END WINDOW DEFINITION 
---------------------------- */ 
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign rowobject.r-rowid = {&TableName}.r-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSetRecord DBOProgram 
PROCEDURE afterSetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign rowobject.r-rowid = {&TableName}.r-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLast DBOProgram 
PROCEDURE getRowidFirstLast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param r-chave-inform as rowid no-undo.
    def input  param c-nav          as char  no-undo.
    def input  param i-linhas       as int   no-undo.
    def output param r-first        as rowid no-undo.
    def output param r-last         as rowid no-undo.
    def var iAuxCont as int no-undo.

    if r-chave-inform <> ? then do:
       find bf{&TABLENAME} where 
            bf{&TABLENAME}.r-rowid = r-chave-inform
             no-lock no-error.

       if c-nav = "ant" then do:
            assign r-last = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find prev bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find first bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = linha-aux + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign r-first = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.

       if c-nav = "pro" or r-first = ? then do:  /* se no "ant" r-first = ? preciso achar r-last */
            if c-nav = "pro" then assign r-first = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find next bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find last bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = i-linhas + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign r-last = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.
    end.

    find first bf{&TABLENAME} no-lock no-error.
    if avail bf{&TABLENAME} and bf{&TABLENAME}.r-rowid = r-first then assign r-first = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterRepositionRecord DBOProgram 
PROCEDURE afterRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     temp-table nÆo posiciona corretamente com REPOSITION, por isso d -se find
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param r-chave as rowid no-undo.
    
    find {&TABLENAME} where 
         {&TABLENAME}.r-rowid = r-chave
          no-lock no-error.
    
    assign r-chave = {&TABLENAME}.r-rowid.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowid DBOProgram 
PROCEDURE getRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} nÆo dispon¡vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayDescricao DBOProgram 
PROCEDURE DisplayDescricao :
/*------------------------------------------------------------------------------
  Purpose:  
  Parameters: 
    ipar1 : 
  Notes:   
------------------------------------------------------------------------------*/
def input  param restricao      as char no-undo.
def input  param c-codigo       as char no-undo.
def output param c-descricao    as char no-undo.

def var    i-moeda              as inte no-undo.
def var i-emitente              as inte no-undo.

    find first rowerrors no-lock no-error.
    if not avail rowerrors then do:

        case restricao:
        when "I" then do:
            assign c-descricao = "".
            find first item no-lock where 
                       item.it-codigo = c-codigo no-error.
            if   avail item then 
                assign c-descricao    = item.desc-item.
            else 
                assign c-descricao    = "NÆo Encontrado".
        end.
        when "ES" then do:
            assign c-descricao = "".
            find first estabelec no-lock where 
                       estabelec.cod-estabel = c-codigo no-error.
            if   avail estabelec then 
                assign c-descricao           = estabelec.nome.
            else
                assign c-descricao           = "NÆo Encontrado".
        end.
        when "M" then do:
            assign c-descricao = ""
                   i-moeda = integer(c-codigo) no-error.
            if  not error-status:error or
                i-moeda  <> ? or
                i-moeda  <> 0 then do:
                find first moeda no-lock where 
                           moeda.mo-codigo = integer(c-codigo) no-error .
                if   avail moeda then
                    assign c-descricao     = moeda.descricao.
                else 
                    assign c-descricao     = "NÆo Encontrado".
            end.
        end.
        when "EM" then do:
            assign c-descricao = ""
                   i-emitente = integer(c-codigo) no-error.
            if  error-status:error or
                i-emitente <> ?    or
                i-emitente <> 0    then do:
                find first emitente no-lock where
                           emitente.cod-emitente = integer(c-codigo) no-error.
                if   avail emitente then 
                    assign c-descricao           = emitente.nome-emit.
                else 
                    assign c-descricao           = "".
            end.        
        end.
        OTHERWISE do:
            assign c-descricao = "".
        end.
        end case.
        
    end.
    else 
        assign c-descricao = "".

end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Validacoes DBOProgram 
PROCEDURE Validacoes :
def input  param p-item            like item.it-codigo.         /* parametros das variaveis de tela */
def input  param p-estabelec       like estabelec.cod-estabel.  /* parametros das variaveis de tela */
def input  param p-moeda           like moeda.mo-codigo.        /* parametros das variaveis de tela */
def input  param p-emitente        like emitente.cod-emitente.
def input  param p-data-inicial    as date    no-undo  format "99/99/9999" .
def input  param p-data-final      as date    no-undo  format "99/99/9999" .
def input  param p-inicio-calculo  as date    no-undo  format "99/99/9999".
def input  param pc-inicio-calculo as char    no-undo.
def output param table for rowerrors.

def var c-par1 as char no-undo initial "".     
def var c-par2 as char no-undo initial "".
    
    
    find item no-lock where
         item.it-codigo = p-item no-error.
    if not avail Item then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind item 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
    end.                

    find estabelec no-lock where
         estabelec.cod-estabel = p-estabelec no-error.
    if not avail estabelec then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgadm estabelec 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters=TRIM(RETURN-VALUE)}
    end.                

    find moeda no-lock where 
         moeda.mo-codigo = p-moeda no-error.
    if   not avail moeda then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Moeda" *}
        ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="c-lbl-liter-moeda"}
    end.
        

    if  p-emitente <> 0 then do:    
        find emitente no-lock where 
             emitente.cod-emitente = p-emitente no-error.
        if   not avail emitente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Emitente" *}
            ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="c-lbl-liter-emitente"}
        end.
    end.
            

    if  p-data-inicial = ? then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-data-inicial AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Data_Inicial" *}
        ASSIGN c-lbl-liter-data-inicial = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="19150"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="c-lbl-liter-data-inicial"}
    end.


    if  p-data-final = ? then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-data-final AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Data_Final" *}
        ASSIGN c-lbl-liter-data-final = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="19150"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="c-lbl-liter-data-final"}
    end.       

    if  pc-inicio-calculo <> "" then do:
        if  p-inicio-calculo = ? then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-data-inicio-calculo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Data_In¡cio_C lculo" *}
            ASSIGN c-lbl-liter-data-inicio-calculo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="19150"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="c-lbl-liter-data-inicio-calculo"}
        end.       
    end.    

    if  p-data-final  < p-data-inicial then do:
       assign c-par1 = "Data Final"
              c-par2 = "Data Inicial" .
              
       {method/svc/errors/inserr.i
                 &ErrorNumber      = "7017"
                 &ErrorType        = "EMS"
                 &ErrorParameters  = "c-par1 + '~~~~' + c-par2"}
    end.

    if  p-data-inicial < p-inicio-calculo then do:

       assign c-par1 = "In¡cio C lculo Varia‡Æo"
              c-par2 = "Data Inicial" .
              
       {method/svc/errors/inserr.i
                 &ErrorNumber      = "508"
                 &ErrorType        = "EMS"
                 &ErrorParameters  = "c-par1 + '~~~~' + c-par2"}
    end.


end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carrega-tt_controleprecos DBOProgram 
PROCEDURE Carrega-tt_controleprecos :
/*------------------------------------------------------------------------------
  Purpose:  Carrega-tt_controleprecos
            Carrega a temp-table tt-precos; calcula os valores de % aumento e % acumulado 
            conforme parametros informados pelo usuario.
  Parameters: parametros informados pelo usuario 
    ipar1 : pcItCodigo                  : codigo do item 
    ipar2 : pcCodEstabel                : codigo do estabelecimento
    ipar3 : piMoeda                     : codigo da moeda 
    ipar4 : piCodEmitente               : codigo do fornecedor
    ipar5 : piTipoPreco                 : preco a vista(1) ou a prazo(2)
    ipar6 : pdDataInicial               : data inicial 
    ipar7 : pdDataFinal                 : data final
    ipar8 : pdInicioCalculo             : data de inicio dos calculos de % aumento e % acumulado
    ipar9 : tt-precos                   : retorna a tt-precos da procedure Consulta_Preco_item (boin681.p)
    ipar10: RowErrors                   : caso ocorra algum erro, retorna a tt-bo-erro 
  Notes:   
------------------------------------------------------------------------------*/
def var    h-bogin514                   as handle.
def var    i-seq                        as integer no-undo.
def var    i-cont-row                   as integer no-undo.
def var    c-par1                       as char    no-undo.
def var    c-par2                       as char    no-undo.

def input  param pcItCodigo             like item.it-codigo         no-undo .
def input  param pcCodEstabel           like estabelec.cod-estabel  no-undo .
def input  param pdeMoeda1              like moeda.mo-codigo        no-undo .
def input  param piCodEmitente          like emitente.cod-emitente  no-undo .
def input  param pitipoPreco            as inte    no-undo .
def input  param pdDataInicial          as date    no-undo format "99/99/9999" .
def input  param pdDataFinal            as date    no-undo format "99/99/9999" .
def input  param pdInicioCalculo        as date    no-undo format "99/99/9999" .
def output param table for tt-precos.
def output param table for RowErrors.

    ASSIGN r-first       = ?
           i-cont        = 0
           i-line-existe = 0
           r-comp-aux    = r-controle-preco.

    assign i-cont-row = 1. 
           i-seq      = 1.

    assign c-type = "consulta".
    assign c-lista-itens = "".

    run adbo/boad098na.p persistent set h-boad098na.

        if piCodEmitente = 0 then do:  /* fornecedor nao informado */
            OPEN QUERY qrComp for each controle-preco no-lock where
                     controle-preco.it-codigo     = pcItCodigo     and
                     controle-preco.cod-estabel   = pcCodEstabel   and
                     controle-preco.data-cotacao >= pdDataInicial  and
                     controle-preco.data-cotacao <= pdDataFinal 
                     /*break*/ by controle-preco.cod-estabel
                           by controle-preco.it-codigo
                           by controle-preco.data-cotacao INDEXED-REPOSITION.
        end. /*end if */
        else do:
            OPEN QUERY qrComp for each controle-preco no-lock where
                    controle-preco.it-codigo     = pcItCodigo      and
                    controle-preco.cod-estabel   = pcCodEstabel    and
                    controle-preco.cod-emitente  = piCodEmitente   and
                    controle-preco.data-cotacao >= pdDataInicial   and
                    controle-preco.data-cotacao <= pdDataFinal
                    /*break*/ by controle-preco.cod-estabel
                          by controle-preco.it-codigo
                          by controle-preco.data-cotacao INDEXED-REPOSITION.
        end. /* end else */

        IF r-controle-preco <> ? THEN DO:
           REPOSITION qrComp TO ROWID r-controle-preco NO-ERROR.
           ASSIGN r-first = r-controle-preco.

           IF c-naveg = "ant" 
              then get prev qrComp.
              else get next qrComp.
        END.
        else get first qrComp.

        if avail controle-preco then do:
            assign l-existeComp = yes.
            ASSIGN r-aux-pri    = ROWID(controle-preco).
        end.

    IF l-existeComp THEN DO:
        if c-naveg = "ant" then ASSIGN r-last  = ROWID(controle-preco).
                           else ASSIGN r-first = ROWID(controle-preco).
        
        DO WHILE i-cont <= (i-nrlinhas - 1):
            if avail controle-preco then do:

                /* if first-of(controle-preco.it-codigo) then do: */
                if not can-do(c-lista-itens,controle-preco.it-codigo) then do:
                   {inbo/boin681.i1}
                   assign c-lista-itens = c-lista-itens + "," + controle-preco.it-codigo.
                end.
                {inbo/boin681.i2}

                assign tt-precos.r-rowid   =  rowid(controle-preco)
                       tt-precos.sequencia =  i-seq.

                if c-naveg = "ant" then assign i-seq = 9999 - i-seq.

                assign i-cont-row          =  i-cont-row + 1
                       i-seq               =  i-seq + 1.
            end.
            else assign i-cont = i-nrlinhas + 1 /* para sair do DO WHILE */
                        l-interrompido = yes
                        r-comp-aux     = ?.

            IF c-naveg = "ant" 
               then get prev qrComp.
               else get next qrComp.

            assign i-cont = i-cont + 1.
        end.
        
        if c-naveg = "ant"
           then ASSIGN r-first = if l-interrompido then ? else ROWID(controle-preco).
           else ASSIGN r-last  = if l-interrompido then ? else ROWID(controle-preco).

        if c-naveg <> "ant" and r-controle-preco = ? then ASSIGN r-first = ?.
    END.
    
    delete procedure h-boad098na no-error.
     
    return "OK".
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carrega-tt_controleprecos DBOProgram 
PROCEDURE Carrega-tt_controleprecos :
/******************************************************************************************************************************************
  PURPOSE: CONFORME PARAMETROS INFORMADOS PELO USUARIO:
                1 - CARREGA-TT_CONTROLEPRECOS;
                2 - CARREGA A TEMP-TABLE TT-PRECOS;
                3 - CALCULA OS VALORES DE % AUMENTO E % ACUMULADO;

  PARAMETERS: PARAMETROS INFORMADOS PELO USUARIO:
                IPAR1 : PCITCODIGO      : CODIGO DO ITEM 
                IPAR2 : PCCODESTABEL    : CODIGO DO ESTABELECIMENTO
                IPAR3 : PIMOEDA         : CODIGO DA MOEDA 
                IPAR4 : PICODEMITENTE   : CODIGO DO FORNECEDOR
                IPAR5 : PITIPOPRECO     : PRECO A VISTA(1) OU A PRAZO(2)
                IPAR6 : PDDATAINICIAL   : DATA INICIAL 
                IPAR7 : PDDATAFINAL     : DATA FINAL
                IPAR8 : PDINICIOCALCULO : DATA DE INICIO DOS CALCULOS DE % AUMENTO E % ACUMULADO
                IPAR9 : TT-PRECOS       : RETORNA A TT-PRECOS DA PROCEDURE CONSULTA_PRECO_ITEM (BOIN681.P)
                IPAR10: ROWERRORS       : CASO OCORRA ALGUM ERRO, RETORNA A TT-BO-ERRO

  NOTES: 
******************************************************************************************************************************************/

DEFINE VARIABLE h-bogin514      AS HANDLE.
DEFINE VARIABLE c-par1          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-par2          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE de-vl-acum      AS DECIMAL FORMAT "->>>,>>9.9999"   NO-UNDO. /*Acumulado*/
DEFINE VARIABLE de-vl-var       AS DECIMAL FORMAT "->>>,>>9.9999"   NO-UNDO. /*Varia‡Æo*/
DEFINE VARIABLE de-Calc-acum    AS DECIMAL FORMAT "->>>,>>9.9999"   NO-UNDO.
DEFINE VARIABLE dataIniControle AS DATE    FORMAT "99/99/9999"      NO-UNDO.

DEFINE  INPUT PARAMETER             pcItCodigo      LIKE  item.it-codigo        NO-UNDO.
DEFINE  INPUT PARAMETER             pcCodEstabel    LIKE  estabelec.cod-estabel NO-UNDO.
DEFINE  INPUT PARAMETER             pdeMoeda        LIKE  moeda.mo-codigo       NO-UNDO.
DEFINE  INPUT PARAMETER             piCodEmitente   LIKE  emitente.cod-emitente NO-UNDO.
DEFINE  INPUT PARAMETER             pitipoPreco     AS INTEGER                  NO-UNDO.
DEFINE  INPUT PARAMETER             pdDataInicial   AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE  INPUT PARAMETER             pdDataFinal     AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE  INPUT PARAMETER             pdInicioCalculo AS DATE FORMAT "99/99/9999" NO-UNDO.
DEFINE OUTPUT PARAMETER             piContador      AS INTEGER                  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR   tt-precos.
DEFINE OUTPUT PARAMETER TABLE FOR   RowErrors.


    ASSIGN c-type          = "consulta"
           i-cont          = 1
           r-first         = ?.
    
    RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
    
    IF piCodEmitente = 0 THEN DO: /*- FORNECEDOR NÇO INFORMADO -*/
        OPEN QUERY qrComp
            FOR EACH controle-preco NO-LOCK
               WHERE controle-preco.cod-estabel   = pcCodEstabel
                 /*AND controle-preco.cod-emitente >= 0*/
                 AND controle-preco.it-codigo     = pcItCodigo
                 AND controle-preco.data-cotacao >= pdDataInicial
                 AND controle-preco.data-cotacao <= pdDataFinal USE-INDEX /*controle*/ estab-item INDEXED-REPOSITION.
    END.
    ELSE DO: /*- FORNECERDOR INFORMADO -*/
        OPEN QUERY qrComp
            FOR EACH controle-preco NO-LOCK
               WHERE controle-preco.cod-estabel   = pcCodEstabel
                 AND controle-preco.cod-emitente  = piCodEmitente
                 AND controle-preco.it-codigo     = pcItCodigo
                 AND controle-preco.data-cotacao >= pdDataInicial
                 AND controle-preco.data-cotacao <= pdDataFinal USE-INDEX controle INDEXED-REPOSITION.
    END.
  
    IF r-controle-preco <> ? THEN DO:                                   /*- Processo de navega‡Æo.                                  -*/
        REPOSITION qrComp TO ROWID r-controle-preco NO-ERROR.           /*- Reposiciona no registro do ROWID enviado do WCC0392.    -*/
        GET NEXT qrComp.                                                /*- Alimenta o buffer com o registro posicionado acima.     -*/
    END.
    ELSE 
        GET FIRST qrComp.                                               /*- Primeira vez que acessa o programa.                     -*/

    IF AVAILABLE controle-preco THEN                                    /*- A query foi aberta e contem informa‡ao.                 -*/
        ASSIGN l-existeComp = YES.
    
    IF l-existeComp THEN DO:                                            /*- Processo executado apenas quando existe informa‡Æo.     -*/
        
        IF pdInicioCalculo = ? THEN
            ASSIGN da-inicio-calculo = IF YEAR((pdDataInicial - 365)) > 0 THEN (pdDataInicial - 365) ELSE pdDataInicial.
        ELSE
            ASSIGN da-inicio-calculo = pdInicioCalculo.
    
        IF c-naveg = "pro" THEN
            ASSIGN dataIniControle = controle-preco.data-cotacao.
        ELSE 
            ASSIGN dataIniControle = pdDataInicial.
        
        ASSIGN r-first = r-controle-preco
               r-last  = r-controle-preco.
        
        DO WHILE i-cont <= (i-nrlinhas):
            
            IF AVAILABLE controle-preco THEN DO:
                IF VALID-HANDLE(h-boad098na) THEN DO:
                    RUN openQueryStatic IN h-boad098na(INPUT "Main":U).
                    RUN GotoKey         IN h-boad098na(INPUT controle-preco.cod-emitente).
                    IF RETURN-VALUE = "OK" THEN
                        RUN GetCharField IN h-boad098na(INPUT  "nome-emit",
                                                        OUTPUT c-nome-emit).
                END.
                    
                CREATE tt-precos.
                ASSIGN tt-precos.cod-estabel          = controle-preco.cod-estabel
                       tt-precos.it-codigo            = controle-preco.it-codigo 
                       tt-precos.cod-emitente         = controle-preco.cod-emitente
                       tt-precos.data-cotacao         = controle-preco.data-cotacao
                       tt-precos.inicio-calculo       = da-inicio-calculo
                       tt-precos.cod-cond-pag         = controle-preco.cod-cond-pag
                       tt-precos.valor-taxa           = controle-preco.valor-taxa
                       tt-precos.preco-unit-vista     = controle-preco.preco-unit-vista
                       tt-precos.preco-unit-prazo     = controle-preco.preco-unit-prazo
                       tt-precos.aliquota-ipi         = controle-preco.aliquota-ipi
                       tt-precos.nome-emit            = c-nome-emit
                       tt-precos.r-rowid              = ROWID(controle-preco)
                       tt-precos.manual-autom         = (IF (controle-preco.numero-ordem = 0) THEN "Manual" ELSE "Autom tico").

                IF c-type = "consulta" THEN DO:
                    {inbo/boin681epc.i STRING(ROWID(controle-preco))}
                END.
                IF c-naveg = "ant" THEN DO:
                    ASSIGN r-first = ROWID(controle-preco)
                           dataIniControle = controle-preco.data-cotacao.
                    GET PREV qrComp.
                END.
                ELSE DO:
                    ASSIGN r-last = ROWID(controle-preco).
                    GET NEXT qrComp.
                END.
                IF c-naveg = "ant" AND NOT AVAIL controle-preco THEN
                    ASSIGN r-first = ?.
                ELSE 
                    IF c-naveg = "pro" AND NOT AVAIL controle-preco THEN
                        ASSIGN r-last = ?.
            END.
            ELSE
                ASSIGN i-cont = i-nrlinhas + 1.
            
            ASSIGN i-cont = i-cont + 1.
        END.

        IF da-inicio-calculo <> pdDataInicial OR c-naveg <> "" THEN
            RUN Calc_Inter_Ant_Dt (INPUT pcItCodigo,
                                   INPUT pcCodEstabel,
                                   INPUT pdeMoeda,
                                   INPUT piCodEmitente,
                                   INPUT pitipoPreco,
                                   INPUT dataIniControle,
                                   INPUT da-inicio-calculo,
                                   INPUT NO,
                                  OUTPUT de-Calc-acum,
                                  OUTPUT de-vl-acum,
                                  OUTPUT de-vl-var).                 
        ELSE /*Apenas verifica se existe um anterior para o calculo da varia‡Æo*/ 
            RUN Calc_Inter_Ant_Dt (INPUT pcItCodigo,
                                   INPUT pcCodEstabel,
                                   INPUT pdeMoeda,
                                   INPUT piCodEmitente,
                                   INPUT pitipoPreco,
                                   INPUT dataIniControle,
                                   INPUT da-inicio-calculo,
                                   INPUT YES,
                                  OUTPUT de-Calc-acum,
                                  OUTPUT de-vl-acum,
                                  OUTPUT de-vl-var).
        RUN Calcula-tt_controleprecos (INPUT pitipoPreco,
                                       INPUT pdeMoeda,
                                       INPUT de-vl-acum,
                                       INPUT de-vl-var,
                                       INPUT de-Calc-acum,
                                       INPUT TABLE tt-precos,
                                      OUTPUT TABLE tt-precos).
    END.
   
    FOR EACH tt-precos:
        ASSIGN piContador = piContador + 1.
    END.

    DELETE PROCEDURE h-boad098na NO-ERROR.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calc_Inter_Ant_Dt DBOProgram 
PROCEDURE Calc_Inter_Ant_Dt :

/*
                                      ===================================
                                        COMENTµRIO REFERENTE AO CALCULO  
=================================================================================================================                                       
Valor Corrente - 100%
Valor Anterior - N%

Valor Corrente x N% = Valor Anterior x 100%
N% = (Valor Anterior / Valor Corrente) x 100%	Simplificando os % temos que,
N = (Valor Anterior / Valor Corrente) x 100		Isso mostra quanto o valor anterior representa do valor corrente.

100 - N = Isso resulta no valor que falta para o anterior tornar-se igual ao corrente.
          Sempre sera positivo e com N menor que 100 para sequencia progressiva.
          O oposto disso resulta em um percentual negativo e com N maior que 100.
          
=================================================================================================================          
*/

DEFINE  INPUT PARAMETER pcItCodigo      LIKE  item.it-codigo        NO-UNDO.
DEFINE  INPUT PARAMETER pcCodEstabel    LIKE  estabelec.cod-estabel NO-UNDO.
DEFINE  INPUT PARAMETER pdeMoeda        LIKE  moeda.mo-codigo       NO-UNDO.
DEFINE  INPUT PARAMETER piCodEmitente   LIKE  emitente.cod-emitente NO-UNDO.
DEFINE  INPUT PARAMETER pitipoPreco     AS INTEGER                  NO-UNDO.
DEFINE  INPUT PARAMETER pdDataInicial   AS DATE                     NO-UNDO FORMAT "99/99/9999".
DEFINE  INPUT PARAMETER pdInicioCalculo AS DATE                     NO-UNDO FORMAT "99/99/9999".
DEFINE  INPUT PARAMETER pdBuscaAntVar   AS LOGICAL                  NO-UNDO.
DEFINE OUTPUT PARAMETER pdCalcAcum      AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE OUTPUT PARAMETER pdVlAcum        AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE OUTPUT PARAMETER pdVlVar         AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.

DEFINE VARIABLE de-vl-corrente          AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-antecessor-acum   AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-somado            AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-antecessor-var    AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE l-reg-qry               AS LOGICAL INITIAL YES            NO-UNDO. 

    IF piCodEmitente = 0 THEN /*- FORNECERDOR NÇO INFORMADO -*/
        OPEN QUERY qrComp2
            FOR EACH b-controle-preco NO-LOCK
               WHERE b-controle-preco.cod-estabel   = pcCodEstabel
                 /*AND b-controle-preco.cod-emitente >= 0*/
                 AND b-controle-preco.it-codigo     = pcItCodigo
                 AND b-controle-preco.data-cotacao >= pdInicioCalculo
                 AND b-controle-preco.data-cotacao  < pdDataInicial USE-INDEX /*controle*/ estab-item INDEXED-REPOSITION.
    
    ELSE /*- FORNECERDOR INFORMADO -*/
        OPEN QUERY qrComp2
            FOR EACH b-controle-preco NO-LOCK
               WHERE b-controle-preco.cod-estabel   = pcCodEstabel
                 AND b-controle-preco.cod-emitente  = piCodEmitente
                 AND b-controle-preco.it-codigo     = pcItCodigo
                 AND b-controle-preco.data-cotacao >= pdInicioCalculo 
                 AND b-controle-preco.data-cotacao  < pdDataInicial USE-INDEX controle INDEXED-REPOSITION.

    IF pdBuscaAntVar THEN DO:
        GET PREV qrComp2.
        IF AVAIL b-controle-preco THEN DO:
            ASSIGN c-data = STRING( YEAR(b-controle-preco.data-cotacao),"9999") +  /*- COTA€ÇO DA MOEDA -*/
                            STRING(MONTH(b-controle-preco.data-cotacao),"99")
                   i-dia  =          DAY(b-controle-preco.data-cotacao).           /*- COTA€ÇO DO RESPECTIVO DIA -*/
            IF piTipoPreco = 1 THEN 
               ASSIGN de-vl-corrente = b-controle-preco.preco-unit-vista.
            ELSE 
                IF piTipoPreco = 2 THEN
                    ASSIGN de-vl-corrente = b-controle-preco.preco-unit-prazo.

            IF pdeMoeda <> 0 THEN
            RUN Converte_cotacao_moeda (INPUT  pdeMoeda,       
                                        INPUT  de-vl-corrente,  
                                        INPUT  c-data,
                                        INPUT  i-dia,
                                        OUTPUT de-cotacao-moeda,
                                        OUTPUT de-vl-corrente).
            ASSIGN pdVlVar = de-vl-corrente.
        END.
        RETURN.
    END.
    GET FIRST qrComp2.

    DO WHILE pdInicioCalculo < pdDataInicial:
        IF AVAIL b-controle-preco THEN DO:
            
            ASSIGN c-data = STRING( YEAR(b-controle-preco.data-cotacao),"9999") +  /*- COTA€ÇO DA MOEDA -*/
                            STRING(MONTH(b-controle-preco.data-cotacao),"99")
                   i-dia  =          DAY(b-controle-preco.data-cotacao).           /*- COTA€ÇO DO RESPECTIVO DIA -*/
            
            IF piTipoPreco = 1 THEN 
               ASSIGN de-vl-corrente = b-controle-preco.preco-unit-vista.
            ELSE 
                IF piTipoPreco = 2 THEN
                    ASSIGN de-vl-corrente = b-controle-preco.preco-unit-prazo.

            IF pdeMoeda <> 0 THEN
                RUN Converte_cotacao_moeda (INPUT  pdeMoeda,       
                                            INPUT  de-vl-corrente,  
                                            INPUT  c-data,
                                            INPUT  i-dia,
                                            OUTPUT de-cotacao-moeda,
                                            OUTPUT de-vl-corrente).
            
            IF l-reg-qry = YES THEN
                ASSIGN de-vl-antecessor-acum = de-vl-corrente
                       de-vl-antecessor-var  = de-vl-corrente
                       l-reg-qry = NO.
            ELSE 
                ASSIGN de-vl-somado = de-vl-somado + (100 - ((de-vl-antecessor-acum / de-vl-corrente) * 100))
                       de-vl-antecessor-var  = de-vl-corrente.

            ASSIGN pdInicioCalculo = b-controle-preco.data-cotacao
                   de-vl-antecessor-acum = de-vl-corrente.

            GET NEXT qrComp2.
        END.
        ELSE 
            ASSIGN pdInicioCalculo = pdDataInicial.
    END.

    ASSIGN pdCalcAcum = de-vl-somado
           pdVlAcum   = de-vl-antecessor-acum
           pdVlVar    = de-vl-antecessor-var.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-tt_controleprecos DBOProgram 
PROCEDURE Calcula-tt_controleprecos :

DEFINE  INPUT PARAMETER             pitipoPreco     AS INTEGER                  NO-UNDO.
DEFINE  INPUT PARAMETER             pdeMoeda        LIKE  moeda.mo-codigo       NO-UNDO.
DEFINE  INPUT PARAMETER             pdVlAcum        AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE  INPUT PARAMETER             pdVlVar         AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE  INPUT PARAMETER             pdCalcAcum      AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE  INPUT PARAMETER TABLE FOR tt-calc-perc-precos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-calc-perc-precos.

DEFINE VARIABLE de-vl-corrente          AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-antecessor-acum   AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-somado            AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-perc-ant          AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-vl-antecessor-var    AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.

ASSIGN de-vl-antecessor-acum = pdVlVar
       de-vl-antecessor-var  = pdVlVar
       de-vl-somado          = pdCalcAcum.

FOR EACH tt-calc-perc-precos EXCLUSIVE-LOCK 
    BY tt-calc-perc-precos.cod-estabel  
    BY tt-calc-perc-precos.cod-emitente  
    BY tt-calc-perc-precos.it-codigo    
    BY tt-calc-perc-precos.data-cotacao:
    
    ASSIGN c-data = STRING( YEAR(tt-calc-perc-precos.data-cotacao),"9999") +  /*- COTA€ÇO DA MOEDA -*/
                    STRING(MONTH(tt-calc-perc-precos.data-cotacao),"99")
           i-dia  =          DAY(tt-calc-perc-precos.data-cotacao).           /*- COTA€ÇO DO RESPECTIVO DIA -*/
    
    IF piTipoPreco = 1 THEN 
       ASSIGN de-vl-corrente = tt-calc-perc-precos.preco-unit-vista.
    ELSE 
        IF piTipoPreco = 2 THEN
            ASSIGN de-vl-corrente = tt-calc-perc-precos.preco-unit-prazo.

    IF pdeMoeda <> 0 THEN
        RUN Converte_cotacao_moeda (INPUT  pdeMoeda,       
                                    INPUT  de-vl-corrente,  
                                    INPUT  c-data,
                                    INPUT  i-dia,
                                    OUTPUT de-cotacao-moeda,
                                    OUTPUT de-vl-corrente).

    ASSIGN de-vl-somado   = IF (de-vl-antecessor-acum / de-vl-corrente) = 0 OR (de-vl-antecessor-acum / de-vl-corrente) = ? THEN 0
                            ELSE de-vl-somado + (100 - ((de-vl-antecessor-acum / de-vl-corrente) * 100))
           de-vl-perc-ant = IF (de-vl-antecessor-var  / de-vl-corrente) = 0 THEN 0
                            ELSE (100 - ((de-vl-antecessor-var  / de-vl-corrente) * 100))
           de-vl-antecessor-var  = de-vl-corrente
           de-vl-antecessor-acum = de-vl-corrente.

    ASSIGN /*tt-calc-perc-precos.preco-moeda[1] = if  <> ? then e-preco-moeda-1 else 0
           tt-calc-perc-precos.preco-moeda[2] = if  <> ? then e-preco-moeda-2 else 0 
           tt-calc-perc-precos.preco-moeda[3] = if  <> ? then e-preco-moeda-3 else 0*/ 
           tt-calc-perc-precos.perc-ant[1]    = IF de-vl-perc-ant <> ? THEN de-vl-perc-ant ELSE 0
           tt-calc-perc-precos.perc-ant[2]    = IF de-vl-perc-ant <> ? THEN de-vl-perc-ant ELSE 0   
           tt-calc-perc-precos.perc-ant[3]    = IF de-vl-perc-ant <> ? THEN de-vl-perc-ant ELSE 0
           tt-calc-perc-precos.perc-acum[1]   = IF de-vl-somado <> ? THEN de-vl-somado ELSE 0
           tt-calc-perc-precos.perc-acum[2]   = IF de-vl-somado <> ? THEN de-vl-somado ELSE 0
           tt-calc-perc-precos.perc-acum[3]   = IF de-vl-somado <> ? THEN de-vl-somado ELSE 0.
    
END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Converte_cotacao_moeda DBOProgram 
PROCEDURE Converte_cotacao_moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar1:  piMoeda         : codigo da moeda informada pelo usuario
              ipar2:  pdePreco        : preco informado pelo usuario (moeda corrente)
              ipar3:  pcData          : data "ano/mes" da cotacao
              ipar4:  piDia           : dia da data da cotacao da moeda
              ipar5:  pdeCotacaoMoeda : cotacao a moeda no respectivo dia
              ipar6:  pdePrecoConv    : preco da moeda convertido 
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piMoeda         as integer no-undo.
    def input  param pdePreco        as decimal no-undo format "->>>,>>>,>>9.99".
    def input  param pcData          as char    no-undo format "999999".
    def input  param piDia           as integer no-undo format "99".
    def output param pdeCotacaoMoeda as decimal no-undo format "->>>,>>>,>>9.999999999".
    def output param pdePrecoConv    as decimal no-undo format "->>>,>>>,>>9.99".

    find first cotacao no-lock where 
               cotacao.mo-codigo   = piMoeda and
               cotacao.ano-periodo = pcData  no-error.
    if avail   cotacao then do:

       assign  pdeCotacaoMoeda = cotacao.cotacao[piDia].
       
       if pdeCotacaoMoeda <> 0 then do:
          assign pdePrecoConv = (pdePreco / pdeCotacaoMoeda).
       end.   
       else assign pdePrecoConv = 0.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        when "cod-estabel":U  then assign pFieldValue = RowObject.cod-estabel.
        when "nome-emit":U    then assign pFieldValue = RowObject.nome-emit.
        when "it-codigo":U    then assign pFieldValue = RowObject.it-codigo.
        when "manual-autom":U then assign pFieldValue = RowObject.manual-autom.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        when "data-cotacao" then ASSIGN pFieldValue = RowObject.data-cotacao. 
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.
    CASE pFieldName:
        when "preco-unit-vista" then ASSIGN pFieldValue = RowObject.preco-unit-vista.
        when "preco-unit-prazo" then ASSIGN pFieldValue = RowObject.preco-unit-prazo.
        when "aliquota-ipi"     then ASSIGN pFieldValue = RowObject.aliquota-ipi.
        when "preco-moeda[1]"   then ASSIGN pFieldValue = RowObject.preco-moeda[1].
        when "preco-moeda[2]"   then ASSIGN pFieldValue = RowObject.preco-moeda[2].
        when "preco-moeda[3]"   then ASSIGN pFieldValue = RowObject.preco-moeda[3].
        when "perc-ant[1]"      then ASSIGN pFieldValue = RowObject.perc-ant[1].
        when "perc-ant[2]"      then ASSIGN pFieldValue = RowObject.perc-ant[2].
        when "perc-ant[3]"      then ASSIGN pFieldValue = RowObject.perc-ant[3].
        when "perc-acum[1]"     then ASSIGN pFieldValue = RowObject.perc-acum[1].
        when "perc-acum[2]"     then ASSIGN pFieldValue = RowObject.perc-acum[2].
        when "perc-acum[3]"     then ASSIGN pFieldValue = RowObject.perc-acum[3].
        when "valor-taxa"       then ASSIGN pFieldValue = RowObject.valor-taxa.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        when "cod-emitente" then ASSIGN pFieldValue = RowObject.cod-emitente.
        when "cod-cond-pag" then ASSIGN pFieldValue = RowObject.cod-cond-pag.
        when "sequencia"    then ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CONTROLE
  Parameters:
               retorna valor dos campos do ¡ndice CONTROLE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel  LIKE controle-preco.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE controle-preco.cod-emitente  NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo    LIKE controle-preco.it-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-cotacao LIKE controle-preco.data-cotacao  NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel  = RowObject.cod-estabel.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN pit-codigo    = RowObject.it-codigo.
    ASSIGN pdata-cotacao = RowObject.data-cotacao.

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
/*    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.*/
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyControle DBOProgram
PROCEDURE goToKeyControle :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CONTROLE
  Parameters:
               recebe valor dos campos do ¡ndice CONTROLE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel  LIKE controle-preco.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE controle-preco.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE controle-preco.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pdata-cotacao LIKE controle-preco.data-cotacao NO-UNDO.
    
    def buffer bfcontrole-preco for controle-preco.

    FIND FIRST bfcontrole-preco NO-LOCK WHERE
         bfcontrole-preco.cod-estabel  = pcod-estabel  AND
         bfcontrole-preco.cod-emitente = pcod-emitente AND
         bfcontrole-preco.it-codigo    = pit-codigo    AND
         bfcontrole-preco.data-cotacao = pdata-cotacao NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/

    IF NOT AVAILABLE bfcontrole-preco THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontrole-preco)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
    define input parameter iAbertura as integer no-undo.

    case iAbertura:
        when 1 then
            run openQueryStatic ("Main").
        when 2 then 
            run openQueryStatic ("BySequencia").
        when 3 then
            run openQueryStatic ("ByControle").
    end case.                  
        
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
    OPEN QUERY {&QueryName} FOR EACH tt-precos NO-LOCK INDEXED-REPOSITION .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySequencia DBOProgram 
PROCEDURE openQueryBySequencia :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH tt-precos NO-LOCK  
         /*by tt-precos.cod-emitente
         by tt-precos.cod-estabel
         by tt-precos.it-codigo
         by tt-precos.data-cotacao*/
         by tt-precos.sequencia
         INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByControle DBOProgram 
PROCEDURE openQueryByControle :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH tt-precos NO-LOCK 
        by tt-precos.cod-estabel  
        by tt-precos.cod-emitente  
        by tt-precos.it-codigo    
        by tt-precos.data-cotacao INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    /*--- Verifica ocorrˆncia de erros ---*/
    if ptype = "create" or ptype = "update" then do:
    
    end.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
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
    def INPUT PARAMETER pc-naveg   as char no-undo.
    def INPUT PARAMETER pc-comp    as CHAR no-undo.
    def INPUT PARAMETER pi-linhas  as INT  no-undo.

    assign c-naveg          = pc-naveg
           r-controle-preco = to-rowid(pc-comp)
           i-nrlinhas       = pi-linhas.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLastTT DBOProgram 
PROCEDURE getRowidFirstLastTT :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os rowids iniciais e finais gravados qdo carregada a tt-controle-preco
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pr-first        as rowid no-undo.
    def output param pr-last         as rowid no-undo.

    ASSIGN pr-first = r-first
           pr-last  = r-last.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

