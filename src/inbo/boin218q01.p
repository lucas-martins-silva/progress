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
{include/i-prgvrs.i BOIN218Q01 2.00.00.008 } /*** "010008" 01/12/2023 10:51:01  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin218q01 MUT}
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
&GLOBAL-DEFINE DBOName BOIN218
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-movto-estoq
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin218q01.i tt-movto-estoq}

{inbo/boin218q01.i RowObject}

{cdp/cdcfgren.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bfmovto-estoq FOR {&TableName}.
DEF BUFFER bftt-movto-estoq FOR {&tableName}.

def var d-data-ini        as date    no-undo.
def var d-data-fim        as date    no-undo.
def var c-estabel         as char    no-undo.
def var c-localiz-ini     as char    no-undo.
def var c-localiz-fim     as char    no-undo.         
def var c-item-ini        as char    no-undo.
def var c-item-fim        as char    no-undo.
def var c-referencia-ini  as char    no-undo.
def var c-referencia-fim  as char    no-undo.
def var c-lote-ini        as char    no-undo.
def var c-lote-fim        as char    no-undo.           
def var i-tipo-trans      as integer no-undo.

def var c-navigation      as char    no-undo.

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
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaMovtosDeposito DBOProgram 
PROCEDURE carregaMovtosDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter r-chave             as rowid no-undo.
    def input parameter p-c-data-ini        as char  no-undo.
    def input parameter p-c-data-fim        as char  no-undo.
    def input parameter p-c-estabel         as char  no-undo.
    def input parameter p-c-localiz-ini     as char  no-undo.
    def input parameter p-c-localiz-fim     as char  no-undo.
    def input parameter p-c-item-ini        as char  no-undo.
    def input parameter p-c-item-fim        as char  no-undo.
    def input parameter p-c-referencia-ini  as char  no-undo.
    def input parameter p-c-referencia-fim  as char  no-undo.
    def input parameter p-c-lote-ini        as char  no-undo.
    def input parameter p-c-lote-fim        as char  no-undo.
    def input parameter p-c-tp-movtos       as char  no-undo. 
    def input parameter p-parametro         as char  no-undo.

    DEF INPUT PARAMETER p-navigation    AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-max-return    AS INT   NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-displayed  AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-displayed AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-base      AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-base       AS ROWID NO-UNDO.
    
    DEF VAR i-count-records AS INT NO-UNDO.
    def var data-movto as date no-undo.
    def var l-primeira as log  no-undo init yes.
    def var r-last-movto as rowid no-undo.
    
    def var l-first as log no-undo.

    assign c-navigation = p-navigation.

    find deposito where
         rowid(deposito) = r-chave no-lock no-error.
    if  not avail deposito then 
        return "NOK":U.
    
    assign d-data-ini       =  date(p-c-data-ini) 
           d-data-fim       =  date(p-c-data-fim)
           c-estabel        =  p-c-estabel
           c-localiz-ini    =  p-c-localiz-ini
           c-localiz-fim    =  p-c-localiz-fim
           c-item-ini       =  p-c-item-ini
           c-item-fim       =  p-c-item-fim  
           c-referencia-ini =  p-c-referencia-ini
           c-referencia-fim =  p-c-referencia-fim
           c-lote-ini       =  p-c-lote-ini 
           c-lote-fim       =  p-c-lote-fim   
           i-tipo-trans     =  integer(p-c-tp-movtos).
          
    /* O prÇ-processador abaixa testa a vers∆o do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-movto-estoq.
    &ELSE
        FOR EACH tt-movto-estoq:
            DELETE tt-movto-estoq.
        END.
    &ENDIF
    
    if p-navigation <> "Prev":U then do:

        DO data-movto = d-data-fim  TO d-data-ini BY -1:
        
            /* Quando o primeiro e o £ltimo registro do browse forem desconhecidos, comeáa
               a pesquisa pelo primeiro registro que se encaixar na seleá∆o */
            IF p-last-displayed  = ?
            OR NOT l-primeira THEN DO:
                
                FIND FIRST  movto-estoq 
                       &IF DEFINED(CUSTOM_GRENDENE) &THEN                        
                           use-index dep-estab                                   
                       &ENDIF                                                    
                       where movto-estoq.cod-depos   = deposito.cod-depos        
                         and movto-estoq.dt-trans    = data-movto                
                         and movto-estoq.cod-estabel = c-estabel                 
                         and movto-estoq.cod-localiz >= c-localiz-ini            
                         and movto-estoq.cod-localiz <= c-localiz-fim            
                         and movto-estoq.it-codigo   >= c-item-ini               
                         and movto-estoq.it-codigo   <= c-item-fim               
                         and movto-estoq.cod-refer   >= c-referencia-ini         
                         and movto-estoq.cod-refer   <= c-referencia-fim         
                         and movto-estoq.lote        >= c-lote-ini               
                         and movto-estoq.lote        <= c-lote-fim               
                         and ((movto-estoq.tipo-trans = 1 and i-tipo-trans <> 2) 
                          or  (movto-estoq.tipo-trans = 2 and i-tipo-trans  > 1))
                         NO-LOCK NO-ERROR.
                IF  p-first-base = ? THEN
                    ASSIGN p-first-base = ROWID(movto-estoq).

                if l-primeira then
                    assign l-first = yes.

            END.
            ELSE DO:

                assign l-primeira = no.
                /* Sen∆o comeáa a pesquisa a partir do registro que contenha o rowid
                   recebido como parÉmetro */
                FIND movto-estoq WHERE 
                     ROWID(movto-estoq) = p-last-displayed NO-LOCK NO-ERROR.
                IF AVAIL movto-estoq THEN
                   ASSIGN data-movto = movto-estoq.dt-trans.

            END.
        
            IF  AVAIL movto-estoq THEN DO:
                REPEAT:
                    
                    i-count-records = i-count-records + 1.

                    /*--- Cria a temp-table ---*/
                    create tt-movto-estoq.
                    buffer-copy movto-estoq to tt-movto-estoq.
                    assign tt-movto-estoq.r-rowid    = rowid(movto-estoq)
                           tt-movto-estoq.sequencial = i-count-records.
                    /*-------------------------*/
    
                    assign r-last-movto = rowid(movto-estoq).

                    IF  i-count-records >= p-max-return THEN 
                        LEAVE.
                             
                    FIND NEXT  movto-estoq 
                           &IF DEFINED(CUSTOM_GRENDENE) &THEN
                               use-index dep-estab
                           &ENDIF
                           where movto-estoq.cod-depos   = deposito.cod-depos
                             and movto-estoq.dt-trans    = data-movto
                             and movto-estoq.cod-estabel = c-estabel
                             and movto-estoq.cod-localiz >= c-localiz-ini
                             and movto-estoq.cod-localiz <= c-localiz-fim
                             and movto-estoq.it-codigo   >= c-item-ini
                             and movto-estoq.it-codigo   <= c-item-fim
                             and movto-estoq.cod-refer   >= c-referencia-ini
                             and movto-estoq.cod-refer   <= c-referencia-fim
                             and movto-estoq.lote        >= c-lote-ini 
                             and movto-estoq.lote        <= c-lote-fim  
                             and ((movto-estoq.tipo-trans = 1 and i-tipo-trans <> 2)
                              or  (movto-estoq.tipo-trans = 2 and i-tipo-trans  > 1))
                             NO-LOCK NO-ERROR.
                             
                    if not avail movto-estoq then
                        leave.
                END.
               
            END.
            
           if i-count-records >= p-max-return then do:
                
                run openquerystatic in this-procedure ("DtDescending":U).

                if l-first or (p-parametro = "retorno" and p-first-displayed = ?) then
                    assign p-first-displayed = ?.
                else do:
                    run getFirst in this-procedure.
                    assign p-first-displayed = tt-movto-estoq.r-rowid.
                end.

                find last  movto-estoq 
                         &IF DEFINED(CUSTOM_GRENDENE) &THEN
                             use-index dep-estab
                         &ENDIF
                         where movto-estoq.cod-depos    = deposito.cod-depos
                           and movto-estoq.dt-trans     = d-data-ini
                           and movto-estoq.cod-estabel  = c-estabel
                           and movto-estoq.cod-localiz >= c-localiz-ini
                           and movto-estoq.cod-localiz <= c-localiz-fim
                           and movto-estoq.it-codigo   >= c-item-ini
                           and movto-estoq.it-codigo   <= c-item-fim
                           and movto-estoq.cod-refer   >= c-referencia-ini
                           and movto-estoq.cod-refer   <= c-referencia-fim
                           and movto-estoq.lote        >= c-lote-ini 
                           and movto-estoq.lote        <= c-lote-fim 
                           and ((movto-estoq.tipo-trans = 1 and i-tipo-trans <> 2)
                            or  (movto-estoq.tipo-trans = 2 and i-tipo-trans  > 1))
                           no-lock no-error.
                    if avail movto-estoq 
                       and r-last-movto = rowid(movto-estoq) then
                            assign p-last-displayed = ?.
                    else do:
                        run getLast in this-procedure.
                        assign p-last-displayed = tt-movto-estoq.r-rowid.
                    end.

                if  i-count-records >= p-max-return then
                    LEAVE.
            END. /* if i-count-record > p-max-return  */
            
        END. /* do data-movto */

        if i-count-records < p-max-return then do:

            run openquerystatic in this-procedure ("DtDescending":U).

            if l-first or (p-parametro = "retorno" and p-first-displayed = ?) then
                assign p-first-displayed = ?.
            else do:
                run getFirst in this-procedure.
                assign p-first-displayed = tt-movto-estoq.r-rowid.
            end.

            assign p-last-displayed = ?.

        end.

    end. /* if p-navigation <> prev */
    else do:
        def var l-mudou-data as log no-undo. 

        DO  data-movto = d-data-ini  TO d-data-fim BY 1:
        
            if  l-mudou-data then do:
                FIND LAST  movto-estoq 
                       &IF DEFINED(CUSTOM_GRENDENE) &THEN
                           use-index dep-estab
                       &ENDIF
                       where movto-estoq.cod-depos   = deposito.cod-depos
                         and movto-estoq.dt-trans    = data-movto
                         and movto-estoq.cod-estabel = c-estabel
                         and movto-estoq.cod-localiz >= c-localiz-ini
                         and movto-estoq.cod-localiz <= c-localiz-fim
                         and movto-estoq.it-codigo   >= c-item-ini
                         and movto-estoq.it-codigo   <= c-item-fim
                         and movto-estoq.cod-refer   >= c-referencia-ini
                         and movto-estoq.cod-refer   <= c-referencia-fim
                         and movto-estoq.lote        >= c-lote-ini 
                         and movto-estoq.lote        <= c-lote-fim
                         and ((movto-estoq.tipo-trans = 1 and i-tipo-trans <> 2)
                          or  (movto-estoq.tipo-trans = 2 and i-tipo-trans  > 1))  
                         NO-LOCK NO-ERROR.                

            end.
            else do:
                /* Sen∆o comeáa a pesquisa a partir do registro que contenha o rowid
                   recebido como parÉmetro */
                FIND movto-estoq WHERE 
                    ROWID(movto-estoq) = p-first-displayed NO-LOCK NO-ERROR.
                IF  AVAIL movto-estoq THEN
                    ASSIGN data-movto = movto-estoq.dt-trans.
                assign l-mudou-data = yes.

            end.

            IF  AVAIL movto-estoq THEN DO:
                REPEAT:
                    
                    i-count-records = i-count-records + 1.
    
                    /*--- Cria a temp-table ---*/
                    create tt-movto-estoq.
                    buffer-copy movto-estoq to tt-movto-estoq.
                    assign tt-movto-estoq.r-rowid    = rowid(movto-estoq)
                           tt-movto-estoq.sequencial = i-count-records.
                    /*-------------------------*/
    
                    IF  i-count-records >= p-max-return THEN 
                        LEAVE.
                             
                    FIND PREV  movto-estoq 
                           &IF DEFINED(CUSTOM_GRENDENE) &THEN
                               use-index dep-estab
                           &ENDIF
                           where movto-estoq.cod-depos   = deposito.cod-depos
                             and movto-estoq.dt-trans    = data-movto
                             and movto-estoq.cod-estabel = c-estabel
                             and movto-estoq.cod-localiz >= c-localiz-ini
                             and movto-estoq.cod-localiz <= c-localiz-fim
                             and movto-estoq.it-codigo   >= c-item-ini
                             and movto-estoq.it-codigo   <= c-item-fim
                             and movto-estoq.cod-refer   >= c-referencia-ini
                             and movto-estoq.cod-refer   <= c-referencia-fim
                             and movto-estoq.lote        >= c-lote-ini 
                             and movto-estoq.lote        <= c-lote-fim  
                             and ((movto-estoq.tipo-trans = 1 and i-tipo-trans <> 2)
                              or  (movto-estoq.tipo-trans = 2 and i-tipo-trans  > 1))
                             NO-LOCK NO-ERROR.                

                    if  avail movto-estoq
                    and rowid(movto-estoq) = p-first-base then
                        assign p-first-displayed = ?. 

                    IF  NOT AVAIL movto-estoq THEN 
                        LEAVE.
                END.
                
            END.
            
            IF  i-count-records >= p-max-return then do:

                run openquerystatic in this-procedure ("DtDescending":U).

                if  p-first-displayed <> ? then do:
                    run getFirst in this-procedure.
                    assign p-first-displayed = tt-movto-estoq.r-rowid.
                end.

                run getLast in this-procedure.
                assign p-last-displayed = tt-movto-estoq.r-rowid.

                LEAVE.

            end. /* if i-count-records > p-max-return */
        END. /* do data-movto: */
    end. /* if p-navigation = prev */

    if not can-find(first tt-movto-estoq) then
            assign p-first-displayed = ?
                   p-last-displayed  = ?.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
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
        WHEN "cod-estabel-des":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-des.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-orig-trans":U THEN ASSIGN pFieldValue = RowObject.cod-orig-trans.
        WHEN "cod-prog-orig":U THEN ASSIGN pFieldValue = RowObject.cod-prog-orig.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "cod-usu-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usu-ult-alter.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "conta-saldo":U THEN ASSIGN pFieldValue = RowObject.conta-saldo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-saldo":U THEN ASSIGN pFieldValue = RowObject.ct-saldo.
        WHEN "descricao-db":U THEN ASSIGN pFieldValue = RowObject.descricao-db.
        WHEN "hr-contab":U THEN ASSIGN pFieldValue = RowObject.hr-contab.
        WHEN "hr-trans":U THEN ASSIGN pFieldValue = RowObject.hr-trans.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "origem-valor":U THEN ASSIGN pFieldValue = RowObject.origem-valor.
        WHEN "refer-contab":U THEN ASSIGN pFieldValue = RowObject.refer-contab.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-saldo":U THEN ASSIGN pFieldValue = RowObject.sc-saldo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "dt-contab":U THEN ASSIGN pFieldValue = RowObject.dt-contab.
        WHEN "dt-criacao":U THEN ASSIGN pFieldValue = RowObject.dt-criacao.
        WHEN "dt-nf-saida":U THEN ASSIGN pFieldValue = RowObject.dt-nf-saida.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm":U THEN ASSIGN pFieldValue = RowObject.valor-icm.
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "valor-iss":U THEN ASSIGN pFieldValue = RowObject.valor-iss.
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "valor-nota":U THEN ASSIGN pFieldValue = RowObject.valor-nota.
        WHEN "vl-icm-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[1].
        WHEN "vl-icm-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[2].
        WHEN "vl-ipi-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[1].
        WHEN "vl-ipi-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[2].
        WHEN "vl-iss-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[1].
        WHEN "vl-iss-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[2].
        WHEN "vl-nota-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[1].
        WHEN "vl-nota-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[2].
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
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
        WHEN "base-calculo":U THEN ASSIGN pFieldValue = RowObject.base-calculo.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "nr-trans-deb":U THEN ASSIGN pFieldValue = RowObject.nr-trans-deb.
        WHEN "num-ord-des":U THEN ASSIGN pFieldValue = RowObject.num-ord-des.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-seq-des":U THEN ASSIGN pFieldValue = RowObject.num-seq-des.
        WHEN "num-sequen":U THEN ASSIGN pFieldValue = RowObject.num-sequen.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "sequen-nf":U THEN ASSIGN pFieldValue = RowObject.sequen-nf.
        WHEN "tipo-preco[1]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[1].
        WHEN "tipo-preco[2]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[2].
        WHEN "tipo-preco[3]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[3].
        WHEN "tipo-trans":U THEN ASSIGN pFieldValue = RowObject.tipo-trans.
        WHEN "tipo-valor":U THEN ASSIGN pFieldValue = RowObject.tipo-valor.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice item-data
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo dt-trans
               retorna valor do campo esp-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.
    DEFINE OUTPUT PARAMETER pesp-docto LIKE movto-estoq.esp-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel
           pdt-trans = RowObject.dt-trans
           pesp-docto = RowObject.esp-docto.

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
        WHEN "contabilizado":U THEN ASSIGN pFieldValue = RowObject.contabilizado.
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
  Purpose:     Reposiciona registro com base no °ndice item-data
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo dt-trans
               recebe valor do campo esp-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.
    DEFINE INPUT PARAMETER pesp-docto LIKE movto-estoq.esp-docto NO-UNDO.

    FIND FIRST bfmovto-estoq WHERE 
        bfmovto-estoq.it-codigo = pit-codigo AND 
        bfmovto-estoq.cod-estabel = pcod-estabel AND 
        bfmovto-estoq.dt-trans = pdt-trans AND 
        bfmovto-estoq.esp-docto = pesp-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-estoq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-estoq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

    open query {&queryName} for each {&tableName} no-lock
         indexed-reposition.
         
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDtDescending DBOProgram 
PROCEDURE openQueryDtDescending :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  c-navigation = "prev" then
        open query {&queryName} for each {&tableName} no-lock
             BY tt-movto-estoq.sequencial descending indexed-reposition.
    else
        open query {&queryName} for each {&tableName} no-lock
            BY tt-movto-estoq.sequencial indexed-reposition.

    /*
    open query {&queryName} for each {&tableName} no-lock

        
         BY tt-movto-estoq.cod-depos
         BY tt-movto-estoq.cod-estabel
         BY tt-movto-estoq.dt-trans  DESCENDING
         indexed-reposition.
    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord Method-Library 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    
    assign pRowid = rowid({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: Nío foi poss≠vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- » necessˇrio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid:
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
