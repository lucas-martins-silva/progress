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
{include/i-prgvrs.i BOIN356SD 2.00.00.007}  /*** 010007 ***/
{cdp/cdcfgmat.i}
/* Include com pr‚-processadores */
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
&GLOBAL-DEFINE DBOName prazo-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel prazo-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin356.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin356.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var    l-invest  as log no-undo.
def var    l-ord-inv as log no-undo.

def buffer b-prazo        for prazo-compra.
def buffer b-prazo-compra for prazo-compra.
def buffer b-ordem        for ordem-compra.

/* Include com pr²-processadores de Materiais */
{cdp/cdcfgmat.i}

/********* Multi-Planta ***********/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.
 
{cdp/cd7300.i1}
{cdp/cd7300.i2}
{mpp/mpapi011.i}
{cdp/cd9730.i "new"} /* define temp-table t-invest */
/************** Fim ***************/

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
         HEIGHT             = 2
         WIDTH              = 44.86.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaDadosMultiplantaParcela DBOProgram 
PROCEDURE criaDadosMultiplantaParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Esta procedure encontra-se em coment rio devido aos problemas de API's (msg, show).*/
    
    /*
    if not avail param-global then
        find first param-global no-lock no-error.
    
    if param-global.modulo-mp then do:
    if l-cc0308 = no then do with frame {&frame-name}:
        find comprador where comprador.cod-comprado = ordem-compra.cod-comprado no-lock no-error.
        assign c-transacao = "MAT002".
        {cdp/cd7300.i5 "001" c-transacao}
        
        assign i-tipo-movto = if  prazo-compra.parcela:sensitive = yes 
                                  then 1 else 2
               c-estabel-dest = ordem-compra.cod-estabel.
        
                
        if (avail comprador and comprador.corporativo) and
           (param-compra.compra-centr = no or prazo-compra.parcela:sensitive = no) and
            lg-multiplanta-ordem      = no then do:
            if ordem-compra.int-1 <> 0 then do:
                run pi-cria-tt-maq-ep-est. 
                find first tt-maq-ep-est 
                     where tt-maq-ep-est.cod-estabel = c-estabel-dest no-lock no-error.
        
                for each tt-param-maq-ep-est: 
                    delete tt-param-maq-ep-est.
                end. 
                
                
                if  avail tt-maq-ep-est and tt-maq-ep-est.tp-conexao <> 1 or
                    param-compra.compra-centr = no then do:
                    assign c-estabel-dest = "".
                    if  tt-replica-msg.log-replica-msg  = yes then do:
                        if  comprador.corporativo = no and
                            param-compra.compra-centr = yes and 
                            ordem-compra.cod-estabel <> ""
                        then
                            assign c-estabel-dest     = ordem-compra.cod-estabel. 
                        
                        if l-atualiza-quantidade then do:
                            create tt-dados-env.                  
                            assign tt-dados-env.num-sequencia  = i-seq 
                                   tt-dados-env.cod-tipo-reg   = 64      
                                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                                   tt-dados-env.identif-msg    = string(ordem-compra.numero-ordem).
                            raw-transfer ordem-compra to tt-dados-env.conteudo-msg.                                     
                            assign i-seq = i-seq + 1.                                     
                            
                            create tt-dados-env.                  
                            assign tt-dados-env.num-sequencia  = i-seq 
                                   tt-dados-env.cod-tipo-reg   = 65      
                                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                                   tt-dados-env.identif-msg    = string(prazo-compra.numero-ordem) + " , " +
                                                                 string(prazo-compra.parcela).
                            raw-transfer prazo-compra to tt-dados-env.conteudo-msg.                                     
                            assign i-seq = i-seq + 1.                                     
                        end.
                        else do:
                            create tt-dados-env.                  
                            assign tt-dados-env.num-sequencia  = i-seq 
                                   tt-dados-env.cod-tipo-reg   = 65      
                                   tt-dados-env.ind-tipo-movto = i-tipo-movto
                                   tt-dados-env.identif-msg    = string(prazo-compra.numero-ordem) + " , " +
                                                                 string(prazo-compra.parcela).
                            raw-transfer prazo-compra to tt-dados-env.conteudo-msg.                                     
                            assign i-seq = i-seq + 1.                                     
                        end.
                        {cdp/cd7300.i6 "001" c-transacao c-estabel-dest ''}
                    end.
                end.
            end.
        end.
    end.    
    else do:
        find ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem
            no-lock no-error.
        if avail ordem-compra then
            find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido
                no-lock no-error.
        if avail pedido-compr and avail ordem-compra then
        if  param-global.modulo-mp    = yes and
            param-compra.compra-centr = yes and
            pedido-compr.end-entrega <> ""  then do:
            
            assign c-transacao = "MAT006"
                   i-tipo-movto = 2.
            {cdp/cd7300.i5 "001" c-transacao}
            
            /* Pedido-compr */
            if avail pedido-compr then do:
                create tt-dados-env.
                assign tt-dados-env.num-sequencia  = i-seq
                       tt-dados-env.cod-tipo-reg   = 88
                       tt-dados-env.ind-tipo-movto = i-tipo-movto
                       tt-dados-env.identif-msg    = string(pedido-compr.num-pedido).
                raw-transfer pedido-compr to tt-dados-env.conteudo-msg.
                assign i-seq          = i-seq + 1.
            end.
            
            /* Parcelas */
            create tt-dados-env .
            assign tt-dados-env.num-sequencia   = i-seq
                   tt-dados-env.cod-tipo-reg    = 65
                   tt-dados-env.ind-tipo-movto  = 1 /*** INCLUSAO ***/
                   tt-dados-env.identif-msg     = string(ordem-compra.numero-ordem) + " , " +
                                                  string(prazo-compra.parcela).
            raw-transfer prazo-compra to tt-dados-env.conteudo-msg.
            assign i-seq          = i-seq + 1.
            
            /* Cotacao-item */
            for each cotacao-item where
                cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                cotacao-item.it-codigo    = ordem-compra.it-codigo and
                cotacao-item.cot-aprovada = yes no-lock:
                create tt-dados-env.
                assign tt-dados-env.num-sequencia  = i-seq
                       tt-dados-env.cod-tipo-reg   = 114
                       tt-dados-env.ind-tipo-movto = i-tipo-movto 
                       tt-dados-env.identif-msg    = string(cotacao-item.numero-ordem)
                                                     + " , " + string(cotacao-item.cod-emitente)
                                                     + " , " + string(cotacao-item.it-codigo)
                                                     + " , " + string(cotacao-item.seq-cotac).
                raw-transfer cotacao-item to tt-dados-env.conteudo-msg.
                assign i-seq = i-seq + 1.
            end.
            
            /* Ordem-compra */
            create tt-dados-env .
            assign tt-dados-env.num-sequencia   = i-seq
                   tt-dados-env.cod-tipo-reg    = 64
                   tt-dados-env.ind-tipo-movto  = i-tipo-movto
                   tt-dados-env.identif-msg     = string(ordem-compra.numero-ordem).
            raw-transfer ordem-compra to tt-dados-env.conteudo-msg.
            assign i-seq          = i-seq + 1.
            
            /* Cond-especif */
            if avail pedido-compr then do:
            find cond-especif where cond-especif.num-pedido = pedido-compr.num-pedido no-lock no-error.
            if available cond-especif then do:
                create tt-dados-env.
                assign tt-dados-env.num-sequencia  = i-seq
                       tt-dados-env.cod-tipo-reg   = 16
                       tt-dados-env.ind-tipo-movto = i-tipo-movto
                       tt-dados-env.identif-msg    = string(ordem-compra.numero-ordem).
                raw-transfer cond-especif to tt-dados-env.conteudo-msg.
            end.
            end.
            
            assign c-estabel-dest = if avail pedido-compr then pedido-compr.end-entrega else "".
            {cdp/cd7300.i6 "001" c-transacao c-estabel-dest ''}
        end.
    end.
    end.
    assign l-cc0308 = no.
    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraMaquinaEmpresaEstabelecimento DBOProgram 
PROCEDURE geraMaquinaEmpresaEstabelecimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Esta procedure encontra-se em coment rio devido aos problemas de API's (msg, show).*/
  
  /*
  find estabelec where estabelec.cod-estabel = c-estabel-dest no-lock no-error.
  if avail estabelec and estabelec.cod-estabel <> " " then do: 
  
      create tt-param-maq-ep-est.
      assign tt-param-maq-ep-est.cod-versao-integracao = 1
             tt-param-maq-ep-est.cod-estabel = c-estabel-dest
             tt-param-maq-ep-est.opcao = 2.
             
      run mpp/mpapi011.p (input-output table tt-param-maq-ep-est,
                          input-output table tt-maq-ep-est).    
  
  end.
  */
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
    OPEN QUERY {&QueryName} FOR EACH prazo-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preparaParcelaModificaQuantidade DBOProgram 
PROCEDURE preparaParcelaModificaQuantidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param prPrazoCompra     as rowid no-undo.
    def output param c-return          as char  no-undo.
    def output param prPrazoCompraNext as rowid no-undo.  

    def var iNumeroOrdem as int no-undo.
   
    find prazo-compra where
         rowid(prazo-compra) = prPrazoCompra 
         no-lock no-error.
         
    if avail prazo-compra then     
        assign iNumeroOrdem = prazo-compra.numero-ordem.
         
    find next prazo-compra where 
              prazo-compra.numero-ordem = iNumeroOrdem
              no-lock no-error.

    if not avail prazo-compra then do:
       c-return = "éltima Parcela da Ordem  - " + trim(string(iNumeroOrdem,'>>>>>9,99')) .
    end.
    else do:
         assign prPrazoCompraNext = rowid(prazo-compra).
    end.        

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnPedidoClienOrdemCompra DBOProgram 
PROCEDURE returnPedidoClienOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if  defined(bf_mat_custeio_item) &then

    def input  param p-numero-ordem  like ordem-compra.numero-ordem  no-undo.
    def output param c-nome-cliente  like emitente.nome-abrev        no-undo.
    def output param c-nr-pedcli     like ordem-compra.nr-pedcli     no-undo.
    def output param i-seq-ped-venda like ordem-compra.seq-ped-venda no-undo.
 
    for first ordem-compra 
        where ordem-compra.numero-ordem = p-numero-ordem no-lock: end.
    if  avail ordem-compra 
    and ordem-compra.local-entrega = 2 /* emitente */ then do:
        for first emitente fields(nome-abrev)
            where emitente.cod-emitente = ordem-compra.int-2 no-lock: end.
        if  avail emitente then
            assign c-nome-cliente = emitente.nome-abrev.
        assign c-nr-pedcli     = ordem-compra.nr-pedcli
               i-seq-ped-venda = ordem-compra.seq-ped-venda.
    end.

&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


